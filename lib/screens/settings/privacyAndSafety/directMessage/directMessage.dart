import 'package:flutter/material.dart';
import 'package:megas_chat/screens/settings/custom_widgets/header_widget.dart';
import 'package:megas_chat/screens/settings/custom_widgets/settings_row_widget.dart';
import 'package:megas_chat/widgets/header_widget.dart';


class DirectMessagesPage extends StatelessWidget {
  const DirectMessagesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //var user = Provider.of<AuthState>(context).userModel ?? UserModel();
    return Scaffold(
      appBar: header(context, strTitle: "Direct"),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          HeaderWidget(
            'Direct Messages',
            secondHeader: true,
          ),
          SettingRowWidget(
            "Receive message requests",
            navigateTo: null,
            showDivider: false,
            visibleSwitch: true,
            vPadding: 20,
            subtitle:
                'You will be able to receive Direct Message requests from anyone on megas, even if you don\'t follow them.',
          ),
          SettingRowWidget(
            "Show read receipts",
            navigateTo: null,
            showDivider: false,
            visibleSwitch: true,
            subtitle:
                'When someone sends you a message, people in the conversation will know you\'ve seen it. If you turn off this setting, you won\'t be able to see read receipt from others.',
          ),
        ],
      ),
    );
  }
}
