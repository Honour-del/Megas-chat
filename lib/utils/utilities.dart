import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:image/image.dart' as ImD;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:megas_chat/models/user_state.dart';
import 'package:path_provider/path_provider.dart';


const MyPurple = Color.fromRGBO(143, 148, 251, 1);

const LIGHT_GREEN = Color.fromRGBO(60, 232, 211, 1);
const DARK_GREEN = Color.fromRGBO(0, 152, 161, 1);

const CRIMSON_RED = Color.fromRGBO(163, 35, 35, 1);
const DARK_RED = Color.fromRGBO(124, 2, 2, 1);
const LIGHT_RED = Color.fromRGBO(255, 126, 126, 1);

const WHITE_COLOR = Colors.white;
const BLACK_COLOR = Colors.black;

const LIGHT_GREY_COLOR = Color.fromRGBO(241, 241, 241, 1);

const DARK_ORANGE = Color.fromRGBO(214, 68, 5, 1);
const PALE_ORANGE = Color.fromRGBO(247, 126, 74, 1);

const BLUE_SHADOW = Color.fromRGBO(0, 172, 183, 0.2);
const ORANGE_SHADOW = Color.fromRGBO(254, 137, 0, 0.2);

const PURPLE_COLOR = Color.fromRGBO(115, 130, 255, 1);
const DARK_PURPLE_COLOR = Color.fromRGBO(28, 34, 87, 1);

const DARK_MODE = Color.fromRGBO(36, 54, 64, 1);
const DARK_MODE_OR = Color.fromRGBO(34, 45, 40, 1);

const DARK_APP_BAR = Color.fromRGBO(16, 29, 36, 1);

class Utils {
  static String getUsername(String email){
    return "live:${email.split('@')[0]}";
  }
  static String getInitials(String name) {

    List<String> nameSplit = name.split(" ");
    String firstNameInitial = nameSplit[0][0];
    String lastNameInitial = nameSplit[1][0];
     return firstNameInitial + lastNameInitial;
  }


  ImagePicker _picker = ImagePicker();

   Future<dynamic> pickImage({@required ImageSource source}) async {
    // File selectedImage = await ImagePicker.pickImage(source: source);
    PickedFile pickedFile = await _picker.getImage(
      source: ImageSource.camera,
      maxHeight: 600,
      maxWidth: 700,
    );
    return await compressImage(pickedFile);
  }

  // ignore: missing_return
  static Future compressImage(PickedFile imageToCompress) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    final int rand = Random().nextInt(10000);

    // ImD.Image image = ImD.decodeImage();
    // ImD.copyResize(image, width: 500, height: 500);
    //
    // return new File('$path/img_$rand.jpg')
    //   ..writeAsBytesSync(ImD.encodeJpg(image, quality: 85));
  }

  static int stateToNum(UserState userState) {
    switch (userState) {
      case UserState.Offline:
        return 0;

      case UserState.Online:
        return 1;

      default:
        return 2;
    }
  }

  static UserState numToState(int number) {
    switch (number) {
      case 0:
        return UserState.Offline;

      case 1:
        return UserState.Online;

      default:
        return UserState.Waiting;
    }
  }

  static String formatDateString(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    var formatter = DateFormat('dd/MM/yy');
    return formatter.format(dateTime);
  }

}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}
enum TweetType{
  Tweet,
  Detail,
  Reply,
  ParentTweet
}

enum SortUser{
  ByVerified,
  ByAlphabetically,
  ByNewest,
  ByOldest,
  ByMaxFollower
}

enum NotificationType{
  NOT_DETERMINED,
  Message,
  Tweet,
  Reply,
  Retweet,
  Follow,
  Mention,
  Like
}