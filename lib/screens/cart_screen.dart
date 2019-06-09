import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:store/models/cart_model.dart';
import 'package:store/models/user_model.dart';
import 'package:store/screens/order_screen.dart';
import 'package:store/tiles/cart_tile.dart';
import 'package:store/widgets/cart_price.dart';
import 'package:store/widgets/discount_card.dart';
import 'package:store/widgets/login_widget.dart';
import 'package:store/widgets/ship_card.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu carrinho"),
        centerTitle: true,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 8.0),
            alignment: Alignment.center,
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model) {
                int p = model.products.length;
                return Text("${p ?? 0} ${p == 1 ? "ITEM" : "ITEMS"}",
                    style: TextStyle(fontSize: 17.0));
              },
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model) {
          if (model.isLoading && UserModel.of(context).isLoggedIn()) {
            return Center(child: CircularProgressIndicator());
          } else if (!UserModel.of(context).isLoggedIn()) {
            return LoginWidget(
                title: "Faça o login para adicionar produtos!",
                icon: Icons.remove_shopping_cart);
          } else if (model.products == null || model.products.length == 0) {
            return Center(
              child: Text(
                "Nenhum produto no carrinho.",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView(
              children: <Widget>[
                Column(
                  children: model.products.map((product) {
                    return CartTile(cartProduct: product);
                  }).toList(),
                ),
                DiscountCard(),
                ShipCard(),
                CartPrice(buy: () async {
                  String orderId = await model.finishOrder();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => OrderScreen(orderId: orderId),
                  ));
                }),
              ],
            );
          }
        },
      ),
    );
  }
}
