// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:megas_chat/models/user_state.dart';
// import 'package:megas_chat/widgets/widgets/customAppBar.dart';
// import 'package:provider/provider.dart';
// import 'shimmering_logo.dart';
//
// class UserDetailsContainer extends StatelessWidget {
//   final UserProvider authMethods = UserProvider();
//
//   @override
//   Widget build(BuildContext context) {
//     final UserProvider userProvider = Provider.of<UserProvider>(context);
//     FirebaseAuth _auth = FirebaseAuth.instance;
//     final bool isLoggedOut = false;
//
//     // Future _logOut() async{
//     //   return await _auth.signOut().whenComplete(() =>
//     //       Navigator.of(context).push(BouncyPageRoute(widget: LoginScreen())));
//     // }
//
//     Future signOut() async {
//       // ignore: unnecessary_statements
//       isLoggedOut == true ? await _auth.signOut() : isLoggedOut != true ;
//       if (isLoggedOut == true) {
//         // set userState to offline as the user logs out'
//         authMethods.setUserState(
//           userId: userProvider.getUser.id,
//           userState: UserState.Offline,
//         );
//
//         // move the user to login screen
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => LoginScreen()),
//           (Route<dynamic> route) => false,
//         );
//       }
//     }
//
//     return Container(
//       margin: EdgeInsets.only(top: 25),
//       child: Column(
//         children: <Widget>[
//           CustomAppBar(
//             leading: IconButton(
//               icon: Icon(
//                 Icons.arrow_back,
//                 color: Colors.white,
//               ),
//               onPressed: () => Navigator.maybePop(context),
//             ),
//             title: ShimmeringLogo(),
//             actions: <Widget>[
//               FlatButton(
//                 onPressed: () => signOut(),
//                 child: Text(
//                   "Log Out",
//                   style: TextStyle(color: Colors.white, fontSize: 12),
//                 ),
//               )
//             ],
//           ),
//           UserDetailsBody(),
//         ],
//       ),
//     );
//   }
// }
//
// class UserDetailsBody extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final UserProvider userProvider = Provider.of<UserProvider>(context);
//     final Users user = userProvider.getUser;
//
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//       child: Row(
//         children: [
//           CachedImage(
//             user.photoUrl,
//             isRound: true,
//             radius: 50,
//           ),
//           SizedBox(width: 15),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 user.name,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: Colors.white,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 user.email,
//                 style: TextStyle(fontSize: 14, color: Colors.white),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
