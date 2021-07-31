import 'package:flutter/material.dart';

class BouncyPageRoute extends PageRouteBuilder{
  final Widget widget;

  BouncyPageRoute({this.widget}): super(
      transitionDuration: Duration(milliseconds: 500),
          transitionsBuilder: (BuildContext context,Animation<double> animation,Animation<double>  secAnimation, Widget child){
            animation = CurvedAnimation(parent: animation, curve: Curves.easeOut);
            return ScaleTransition(scale: animation,
              alignment: Alignment.center,
              child: child,
            );
          },
          pageBuilder: (BuildContext context,Animation<double> animation,Animation<double>  secAnimation ){
            return widget;
      }
  );
}