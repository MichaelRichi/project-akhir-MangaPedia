import 'package:flutter/material.dart';
import 'package:flutter_mangapedia/screens/favorite_screen.dart';
import 'package:flutter_mangapedia/screens/home_screen.dart';
import 'package:flutter_mangapedia/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screenOptions = <Widget>[
    HomeScreen(),
    FavoriteScreen(),
    ProfileScreen(), // Ensure this class name is correct
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screenOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          //Item Pertama
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          //Item Kedua
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorite'),
          //Item Ketiga
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
