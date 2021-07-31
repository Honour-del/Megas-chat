import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:megas_chat/utils/utilities.dart';

//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:provider/provider.dart';
//import 'package:shared_preferences/shared_preferences.dart';


  ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: WHITE_COLOR,
    appBarTheme: AppBarTheme(
      color: DARK_PURPLE_COLOR,
      iconTheme: IconThemeData(
        color: WHITE_COLOR,
      ),
    ),
    iconTheme: IconThemeData(
      color: BLACK_COLOR,
    ),
    colorScheme: ColorScheme.light(
      primary: BLACK_COLOR,
      onPrimary: BLACK_COLOR,
    ),
    cardTheme: CardTheme(
      color: BLACK_COLOR,
      shadowColor: WHITE_COLOR,
    ),
    textTheme: TextTheme(
      headline6: GoogleFonts.convergence(color: WHITE_COLOR, fontSize: 20),
      subtitle1: GoogleFonts.convergence(color: BLACK_COLOR, fontSize: 13),
      subtitle2: GoogleFonts.convergence(color: BLACK_COLOR, fontSize: 21),
      bodyText2: GoogleFonts.convergence(color: BLACK_COLOR, ),
      headline3: GoogleFonts.convergence(color: BLACK_COLOR, fontSize: 24),
      bodyText1: GoogleFonts.convergence(color: BLACK_COLOR, fontSize: 15),
    ),
  );


  ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: DARK_MODE,
    appBarTheme: AppBarTheme(
      color: DARK_APP_BAR,
      iconTheme: IconThemeData(
          color: WHITE_COLOR
      ),
    ),
    iconTheme: IconThemeData(
      color: WHITE_COLOR,
    ),
    colorScheme: ColorScheme.light(
      primary: WHITE_COLOR,
      onPrimary: WHITE_COLOR,
      secondary: WHITE_COLOR,
    ),
    cardTheme: CardTheme(
      color: BLACK_COLOR,
      shadowColor: DARK_MODE,
    ),
    textTheme: TextTheme(
      headline6: GoogleFonts.convergence(color: WHITE_COLOR, fontSize: 26),
        subtitle1: GoogleFonts.convergence(color: WHITE_COLOR, fontSize: 13),
        subtitle2: GoogleFonts.convergence(color: WHITE_COLOR, fontSize: 21),
      bodyText2: GoogleFonts.convergence(color: WHITE_COLOR, ),
      headline3: GoogleFonts.convergence(color: WHITE_COLOR, fontSize: 24),
      bodyText1: GoogleFonts.convergence(color: WHITE_COLOR, fontSize: 15),
    ),
  );

class ThemeNotifier extends ChangeNotifier {

  final String key = 'theme';
  //SharedPreferences prefs;
  bool isDarkMode = false;

  bool get darkTheme => isDarkMode;

  ThemeNotifier(){
    isDarkMode = true;
   // _loadFromPrefs();
  }

  toggleTheme(){
    isDarkMode = !isDarkMode;
    notifyListeners();
    //_savePrefs();
  }

  // initPrefs() async{
  //   if(prefs ==  null)
  //     prefs = await SharedPreferences.getInstance();
  // }

  // _loadFromPrefs() async{
  //   await initPrefs();
  //   isDarkMode = prefs.getBool(key) ?? true;
  //   notifyListeners();
  // }

  // _savePrefs() async{
  //   await initPrefs();
  //   prefs.setBool(key, isDarkMode);
//  }

  void updateTheme(bool isDarkMode) {
    this.isDarkMode = isDarkMode;
    notifyListeners();
  }
}