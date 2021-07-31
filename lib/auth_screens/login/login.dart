//Login page
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:megas_chat/auth_screens/forgot_password/forgotPassword.dart';
import 'package:megas_chat/auth_screens/signup/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megas_chat/screens/home_view.dart';
import 'package:megas_chat/services/auth_services.dart';
import 'package:megas_chat/services/references.dart';
import 'package:megas_chat/utils/sizeConfig.dart';
import 'package:megas_chat/utils/utilities.dart';
import 'package:megas_chat/widgets/pages_anime.dart';
import 'package:megas_chat/widgets/progress_widget.dart';
import 'package:megas_chat/widgets/widgets/flat_button.dart';




// final GoogleSignIn gSignIn = GoogleSignIn();
class LoginScreen extends StatefulWidget {
  static final routeName = "/login";

  final VoidCallback loginCallback;

  const LoginScreen({Key key, this.loginCallback}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
bool passAuth = false;
bool _isLoading = false;
bool isSignedIn = false;
final _formKey = GlobalKey<FormState>();
void initState(){
  super.initState();
}

 // bool _isLoading = false;
  bool _secureText = true;
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController email= TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextStyle let = GoogleFonts.convergence(color: DARK_ORANGE, fontSize: 31, fontWeight: FontWeight.bold);
  final TextStyle lets = GoogleFonts.convergence(color: DARK_ORANGE, fontSize: 22);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.28,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.07, 0, 0, 0),
                      child: Text(
                        "Welcome Back!",
                        style: let,
                      ),
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.02,
                    ),

                    Container(
                      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.07, 0, 0, 0),
                      child: Text(
                        "you've been missed.",
                        style: let,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.08,
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.only(left: getProportionateScreenWidth(30), right: getProportionateScreenWidth(30)),
                      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
                      decoration: BoxDecoration(
                          color: Color(0XFFdae1eb),
                          //color: Color.fromRGBO(241, 241, 241, 1),
                        borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.1),
                              blurRadius: 6, // soften the shadow
                              spreadRadius: 3, //end the shadow
                              offset: Offset(
                                6.0, // Move to right 10  horizontally
                                2.0, // Move to bottom 10 Vertically
                              ),
                            ),
                            BoxShadow(
                              color: Color.fromRGBO(255, 255, 255, 0.5),
                              blurRadius: 6, // soften the shadow
                              spreadRadius: 3, //end the shadow
                              offset: Offset(
                                -6.0, // Move to right 10  horizontally
                                -2.0, // Move to bottom 10 Vertically
                              ),
                            ),
                          ]),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "email",
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        controller: email,
                      ),
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.02,
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
                              blurRadius: 6, // soften the shadow
                              spreadRadius: 3, //end the shadow
                              offset: Offset(
                                6.0, // Move to right 10  horizontally
                                2.0, // Move to bottom 10 Vertically
                              ),
                            ),
                            BoxShadow(
                              color: Color.fromRGBO(255, 255, 255, 0.5),
                              blurRadius: 6, // soften the shadow
                              spreadRadius: 3, //end the shadow
                              offset: Offset(
                                -6.0, // Move to right 10  horizontally
                                -2.0, // Move to bottom 10 Vertically
                              ),
                            ),
                          ]),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'password',
                          //errorText: _passwordError,
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon((_secureText ? Icons.remove_red_eye:Icons.security
                            ),color: Color.fromRGBO(247, 126, 74, 1),),
                            onPressed: (){
                              setState(() {
                                _secureText = !_secureText;
                              });
                            },
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _secureText,
                        controller: password,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                    if (_isLoading) Center(
                      child: circularProgress()
                    ),
                    //if (!_isLoading)
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          if (_isLoading) CircularProgressIndicator(),
                          if (!_isLoading)
                          Button(
                            color: Color.fromRGBO(247, 126, 74, 1),
                            onPressed: ()async{
                              Navigator.of(context).pushNamed(HomePage.routeName);
                              // if(!emailTextEditingController.text.contains("@")){
                              //   displayToastMessage("Presented email is not valid", context);
                              // }
                              // else if(passwordTextEditingController.text.length < 5 ){
                              //   displayToastMessage("Presented password is not valid", context);
                              // }
                              // else{
                              //   if(_formKey.currentState.validate()){
                              //     _signInWithEmailPassword();
                              //   }
                              //   }
                               },
                            label: "     Login     ",
                          ),
                          /////////// this is the space between the buttons..........
                          SizedBox(height: getProportionateScreenHeight(10),),
                          TextButton(
                            onPressed: (){
                              Navigator.pushNamed(context, ForgetPasswordPage.routeName);
                            },
                            child: Text(
                              "     Forgot password?     ",
                              style: TextStyle(color: Color.fromRGBO(124, 2, 2, 1), fontSize: 18),
                            ),
                          ),
                          Container(
                            //alignment: Alignment.center,
                            margin: EdgeInsets.only(left: getProportionateScreenWidth(50), right: getProportionateScreenWidth(30)),
                          ),
                          if (!_isLoading)
                          RoundButton(
                            onPressed: (){Navigator.of(context).push(
                              BouncyPageRoute(widget:SignUp()),);},
                            label: "SignUp",
                            color: PALE_ORANGE,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }


  // gotoForgotPass(){
  //   return Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ForgetPasswordPage()));
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


//static final FirebaseMessaging _messaging = FirebaseMessaging();
  bool okay = false;
   _signInWithEmailPassword() async{
  if(_formKey.currentState.validate()){
    FocusScope.of(context).unfocus();
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
      circularProgress();
    });
    try{
      AuthService.loginUser(email.text.trim(), password.text.trim());
        DocumentSnapshot documentSnapshot = await usersReference.doc(currentUser.id).get();
      if(documentSnapshot.exists){
        // Map<String, dynamic> docdata = documentSnapshot.data as Map<String, dynamic>;
        // final Users gCurrentUser = Users.fromDocument(documentSnapshot, docdata);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
          return HomePage(
            authUsers: authUser,
          );
        }));
        setState(() {
          _isLoading = false;
        });
      }else if(!documentSnapshot.exists){  ///// if data is not correct it will return this.......
        displayToastMessage("Email or password is not correct!", context);
      }
    } catch (err) {
      _showErrorDialog(err);
      // displayToastMessage("Failed to SignIn with provided credential", context);
      print("Error: " + "$err");
      setState(() {
        _isLoading = false;
      });
    }
  }
}
}
