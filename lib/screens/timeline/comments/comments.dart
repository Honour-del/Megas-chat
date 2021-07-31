import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:megas_chat/services/references.dart';
import 'package:megas_chat/utils/consts.dart';
import 'package:megas_chat/widgets/header_widget.dart';
import 'package:megas_chat/widgets/progress_widget.dart';
import 'package:timeago/timeago.dart' as timeAgo;

import '../../home_view.dart';

final DateTime timeStamp = DateTime.now();
class CommentsPage extends StatefulWidget {
  final String  postId;
  final String ownerId;
  final String mediaUrl;

  CommentsPage({this.postId,this.ownerId,this.mediaUrl});
  @override
  CommentsPageState createState() => CommentsPageState(
    postId: this.postId,
    ownerId: this.ownerId,
    url: this.mediaUrl,
  );
}

class CommentsPageState extends State<CommentsPage> {
  TextEditingController commentController = TextEditingController();
  final String  postId;
  final String ownerId;
  final String url;

  CommentsPageState({this.postId,this.ownerId,this.url});
  buildComments(){
    return StreamBuilder(
      stream: commentsRef.doc(postId).collection("comments").orderBy("timeStamp", descending: false).snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData) {
          return circularProgress();
        }
        List<Comment> comments = [];
        snapshot.data.docs.forEach((doc){
          comments.add(Comment.fromDocument(doc));
        });
        return ListView(
          children: comments,
        );
      },
    );
  }

  postComment(){
    commentsRef.doc(postId)
        .collection("comments")
        .add({
      "username": currentUser.username,
      "comment": commentController.text,
      "timesStamp": timeStamp,
      "avatarUrl": AssetImage(picture),
      "userId": currentUser.id,
    });
    bool isNotPostOwner = ownerId != currentUser.id;
    if(isNotPostOwner) {
      activityFeedRef.doc(ownerId)
          .collection('feedItems')
          .add({
        "type": "comment",
        "commentData": commentController.text,
        "username": currentUser.username,
        "timesStamp": timeStamp,
        "avatarUrl": AssetImage(picture),
        "userId": currentUser.id,
        "postId": postId,
        "mediaUrl": url,
      });
    }
    commentController.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "Comments"),
      body: Column(
        children: [
          Expanded(child: buildComments()),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentController,
              decoration: InputDecoration(labelText: "Write your comment...."),
            ),
            trailing: TextButton(onPressed: postComment,
            child: Text("posts"),),
          ),
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String username;
  final String userId;
  final String avatarUrl;
  final String comment;
  final DateTime timeStamp;

  Comment({
    this.username,
    this.userId,
    this.avatarUrl,
    this.comment,
    this.timeStamp
});

  factory Comment.fromDocument(DocumentSnapshot doc){
    return Comment(
      username: doc['username'],
      userId: doc['userId'],
      avatarUrl: doc['avatarUrl'],
      comment: doc['comment'],
      timeStamp: doc['timeStamp'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(comment),
          leading: CircleAvatar(
            backgroundImage: AssetImage(picture),),
          subtitle: Text(timeAgo.format(timeStamp.toUtc())),
        ),
        Divider(),
      ],
    );
  }
}
