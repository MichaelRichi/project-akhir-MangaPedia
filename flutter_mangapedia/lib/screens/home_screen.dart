import 'package:flutter/material.dart';
import 'package:flutter_mangapedia/data/manga_data.dart';
import 'package:flutter_mangapedia/models/manga.dart';
import 'package:flutter_mangapedia/screens/detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('email');
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Home',style: TextStyle(fontWeight: FontWeight.bold))),
        actions: [
          IconButton(
            onPressed: (){
              _logout(context);
            }, icon: const Icon(Icons.logout))
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                // agar tdk saling scroll
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  ), 
                  padding: const EdgeInsets.all(8),
                  itemCount: mangaList.length,
                itemBuilder: (context, index) {
                  Manga varManga = mangaList[index];
                  return MouseRegion(
                    cursor: SystemMouseCursors.click, // Menjadikan kursor klik
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(manga: varManga),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      margin: const EdgeInsets.all(6),
                      // kemiringan
                      elevation: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          //Gambar Tempat
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                varManga.imageAsset,
                                fit: BoxFit.cover,
                              ),
                            )),
                            //Nama Tempat
                            Padding(padding: const EdgeInsets.only(left: 16,top: 8),
                            child: Text(
                              varManga.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          //Lokasi Tempat
                          Padding(padding: const EdgeInsets.only(left: 16,bottom: 8),
                            child: Text(
                              varManga.chapter,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        )
      ),
    );
  }
}