import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:megas_chat/auth_screens/signup/create_username/create_username.dart';
// import 'package:instagram/utilities/constants.dart';
import 'package:megas_chat/models/UserData.dart';
import 'package:megas_chat/models/user/user.dart';
import 'package:megas_chat/screens/home_view.dart';
import 'package:megas_chat/services/references.dart';
import 'package:megas_chat/widgets/progress_widget.dart';
import 'package:provider/provider.dart';



class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  // static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static  FirebaseMessaging _messaging;
  static bool loading = false;

  static Future<void> signUpUser(
      BuildContext context, String name, String email, String password) async {
    try {
       await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User signedInUser = _auth.currentUser;
      if (signedInUser != null) {
        // String token = await _messaging.getToken();
        final username = await Navigator.push(context, MaterialPageRoute(builder: (ctx) => CreateAccountPage()));
        usersReference.doc(signedInUser.uid).set({
          'name': name,
          'email': email,
          "uid": signedInUser.uid,
          "username": username,
          "photoUrl": signedInUser.photoURL,
          "displayName": signedInUser.displayName,
          "bio": "Edit profile to update bio",
          "timeStamp": Timestamp.now(),
          "phone": signedInUser.phoneNumber,
          // 'token': token,
          'isVerified': false,
        });
        await followersRef
            .doc(signedInUser.uid)
            .collection('userFollowers')
            .doc(signedInUser.uid)
            .set({});
        if(_auth.currentUser != null){
          print(signedInUser.uid);
        }
        loading = true;
          circularProgress();
        DocumentSnapshot documentSnapshot = await usersReference.doc(signedInUser.uid).get();
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
          return HomePage();}));
        loading = false;
       Map<String, dynamic> _docdata = documentSnapshot.data as Map<String, dynamic>;
       currentUser = Users.fromDocument(documentSnapshot,_docdata);

    }
      Provider.of<UserData>(context, listen: false).currentUserId =
          signedInUser.uid;
      Navigator.pop(context);
    }  catch (err) {
      throw (err);
    }
  }

  static Future<void> signUp(
      BuildContext context, String email, String password) async {
    try {
        await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // User signedInUser = authResult.user;
    } on PlatformException catch (err) {
      throw (err);
    }
  }

  static Future<void> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      if(user != null){
        return user.uid;
      }

    } on PlatformException catch (err) {
      throw (err);
    }
  }

  static Future<void> removeToken() async {
    final currentUser =  _auth.currentUser;
    await usersReference
        .doc(currentUser.uid)
        .set({'token': ''},);//merge: true
  }

  static Future<void> updateToken() async {
    final currentUser =  _auth.currentUser;
    final token = await _messaging.getToken();
    final userDoc = await usersReference.doc(currentUser.uid).get();
    if (userDoc.exists) {
      Map<String, Object> docdata= userDoc.data();
      Users user = Users.fromDocument(userDoc, docdata);
      if (token != user.token) {
        usersReference
            .doc(currentUser.uid)
            .set({'token': token}, );//merge = true;
      }
    }
  }

  static Future<void> updateTokenWithUser(Users user) async {
    final token = await _messaging.getToken();
    if (token != user.token) {
      await usersReference.doc(user.id).update({'token': token});
    }
  }

  static Future<void> logout() async {
    await removeToken();
    Future.wait([
      _auth.signOut(),
    ]);
  }
}


// class AuthService{
//
// }