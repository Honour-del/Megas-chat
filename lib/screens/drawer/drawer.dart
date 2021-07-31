import 'package:flutter/material.dart';
import 'package:megas_chat/screens/profile/profile.dart';
import 'package:megas_chat/screens/settings/settings/settings.dart';
import 'package:megas_chat/utils/theme.dart';
import 'package:megas_chat/widgets/pages_anime.dart';
import 'package:provider/provider.dart';

import '../home_view.dart';


class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1,),
          height: MediaQuery.of(context).size.height*0.8,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.of(context).pushNamed(Profile.routeName);
                    },
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.black,
                      backgroundImage: AssetImage('assets/photo.png'),
                      //currentUser.photoUrl.isEmpty
                      //     ? AssetImage('assets/photo.jpeg')
                      //     : CachedNetworkImageProvider(currentUser.photoUrl),
                    ),
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.account_box, color: Theme.of(context).iconTheme.color),
                  title: Text("Profile",style: Theme.of(context).textTheme.subtitle1,),
                  onTap: () {
                    Navigator.of(context).pushNamed(Profile.routeName);
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.account_box,color: Theme.of(context).iconTheme.color),
                  title: Text("Settings and privacy",style: Theme.of(context).textTheme.subtitle1,),
                  onTap: () {
                    Navigator.of(context).pushNamed(Settings.routeName);
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.lightbulb_outline, color: Theme.of(context).iconTheme.color),
                  title: Text("Themes Setting",style: Theme.of(context).textTheme.subtitle1,),
                  onTap: () {
                    Navigator.of(context).pushNamed(Profile.routeName);
                  },
                ),
                Divider(),
                Consumer<ThemeNotifier>(
                  builder: (context, notifier, child) => SwitchListTile(
                    title: Text("Dark Mode",style: Theme.of(context).textTheme.subtitle1,),
                    value: notifier.darkTheme,
                    onChanged: (val){
                      notifier.toggleTheme();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
