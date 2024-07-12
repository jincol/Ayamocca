import 'package:ayamocca/theme.dart';
import 'package:ayamocca/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:ayamocca/screens/login_screen.dart';
import 'package:ayamocca/screens/post_screen.dart';
import 'package:ayamocca/screens/profile_screen.dart';
import 'package:ayamocca/screens/search_screen.dart';
import 'package:ayamocca/screens/new_post_screen.dart';
import 'package:ayamocca/connections/firebase_connection.dart';
import 'package:ayamocca/screens/splash_screen.dart';
import 'package:ayamocca/theme.dart';
import 'package:ayamocca/utils/utils.dart';

import 'connections/firebase_connection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConnection.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Actor", "ABeeZee");
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ayamocca',
      //theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      theme: theme.light(),

      /*theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
        ),
      ),*/
      //theme: materialTheme.light(),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/post': (context) => PostScreen(),
        '/profile': (context) => ProfileScreen(),
        '/search': (context) => SearchScreen(),
        '/new_post': (context) => NewPostScreen(),
      },
    );
  }
}
