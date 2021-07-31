import 'package:flutter/material.dart';
import 'package:megas_chat/screens/chat_screens/search_chat/search_chat.dart';
import 'package:megas_chat/utils/utilities.dart';


class QuietBox extends StatelessWidget {
  final String heading;
  final String subtitle;

  QuietBox({
    @required this.heading,
    @required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          // color: UniversalVariables.separatorColor,
          padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                heading,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 25),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 25),
              // ignore: deprecated_member_use
              FlatButton(
                color: MyPurple,
                child: Text("START SEARCHING"),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatSearchPage(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
