// class MegaUser {
//   String name;
//   String email;
//   String username;
//   String status;
//   int state;
//   String profilePhoto;
//   String id;
//   String photoUrl;
//   String displayName;
//   String bio;
//   String phone;
//   String token;
//   String type;
//   String message;
//   bool isVerified;
//   int followers;
//   int following;
//   String webSite;
//   List<String> followersList;
//   List<String> followingList;
//
//
//   MegaUser({
//     this.id,
//     this.name,
//     this.email,
//     this.username,
//     this.status,
//     this.state,
//     this.profilePhoto,
//     this.photoUrl,
//     this.followers,
//     this.webSite,
//     this.displayName,
//     this.phone,
//     this.bio,
//     this.isVerified,
//     this.following,
//     this.token,
//     this.followingList,
//     this.followersList,
//   });
//
//   Map toMap(MegaUser user) {
//     var data = Map<String, dynamic>();
//     data['uid'] = user.id;
//     data['name'] = user.name;
//     data['email'] = user.email;
//     data['username'] = user.username;
//     data["status"] = user.status;
//     data["state"] = user.state;
//     data["profile_photo"] = user.profilePhoto;
//     data["phone"] = user.phone;
//     data["bio"] = user.bio;
//     data["displayName"] = user.displayName;
//     data["webSite"] = user.webSite;
//     data["photoUrl"] = user.photoUrl;
//     data["following"] = user.following;
//     data["followers"] = user.followers;
//     data['followers'] = followersList != null ? followersList.length : null;
//     data['following'] = followingList != null ? followingList.length : null;
//     return data;
//   }
//
//   // Named constructor
//   MegaUser.fromMap(Map<String, dynamic> mapData) {
//     this.id = mapData['uid'];
//     this.name = mapData['name'];
//     this.email = mapData['email'];
//     this.username = mapData['username'];
//     this.status = mapData['status'];
//     this.state = mapData['state'];
//     this.profilePhoto = mapData['profile_photo'];
//     this.photoUrl = mapData["photoUrl"];
//     this.webSite = mapData["webSite"];
//     this.phone = mapData["phone"];
//     this.displayName = mapData["displayName"];
//     this.bio = mapData["bio"];
//     followers = mapData['followers'];
//     following = mapData['following'];
//     if (mapData['followerList'] != null) {
//       // ignore: deprecated_member_use
//       followersList = List<String>();
//       mapData['followerList'].forEach((value) {
//         followersList.add(value);
//       });
//     }
//     followers = followersList != null ? followersList.length : null;
//     if (mapData['followingList'] != null) {
//       // ignore: deprecated_member_use
//       followingList = List<String>();
//       mapData['followingList'].forEach((value) {
//         followingList.add(value);
//       });
//     }
//     following = followingList != null ? followingList.length : null;
//   }
// }
