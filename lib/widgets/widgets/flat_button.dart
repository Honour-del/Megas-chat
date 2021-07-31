import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Button extends StatelessWidget {
  // const FlatButton({Key? key}) : super(key: key);

  Button({
    this.onPressed,
    this.label,
    this.color,
    this.height,
    this.width
  });
  final VoidCallback onPressed;
  final String label;
  final Color color;
  final double height;
  final double  width;
  @override
  Widget build(BuildContext context) {
    // final heights = MediaQuery.of(context).size.height;
    final widths = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        height: 50,
        width: widths / 3.2,
        // color: color,
        child: Center(
          child: Text(label,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}


class RoundButton extends StatelessWidget {
  // const FlatButton({Key? key}) : super(key: key);

  RoundButton({
    this.onPressed,
    this.label,
    this.color,
    this.size
  });
  final VoidCallback onPressed;
  final String label;
  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      elevation: 20.0,
      fillColor: color,
      splashColor: color,
      padding: const EdgeInsets.all(22.0),
      shape: const CircleBorder(),
      child: Column(
        children: [
          const Icon(
            FontAwesomeIcons.longArrowAltRight,
            color: Colors.white,
            size: 24.0,
          ),
          Text(
            label,
            style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
