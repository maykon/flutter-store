import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final PageController pageController;
  final int page;

  const DrawerTile(
      {Key key, this.icon, this.text, this.pageController, this.page})
      : super(key: key);

  bool get isCurrentPage {
    return pageController.page.round() == page;
  }

  @override
  Widget build(BuildContext context) {
    Color _getActualColor() {
      return isCurrentPage ? Theme.of(context).primaryColor : Colors.black;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          pageController.jumpToPage(page);
        },
        child: Container(
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 32.0,
                color: _getActualColor(),
              ),
              SizedBox(width: 32.0),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: _getActualColor(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
