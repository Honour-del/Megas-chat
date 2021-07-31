import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:megas_chat/models/user/user.dart';
import 'package:megas_chat/services/references.dart';
import 'package:megas_chat/utils/utilities.dart';
import 'package:megas_chat/widgets/header_widget.dart';
import 'package:megas_chat/widgets/pages_anime.dart';
import 'package:megas_chat/widgets/progress_widget.dart';

import '../chat_screen.dart';


class ChatSearchPage extends StatefulWidget {
  static final routeName = "/Chat_SearchPage";
  @override
  _ChatSearchPageState createState() => _ChatSearchPageState();
}

class _ChatSearchPageState extends State<ChatSearchPage> with AutomaticKeepAliveClientMixin<ChatSearchPage>
{

  TextEditingController searchTextEditingController = TextEditingController();
  Future<QuerySnapshot> futureSearchResults;

  emptyTheTextFormField(){
    searchTextEditingController.clear();
  }

  controlSearching(String str){
    Future<QuerySnapshot> allUsers = usersReference.where("username", isGreaterThanOrEqualTo: str).get();
    setState(() {
      futureSearchResults = allUsers;
    });
  }

   searchPageHeader(BuildContext context, {disappearedBackButton = false}){
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.color,
      shadowColor:  PURPLE_COLOR,
      elevation: 0,
      automaticallyImplyLeading: disappearedBackButton ? false : true,
      title: Padding(
        padding: const EdgeInsets.only(left: 5, right: 10),
        child: TextFormField(
          style: TextStyle(fontSize: 18, color: WHITE_COLOR),
          controller: searchTextEditingController,
          decoration: InputDecoration(
            hintText: "Search here for a friend....",
            hintStyle:  TextStyle(color: Colors.white54,),
            filled: true,
            prefixIcon: Icon(Icons.person_pin, color: WHITE_COLOR, size: 30,),
            suffixIcon: IconButton(icon: Icon(Icons.clear, color: WHITE_COLOR,), onPressed: emptyTheTextFormField,),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(40),borderSide: BorderSide.none,),
            fillColor: Colors.transparent,
          ),
          onFieldSubmitted: controlSearching,
        ),
      ),
    );
  }

  Widget displayNoSearchResultsScreen(){
    return
       Container(
        color: Colors.white,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Icon(Icons.group,color: DARK_PURPLE_COLOR, size: 200,),
              Text(
                "Search User",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 50),
              ),
            ],
          ),
        ),
    );
  }

  displayUsersFoundScreen(){
    return
       Container(
        color: Colors.white,
        child: FutureBuilder(
            future: futureSearchResults,
            builder: (context,AsyncSnapshot<QuerySnapshot> dataSnapshot){
              if(!dataSnapshot.hasData){
                return circularProgress();
              }

              if (dataSnapshot.data.docs.length == 0) {/////.documents
                return Center(
                  child: Text('No Users found! Please try again.'),
                );
              }
              return ListView.builder(
                itemCount: dataSnapshot.data.docs.length,
                itemBuilder: (context,int index){
                  DocumentSnapshot user = dataSnapshot.data.docs[index];
                  return GestureDetector(
                    onTap: () => onTap(profileId: user.id,),
                    child: Card(
                      color: Colors.white70,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage('assets/photo.png'),
                        ),
                        title: Text(user['username'], style: Theme.of(context).textTheme.bodyText1,),
                        // subtitle: Text(user['displaame'], style: Theme.of(context).textTheme.subtitle1,),
                      ),
                    ),
                  );
                },
              );
            }
        ),
    );
  }


  onTap({String profileId}){
    return Navigator.of(context).push(BouncyPageRoute(widget: ChatScreen(currentUserId: profileId,)));
  }
  bool get wantKeepAlive => true;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchPageHeader(context),
      body: futureSearchResults == null ? displayNoSearchResultsScreen() : displayUsersFoundScreen(),
    );
  }


  disPlayNoUser(){
    return Scaffold(
      // appBar: header(context, strTitle: 'Ughhhhhh! No users found'),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.do_not_disturb_alt,color: Color.fromRGBO(28, 34, 87, 1), size: 200,),
              Text(
                "No Users with username found! Please try again...",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color.fromRGBO(28, 34, 87, 1), fontWeight: FontWeight.w500, fontSize: 50),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserResult extends StatelessWidget {
  final Users eachUser;
  UserResult(this.eachUser);
  //final bool isThere = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3),
      child: Container(
        color: Colors.white70,
        child: Column(
          children: [
            GestureDetector(
              onTap: onTap(context),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: CachedNetworkImageProvider(eachUser.photoUrl,),
                ),
                title: Text(eachUser.displayName, style: Theme.of(context).textTheme.bodyText1,),
                subtitle: Text(eachUser.username, style: Theme.of(context).textTheme.subtitle1,),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // goto receiver chatScree
  onTap(BuildContext context){
    return Navigator.of(context).push(BouncyPageRoute(widget: ChatScreen(receiverId: eachUser.id,)));
  }
}


