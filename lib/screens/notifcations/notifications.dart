import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:megas_chat/screens/posts/postsView.dart';
import 'package:megas_chat/screens/profile/profile.dart';
import 'package:megas_chat/services/references.dart';
import 'package:megas_chat/utils/consts.dart';
import 'package:megas_chat/utils/utilities.dart';
import 'package:megas_chat/widgets/header_widget.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../home_view.dart';

class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

getActivityFeed() async {
  QuerySnapshot snapshot = await activityFeedRef
      .doc(currentUser.id)
      .collection('feedItems')
      .orderBy('timestamp', descending: true)
      .limit(50)
      .get();
  List<ActivityFeedItem> feedItems = [];
  snapshot.docs.forEach((doc) {
    feedItems.add(ActivityFeedItem.fromDocument(doc));
  });
  print(feedItems);
  snapshot.docs.forEach((doc) {
    print('Activity Feed Items ${doc.data}');
  });
  return feedItems;
}

class _ActivityFeedState extends State<ActivityFeed> {
  Future userNotifications;

  @override
  void initState() {
    super.initState();
    userNotifications = getActivityFeed();
  }


  final TextStyle lets = GoogleFonts.convergence(color: PURPLE_COLOR, fontSize: 22);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: 'Activities & Notifications', disappearedBackButton: true),
      body: Container(
        child: FutureBuilder(
          future: userNotifications,
          builder: (context, snapshot) {
            if(snapshot.hasError)
              Text(snapshot.error.toString());
              // showErrorDialog(snapshot.error);
            if (!snapshot.hasData) {
              return Center(
                child: Text(
                    "             No Notifications Yet \nfollow people and post Pictures/Video \n              to receive notifications",
                  style: GoogleFonts.convergence(color: BLACK_COLOR, fontSize: 17),
                ),
              );
            }
            if(snapshot.hasData)
              return snapshot.data;
            return ListView(//original item is only snapshot.data//,Text('hekki',style: TextStyle(fontSize: 50),)
              children: snapshot.data,
            );
          },
        ),
      ),
    );
  }
  showErrorDialog(String errorMessage,) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
            actions: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }
}

Widget mediaPreview;
String activityItemText;

class ActivityFeedItem extends StatelessWidget {
  final String username;
  final String ownerId;
  final String type;
  final String mediaUrl;
  final String postId;
  final String userProfileImg;
  final String commentData;
  final DateTime timestamp;

  ActivityFeedItem(
      {this.username,
        this.ownerId,
        this.type,
        this.mediaUrl,
        this.postId,
        this.userProfileImg,
        this.commentData,
        this.timestamp});

  factory ActivityFeedItem.fromDocument(DocumentSnapshot doc) {
    return ActivityFeedItem(
      username: doc['username'],
      ownerId: doc['ownerId'],
      type: doc['type'],
      mediaUrl: doc['mediaUrl'],
      postId: doc['postId'],
      userProfileImg: doc['userProfileImg'],
      commentData: doc['commentData'],
      timestamp: doc['timestamp'],
    );
  }

  showPost(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostScreen(
          postId: postId,
          ownerId: ownerId,
        ),
      ),
    );
  }

  configureMediaPreview(context) {
    if (type == 'like' || type == 'comment') {
      mediaPreview = GestureDetector(
        onTap: () => showPost(context),
        child: Container(
          height: 50,
          width: 50,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(mediaUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      mediaPreview = Text('');
    }
    if (type == 'like') {
      activityItemText = ' liked your post';
    } else if (type == 'follow') {
      activityItemText = ' is following you';
    } else if (type == 'comment') {
      activityItemText = ' replied: $commentData';
    } else {
      activityItemText = ' Error : Unknown type $type';
    }
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 2),
      child: Container(
        child: ListTile(
          title: GestureDetector(
            onTap: () => showProfile(context, profileId: ownerId),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(
                  color: DARK_GREEN,
                ),
                children: [
                  TextSpan(
                    text: "username",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,color: BLACK_COLOR,
                    ),
                  ),
                  TextSpan(
                    text: '$activityItemText',
                  ),
                ],
              ),
            ),
          ),
          leading: CircleAvatar(//CachedNetworkImageProvider(userProfileImg),
            backgroundImage: AssetImage(picture),
          ),
          subtitle: Text(
            timeago.format(
              timestamp.toUtc(),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: mediaPreview,
        ),
      ),
    );
  }
}

showProfile(BuildContext context, {String profileId}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Profile(
        profileId: profileId,
      ),
    ),
  );
}
