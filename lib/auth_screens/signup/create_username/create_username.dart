import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megas_chat/widgets/header_widget.dart';


class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  // final _scaffoldKey = GlobalKey<ScaffoldState>().currentState;
  final _formKey = GlobalKey<FormState>();
  String username;

  submitUsername() async {
    final form = _formKey.currentState;
    if(form.validate())
      {
        form.save();

        SnackBar snackBar = SnackBar(content: Text("Welcome " + username));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Timer(Duration(seconds: 4), (){
          Navigator.pop(context, username);
        });
      }
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      // key: _scaffoldKey,
      appBar: header(context, strTitle: "Username", disappearedBackButton: true),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.07),
                    child: Center(
                      child: Text("Set up your username", style: TextStyle(fontSize: 26,),),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 17,bottom: 17),
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.only(left: 30, right: 30),
                    padding: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(241, 241, 241, 1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextFormField(
                      style: TextStyle(color:  Colors.black),
                      validator: (val) {
                        if(val.trim().length<5 || val.isEmpty){
                          return "username is too short.";
                        }else if(val.trim().length>15 || val.isEmpty){
                          return "username is too long.";
                        }
                        else{
                          return null;
                        }
                      },
                      onSaved: (val) => username = val,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "set your username",
                        labelStyle: TextStyle(fontSize: 16),
                        hintText: "must be at least 5 characters ",
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.01,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height* 0.12,
                  ),
                  GestureDetector(
                    onTap: submitUsername,
                    child: Container(
                      height:  55,
                      width: MediaQuery.of(context).size.width*0.7,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(28, 34, 87, 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          "Proceed",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
