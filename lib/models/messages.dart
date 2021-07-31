import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String type;
  final String message;
  final DateTime timestamp;
  final String photoUrl;
  final String imageMessage;
  final String videoMessage;

  Message({
    this.senderId,
    this.receiverId,
    this.type,
    this.message,
    this.timestamp,
    this.imageMessage,
    this.videoMessage,
    this.photoUrl,
  });

  factory Message.fromDocument(DocumentSnapshot doc,
      Map<String, dynamic> docdata){
    return Message(
      senderId: doc.id,
      receiverId: doc.id,
      type: docdata["type"],
      message: docdata["message"],
      timestamp: docdata["timestamp"],
      photoUrl: docdata["photoUrl"],
      videoMessage: docdata["videoMessage"],
      imageMessage: docdata["imageMessage"],
    );
  }
}