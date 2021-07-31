import 'package:flutter/material.dart';

class SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  SettingsAppBar({Key key, this.title, this.subtitle}) : super(key: key);
  final String title, subtitle;
  final Size appBarHeight = Size.fromHeight(60.0);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 5),
          Text(
            title ?? '',
            style: Theme.of(context).textTheme.headline6,
          ),
          Text(
            subtitle ?? '',
            style: Theme.of(context).textTheme.bodyText1,
          )
        ],
      ),
      backgroundColor: Theme.of(context).appBarTheme.color,
    );
  }

  @override
  Size get preferredSize => appBarHeight;
}
