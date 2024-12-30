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
        title: const Center(
            child: Text('My Favorite',
                style: TextStyle(fontWeight: FontWeight.bold))),
      ),
      body: favoriteManga.isEmpty
          ? const Center(
              child: Text('No favorite manga yet'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteManga.length,
              itemBuilder: (context, index) {
                Manga manga = favoriteManga[index];
                return MouseRegion(
                  cursor: SystemMouseCursors
                      .click, // Menambahkan MouseRegion untuk kursor
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(manga: manga),
                        ),
                      ).then((updated) {
                      if (updated == true) {
                        _loadFavoriteManga(); // Perbarui daftar favorit
                      }
                    });
                    },
                    child: Card(
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
                          // Nama, Genre, dan info lainnya
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
                                  // Menampilkan informasi chapter manga
                                  Text(
                                    'Chapter: ${manga.chapter}', // Menampilkan genre manga
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Menampilkan informasi genre manga
                                  Text(
                                    'Genre: ${manga.genre}', // Menampilkan genre manga
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Ikon favorit
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
