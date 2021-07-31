import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


  final usersReference = FirebaseFirestore.instance.collection("users");
  final postReference = FirebaseFirestore.instance.collection("posts");
  final commentsRef = FirebaseFirestore.instance.collection("comments");
  final activityFeedRef = FirebaseFirestore.instance.collection("feed");
  final messageReference = FirebaseFirestore.instance.collection("messages");
  final followingRef = FirebaseFirestore.instance.collection('following');
  final followersRef = FirebaseFirestore.instance.collection('followers');
  final timelineRef = FirebaseFirestore.instance.collection('timeline');
  final callRef = FirebaseFirestore.instance.collection('calls');
  final contactRef = FirebaseFirestore.instance.collection('contacts');
  final profileRef = FirebaseFirestore.instance.collection('profileId');
  var storageRef = FirebaseStorage.instance.ref();
