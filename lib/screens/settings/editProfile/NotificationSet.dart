import 'package:flutter/material.dart';
import 'package:megas_chat/screens/settings/custom_widgets/header_widget.dart';
import 'package:megas_chat/screens/settings/custom_widgets/settings_appbar.dart';
import 'package:megas_chat/screens/settings/custom_widgets/settings_row_widget.dart';
//import 'package:flutter_twitter_clone/state/authState.dart';
// import 'package:provider/provider.dart';

class Notificate extends StatelessWidget {
  const Notificate({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //var user = Provider.of<AuthState>(context).userModel ?? UserModel();
    return Scaffold(
      appBar: SettingsAppBar(
        title: 'Notifications',
        //subtitle: user.userName,
      ),
      body: ListView(
        children: <Widget>[
          HeaderWidget('Filters'),
          SettingRowWidget(
            "Quality filter",
            showCheckBox: true,
            subtitle:
            'Filter lower-quality from your notifications. This won\'t filter out notifications from people you follow or account you\'ve inteacted with recently.',
            // navigateTo: 'AccountSettingsPage',
          ),
          Divider(height: 0),
          SettingRowWidget("Advanced filter"),
          SettingRowWidget("Muted word"),
          HeaderWidget(
            'Preferences',
            secondHeader: true,
          ),
          SettingRowWidget(
            "Unread notification count badge",
            showCheckBox: false,
            subtitle:
            'Display a badge with the number of notifications waiting for you inside the megas app.',
          ),
          SettingRowWidget("Push notifications"),
          SettingRowWidget("SMS notifications"),
          SettingRowWidget(
            "Email notifications",
            subtitle: 'Control when how often megas sends emails to you.',
          ),
        ],
      ),
    );
  }
}
