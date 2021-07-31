import 'package:flutter/material.dart';
import 'package:megas_chat/screens/settings/custom_widgets/settings_row_widget.dart';
import 'package:megas_chat/widgets/header_widget.dart';

class ProxyPage extends StatelessWidget {
  const ProxyPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "Proxy", disappearedBackButton: false),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          SettingRowWidget(
            "Enable HTTP Proxy",
            showCheckBox: false,
            vPadding: 15,
            showDivider: true,
            subtitle:
                'Configure HTTP proxy for network request (note: this does not apply to browser).',
          ),
          SettingRowWidget(
            "Proxy Host",
            subtitle: 'Configure your proxy\'s hostname.',
            showDivider: true,
          ),
          SettingRowWidget(
            "Proxy Port",
            subtitle: 'Configure your proxy\'s port number.',
          ),
        ],
      ),
    );
  }
}
