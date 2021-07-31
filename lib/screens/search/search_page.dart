//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:cached_network_image/cached_network_image.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:megas_chat/models/user/user.dart';
import 'package:megas_chat/screens/notifcations/notifications.dart';
import 'package:megas_chat/services/references.dart';
import 'package:megas_chat/utils/consts.dart';
import 'package:megas_chat/utils/utilities.dart';
import 'package:megas_chat/widgets/header_widget.dart';
import 'package:megas_chat/widgets/progress_widget.dart';



class SearchPage extends StatefulWidget {
  static final routeName = "/search_page";
  @override
  _SearchPageState createState() => _SearchPageState();
}


class _SearchPageState extends State<SearchPage> with AutomaticKeepAliveClientMixin<SearchPage>
{

  TextEditingController searchTextEditingController = TextEditingController();
  Future<QuerySnapshot> futureSearchResults;

  emptyTheTextFormField(){
    searchTextEditingController.clear();
    setState(() {
      futureSearchResults = null;
    });
  }

  controlSearching(String str){
    Future<QuerySnapshot> allUsers = usersReference.where("username", isGreaterThanOrEqualTo: str).get();
    setState(() {
      futureSearchResults = allUsers;
    });
  }

  AppBar searchPageHeader(BuildContext context, {disappearedBackButton = false}){
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

  Scaffold displayNoSearchResultsScreen(){
    return Scaffold(
      appBar: searchPageHeader(context, disappearedBackButton: true),
      body: Container(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Icon(Icons.person,color: DARK_PURPLE_COLOR, size: 200,),
              Text(
                "Search User",
                textAlign: TextAlign.center,
                style: TextStyle(color: DARK_PURPLE_COLOR, fontWeight: FontWeight.w500, fontSize: 50),
              ),
            ],
          ),
        ),
      ),
    );
  }

  displayUsersFoundScreen(){
    // Users eachUsers;
    return Scaffold(
      appBar: header(context, strTitle: "User is found", disappearedBackButton: false,),
      body: FutureBuilder(
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
                  onTap: () => showProfile(context, profileId: user.id),//profileId: eachUser.id// onTap for will be present at users profile page when viewed by current user
                  child: Card(
                    color: Colors.white70,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(picture),
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

  bool get wantKeepAlive => true;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      body: futureSearchResults == null ? displayNoSearchResultsScreen() : displayUsersFoundScreen(),
    );
  }
}

class UserResult extends StatelessWidget {
  final Users eachUser;
  UserResult(this.eachUser);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3),
      child: Container(
        color: Colors.white70,
        child: Column(
          children: [
            GestureDetector(
              onTap: () => showProfile(context, profileId: eachUser.id),//profileId: eachUser.id// onTap for will be present at users profile page when viewed by current user
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: BLACK_COLOR,
                  backgroundImage: AssetImage(picture)//eachUser.photoUrl.isEmpty
                      //? AssetImage('assets/photo.jpeg')
                      //: CachedNetworkImageProvider(eachUser.photoUrl)
                ),
                title: Text(eachUser.displayName, style: Theme.of(context).textTheme.bodyText1,),
                subtitle: Text(eachUser.username, style: Theme.of(context).textTheme.subtitle1,),
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }


  disPlayNoUser(){
    return Container(
      color: Colors.white,
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Icon(Icons.do_not_disturb_alt,color: Color.fromRGBO(28, 34, 87, 1), size: 200,),
            Text(
              "No User with the Username if found",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color.fromRGBO(28, 34, 87, 1), fontWeight: FontWeight.w500, fontSize: 50),
            ),
          ],
        ),
      ),
    );
  }
}


