

import 'package:flutter/material.dart';
import 'package:megas_chat/auth_screens/forgot_password/forgotPassword.dart';
import 'package:megas_chat/auth_screens/login/login.dart';
import 'package:megas_chat/auth_screens/signup/signup.dart';
import 'package:megas_chat/main.dart';
import 'package:megas_chat/screens/chat_screens/chat_page/chat_page.dart';
import 'package:megas_chat/screens/chat_screens/chat_screen.dart';
import 'package:megas_chat/screens/chat_screens/search_chat/search_chat.dart';
import 'package:megas_chat/screens/home_view.dart';
import 'package:megas_chat/screens/profile/components/edit_profile.dart';
import 'package:megas_chat/screens/profile/components/profile_pic_view.dart';
import 'package:megas_chat/screens/profile/profile.dart';
import 'package:megas_chat/screens/search/search_page.dart';
import 'package:megas_chat/screens/settings/settings/settings.dart';
import 'package:megas_chat/screens/upload/component/upload_photo.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (context) => LoginScreen(),
  HomePage.routeName: (context) => HomePage(),
  SignUp.routeName: (context) => SignUp(),
  SearchPage.routeName: (context) => SearchPage(),
  ChatPage.routeName: (context) => ChatPage(),
  EditProfile.routeName: (context) => EditProfile(),
  ChatScreen.routeName: (context) => ChatScreen(),
  ChatSearchPage.routeName: (context) => ChatSearchPage(),
  Profile.routeName: (context) => Profile(profileId: currentUser?.id,),
  ProfileView.routeName: (context) => ProfileView(),
  Settings.routeName: (context) => Settings(),
  UploadPhoto.routeName: (context) => UploadPhoto(currentUser: currentUser,),
  ForgetPasswordPage.routeName: (context) => ForgetPasswordPage(),
  SpinKit.routeName: (context) => SpinKit(),
  // CreateAds.routeName: (context) => CreateAds(),
  // Certification.routeName: (context) => Certification(),
  // Navigation.routeName: (context) => Navigation(),
};
