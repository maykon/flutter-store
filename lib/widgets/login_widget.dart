import 'package:flutter/material.dart';
import 'package:store/screens/login_screen.dart';

class LoginWidget extends StatelessWidget {
  final String title;
  final IconData icon;

  const LoginWidget({Key key, this.title, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon ?? Icons.remove_shopping_cart,
            size: 80.0,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(height: 16.0),
          Text(
            title ?? "Faça o login para adicionar produtos!",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.0),
          RaisedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Text(
              "Entrar",
              style: TextStyle(fontSize: 18.0),
            ),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
