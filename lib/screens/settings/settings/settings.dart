import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:megas_chat/auth_screens/login/login.dart';
import 'package:megas_chat/screens/settings/account/account.dart';
import 'package:megas_chat/screens/settings/dataUsage/dataUsagePage.dart';
import 'package:megas_chat/screens/settings/editProfile/NotificationSet.dart';
import 'package:megas_chat/screens/settings/proxy/proxyPage.dart';
import 'package:megas_chat/utils/utilities.dart';
import 'package:megas_chat/widgets/pages_anime.dart';

import 'about.dart';

class Settings extends StatefulWidget {
  static final routeName = '/settings';
  final String user;
  Settings({this.user});
  @override
  _SettingsState createState() => _SettingsState();
}
//final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
final FirebaseAuth _auth = FirebaseAuth.instance;
final TextStyle styL = GoogleFonts.convergence(color: WHITE_COLOR, fontSize: 22, fontWeight: FontWeight.bold);
class _SettingsState extends State<Settings> {
  someWidget(){
    // wants to some flexible space  or might later be changed to sliverAppbar
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),//preferred size for appbar
        child: AppBar(
          title: Text("Settings and privacy", style: styL,),
          backgroundColor: Theme.of(context).appBarTheme.color,
          flexibleSpace: someWidget(),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.03,),
              Container(
                child: Text("Settings",style: Theme.of(context).textTheme.headline3,),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.02,),
              Divider(thickness: 2,),
              ListTile(
                leading: Icon(Icons.vpn_key),
                title: Text("Account", style:  Theme.of(context).textTheme.subtitle1,),
                subtitle: Text("Privacy,security"),
                onTap: () => _account(),
              ),
              Divider(thickness: 2,),
              ListTile(
                leading: Icon(Icons.chat),
                title: Text("Messages",style:  Theme.of(context).textTheme.subtitle1,),
                subtitle: Text("Wallpaper,chat setting"),
                onTap: () => _messages(),
              ),
              Divider(thickness: 2,),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text("Notification",style:  Theme.of(context).textTheme.subtitle1,),
                subtitle: Text("All notifications"),
                onTap: () => _notifications(),
              ),
              Divider(thickness: 2,),
              ListTile(
                leading: Icon(Icons.data_usage),
                title: Text("Data usage",style:  Theme.of(context).textTheme.subtitle1,),
                subtitle: Text("Network usage and device storage usage"),
                onTap: () => _dataUsage(),
              ),
              Divider(thickness: 2,),
              ListTile(
                leading: Icon(Icons.adb_rounded),
                title: Text("Proxy",style:  Theme.of(context).textTheme.subtitle1,),
                subtitle: Text("Contact us, Privacy and policy"),
                onTap: () => proxy(),
              ),
              Divider(thickness: 2,),
              ListTile(
                leading: Icon(Icons.help_outline),
                title: Text("About us",style:  Theme.of(context).textTheme.subtitle1,),
                subtitle: Text("Contact us, Privacy and policy"),
                onTap: () => _about(),
              ),
              Divider(thickness: 2,),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlineButton(
                    child: Text(
                      "Logout",
                      style: TextStyle(
                        color: DARK_RED, fontSize: 18, fontWeight: FontWeight.bold,
                      ),
                    ),
                    shape: StadiumBorder(side: BorderSide(color: DARK_RED)),
                    onPressed: _logOut,
                  ),
                  Container(
                    //alignment: Alignment.bottomCenter,
                    child: Text("Developed by alien teams"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Navigator
  _account(){
    return Navigator.of(context).push(BouncyPageRoute(widget:Account()));
  }
  _about(){
    return Navigator.of(context).push(BouncyPageRoute(widget:AboutScreen()));
  }

  proxy(){
    return Navigator.of(context).push(BouncyPageRoute(widget:ProxyPage()));
  }

  _messages(){
    return Navigator.of(context).push(BouncyPageRoute(widget:Account()));//not yet created
  }
  _notifications(){
    return Navigator.of(context).push(BouncyPageRoute(widget:Notificate()));
  }
  _dataUsage(){
    return Navigator.of(context).push(BouncyPageRoute(widget:DataUsagePage()));//not yet created
  }

  Future _logOut() async{
    await _auth.signOut().whenComplete(() =>
        Navigator.of(context).push(BouncyPageRoute(widget: LoginScreen())));
  }
}

