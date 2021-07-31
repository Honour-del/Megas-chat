import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:megas_chat/utils/utilities.dart';


AppBar header(context, {bool isAppTitle=false, String strTitle, disappearedBackButton=false})
{
  return AppBar(
    iconTheme: IconThemeData(
      color: WHITE_COLOR,
    ),
      automaticallyImplyLeading: disappearedBackButton ? false : true,
    title: Text(
      isAppTitle ? "Mega CHATz" : strTitle,
      style: GoogleFonts.convergence(
        color: WHITE_COLOR,
        fontSize: isAppTitle ? 28 : 22,
      ),
      overflow:  TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).appBarTheme.color,
  );
}


CustomScrollView head(context, {bool thisAppTitle=false, String cTitle, disappearedBackButton=false})
{
  return CustomScrollView(
    slivers: [
      SliverAppBar(
        iconTheme: IconThemeData(
          color: WHITE_COLOR,
        ),
        automaticallyImplyLeading: disappearedBackButton ? false : true,
        expandedHeight: 100,
        floating: false,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          title: Text(
            thisAppTitle ? "Mega Chatz" : cTitle,
            style: TextStyle(
              color: WHITE_COLOR,
              fontFamily: thisAppTitle ?  "Signatra" : "",
              fontSize: thisAppTitle ? 28 : 22,
            ),
            overflow:  TextOverflow.ellipsis,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.color,
      )
    ],
  );
}
