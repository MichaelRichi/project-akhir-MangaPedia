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
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserEmail(); // Memuat email pengguna terlebih dahulu
  }

  // Fungsi untuk memuat email pengguna
  Future<void> _loadUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email'); // Ambil email pengguna dari SharedPreferences
    if (email != null) {
      setState(() {
        userEmail = email;
      });
      _loadFavoriteManga(email); // Memuat data manga favorit berdasarkan email
    } else {
      print('No email found in SharedPreferences');
    }
  }

  // Fungsi untuk memuat manga favorit berdasarkan email pengguna
  Future<void> _loadFavoriteManga(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> favoriteMangaTitles = prefs.getStringList('favoriteMangas_$email') ?? [];
    List<Manga> favorites = [];
    // Cari manga yang sesuai dengan judul favorit
    for (String title in favoriteMangaTitles) {
      Manga? manga = mangaList.firstWhere((manga) => manga.title == title, orElse: () => Manga(
        title: '',
        chapter: "",
        genre: '',
        imageAsset: '',
        releaseDate: '',
        malScore: "",
        author: '',
        status: '',
        serialization: '',
        animeAdaptation: '',
        synopsis: '',
        imageUrls: [],
        mangaLink: '',
      ));
      if (manga != null) {
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
      body: userEmail == null
          ? const Center(
              child: Text('No favorite manga yet'),
            )
          : favoriteManga.isEmpty
              ? const Center(
                  child: Text('No favorite manga yet'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: favoriteManga.length,
                  itemBuilder: (context, index) {
                    Manga manga = favoriteManga[index];
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(manga: manga),
                            ),
                          ).then((updated) {
                            if (updated == true && userEmail != null) {
                              _loadFavoriteManga(userEmail!); // Perbarui daftar favorit
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        manga.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Chapter: ${manga.chapter}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Genre: ${manga.genre}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
