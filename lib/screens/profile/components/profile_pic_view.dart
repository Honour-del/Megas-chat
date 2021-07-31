import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:megas_chat/services/database_services.dart';
import 'package:megas_chat/utils/utilities.dart';
import 'package:megas_chat/widgets/progress_widget.dart';

import '../../home_view.dart';

class ProfileView extends StatefulWidget {
  static final routeName = "/profilePic";
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  
  bigProView(){
    return Scaffold(
      appBar: itsAppBar(),
      body: bodyView(),
    );
  }

  ooo(){
    return PopupMenuButton<Choice>(
      onSelected: (d) {},
      itemBuilder: (BuildContext context) {
        return choices.map((Choice choice) {
          return PopupMenuItem<Choice>(
            value: choice,
            child: Text(choice.title),
          );
        }).toList();
      },
    );
  }

  itsAppBar(){
    return AppBar(
      backgroundColor: BLACK_COLOR,
      actions: [
        ooo(),
      ],
    );
  }

  bodyView(){
    return FutureBuilder(
      future: DataBase.getData(),
      builder: (context,AsyncSnapshot<DocumentSnapshot> snapshot){
        if(snapshot.hasData){
          return Center(
            child: InteractiveViewer(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                      image: AssetImage('assets/photo.png'),
                      // image: CachedNetworkImageProvider(snapshot.data == null ? AssetImage('assets/photo.png') : snapshot.data.get('photoUrl')),
                      // image: currentUser.photoUrl == null ?  AssetImage('assets/photo.png') : snapshot.data.get('photoUrl') ,
                      fit: BoxFit.contain,
                    )
                ),
              ),
            ),
          );
        }else {
          return circularProgress();
        }
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return bigProView();
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final IconData icon;
  final String title;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Share image link', icon: Icons.directions_car),
  const Choice(title: 'Open in browser', icon: Icons.directions_bike),
  const Choice(title: 'View Lists', icon: Icons.directions_boat),
  const Choice(title: 'View Moments', icon: Icons.directions_bus),
  const Choice(title: 'Save', icon: Icons.directions_railway),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.headline1;
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(choice.icon, size: 128.0, color: textStyle.color),
            Text(choice.title, style: textStyle),
          ],
        ),
      ),
    );
  }
}
