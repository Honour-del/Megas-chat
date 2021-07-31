import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:megas_chat/models/User_Notifier.dart';
import 'package:megas_chat/models/user/user.dart';
import 'package:megas_chat/models/user_state.dart';
import 'package:megas_chat/screens/chat_screens/callscreens/user_provider.dart';
import 'package:megas_chat/utils/utilities.dart';



class OnlineDotIndicator extends StatelessWidget {
  final String uid;
  //final AuthMethods _authMethods = AuthMethods();
  final UserProvider _authMethods = UserProvider();

  OnlineDotIndicator({
    @required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    getColor(int state) {
      switch (Utils.numToState(state)) {
        case UserState.Offline:
          return Colors.red;
        case UserState.Online:
          return Colors.green;
        default:
          return Colors.orange;
      }
    }

    return Align(
      alignment: Alignment.topRight,
      child: StreamBuilder<DocumentSnapshot>(
        stream: _authMethods.getUserStream(
          uid: uid,
        ),
        builder: (context, snapshot) {
          Users user;

          if (snapshot.hasData && snapshot.data.data != null) {
             Map<String, dynamic> d = snapshot.data.data();
            user = Users.fromDocument(snapshot.data, d);
          }

          return Container(
            height: 10,
            width: 10,
            margin: EdgeInsets.only(right: 5, top: 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: getColor(user?.state),
            ),
          );
        },
      ),
    );
  }
}
