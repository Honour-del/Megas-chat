import 'package:flutter/material.dart';
import 'package:megas_chat/screens/posts/components/post_widget.dart';
import 'package:megas_chat/widgets/Custom_image.dart';

import '../postsView.dart';


class PostTile extends StatelessWidget {
  final Post post;

  PostTile(this.post);

  showPost(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostScreen(
          postId: post.postId,
          ownerId: post.ownerId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPost(context),
      child: cachedNetworkImage(post.postMediaUrl),
      //child: cachedNetworkImage(post.mediaUrl),
    );
  }
}
