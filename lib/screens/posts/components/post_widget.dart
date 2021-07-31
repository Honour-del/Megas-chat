//import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:megas_chat/models/user/user.dart';
import 'package:megas_chat/screens/notifcations/notifications.dart';
import 'package:megas_chat/screens/timeline/comments/comments.dart';
import 'package:megas_chat/services/references.dart';
import 'package:megas_chat/utils/utilities.dart';
import 'package:megas_chat/widgets/Custom_image.dart';
import 'package:megas_chat/widgets/progress_widget.dart';

import '../../home_view.dart';


class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final dynamic likes;
  final String username;
  final String description;
  final String postMediaUrl;

  Post({
    this.postId,
    this.ownerId,
    this.likes,
    this.username,
    this.description, //this.location,
    this.postMediaUrl,
});

  factory Post.fromDocument(DocumentSnapshot doc, Map<String, dynamic> docdata){
    return Post(
      postId: docdata["postId"],
      ownerId: docdata["ownerId"],
      likes: docdata["likes"],
      username: docdata["username"],
      description: docdata["description"],
      postMediaUrl: docdata["url"],
    );
  }

  int getTotalNumbersOfLikes(List likes){
    if (likes == null)
      {
        return 0;
      }
    int counter = 0;
    likes.forEach((eachValue){
      if(eachValue == true)
        {
          counter = counter +1;
        }
    });
    return counter;
  }


  @override
  _PostState createState() => _PostState(
    postId: this.postId,
    ownerId: this.ownerId,
    likes: this.likes,
    username: this.username,
    description: this.description,
    url: this.postMediaUrl,

    likesCount: getTotalNumbersOfLikes(this.likes),
  );
}



class _PostState extends State<Post>
{
  final String postId;
  final String ownerId;
  Map likes;
  final String username;
  final String description;
  final String location;
  final String url;
  int likesCount;
  bool isLiked;
  bool showHeart = false;
  final String currentOnlineUserId = currentUser?.id;
//heart likes
  _PostState({
    this.postId,
    this.ownerId,
    this.likes,
    this.username,
    this.description,
    this.location,
    this.url,
    this.likesCount,
  });


  @override
  Widget build(BuildContext context) {
    isLiked = (likes[currentUser] == true);
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          createPostHeader(),
          createPostPicture(),
          createPostFooter(),
        ],
      ),
    );
  }

  createPostHeader(){
    return FutureBuilder(
      future: usersReference.doc(ownerId).get(),
      builder: (context, doc){
        if(!doc.hasData)
          {
            return circularProgress();
          }
        Map _docdata = doc.data();
        Users user = Users.fromDocument(doc.data, _docdata);
        bool isPostOwner = currentOnlineUserId == ownerId;
        return ListTile(
          leading: CircleAvatar( backgroundColor:  Colors.grey,backgroundImage: AssetImage('assets/photo.png')),//backgroundImage: CachedNetworkImageProvider(user?.url)
          title: GestureDetector(
            onTap: ()=>showProfile(context),
            child: Text(
              user.username,
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          subtitle: Text(location, style: TextStyle(color: Colors.grey),),
          trailing: isPostOwner ? IconButton(
            icon: Icon(Icons.more_vert, color: Colors.grey,),
            onPressed: ()=>"tapped",
          ) : Text(""),
        );
      },
    );
  }

  likePost(){
   bool _isLiked = likes[currentOnlineUserId] == true;
   if(_isLiked){
     postReference.doc(ownerId)
     .collection('Posts Pictures')
     .doc(postId)
     .update({'likes.$currentOnlineUserId': false});
     removeLikeFromActivityFeed();
     setState(() {
       likesCount -= 1;
       _isLiked = false;
       likes[currentOnlineUserId] = false;
     });
   } else if (!_isLiked){
     postReference.doc(ownerId)
         .collection('Posts Pictures')
         .doc(postId)
         .update({'likes.$currentOnlineUserId': true});
     setState(() {
       likesCount += 1;
       _isLiked = true;
       likes[currentUser] = true;
     });
   }
  }

  addLikeToActivityFeed(){
    //add a notification to the post owner activity feed only if comment made by Other Users
    // (to avoid getting notification for our own like)
    //Map _docdata =
    Users user = Users();
    bool isNotOwner = currentOnlineUserId != ownerId;
    if (isNotOwner){
      activityFeedRef
          .doc(ownerId)
          .collection("feedItems")
          .doc(postId)
          .set({
        "type": "like",
        "username": user.username,
        "userId": user.id,
        "userProfileImage": AssetImage('assets/photo.png'),
        "postId": postId,
        "media": url,
        // "timeStamp": timeStamp,
      });
    }
  }
  removeLikeFromActivityFeed(){
    bool isNotOwner = currentOnlineUserId != ownerId;
   if(isNotOwner){
     activityFeedRef
         .doc(ownerId)
         .collection("feedItems")
         .doc(postId)
         .get().then((doc) {
       if(doc.exists){
         doc.reference.delete();
       }
     });
   }
  }

  createPostPicture(){
    return GestureDetector(
      onDoubleTap: likePost,
      child: Stack(
        alignment: Alignment.center,
        children: [
          cachedNetworkImage(url),
        ],
      ),
    );
  }

  createPostFooter(){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(left: 20,top: 40)),
            GestureDetector(
              onTap: likePost,
              child: Icon(
                isLiked ? (Icon(Icons.thumb_up ,color: Colors.deepPurple,size: 28,)) : Icons.thumb_up,
                size: 28,
              ),
            ),
            // Padding(padding: EdgeInsets.only(right: 20)),
            Spacer(),
            GestureDetector(
              onTap: ()=> showComments(
                context,
                postId: postId,
                ownerId: ownerId,
                url: url,
              ),
              child: Icon(
                Icons.chat_bubble_outline, size: 28, color: DARK_PURPLE_COLOR,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                "$likesCount  likes",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Spacer(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(username, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
            ),
            Expanded(
              child: Text(description, style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
      ],
    );
  }
}


showComments(BuildContext context, {String postId, String ownerId, String url}){
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return CommentsPage(
        postId: postId,
        ownerId: ownerId,
        mediaUrl: url,
    );
  }));
}

