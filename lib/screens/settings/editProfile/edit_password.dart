import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:megas_chat/auth_screens/forgot_password/forgotPassword.dart';
import 'package:megas_chat/models/user/user.dart';
import 'package:megas_chat/services/references.dart';
import 'package:megas_chat/utils/utilities.dart';
import 'package:megas_chat/widgets/header_widget.dart';
import 'package:megas_chat/widgets/pages_anime.dart';


class PasswordRest extends StatefulWidget {
  final String currentUserId;

  PasswordRest({this.currentUserId});
  @override
  _PasswordRestState createState() => _PasswordRestState();
}

class _PasswordRestState extends State<PasswordRest> {
  Users user;
  bool passwordValid = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _currentPass = TextEditingController();
  TextEditingController _newPass = TextEditingController();
  TextEditingController _confirmNewPass = TextEditingController();
  final TextStyle stx = GoogleFonts.convergence(color: BLACK_COLOR, fontWeight: FontWeight.bold);
  final TextStyle stxU = GoogleFonts.convergence(color: DARK_RED, fontWeight: FontWeight.bold);
  final TextStyle stxS = GoogleFonts.convergence(color: BLACK_COLOR, fontWeight: FontWeight.bold, fontSize: 30);

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    // setState(() {
    //   //isLoading = true;
    // });
    // DocumentSnapshot doc = await usersReference.doc(widget.currentUserId).get();
    // Map _docdata = doc.data();
    // user = Users.fromDocument(doc, _docdata);
    // _textController.text = user.password;
    // bioController.text = user.bio;
    // setState(() {
    //   isLoading = false;
    // });
  }

  updateProfileData() {
    setState(() {
      _newPass.text.trim().length < 3 ||
          _newPass.text.isEmpty
          ? passwordValid = false
          : passwordValid = true;
    });

    if (passwordValid) {
      usersReference.doc(widget.currentUserId).update({
        'displayName': _newPass.text,
      });
      print(_newPass.text);
      SnackBar snackbar = SnackBar(content: Text('Profile updated !'));
      // ignore: deprecated_member_use
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }

  textC(){
    return Padding(
      padding: EdgeInsets.all(18),
      child: Column(
        children: [
          Text("Current password", style: stx,),
          TextField(
            controller: _currentPass,
            decoration: InputDecoration(
              labelText: "Current password",
            ),
          )
        ],
      ),
    );
  }

  textN(){
    return Padding(
      padding: EdgeInsets.all(18),
      child: Column(
        children: [
          Text("New password", style: stx,),
          TextField(
            controller: _newPass,
            decoration: InputDecoration(
              labelText: "New password",
            ),
          )
        ],
      ),
    );
  }

  textCN(){
    return Padding(
      padding: EdgeInsets.all(18),
      child: Column(
        children: [
          Text("Confirm password", style: stx,),
          TextField(
            controller: _confirmNewPass,
            decoration: InputDecoration(
              labelText: "Confirm new password",
            ),
          )
        ],
      ),
    );
  }

  passButt(){
    return Padding(
      padding: EdgeInsets.all(25),
      child: MaterialButton(
        onPressed: (){},
        child: Text("CHANGE PASSWORD", style: stx,),
        color: PURPLE_COLOR,
      ),
    );
  }

  forPassButt(){
    return Padding(
      padding: EdgeInsets.only(left: 25,right: 25),
      child: TextButton(
        onPressed: (){},
        child: Text("Forgot PASSWORD?", style: stxU,),
        //color: PURPLE_COLOR,
      ),
    );
  }
  //go to forgot password page
  onPressed(){
    Navigator.of(context).push(BouncyPageRoute(widget: ForgetPasswordPage()));
  }

  passReset(){
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context,strTitle: "Change Password"),
      body: Container(
        child: SingleChildScrollView(child:
        Column(
          children: [
            textC(),
            textN(),
            textCN(),
            passButt(),
            forPassButt(),
          ],
        )
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return passReset();
  }
}
