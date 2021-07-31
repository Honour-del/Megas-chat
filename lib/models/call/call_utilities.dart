import 'dart:math';

import 'package:megas_chat/models/log.dart';
import 'package:megas_chat/models/resources/call_methods.dart';
import 'package:megas_chat/models/resources/local_db/repository/log_repository.dart';
import 'package:megas_chat/models/user/user.dart';
import 'package:megas_chat/screens/chat_screens/callscreens/strings.dart';

import 'call.dart';


class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({Users from, Users to, context}) async {
    Call call = Call(
      callerId: from.id,
      callerName: from.name,
      callerPic: from.photoUrl,
      receiverId: to.id,
      receiverName: to.name,
      receiverPic: to.photoUrl,
      channelId: Random().nextInt(1000).toString(),
    );

    Log log = Log(
      callerName: from.name,
      callerPic: from.photoUrl,
      callStatus: CALL_STATUS_DIALLED,
      receiverName: to.name,
      receiverPic: to.photoUrl,
      timestamp: DateTime.now().toString(),
    );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      // enter log
      LogRepository.addLogs(log);

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => CallScreen(call: call),
      //   ),
      // );
    }
  }
}
