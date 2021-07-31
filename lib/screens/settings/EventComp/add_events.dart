import 'package:flutter/material.dart';
import 'package:megas_chat/widgets/header_widget.dart';


class EventLogList extends StatefulWidget {
  @override
  _EventLogListState createState() => _EventLogListState();
}

class _EventLogListState extends State<EventLogList> {
  @override
  Widget build(BuildContext context) {

    listBody(){
      return Padding(
        padding: EdgeInsets.only(left: 15),
        // child: LogListContainer(),
      );
    }

    logContainer(){
      return Scaffold(
        appBar: header(context, strTitle: "Lists of events", disappearedBackButton: false),
        body: listBody(),
      );
    }
    return logContainer();
  }
}
