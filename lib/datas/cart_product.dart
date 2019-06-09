import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store/datas/product_data.dart';

class CartProduct {
  String cid;
  String category;
  String pid;
  int quantity;
  int option;

  ProductData productData;

  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot document) {
    cid = document.documentID;
    category = document.data["category"];
    pid = document.data["pid"];
    quantity = document.data["quantity"];
    option = document.data["option"];
  }

  Map<String, dynamic> toMap() {
    return {
      "category": category,
      "pid": pid,
      "quantity": quantity,
      "option": option,
      "product": productData != null ? productData.toResumeMap() : [],
    };
  }
}
