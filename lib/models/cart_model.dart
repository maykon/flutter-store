import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:store/datas/cart_product.dart';
import 'package:store/models/user_model.dart';

class CartModel extends Model {
  UserModel user;
  List<CartProduct> products = [];
  bool isLoading = false;
  String couponCode;
  int discountPercentage = 0;

  CartModel(this.user) {
    if (user.isLoggedIn()) _loadCartItems();
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct) {
    int index = products.indexWhere(
        (p) => p.pid == cartProduct.pid && p.option == cartProduct.option);
    if (index >= 0) {
      products[index].quantity++;
    } else {
      products.add(cartProduct);
    }

    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .add(cartProduct.toMap())
        .then((cart) {
      cartProduct.cid = cart.documentID;
    });
    notifyListeners();
  }

  void removeCartProduct(CartProduct cartProduct) {
    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cid)
        .delete();
    products.remove(cartProduct);
    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.quantity--;
    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());
    notifyListeners();
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.quantity++;
    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());
    notifyListeners();
  }

  void setCouponDiscount(String couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
    notifyListeners();
  }

  void updatePrices() {
    notifyListeners();
  }

  double getProductsPrice() {
    double price = 0.0;
    for (CartProduct c in products) {
      if (c.productData != null)
        price += c.quantity * c.productData.prices[c.option];
    }
    return price;
  }

  double getShipPrice() {
    return 9.99;
  }

  double getDiscount() {
    return getProductsPrice() * discountPercentage / 100;
  }

  Future<String> finishOrder() async {
    if (products.length == 0) return null;

    isLoading = true;
    notifyListeners();

    try {
      double productsPrice = getProductsPrice();
      double shipPrice = getShipPrice();
      double discount = getDiscount();

      DocumentReference refOrder =
          await Firestore.instance.collection("orders").add({
        "clientId": user.firebaseUser.uid,
        "products": products.map((cp) => cp.toMap()).toList(),
        "productsPrice": productsPrice,
        "shipProce": shipPrice,
        "discount": discount,
        "totalPrice": productsPrice + shipPrice - discount,
        "status": 1
      });

      await Firestore.instance
          .collection("users")
          .document(user.firebaseUser.uid)
          .collection("orders")
          .document(refOrder.documentID)
          .setData({"orderId": refOrder.documentID});

      QuerySnapshot query = await Firestore.instance
          .collection("users")
          .document(user.firebaseUser.uid)
          .collection("cart")
          .getDocuments();
      for (DocumentSnapshot doc in query.documents) {
        doc.reference.delete();
      }

      products.clear();
      discountPercentage = 0;
      couponCode = null;
      isLoading = false;
      notifyListeners();

      return refOrder.documentID;
    } catch (err) {
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  void _loadCartItems() async {
    QuerySnapshot query = await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .getDocuments();
    products = query.documents
        .map((product) => CartProduct.fromDocument(product))
        .toList();
    notifyListeners();
  }
}
