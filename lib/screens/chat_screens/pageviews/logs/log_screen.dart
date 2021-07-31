// import 'package:flutter/material.dart';
// import 'package:megas_chat/chatPages/ChatPage_Search.dart';
// import 'package:megas_chat/chatPages/callscreens/pickup/pickup_layout.dart';
// import 'package:megas_chat/models/colors.dart';
// import 'package:megas_chat/pages2/pageviews/logs/widgets/floating_column.dart';
// import 'package:megas_chat/pages2/pageviews/logs/widgets/log_list_container.dart';
// import 'package:megas_chat/widgets/pagesAnime.dart';
//
//
// class LogScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return PickupLayout(
//       scaffold: Scaffold(
//         appBar: logBar(context),
//         floatingActionButton: FloatingColumn(),
//         body: Padding(
//           padding: EdgeInsets.only(left: 15),
//           child: LogListContainer(),
//         ),
//       ),
//     );
//   }
//
//
//   onPressed(BuildContext context){
//     return Navigator.push(context, BouncyPageRoute(widget: ChatSearchPage()));
//   }
//   back(BuildContext context){
//     return Navigator.pop(context);
//   }
//   Widget logBar(BuildContext context){
//     return AppBar(
//       backgroundColor: Theme.of(context).appBarTheme.color,
//       title: Text("Calls", style: TextStyle(fontSize: 22, color: WHITE_COLOR)),
//       leading: IconButton(icon: Icon(Icons.arrow_back_outlined, color: Colors.white,size: 22,), onPressed: back(context),),
//       actions: [IconButton(icon: Icon(
//         Icons.search,
//         color: Colors.white,
//       ),
//           onPressed: () => onPressed)],
//     );
//   }
// }
