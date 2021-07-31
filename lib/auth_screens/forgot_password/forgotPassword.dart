import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:megas_chat/utils/sizeConfig.dart';
import 'package:megas_chat/utils/utilities.dart';
import 'package:megas_chat/widgets/pages_anime.dart';
import 'package:megas_chat/widgets/widgets/flat_button.dart';
import 'package:megas_chat/widgets/widgets/utility.dart';
import 'reset-request_sent.dart';
//import 'package:provider/provider.dart';


class ForgetPasswordPage extends StatefulWidget{
  static final routeName = '/forget_password';
  final VoidCallback loginCallback;

  const ForgetPasswordPage({Key key, this.loginCallback}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ForgetPasswordPageState();

}

class _ForgetPasswordPageState extends State<ForgetPasswordPage>{
  FocusNode _focusNode;
  bool isSubmitted = false;
  TextEditingController _emailController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _focusNode = FocusNode();
    _emailController = TextEditingController();
    _emailController.text = '';
    _focusNode.requestFocus();
    super.initState();
  }
  @override
  void dispose(){
    _focusNode.dispose();
    super.dispose();
  }
  Widget _body(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child:ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: getProportionateScreenHeight(200),
              ),
              _label(),
              SizedBox(height: getProportionateScreenHeight(45),),
              _entryField('Enter email',controller: _emailController),
               SizedBox(height: getProportionateScreenHeight(35),),
              _submitButton(context),
            ],)
      ),
    );
  }


  Widget _entryField(String hint,{TextEditingController controller,bool isPassword = false}){
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20), right: getProportionateScreenWidth(20)),
      child: Container(
        height: 50,
        // margin: EdgeInsets.only(left: 30, right: 30),
        // padding: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
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
              contentPadding:EdgeInsets.symmetric(vertical: 15,horizontal: 10)
          ),
        ),
      ),
    );
  }
  Widget _submitButton(BuildContext context){
    return Container(
        height: 55,
        width: MediaQuery.of(context).size.width*0.7,
        decoration: BoxDecoration(
          color: Color.fromRGBO(28, 34, 87, 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Button(
          color: DARK_PURPLE_COLOR,
          onPressed:_submit,
          label: "Submit",
        )
    );
  }
  Widget _label(){
    return Container(
        child:Column(
          children: <Widget>[
            Text('Forget Password',style:TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Enter your email address below to receive password reset instruction',
                  style:TextStyle(fontSize: 18,fontWeight: FontWeight.w500,),textAlign: TextAlign.center),

            )
          ],
        )
    );
  }

  goTOAnimePage(){
    Navigator.of(context).push(BouncyPageRoute(widget: ResetSent()));
    setState(() {
      // isSubmitted == true;
    });
  }

  void _submit() async{
    if(_emailController.text == null || _emailController.text.isEmpty){
      displayToastMessage('Email field cannot be empty', context);
      return;
    }

    if(!_emailController.text.contains("@")){
      displayToastMessage('Please enter valid email address', context);
      return;
    }
    _focusNode.unfocus();
    forgetPassword();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Forget Password',style: TextStyle(fontSize: 20)),
        centerTitle: true,
      ),
      body: _body(context),
    );
  }

  displayToastMessage(String message, BuildContext context) async{
    Fluttertoast.showToast(msg: message);
  }

  validateEmail(String text) {}

  FirebaseAuth _auth = FirebaseAuth.instance;
  /// Send password reset link to email
  Future<void> forgetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text).then((value) {
        displayToastMessage("A reset password link is sent yo your mail.You can reset your password from there", context);
        logEvent('forgot+password');
        return Navigator.pop(context);
      }).catchError((error) {
        cprint(error.message);
        return false;
      });
    } catch (error) {
      displayToastMessage("Error: " +  error.message, context);
      return Future.value(false);
    }
  }
}
