import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  final String orderId;

  const OrderTile({Key key, this.orderId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection("orders")
              .document(orderId)
              .snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
                break;
              default:
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Código do pedido: $orderId",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.0),
                    Text(_buildBuildProductText(snapshot.data)),
                    SizedBox(height: 4.0),
                    Text(
                      "Status do pedido",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _buildCircle(
                            "1", "Preparação", snapshot.data["status"], 1),
                        _buildLine(),
                        _buildCircle(
                            "2", "Transporte", snapshot.data["status"], 2),
                        _buildLine(),
                        _buildCircle(
                            "3", "Entrega", snapshot.data["status"], 3),
                      ],
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }

  String _buildBuildProductText(DocumentSnapshot snapshot) {
    String text = "Descrição:\n";
    for (LinkedHashMap p in snapshot.data["products"]) {
      text +=
          "${p["quantity"]} x ${p["product"]["title"]} (R\$ ${p["product"]["price"].toStringAsFixed(2)})\n";
    }
    text += "Total: R\$ ${snapshot.data["totalPrice"].toStringAsFixed(2)}";
    return text;
  }

  Widget _buildLine() {
    return Container(
      height: 1.0,
      width: 40.0,
      color: Colors.grey[500],
    );
  }

  Widget _buildCircle(
      String title, String subtitle, int status, int thisStatus) {
    Color backColor;
    Widget child;

    if (status < thisStatus) {
      backColor = Colors.grey[500];
      child = Text(title, style: TextStyle(color: Colors.white));
    } else if (status == thisStatus) {
      backColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(title, style: TextStyle(color: Colors.white)),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      );
    } else {
      backColor = Colors.green;
      child = Icon(Icons.check, color: Colors.white);
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subtitle)
      ],
    );
  }
}
