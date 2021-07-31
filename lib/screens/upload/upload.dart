// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:megas_chat/screens/upload/component/upload_photo.dart';
// import 'package:megas_chat/models/user/user.dart';
// import 'package:megas_chat/utils/sizeConfig.dart';
// import 'package:megas_chat/utils/utilities.dart';
// import 'package:megas_chat/widgets/header_widget.dart';
//
//
// import 'component/upload_video.dart';
//
// // import 'package:video_player/video_player.dart';
// //import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
//
// class UploadPage extends StatefulWidget {
//   final Users currentUser;
//
//   UploadPage({this.currentUser});
//   @override
//   _UploadPageState createState() => _UploadPageState();
// }
// class _UploadPageState extends State<UploadPage> with AutomaticKeepAliveClientMixin<UploadPage>
// {
//
//   File _video;
//   File file;
//   var formKey = GlobalKey<FormState>();
//
//
//
//
//
//
//   imgButt(){
//     return Padding(
//       padding:
//       EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.07),
//       // ignore: deprecated_member_use
//       child: RaisedButton(
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(9)),
//         child: Text(
//           "upload image",
//           style: TextStyle(color: WHITE_COLOR, fontSize: 20),
//         ),
//         color: Theme.of(context).appBarTheme.color,
//         onPressed: () => UploadPhoto.takeImage(context),
//       ),
//     );
//   }
//
//   vidButt(){
//     // ignore: deprecated_member_use
//     return RaisedButton(
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(9)),
//       child: Text(
//         "upload video",
//         style: TextStyle(color: WHITE_COLOR, fontSize: 20),
//       ),
//       color: Theme.of(context).appBarTheme.color,
//       onPressed: () => UploadVideo().takeVideo(context),
//     );
//   }
//
//   displayUploadScreen() {
//     return Scaffold(
//       appBar: header(context, strTitle: "Upload", disappearedBackButton: false),
//       body: Container(
//         child: Align(
//           alignment: Alignment.center,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.add_a_photo,
//                 size: 200,
//                 color: Theme.of(context).appBarTheme.color,
//               ),
//               imgButt(),
//               SizedBox(height: 60,),
//               vidButt(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> getUserCurrentLocation() async {
//     print("lMAoo: u are in your current location");//geolocation isn't working
//
//   }
//
//
//   bool get wantKeepAlive => true;
//   @override
//   // ignore: must_call_super
//   Widget build(BuildContext context) {//return file == null ? displayUploadScreen() : displayUploadFormScreen();
//     return displayUploadScreen();
//     // if(file != null){
//     //   return UploadPhoto();
//     // }else if(_video != null){
//     //   return UploadVideo();
//     // }else{
//     //   return displayUploadScreen();
//     // }
//   }
// }
