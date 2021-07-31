import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:megas_chat/screens/settings/editProfile/EventsSett.dart';
import 'package:megas_chat/screens/settings/editProfile/edit_email.dart';
import 'package:megas_chat/screens/settings/editProfile/edit_password.dart';
import 'package:megas_chat/screens/settings/editProfile/edit_phoneNumber.dart';
import 'package:megas_chat/screens/settings/editProfile/edit_username.dart';
import 'package:megas_chat/screens/settings/privacyAndSafety/privacyAndSafetyPage.dart';
import 'package:megas_chat/services/references.dart';
import 'package:megas_chat/widgets/header_widget.dart';
import 'package:megas_chat/widgets/pages_anime.dart';
import 'package:megas_chat/widgets/progress_widget.dart';

import '../../home_view.dart';


class Account extends StatefulWidget {
  final String currentUserId;

  Account({this.currentUserId});
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String userName;
  String phoneNumber;
  String email;
  bool dataIsThere = false;

  @override
  void initState() {
    super.initState();
    //getData();
    getCurrentUserInfo();
  }

  getCurrentUserInfo() async {
    print(widget.currentUserId);
    DocumentSnapshot userdoc =
    await usersReference.doc(widget.currentUserId).get();
    setState(() {
      userName = userdoc['username'];
      phoneNumber = userdoc['phone'];
      email = userdoc['email'];
      dataIsThere = true;
    });
  }


  _passW(){
    return Navigator.of(context).push(BouncyPageRoute(widget:PasswordRest(currentUserId: currentUser.id,)));//not yet created
  }

  emailW(){
    return Navigator.of(context).push(BouncyPageRoute(widget:EmailSett()));//not yet created
  }

  phoneW(){
    return Navigator.of(context).push(BouncyPageRoute(widget:PhoneSett()));//not yet created
  }

  usernameW(){
    return Navigator.of(context).push(BouncyPageRoute(widget:UsernameSett()));//not yet created
  }

  _eventW(){
    return Navigator.of(context).push(BouncyPageRoute(widget:Events()));//not yet created
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "Account"),
      body:  dataIsThere == true ? Container(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Login and security", style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
              ),
              color: Colors.black26,
            ),
            Expanded(
                child: Column(
                  children: [
                    ListTile(
                      title: Text("Username",style: Theme.of(context).textTheme.subtitle1,),
                      subtitle: Text("@"+"$userName"),
                      onTap: () => usernameW(),
                    ),
                    Divider(),
                    ListTile(
                      title: Text("Phone",style:  Theme.of(context).textTheme.subtitle1,),
                      subtitle: Text("$phoneNumber",),
                      onTap: () => phoneW(),
                    ),
                    Divider(),
                    ListTile(
                      title: Text("Email",style:  Theme.of(context).textTheme.subtitle1,),
                      subtitle: Text("$email",),
                      onTap: () => emailW(),
                    ),
                    Divider(),
                    ListTile(
                      title: Text("Password",style:  Theme.of(context).textTheme.subtitle1,),
                      subtitle: Text("*********"),
                      onTap: () => _passW(),
                    ),
                    Divider(),
                    ListTile(
                      title: Text("Data privacy",style:  Theme.of(context).textTheme.subtitle1,),
                      onTap: () => _privacy(),
                    ),
                    Divider(),
                    ListTile(
                      title: Text("Event",style:  Theme.of(context).textTheme.subtitle1),
                      subtitle: Text("You can set reminder and keep other important things here",style:  Theme.of(context).textTheme.bodyText2),
                      onTap: () => _eventW(),
                    ),
                    Divider(),
                  ],
                )
            ),
            TextButton(onPressed: (){},
                child: Text("Delete Account")),
          ],
        ),
      ) : Center(child: circularProgress(),),
    );
  }
  _privacy(){
    return Navigator.of(context).push(BouncyPageRoute(widget:PrivacyPages()));//not yet created
  }

//   Future _deleteAccount() async{
//     try{
//       await _auth.currentUser.;
//     }catch(e){
//       print("Error: " + e);
//     }
//   }
}