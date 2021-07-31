import 'package:flutter/material.dart';
import 'package:megas_chat/widgets/header_widget.dart';

class InputEvents extends StatefulWidget {
  @override
  _InputEventsState createState() => _InputEventsState();
}

class _InputEventsState extends State<InputEvents> {
  @override
  Widget build(BuildContext context) {
    scaffold(){
      return Scaffold(
        appBar: header(context, strTitle: "Note"),
        body: Column(),
      );
    }
    return scaffold();
  }

  FocusNode _focusNode;
  entryTextField(BuildContext context, String hint,{TextEditingController controller,bool isPassword = false}) {
    return Container(
      height: 50,
      margin: EdgeInsets.only(left: 30, right: 30),
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        // color: Colors.grey.shade200,
          color: Color(0XFFdae1eb),
          borderRadius: BorderRadius.circular(16)
      ),
      child: TextField(
        focusNode: _focusNode,
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(fontStyle: FontStyle.normal,fontWeight: FontWeight.normal),
        obscureText: isPassword,
        decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                borderSide: BorderSide(color: Colors.blue)),
            contentPadding:EdgeInsets.symmetric(vertical: 15,horizontal: 10)
        ),
      ),
    );
  }
}

