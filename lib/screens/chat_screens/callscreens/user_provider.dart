import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:megas_chat/models/user/user.dart';
import 'package:megas_chat/models/user_state.dart';
import 'package:megas_chat/services/references.dart';
import 'package:megas_chat/utils/utilities.dart';


class UserProvider with ChangeNotifier {
  Users _user;
  FirebaseAuth _auth = FirebaseAuth.instance;


  Future<User> getCurrentUser() async {
    User currentUserr;
    currentUserr = _auth.currentUser; //////// I don't really know how this works it should be changed later
    return currentUserr;
  }
  Future<Users> getUserDetails() async {
    User currentUser = await getCurrentUser();

    DocumentSnapshot documentSnapshot =
    await usersReference.doc(currentUser.uid).get();
    //Map doc = documentSnapshot.data();
    Map _docdata = documentSnapshot.data as Map<String, dynamic>;
    return Users.fromDocument(documentSnapshot, _docdata);
  }

  Future<Users> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot =
      await usersReference.doc(id).get();
      Map _docdata = documentSnapshot.data as Map<String, dynamic>;
      return Users.fromDocument(documentSnapshot, _docdata);
    } catch (e) {
      print(e);
      return null;
    }
  }

  void setUserState({@required String userId, @required UserState userState}) {
    int stateNum = Utils.stateToNum(userState);
    usersReference.doc(userId).update({
      "state": stateNum,
    });
  }

  Stream<DocumentSnapshot> getUserStream({@required String uid}) =>
      usersReference.doc(uid).snapshots();

  Users get getUser => _user;

  Future<void> refreshUser() async {
    Users user = await getUserDetails();
    _user = user;
    notifyListeners();
  }

}
