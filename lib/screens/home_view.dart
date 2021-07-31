import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:megas_chat/models/UserData.dart';
import 'package:megas_chat/models/user/user.dart';
import 'package:megas_chat/services/auth_services.dart';
import 'package:megas_chat/services/database_services.dart';
import 'package:megas_chat/utils/utilities.dart';
import 'package:megas_chat/widgets/widgets/flutter_toast.dart';
import 'package:provider/provider.dart';
import 'chat_screens/chat_page/chat_page.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'notifcations/notifications.dart';
import 'search/search_page.dart';
import 'timeline/timeline.dart';


Users currentUser;
User authUser;
class HomePage extends StatefulWidget {
  static final routeName = "/home";
  final String thisUserId;
  final Users currentUsers;
  final User authUsers;
  const HomePage({Key key,this.thisUserId,this.authUsers, this.currentUsers}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
// FirebaseMessaging messaging;
// final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{

  //controllers
  PageController _pageController;
  int getPageIndex = 0;

  bool isSelected = false;
  TabController _tabController;
  Users _currentUser;
  int currentTab = 0;
  final List<Widget> screens = [
    TimeLinePage(currentUser: currentUser,),
    SearchPage(),
    ChatPage(currentUserId: currentUser,),
    ActivityFeed(),
  ];
  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _tabController = TabController(length: 4, vsync: this);

  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void _getCurrentUser() async {
    Users currentUser =
    await DataBase.getUserWithId(widget.thisUserId);

    Provider.of<UserData>(context, listen: false).currentUser = currentUser;

    print('i have the current user now');
    setState(() => _currentUser = currentUser);
    AuthService.updateTokenWithUser(currentUser);
  }
    // void _getCurrentUser() async {
  //       DocumentSnapshot result = await FirebaseFirestore.instance.collection('users').doc(widget.currentUsers).get();
  // }

  void configurePushNotifications() {
    final User user = _auth.currentUser;
    if (Platform.isIOS) getiOSPermission();
    // messaging.getToken().then((token) {
    //   print('Firebase Messaging Token : $token\n');
    //   usersReference
    //       .doc(user.uid)
    //       .update({'androidNotificationToken': token});
    // });
    // messaging.configure(
    //     onMessage: (Map<String, dynamic> message) async {
    //       print('on message : $message');
    //       final String recipientId = message['data']['recipient '];
    //       final String body = message['notification']['body'];
    //       if (recipientId == user.uid) {
    //         print('Notification shown');
    //         SnackBar snackbar = SnackBar(
    //           content: Text(
    //             body,
    //             overflow: TextOverflow.ellipsis,
    //           ),
    //         );
    //         _scaffoldKey.currentState.showSnackBar(snackbar);
    //       } else {
    //         print('Notification not shown');
    //       }
    //     });
  }

  void getiOSPermission() {
    // messaging.requestNotificationPermissions(IosNotificationSettings(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // ));
    // messaging.onIosSettingsRegistered.listen((settings) {
    //   print('Setting registered : $settings');
    // });
  }



  whenPageChanges(int pageIndex) {
    setState(() {
      this.getPageIndex = pageIndex;
    });
  }

  onTapChangePage(int pageIndex) {
    _pageController.animateToPage(
      pageIndex,
      duration: Duration(microseconds: 30),
      curve: Curves.elasticInOut,
    );
  }
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        // backgroundColor: Theme.of(context).appBarTheme.color,
        bottomNavigationBar: BottomAppBar(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).appBarTheme.color,
              borderRadius: BorderRadiusDirectional.only(
                topEnd: Radius.circular(20),
                topStart: Radius.circular(20),
              ),
            ),
            height: 60,//getProportionateScreenHeight(70)
            width: double.infinity,
            child: TabBar(
              // unselectedLabelColor: Colors.white,
              indicatorColor: DARK_PURPLE_COLOR,
              tabs: [
                InkWell(
                  onTap: () {
                    setState(() {

                      currentTab = 0;
                    });
                  },
                  child: Icon(
                          Icons.home,
                          size: 25,
                    color: currentTab == 0 ? MyPurple : Colors.white,
                  )
                ),
                InkWell(
                  onTap: () {
                    setState(() {

                      currentTab = 1;
                    });
                  },
                  child:     Icon(
                    Icons.search,
                    size: 25,
                    color: currentTab == 1 ? MyPurple : Colors.white,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      currentTab = 2;
                    });
                  },
                  child:      Icon(
                    Icons.chat_bubble,
                    size: 25,
                    color: currentTab == 2 ? MyPurple : Colors.white,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      currentTab = 3;
                    });
                  },
                  child:      Icon(
                      Icons.notifications,
                    size: 25,
                    color: currentTab == 3 ? MyPurple : Colors.white,
                  ),
                )
              ],
              controller: _tabController,
            ),
          ),
        ),
        body: screens[currentTab],
      );
  }
}

displayToastMessage(String message, BuildContext context) async{
  Fluttertoast.showToast(msg: message);
}
