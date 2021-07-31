import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:megas_chat/models/call/call.dart';
import 'package:megas_chat/services/references.dart';

class CallMethods {
  Stream<DocumentSnapshot> callStream({String uid}) =>
      callRef.doc(uid).snapshots();

  Future<bool> makeCall({Call call}) async {
    try {
      call.hasDialled = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call);
      
      call.hasDialled = false;
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      await callRef.doc(call.callerId).set(hasDialledMap);
      await callRef.doc(call.receiverId).set(hasNotDialledMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall({Call call}) async {
    try {
      await callRef.doc(call.callerId).delete();
      await callRef.doc(call.receiverId).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
