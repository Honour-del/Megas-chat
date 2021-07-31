import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:megas_chat/models/resources/chat_methods.dart';
import 'package:megas_chat/models/user/user.dart';
import 'package:megas_chat/services/references.dart';
import 'image_upload_provider.dart';




class StorageMethods {
  //user class
  Users user = Users();

  Future<String> uploadImageToStorage(File imageFile) async {
    // mention try catch later on

    try {
      storageRef = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      UploadTask storageUploadTask =
          storageRef.putFile(imageFile);
      var url = await (await storageUploadTask.whenComplete(() => null)).ref.getDownloadURL();
      // print(url);
      return url;
    } catch (e) {
      return null;
    }
  }

  void uploadImage({
    @required File image,
    @required String receiverId,
    @required String senderId,
    @required ImageUploadProvider imageUploadProvider,
  }) async {
    final ChatMethods chatMethods = ChatMethods();

    // Set some loading value to db and show it to user
    imageUploadProvider.setToLoading();

    // Get url from the image bucket
    String url = await uploadImageToStorage(image);

    // Hide loading
    imageUploadProvider.setToIdle();

    chatMethods.setImageMsg(url, receiverId, senderId);
  }
}
