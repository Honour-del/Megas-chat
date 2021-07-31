//import 'package:megas_chat/chatPages/message/newMessagePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:megas_chat/models/call/contact.dart';
import 'package:megas_chat/models/resources/chat_methods.dart';
import 'package:megas_chat/models/user/user.dart';
import 'package:megas_chat/screens/chat_screens/callscreens/user_provider.dart';
import 'package:megas_chat/screens/chat_screens/pageviews/chats/widgets/contact_view.dart';
import 'package:megas_chat/screens/chat_screens/pageviews/chats/widgets/quiet_box.dart';
import 'package:megas_chat/screens/chat_screens/search_chat/search_chat.dart';
import 'package:megas_chat/screens/notifcations/notifications.dart';
import 'package:megas_chat/utils/consts.dart';
import 'package:megas_chat/utils/utilities.dart';

class ChatPage extends StatefulWidget {
  static final routeName = "/Chat_Page";
  final Users currentUserId;

  ChatPage({this.currentUserId});
  @override
  _ChatPageState createState() => _ChatPageState();
}


//global
final UserProvider _repository = UserProvider();

class _ChatPageState extends State<ChatPage> {
  String currentUserId;
  String initials;
  String username;


  @override
  void initState(){
    super.initState();
    _repository.getCurrentUser().then((user){
      setState(() {
        currentUserId = user.uid;
        initials = Utils.getInitials(user.displayName);
      });
    });
  }

  onTap(){
   return showProfile(context, profileId: currentUserId);
  }

   customAppBar(BuildContext context, {disappearedBackButton = false, circleAvatar = false}){
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.color,
      shadowColor:  PURPLE_COLOR,
      automaticallyImplyLeading: disappearedBackButton ? false : true,
       leading: Padding(
         padding: const EdgeInsets.all(8.0),
         child: GestureDetector(
           onTap: onTap,
           child: CircleAvatar(backgroundColor: Colors.transparent,backgroundImage: AssetImage(picture),
           // currentUser.photoUrl.isEmpty
           //    ? AssetImage('assets/photo.jpeg')
           //    : CachedNetworkImageProvider(currentUser.photoUrl),
           ),
         ),
       ),
      title: Text("Chats", style: GoogleFonts.convergence(color: WHITE_COLOR, fontSize: 30),),
      centerTitle: true,
      actions: [
        IconButton(icon: Icon(Icons.search, color: Colors.white,), onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => ChatSearchPage()))),
        IconButton(icon: Icon(Icons.call, color: Colors.white,), onPressed: ()=>function()),// IconButton(icon: Icon(Icons.search, color: Colors.green,), onPressed: ()=>{}),
      ],
    );
  }

  function(){
    // return Navigator.of(context).push(BouncyPageRoute(widget: LogScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, disappearedBackButton: true),
      // floatingActionButton: NewChatButton(),
      body: ChatListContainer(currentUserId),
    );
  }
}


class ChatListContainer extends StatefulWidget {
  final String currentUserId;
  ChatListContainer(this.currentUserId);
  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}
class _ChatListContainerState extends State<ChatListContainer> {
  final ChatMethods _chatMethods = ChatMethods();
  String username;
  // final UserProvider userProvider = Provider.of(context)<UserProvider>;
  @override
  Widget build(BuildContext context) {
    // final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Container(
      color: Theme.of(context).cardTheme.shadowColor,
      child: StreamBuilder<QuerySnapshot>(
          stream: _chatMethods.fetchContacts(
            // userId: .id,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data.docs;

              if (docList.isEmpty) {
                return QuietBox(
                  heading: "This is where all chats are listed",
                  subtitle: "Search for your friends and family to start calling or chatting with...",
                );
              }
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  Contact contact = Contact.fromMap(docList[index].data as Map<String, dynamic>);

                  return ContactView(contact);
                },
              );
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}

