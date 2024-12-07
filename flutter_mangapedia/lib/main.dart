import 'package:flutter/material.dart';
import 'package:flutter_mangapedia/data/manga_data.dart';
import 'package:flutter_mangapedia/screens/detail_screen.dart';
import 'package:flutter_mangapedia/screens/home_screen.dart';
import 'package:flutter_mangapedia/screens/login_screen.dart';
import 'package:flutter_mangapedia/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //mewakili preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MainApp(isLoggedIn: isLoggedIn,));
}

class MainApp extends StatelessWidget {
  final bool isLoggedIn;
  const MainApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      home: isLoggedIn ? const MainScreen() : const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainScreen()
     },
    //home: const HomeScreen(),
    //  home: DetailScreen(manga: mangaList[0]),
    );

  }
}
