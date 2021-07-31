import 'package:flutter/material.dart';
import 'package:megas_chat/services/references.dart';
import 'package:megas_chat/widgets/header_widget.dart';
import 'package:megas_chat/widgets/progress_widget.dart';

import 'components/post_widget.dart';

class PostScreen extends StatelessWidget {
  final String ownerId;
  final String postId;

  PostScreen({this.ownerId, this.postId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: postReference
          .doc(ownerId)
          .collection('posts')
          .doc(postId)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        Map<String, dynamic> docdata = snapshot.data();
        Post post = Post.fromDocument(snapshot.data, docdata);
        return Center(
          child: Scaffold(
            appBar: header(context, strTitle: 'Post', disappearedBackButton: false),
            body: ListView(
              children: <Widget>[
                Container(
                  child: post,//post
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
