import 'dart:async';
import 'package:megas_chat/screens/home_view.dart';
import 'package:megas_chat/utils/routes.dart';
import 'package:megas_chat/utils/sizeConfig.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:megas_chat/screens/home_view.dart';
import 'package:provider/provider.dart';
import 'auth_screens/login/login.dart';
import 'utils/theme.dart';
import 'widgets/pages_anime.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseFirestore.instance.settings = Settings( persistenceEnabled: false, cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,);
  runApp(MyApp());
}
FirebaseAuth _auth = FirebaseAuth.instance;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final String title = 'Megas';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child){
          return MaterialApp(
            theme: notifier.darkTheme ? lightTheme : darkTheme,
            title: title,
            routes: routes,
            initialRoute: SpinKit.routeName,
            // home: SpinKit(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class SpinKit extends StatefulWidget {
  static final routeName = 'splash_screen';
  @override
  _SpinKitState createState() => _SpinKitState();
}
class _SpinKitState extends State<SpinKit> {
  userToReturnPage(BuildContext context){
  //   return _auth.authStateChanges().listen((User user)async {
  //     if(user != null){
  //       return HomePage(
  //         // currentUsers: currentUser,
  //       );
  //     }else {
  //       return LoginScreen();
  //     }
  //   });
    return StreamBuilder<User>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          User user = snapshot.data;
          if(user != null){
            return HomePage();
            // return HomePage(
            //   // authUsers: authUser,
            // );
          }
          return LoginScreen();//this should be null
        }else{
          return LoginScreen();
        }
      },
    );
  }
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),() =>
        Navigator.pushReplacement(context,
            BouncyPageRoute(widget: userToReturnPage(context))));
  }

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Image.asset('assets/megas.png', height: 150,)),
          SizedBox(height: 10,),
        ],
      ),
    );
  }
}

//
//
// // FirebaseFirestore.instance.settings(timeStampInSnapshotsEnabled: true).then(
// //     (_) {
// //       print("timeStamp enable in snapshots\n");
// //     }, onError: (_){
// //   print("Error enabling timeStamp in snapshots\n");
// // });
