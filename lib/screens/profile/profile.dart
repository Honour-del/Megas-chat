import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:megas_chat/models/user/user.dart';
import 'package:megas_chat/screens/posts/components/post_tile_widget.dart';
import 'package:megas_chat/screens/posts/components/post_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:megas_chat/services/references.dart';
import 'package:megas_chat/utils/utilities.dart';
import 'package:megas_chat/widgets/header_widget.dart';
import 'package:megas_chat/widgets/pages_anime.dart';
import 'package:megas_chat/widgets/progress_widget.dart';
import 'package:megas_chat/widgets/widgets/customWidgets.dart';
import '../home_view.dart';
import 'components/edit_profile.dart';
import 'components/profile_pic_view.dart';
// import 'components/profile_pic_view.dart';

class Profile extends StatefulWidget {
  static final routeName = "/profile";
  final String profileId;
  final String users;
  Profile({this.profileId, this.users});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isMyProfile = false;
  final String currentUserId = currentUser?.id;
  bool isLoading = false;
  bool isFollowing = false;
  bool edit = false;
  String postOrientation = 'grid';
  String email;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;
  List<Post> posts = [];
  String userName;
  String profileName;
  String bio;
  String profilePic;
  String id;
  bool dataIsThere = false;
  Users _users;


  getCurrentUserInfo() async {
    print(widget.profileId);
    //var firebaseuser = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userdoc =
    await usersReference.doc(widget.profileId).get();
    setState(() {
      id = userdoc['id'];/////???
      userName = userdoc['username'];
      profileName = userdoc['displayName'];
      bio = userdoc['bio'];
      profilePic = userdoc['photoUrl'];
      dataIsThere = true;
    });
  }


//  Users _users;
  @override
  void initState() {
    super.initState();
    getData();
    // getCurrentUserInfo();
    getProfilePosts();
    getFollowers();
    getFollowing();
    checkIfFollowing();
  }

  getFollowers() async {
    QuerySnapshot snapshot = await followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .get();
    setState(() {
      followerCount = snapshot.docChanges.length;
      print(followerCount);
    });
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingRef
        .doc(widget.profileId)
        .collection('userFollowing')
        .get();
    setState(() {
      followingCount = snapshot.docChanges.length;
      print(followingCount);
    });
  }

  checkIfFollowing() async {
    DocumentSnapshot doc = await followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId)
        .get();
    setState(() {
      isFollowing = doc.exists;
    });
  }

  getProfilePosts() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await postReference
        .doc(widget.profileId)
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .get();
    setState(() {
      isLoading = false;
      postCount = snapshot.docs.length;
      Map<String, dynamic> _docdata = snapshot.docs.last.data();//not sure
      posts = snapshot.docs.map((doc) => Post.fromDocument(doc, _docdata)).toList();////this should be where the problem lies
    });
    print("this is your id: " + widget.profileId);
  }

  Column buildCountColumn(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '$count',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfile(currentUserId: currentUserId),
      ),
    );
  }

  buildButton({String text, Function function}) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 6),
        child: TextButton(
          onPressed: ()async{
            await function;
          },
          child: Container(
            height: 27,
            decoration: BoxDecoration(
              border: Border.all(
                color: isFollowing ? Colors.grey : DARK_PURPLE_COLOR,
              ),
              borderRadius: BorderRadius.circular(5),
              color: isFollowing ? Colors.white : DARK_PURPLE_COLOR,
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: isFollowing ? BLACK_COLOR : Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  buildProfileButton() {
    bool isProfileOwner = currentUserId == widget.profileId;
    if (isProfileOwner) {
      return buildButton(
        text: 'Edit Profile',
        function: editProfile,
      );
    } else{
      return !isFollowing ?  buildButton(
        text: 'Follow', function: handleFollowUser
      ) : buildButton(text: 'Unfollow', function: handleUnfollowUser);
    }
  }

  void handleUnfollowUser() {
    setState(() {
      isFollowing = false;
      followerCount --;
    });
    followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    followingRef
        .doc(currentUserId)
        .collection('userFollowing')
        .doc(widget.profileId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    activityFeedRef
        .doc(widget.profileId)
        .collection('feedItems')
        .doc(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // if(!mounted) return;
  }

  void handleFollowUser() {
    setState(() {
      isFollowing = true;
      followerCount ++;
    });
    followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId)
        .set({});
    followingRef
        .doc(currentUserId)
        .collection('userFollowing')
        .doc(widget.profileId)
        .set({});
    activityFeedRef
        .doc(widget.profileId)
        .collection('feedItems')
        .doc(currentUserId)
        .set({
      'type': 'follow',
      'ownerId': widget.profileId,
      // 'username': currentUser.username,
      'userId': currentUserId,
      'userProfileImg': AssetImage('assets/photo.jpeg'),
      'timestamp': 'timeStamp',///coming back here
    });

  }

  Future<DocumentSnapshot> getData() async {
    final User alien = FirebaseAuth.instance.currentUser;
    return usersReference.doc(alien.uid).get();
  }

  buildProfileHeader() {//wanna add star progress like 2go ? increase in star is directly proportional to increase in followers
    return FutureBuilder(
      future: getData(),//usersReference.doc(widget.profileId).get()
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if(snapshot.connectionState != ConnectionState.done){
          return Center(
            child: Text(
              "Please check your internet connection",
            ),
          );
        }
        if (!snapshot.hasData) {
          return circularProgress();
        }
          return  Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            buildCountColumn( "posts", postCount != null ? postCount : 0),
                            buildCountColumn('follower', followerCount -1),
                            buildCountColumn('following', followingCount),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            buildProfileButton(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 12),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      snapshot.data.get('username'),//+ _users.displayName
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    // user.isVerified ?
                    // FaIcon(FontAwesomeIcons.pen, color: DARK_PURPLE_COLOR, size: 13,) : SizedBox(width: 0,),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 4),
                alignment: Alignment.centerLeft,
                child: customText(
                  snapshot.data.get('name'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 2),
                alignment: Alignment.centerLeft,
                child: Text(
                  snapshot.data.get('bio'),
                ),
              ),
            ],
          ),
        ) ;
      },
    );
  }

  buildProfilePosts() {
    if (isLoading) {
      return circularProgress();
    }
    if (posts.isEmpty) {
      return Center(
          child: Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                "No posts...",
                style: TextStyle(fontSize: 30),
              )));}
    if(posts != null){
      return posts;
    }
    if (postOrientation == "Grid") {
      List<GridTile> gridTiles = [];
      posts
          .forEach((post) {
        gridTiles.add(GridTile(
          child: PostTile(post),
        ));
      });
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTiles,
      );
    } else {
      return Column(
        children: posts,
      );
    }
  }

  buildTogglePostOrientation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.grid_on),
          onPressed: () => setPostOrientation('grid'),
          color: postOrientation == 'grid'
              ? DARK_PURPLE_COLOR
              : Colors.grey,
        ),
        IconButton(
          icon: Icon(Icons.list),
          onPressed: () => setPostOrientation('list'),
          color: postOrientation == 'list'
              ? DARK_PURPLE_COLOR
              : Colors.grey,
        ),
      ],
    );
  }

  setPostOrientation(String postOrientation) {
    setState(() {
      this.postOrientation = postOrientation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "Profile"),
      body: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.of(context).pushNamed(ProfileView.routeName);
                    },
                    child: CircleAvatar(
                    radius: 60,
                     backgroundColor: Colors.black,
                     backgroundImage: profilePic == null ?  AssetImage('assets/photo.png'):CachedNetworkImageProvider(profilePic),////[this should either be currentUser.photoUrl or profilePic]////
                     // backgroundImage: currentUser.photoUrl.isEmpty
                     //     ? AssetImage('assets/photo.jpeg')
                     //     : CachedNetworkImageProvider(currentUser.photoUrl),
                    ),
                  ),
                )
              ],
            ),
          ),
          buildProfileHeader(),
          Divider(),
          buildTogglePostOrientation(),
          Divider(),
          buildProfilePosts()
        ],
      )
    );
  }

  displayToastMessage(String message, BuildContext context) async{
    Fluttertoast.showToast(msg: message);
  }



  String getBio(String bio) {//  to get bio from snapshot after been edites
    if (bio != null && bio.isNotEmpty && bio != "Edit profile to update bio") {
      if (bio.length > 100) {
        bio = bio.substring(0, 100) + '...';
        return bio;
      } else {
        return bio;
      }
    }
    return null;
  }
}
