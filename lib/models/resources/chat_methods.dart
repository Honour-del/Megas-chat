import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:megas_chat/models/call/contact.dart';
import 'package:megas_chat/models/messages.dart';
import 'package:megas_chat/services/references.dart';
import 'package:meta/meta.dart';

class ChatMethods {

  static Future<void> addMessageToDb(
    Message message,
  ) async {
    await messageReference
        .doc(message.senderId)
        .collection(message.receiverId)
        .add({
      // 'message': message.message,
      // 'receiverId': message.receiverId,
      // 'senderId': message.senderId,
      // 'timestamp': DateTime.now(),
    });

    // addToContacts(senderId: message.senderId, receiverId: message.receiverId);

    return await messageReference
        .doc(message.receiverId)
        .collection(message.senderId)
        .get();
  }

  DocumentReference getContactsDocument({String of, String forContact}) =>
      usersReference
          .doc(of)
          .collection(contactRef.id)
          .doc(forContact);

  addToContacts({String senderId, String receiverId}) async {
    DateTime currentTime = DateTime.now();

    await addToSenderContacts(senderId, receiverId, currentTime);
    await addToReceiverContacts(senderId, receiverId, currentTime);
  }

  Future<void> addToSenderContacts(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot senderSnapshot =
        await getContactsDocument(of: senderId, forContact: receiverId).get();

    if (!senderSnapshot.exists) {
      //does not exists
      Contact receiverContact = Contact(
        uid: receiverId,
        addedOn: currentTime,
      );

      var receiverMap = receiverContact.toMap(receiverContact);

      await getContactsDocument(of: senderId, forContact: receiverId)
          .set(receiverMap);
    }
  }

  Future<void> addToReceiverContacts(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot receiverSnapshot =
        await getContactsDocument(of: receiverId, forContact: senderId).get();

    if (!receiverSnapshot.exists) {
      //does not exists
      Contact senderContact = Contact(
        uid: senderId,
        addedOn: currentTime,
      );

      var senderMap = senderContact.toMap(senderContact);

      await getContactsDocument(of: receiverId, forContact: senderId)
          .set(senderMap);
    }
  }

  void setImageMsg(String url, String receiverId, String senderId) async {
    Message message;
    message = Message(
        message: "IMAGE",
        receiverId: receiverId,
        senderId: senderId,
        imageMessage: url,
        timestamp: DateTime.now(),
        type: 'image');

    // create imagemap
    //var  = message;

    // var map = Map<String, dynamic>();
    await messageReference
        .doc(message.senderId)
        .collection(message.receiverId)
        .add({});

    messageReference
        .doc(message.receiverId)
        .collection(message.senderId)
        .add({});
  }

  Stream<QuerySnapshot> fetchContacts({String userId}) => usersReference
      .doc(userId)
      .collection(contactRef.id)
      .snapshots();

  Stream<QuerySnapshot> fetchLastMessageBetween({
    @required String senderId,
    @required String receiverId,
  }) =>
      messageReference
          .doc(senderId)
          .collection(receiverId)
          .orderBy("timestamp")
          .snapshots();
}
