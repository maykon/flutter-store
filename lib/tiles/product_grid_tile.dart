import 'package:flutter/material.dart';
import 'package:store/datas/product_data.dart';
import 'package:store/screens/product_screen.dart';

class ProductGridTile extends StatelessWidget {
  final ProductData product;

  const ProductGridTile({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductScreen(product: product),
          ),
        );
      },
      child: Card(
        child: Column(children: <Widget>[
          AspectRatio(
            aspectRatio: 0.8,
            child: Image.network(
              product.image,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    product.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "R\$ ${product.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
