import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String id;
  final String username;
  final String email;
  final String photoUrl;
  final String displayName;
  final String bio;
  final String name;
  final String phone;
  final String token;
  String receiverId;
  String type;
  String message;
  final bool isVerified;
  int followers;
  int following;
  String webSite;
  int state;
  List<String> followersList;
  List<String> followingList;


  Users(
      {this.id,
        this.username,
        this.email,
        this.photoUrl,this.isVerified,
        this.displayName,this.token,
        this.bio, this.name,this.phone,
        this.followers,
        this.following,
        this.state,
        this.webSite,
      });

   Users.fromDocument(DocumentSnapshot doc, Map<String, dynamic> docdata) : this(
       id: doc.id,
       username: docdata['username'] as String,
       email: docdata['email'] as String,
       photoUrl: docdata['photoUrl'] as String,
       displayName: docdata['displayName'] as String,
       bio: docdata['bio'] as String,
       name: docdata['name'] as String,
       phone: docdata['phone'] as String,
       token: docdata['token'] as String,
       isVerified: docdata['isVerified'] ?? false,
       followers: docdata['followers'],
       following: docdata['following'],
       state: docdata['state']
   );

   Map<String, Object> toJson(){
     return {
       'id' : id,
       'username' : username,
       'email' : email,
       'photoUrl' : photoUrl,
       'displayName' : displayName,
       'bio' : bio,
       'phone' : name,
     };
   }
  String getFollower() {
    return '${this.followers ?? 0}';
  }

  String getFollowing() {
    return '${this.following ?? 0}';
  }

}
//import 'package:cloud_firestore/cloud_firestore.dart';
//
// class Users {
//    String uid;
//    String profileName;
//    String username;
//    String url;
//    String email;
//    String bio;
//    String message;
//    String name;
//    String phone;
//    String password;
//
//
//
//
//     Users.fromMap(Map<String, dynamic> data) {
//       uid = data['id'];
//       email =  data['email'];
//       username = data['username'];
//       url = data['url'];
//       profileName = data['profileName'];
//       bio = data['bio'];
//       message = data['message'];
//       password = data['password'];
//       phone = data['phoneNumber'];
//       name = data['names'];
//
//   }
// }
//import 'package:cloud_firestore/cloud_firestore.dart';
//
// class Users {
//    String uid;
//    String profileName;
//    String username;
//    String url;
//    String email;
//    String bio;
//    String message;
//    String name;
//    String phone;
//    String password;
//
//
//
//
//     Users.fromMap(Map<String, dynamic> data) {
//       uid = data['id'];
//       email =  data['email'];
//       username = data['username'];
//       url = data['url'];
//       profileName = data['profileName'];
//       bio = data['bio'];
//       message = data['message'];
//       password = data['password'];
//       phone = data['phoneNumber'];
//       name = data['names'];
//
//   }
// }