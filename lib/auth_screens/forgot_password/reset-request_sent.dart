import 'package:flutter/material.dart';
import 'package:megas_chat/utils/utilities.dart';

class ResetSent extends StatefulWidget {
  @override
  _ResetSentState createState() => _ResetSentState();
}

class _ResetSentState extends State<ResetSent> {
final Text data = Text("Congratulations reset email has been successfully sent to the provided email Account");
final TextStyle _style = TextStyle(color: DARK_PURPLE_COLOR, fontWeight: FontWeight.bold, fontSize: 18);

  sentAnime(){
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/message_sent.gif"),
            Text('$data', style: _style,),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
