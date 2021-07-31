//Sign up page

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:megas_chat/auth_screens/login/login.dart';
import 'package:megas_chat/models/user/user.dart';
import 'package:megas_chat/screens/home_view.dart';
import 'package:megas_chat/services/auth_services.dart';
import 'package:megas_chat/services/references.dart';
import 'package:megas_chat/utils/sizeConfig.dart';
import 'package:megas_chat/utils/utilities.dart';
import 'package:megas_chat/widgets/widgets/flat_button.dart';

import 'create_username/create_username.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;

class SignUp extends StatefulWidget {
  static final routeName = "/sign_up";

  @override
  _SignUpState createState() => _SignUpState();
}

final DateTime timeStamp = DateTime.now();

class _SignUpState extends State<SignUp> {
  // @override
  bool passAuth = false;
  void initState() {
    super.initState();
    // _auth.authStateChanges().listen((User user) {
    //   handleLogin(user);
    // });
    //_auth.signInAnonymously(suppressErrors: false);
  }


  final DateTime timeStamp = DateTime.now();


  //for Email and password auth
  bool _secureText = true;
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextStyle let = GoogleFonts.convergence(color: PURPLE_COLOR, fontSize: 24, fontWeight: FontWeight.bold);
  final TextStyle lets = GoogleFonts.convergence(color: PURPLE_COLOR, fontSize: 22);
  String _name;
  String _password;
  String _email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(50),
                  ),
                  Text(
                    "Welcome",
                    style: lets,
                  ),
                  Text(
                    "To MegaS",
                    style: let,
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(90),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    padding: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                        color: Color(0XFFdae1eb),
                        borderRadius: BorderRadius.circular(100.0),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.1),
                              offset: Offset(6, 2),
                              blurRadius: 6.0,
                              spreadRadius: 3.0),
                          BoxShadow(
                              color: Color.fromRGBO(255, 255, 255, 0.9),
                              offset: Offset(-6, -2),
                              blurRadius: 6.0,
                              spreadRadius: 3.0)
                        ]),
                    child: TextFormField(
                      controller: name,
                      decoration: InputDecoration(
                        hintText: "name",
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      onSaved: (input) => _name = input,
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(25),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    padding: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                        color: Color(0XFFdae1eb),
                        borderRadius: BorderRadius.circular(100.0),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.1),
                              offset: Offset(6, 2),
                              blurRadius: 6.0,
                              spreadRadius: 3.0),
                          BoxShadow(
                              color: Color.fromRGBO(255, 255, 255, 0.9),
                              offset: Offset(-6, -2),
                              blurRadius: 6.0,
                              spreadRadius: 3.0)
                        ]),
                    child: TextFormField(
                      controller: phone,
                      autocorrect: true,
                      decoration: InputDecoration(
                        hintText: "phone number ....+234",
                        border: InputBorder.none,
                      ),
                      validator: (String val) {
                        Pattern _pat = r'(^(?:[+0]9)?[0-9]{10,12}$)'; //r'/^\(?(\d{3})\)?[- ]?(\d{3})[- ]?(\d{4})$/'
                        RegExp regEx = new RegExp(_pat);
                        if (!regEx.hasMatch(val)) {
                          return "Enter valid phone Number";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      obscureText: false,
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(25),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    padding: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                        color: Color(0XFFdae1eb),
                        borderRadius: BorderRadius.circular(100.0),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.1),
                              offset: Offset(6, 2),
                              blurRadius: 6.0,
                              spreadRadius: 3.0),
                          BoxShadow(
                              color: Color.fromRGBO(255, 255, 255, 0.9),
                              offset: Offset(-6, -2),
                              blurRadius: 6.0,
                              spreadRadius: 3.0)
                        ]),
                    child: TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                        hintText: "email",
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      onSaved: (input) => _email = input,
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(25.00),
                  ),
                  Container(
                    height: 50,
                    margin: EdgeInsets.only(left: 30, right: 30),
                    padding: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                        color: Color(0XFFdae1eb),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.1),
                              offset: Offset(6, 2),
                              blurRadius: 6.0,
                              spreadRadius: 3.0),
                          BoxShadow(
                              color: Color.fromRGBO(255, 255, 255, 0.9),
                              offset: Offset(-6, -2),
                              blurRadius: 6.0,
                              spreadRadius: 3.0)
                        ]),
                    child: TextFormField(
                      controller: password,
                      decoration: InputDecoration(
                        hintText: 'password',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(
                            (_secureText
                                ? Icons.remove_red_eye
                                : Icons.security),
                            color: Color.fromRGBO(143, 148, 251, 1),
                          ),
                          onPressed: () {
                            setState(() {
                              _secureText = !_secureText;
                            });
                          },
                        ),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _secureText,
                      onSaved: (input) => _password = input,
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(143, 148, 251, 1),
                              borderRadius: BorderRadius.circular(100.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.1),
                                    offset: Offset(7, 2),
                                    blurRadius: 7.0,
                                    spreadRadius: 3.0),
                                BoxShadow(
                                    color: Color.fromRGBO(255, 255, 255, 0.9),
                                    offset: Offset(-6, -2),
                                    blurRadius: 7.0,
                                    spreadRadius: 3.0)
                              ]),
                          child: Button(
                             label: "    Sign Up   ",
                            color: Color.fromRGBO(143, 148, 251, 1),
                            onPressed: () async {
                              if (name.text.length < 4) {
                                displayToastMessage(
                                    "Name must be at least 4 char..", context);
                              } else if (!email.text.contains("@")) {
                                displayToastMessage(
                                    "Email address is not Valid.", context);
                              } else if (phone
                                  .text.isEmpty) {
                                displayToastMessage(
                                    "Phone Number is compulsory..", context);
                              } else if (phone.text
                                  .contains("+")) {
                                displayToastMessage(
                                    "Phone Number is not valid..", context);
                              } else if (password.text.length < 5) {
                                displayToastMessage(
                                    "Password is too short", context);
                              } else if (_formKey.currentState.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                _formKey.currentState.save();
                                _registerAccount();
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(10),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: getProportionateScreenWidth(25), right: getProportionateScreenWidth(25)),
                          child: Center(
                            child: Text(
                              "By signing up you agree to \nour terms and conditions",
                              style: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(10),
                        ),
                        RoundButton(
                          onPressed: (){
                            Navigator.pushNamed(context, LoginScreen.routeName);
                          },
                          label: 'Login',
                          color: MyPurple,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // handleLogin(User user) async{
  //   if (user != null) {
  //     await saveUserToFireStore();
  //     setState(() {
  //       passAuth = true;
  //     });
  //   } else {
  //     setState(() {
  //       passAuth = false;
  //     });
  //   }
  // }

  ////// this will save users info to firestore
  ////// 'https://www.vpsmalaysia.com.my/wp-content/uploads/backup/2016/09/profile-picture.png'
  ////// username might be set manually and Profile pic will be set automatically from email and can be changed later
  //  saveUserToFireStore() async{//User cu
  //   // String profilePic = cu.photoURL;
  //   final User gCurrentUser = _auth.currentUser;
  //   DocumentSnapshot documentSnapshot = await usersReference.doc(gCurrentUser.uid).get();
  //   if (!documentSnapshot.exists){
  //
  //     final username = await Navigator.push(context, MaterialPageRoute(builder: (ctx) => CreateAccountPage()));
  //     usersReference.doc(gCurrentUser.uid).set({
  //       "uid": gCurrentUser.uid,
  //       "email": gCurrentUser.email,
  //       "username": username,
  //       "photoUrl": gCurrentUser.photoURL,
  //       "displayName": name.text,
  //       "bio": "Edit profile to update bio",
  //       "timeStamp": timeStamp,
  //       "phone": phone.text,
  //     });
  //     // await gCurrentUser.updateProfile(displayName: nameTextEditingController.text,);
  //     await followersRef
  //         .doc(gCurrentUser.uid)
  //         .collection('userFollowers')
  //         .doc(gCurrentUser.uid)
  //         .set({});
  //     if(_auth.currentUser != null){
  //       print(gCurrentUser.uid);
  //     }
  //     documentSnapshot = await usersReference.doc(gCurrentUser.uid).get();
  //     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
  //       return HomePage();}));
  //   }
  //   Map<String, dynamic> _docdata = documentSnapshot.data as Map<String, dynamic>;
  //   currentUser = Users.fromDocument(documentSnapshot,_docdata);
  // }
  _showErrorDialog(String errorMessage) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
            actions: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  //////this function will register the account
  FirebaseAuth auth = FirebaseAuth.instance;
  void _registerAccount() async{
    try{
      await AuthService.signUpUser(context, name.text, email.text, password.text);
      displayToastMessage('success', context);
      // await _auth.createUserWithEmailAndPassword(
      //     email: email.text,
      //     password: password.text);
      // displayToastMessage('success', context);
      // // await saveUserToFireStore();
    }catch (e){
      _showErrorDialog(e.toString());
      // displayToastMessage(e, context);
      print("Error: " + e.toString());
    }
  }


  displayToastMessage(String message, BuildContext context) async{
    Fluttertoast.showToast(msg: message);
  }
}

