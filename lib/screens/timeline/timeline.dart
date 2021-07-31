import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:megas_chat/models/UserData.dart';
import 'package:megas_chat/models/user/user.dart';
import 'package:megas_chat/screens/drawer/drawer.dart';
import 'package:megas_chat/screens/posts/components/post_widget.dart';
import 'package:megas_chat/screens/profile/profile.dart';
import 'package:megas_chat/screens/search/search_page.dart';
import 'package:megas_chat/screens/upload/component/upload_photo.dart';
import 'package:megas_chat/services/database_services.dart';
import 'package:megas_chat/services/references.dart';
import 'package:megas_chat/utils/utilities.dart';
import 'package:megas_chat/widgets/pages_anime.dart';
import 'package:megas_chat/widgets/progress_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../home_view.dart';



// final usersReference = Firestore.instance.collection("users");
class TimeLinePage extends StatefulWidget {
  final String currentUserId;
  final Users currentUser;

  TimeLinePage({this.currentUserId, this.currentUser});

  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}
class _TimeLinePageState extends State<TimeLinePage> with SingleTickerProviderStateMixin{
  List<Post> posts = [];
  List<Users> userStories = [];
  List<dynamic> users = [];
  bool _isLoadingFeed = false;
  bool _isLoadingStories = false;


  @override
  void initState() {
    super.initState();
    getUsers();
    DataBase.getData();
    _setupFeed();
    getTimeline();
  }

  getUsers()async{
    final QuerySnapshot snapshot = await usersReference.get();
    setState(() {
      users = snapshot.docs;
    });
  }
  _setupFeed() async {
    _setupStories();

    setState(() => _isLoadingFeed = true);

    List<Post> posts = await DataBase.getFeedPosts(
      widget.currentUserId,
    );

    // List<Post> posts = await DatabaseService.getAllFeedPosts();
    setState(() {
      posts = posts;
      _isLoadingFeed = false;
    });
  }

  void _setupStories() async {
    setState(() => _isLoadingStories = true);

    // Get currentUser followingUsers
    List<Users> followingUsers =
    await DataBase.getUserFollowingUsers(widget.currentUserId);

    if (!mounted) return;
    Users currentUser =
        Provider.of<UserData>(context, listen: false).currentUser;
    /* A method to add Admin stories to each user */
    if (currentUser.id != currentUser.id) {
      bool isFollowingAdmin = false;

      for (Users user in followingUsers) {
        if (user.id == currentUser.id) {
          isFollowingAdmin = true;
        }
      }
      // if current user doesn't follow admin
      if (!isFollowingAdmin) {
        // get admin stories
        List<Post> adminStories =
        await DataBase.getStoriesByUserId(currentUser.id, true);

        if (!mounted) return;
        // if there is admin stories
        if (adminStories != null && adminStories.isNotEmpty) {
          // get admin user
          Users adminUser = await DataBase.getUserWithId(currentUser.id);
          if (!mounted) return;
          // add admin to story circle list
          followingUsers.insert(0, adminUser);
        }
      }
    }
    /* End of method to add Admin stories to each user */

    if (mounted) {
      setState(() {
        _isLoadingStories = false;
        userStories = followingUsers;
      });
    }
  }



  getTimeline() async {
    QuerySnapshot snapshot = await timelineRef
        .doc(widget.currentUserId)
        .collection('timelinePosts')
        .orderBy('timestamp', descending: true)
        .get();
    print(snapshot.docs.toString());
    Map<String, dynamic> _docdata = snapshot.docs.last.data();//not sure
    List<Post> posts = snapshot.docs.map((doc) => Post.fromDocument(doc, _docdata)).toList();
    setState(() {
      this.posts = posts;
    });
  }

   buildTimeline() {
    if (posts == null) {
      return buildUsersToFollow();
    } else if (posts.isEmpty) {
      return buildUsersToFollow();
    }
    return ListView(children: posts);
  }


  showNoPost(){
    return Center(
      child: Container(
        color: Colors.red,
      ),
    );
  }

  Widget buildUsersToFollow() {
    return FutureBuilder(
      future:
      usersReference.where('username').orderBy('timestamp', descending: true).limit(30).get(),
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return Center(
            child: Text('$snapshot'),
          );
        }
        if(snapshot.connectionState != ConnectionState.waiting){
          // return circularProgress();
        }if(snapshot.hasData){
          return userOptions();
        }
        if (!snapshot.hasData) {
          return showNoPost();
        }
        List<UserResult> userResults = [];
        snapshot.data.docs.forEach((doc) {
          Map _docdata = doc.data();
          Users user = Users.fromDocument(doc, _docdata);
          final bool isAuthUser = (currentUser.id == user.id);
          if (isAuthUser) {
            return;
          } else {
            UserResult userResult = UserResult(user);
            userResults.add(userResult);
          }
        });
        return Container(
          //color: Color.fromRGBO(115, 130, 255, 1),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.person_add,
                      size: 30,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(width: 8),
                    Text(
                      usersReference.id,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
              Column(children: userResults),
            ],
          ),
        );
      },
    );
  }

  final FirebaseFirestore fb = FirebaseFirestore.instance;
  Future<DocumentSnapshot> getPosts(){
    return postReference.doc().get();
  }

  userOptions(){
    return FutureBuilder(
      future: getPosts(),
      builder: (context, snapshot){
        if(snapshot.connectionState != ConnectionState.done){
         return circularProgress();
        }
        if(!snapshot.hasData)
          {
            return Center(
              child: Text('Snapshot has no data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
              ),
            );
          }
        // Post ab = Post.fromDocument(snapshot, docdata);
       // final List<Post> children = snapshot.data.map((user) => Text(Post[])).toList();
        return Container(
          child: ListView(
            children: posts,
          ),
        );
      },
    );
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.color,//alatsi
          title: Text("Megas", style: Theme.of(context).textTheme.headline6,),
              actions: [
                IconButton(icon: Icon(Icons.photo_camera,size: 20, color: WHITE_COLOR,), onPressed: () {Navigator.of(context).push( MaterialPageRoute(builder: (ctx) =>UploadPhoto(currentUser: currentUser,)));}),
                IconButton(icon: Icon(Icons.person,size: 20, color: WHITE_COLOR,), onPressed: () {
                  Navigator.of(context).pushNamed(Profile.routeName);
                }),
              ],
             ),
      ),
      drawer: Drawer(
        child: MainDrawer(),
      ),
      body: RefreshIndicator(
        onRefresh: () => getTimeline(),
        child: buildTimeline(),
      ),
    );
  }
}







