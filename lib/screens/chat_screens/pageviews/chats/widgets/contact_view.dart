import 'package:flutter/material.dart';
import 'package:megas_chat/models/call/contact.dart';
import 'package:megas_chat/models/resources/chat_methods.dart';
import 'package:megas_chat/models/user/user.dart';
import 'package:megas_chat/screens/chat_screens/callscreens/user_provider.dart';
import 'package:megas_chat/screens/chat_screens/chat_page/component/chat_tile.dart';
import 'package:megas_chat/utils/cached_image.dart';
import 'package:provider/provider.dart';


import '../../../chat_screen.dart';
import 'last_message_container.dart';
import 'online_dot_indicator.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final UserProvider _authMethods = UserProvider();

  ContactView(this.contact);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Users>(
      future: _authMethods.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Users user = snapshot.data;

          return ViewLayout(
            contact: user,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final Users contact;
  final ChatMethods _chatMethods = ChatMethods();

  ViewLayout({
    @required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return CustomTile(
      mini: false,
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              //receiver: contact,
            ),
          )),
      title: Text(
        (contact != null ? contact.name : null) != null ? contact.name : "..",
        style:
            TextStyle(color: Colors.white, fontFamily: "Arial", fontSize: 19),
      ),
      subtitle: LastMessageContainer(
        stream: _chatMethods.fetchLastMessageBetween(
          senderId: userProvider.getUser.id,
          receiverId: contact.id,
        ),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            CachedImage(
              contact.photoUrl,
              radius: 80,
              isRound: true,
            ),
            OnlineDotIndicator(
              uid: contact.id,
            ),
          ],
        ),
      ),
    );
  }
}
