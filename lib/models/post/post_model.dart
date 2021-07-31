// //import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:megas_chat/models/user/user.dart';
// import 'package:megas_chat/screens/home_view.dart';
// import 'package:megas_chat/screens/notifcations/notifications.dart';
// import 'package:megas_chat/screens/timeline/comments/comments.dart';
// import 'package:megas_chat/services/references.dart';
// import 'package:megas_chat/utils/utilities.dart';
// import 'package:megas_chat/widgets/Custom_image.dart';
// import 'package:megas_chat/widgets/progress_widget.dart';
//
// // import '../../home_view.dart';
//
//
// class Post extends StatefulWidget {
//   final String postId;
//   final String ownerId;
//   final dynamic likes;
//   final String username;
//   final String description;
//   final String postMediaUrl;
//
//   Post({
//     this.postId,
//     this.ownerId,
//     this.likes,
//     this.username,
//     this.description, //this.location,
//     this.postMediaUrl,
//   });
//
//   factory Post.fromDocument(DocumentSnapshot doc, Map<String, dynamic> docdata){
//     return Post(
//       postId: docdata["postId"],
//       ownerId: docdata["ownerId"],
//       likes: docdata["likes"],
//       username: docdata["username"],
//       description: docdata["description"],
//       postMediaUrl: docdata["url"],
//     );
//   }
//
//   int getTotalNumbersOfLikes(likes){
//     if (likes == null)
//     {
//       return 0;
//     }
//     int counter = 0;
//     likes.values.forEach((eachValue){
//       if(eachValue == true)
//       {
//         counter = counter + 1;
//       }
//     });
//     return counter;
//   }
//
//
//   @override
//   PostState createState() => PostState(
//     postId: this.postId,
//     ownerId: this.ownerId,
//     likes: this.likes,
//     username: this.username,
//     description: this.description,
//     url: this.postMediaUrl,
//
//     likesCount: getTotalNumbersOfLikes(this.likes),
//   );
// }
//
//
//
