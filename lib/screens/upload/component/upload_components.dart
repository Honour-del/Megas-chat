import 'dart:io';
import 'package:megas_chat/auth_screens/signup/signup.dart';
import 'package:megas_chat/services/references.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:uuid/uuid.dart';

class Uploads{
  File file;
  String postId = Uuid().v4();
  static Future<String> uploadPhoto(mImageFile) async {
    String postId = Uuid().v4();
    UploadTask uploadTask =
    storageRef.child('post_$postId.jpg').putFile(mImageFile);
    TaskSnapshot storageSnap = await uploadTask.whenComplete(() => storageRef);
    String downloadUrl = await (storageSnap).ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadVideo(mVideoFile) async {
    UploadTask uploadTask =
    storageRef.child('post_$postId.mp4').putFile(mVideoFile);
    TaskSnapshot storageSnaps = await uploadTask.whenComplete(() => storageRef);
    String downloadUrl = await (storageSnaps).ref.getDownloadURL();
    return downloadUrl;
  }



  static Future createPostInFireStore({ String mediaUrl, String location, String caption}) {
    var widget;
    String postId = Uuid().v4();
    DateTime timeStamp = DateTime.now();
    postReference
        .doc(widget.currentUser.id)
        .collection('posts')
        .doc(postId)
        .set({
      'postId': postId,
      'ownerId': widget.currentUser.id,
      'username': widget.currentUser.username,
      'url': mediaUrl,
      'description': caption,
      'timeStamp': timeStamp,
      'likes': {},
    });
    return null;
  }
}
