import 'package:flutter/material.dart';
import 'package:flutter_mangapedia/data/manga_data.dart';
import 'package:flutter_mangapedia/screens/detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_mangapedia/models/manga.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Manga> favoriteManga = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteManga(); // Memuat data manga favorit
  }

  // Fungsi untuk memuat manga favorit dari SharedPreferences
  Future<void> _loadFavoriteManga() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Manga> allManga = mangaList; // Daftar manga (diambil dari sumber data)
    List<Manga> favorites = [];

    for (Manga manga in allManga) {
      bool isFavorite = prefs.getBool(manga.title) ?? false;
      if (isFavorite) {
        favorites.add(manga);
      }
    }

    setState(() {
      favoriteManga = favorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('My Favorite',style: TextStyle(fontWeight: FontWeight.bold),)),
      ),
      body: favoriteManga.isEmpty
          ? const Center(
              child: Text('No favorite manga yet.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteManga.length,
              itemBuilder: (context, index) {
                Manga manga = favoriteManga[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      // Gambar manga
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            manga.imageAsset,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Nama dan detail manga
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                manga.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              ElevatedButton(
                                onPressed: () async{
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailScreen(manga: manga),
                                    ),
                                  );
                                  // Refresh data favorit setelah kembali dari DetailScreen
                                    if (result == true) {
                                      _loadFavoriteManga();
                                    } 
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[200],
                                ),
                                child: const Text(
                                  'Details',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Ikon favorit
                      const Padding (
                        padding:  EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}