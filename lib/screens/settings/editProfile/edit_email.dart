import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:megas_chat/models/user/user.dart';
import 'package:megas_chat/services/references.dart';
import 'package:megas_chat/utils/utilities.dart';
import 'package:megas_chat/widgets/header_widget.dart';


class EmailSett extends StatefulWidget {
  final String currentUserId;
  EmailSett({this.currentUserId});
  @override
  _EmailSettState createState() => _EmailSettState();
}

class _EmailSettState extends State<EmailSett> {
  @override
  void initState() {
    super.initState();
  }
    Users user;
    bool passwordValid = true;
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    TextEditingController _currentPass = TextEditingController();
    TextEditingController _newPass = TextEditingController();
    TextEditingController _confirmNewPass = TextEditingController();
    final TextStyle stx = GoogleFonts.convergence(color: BLACK_COLOR, fontWeight: FontWeight.bold);
    final TextStyle stxU = GoogleFonts.convergence(color: DARK_RED, fontWeight: FontWeight.bold);
    final TextStyle stxS = GoogleFonts.convergence(color: BLACK_COLOR, fontWeight: FontWeight.bold, fontSize: 30);

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
        _scaffoldKey.currentState.showSnackBar(snackbar);
      }
    }

    textC(){
      return Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          children: [
            Text("Current email", style: stx,),
            TextField(
              controller: _currentPass,
              decoration: InputDecoration(
                labelText: "Current email",
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
            Text("New email", style: stx,),
            TextField(
              controller: _newPass,
              decoration: InputDecoration(
                labelText: "New email",
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
          child: Text("CHANGE EMAIL", style: stx,),
          color: PURPLE_COLOR,
        ),
      );
    }



    passReset(){
      return Scaffold(
        key: _scaffoldKey,
        appBar: header(context,strTitle: "Change Email"),
        body: Container(
          child: SingleChildScrollView(child:
          Column(
            children: [
              textC(),
              textN(),
              passButt(),
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
