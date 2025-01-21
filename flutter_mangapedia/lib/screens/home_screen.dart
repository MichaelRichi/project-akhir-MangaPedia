import 'package:flutter/material.dart';
import 'package:flutter_mangapedia/data/manga_data.dart';
import 'package:flutter_mangapedia/models/manga.dart';
import 'package:flutter_mangapedia/screens/detail_screen.dart';
import 'package:flutter_mangapedia/screens/ranking_screen.dart'; // Pastikan RankingScreen sudah diimport
import 'package:flutter_mangapedia/screens/search_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Manga> displayedManga = mangaList; // Daftar manga yang ditampilkan
  TextEditingController searchController = TextEditingController();

  // Fungsi untuk mencari manga berdasarkan nama
  void _searchManga(String query) {
    final results = mangaList
        .where(
            (manga) => manga.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      displayedManga = results;
    });
  }

  void _navigateToRankingScreen() {
    // Mengurutkan manga berdasarkan malScore secara descending (nilai tertinggi -> terendah)
    List<Manga> sortedMangaList = [...mangaList];
    sortedMangaList.sort((a, b) => b.malScore.compareTo(a.malScore));

    // Navigasi ke screen baru untuk melihat ranking manga
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RankingScreen(mangaList: sortedMangaList),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Home',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SearchScreen()),
                          );
                        },
                        child: AbsorbPointer(
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: 'Search Manga...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color:
                            Colors.grey, // Ganti dengan warna yang diinginkan
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Tombol RANKING MANGA
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                child: ElevatedButton(
                  onPressed: _navigateToRankingScreen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent, // Warna tombol
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Sudut melengkung
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.emoji_events,
                          size: 24, color: Colors.yellowAccent), // Ikon kiri
                      Text(
                        'TOP MANGA SERIES',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Warna teks
                        ),
                      ),
                      Icon(Icons.emoji_events,
                          size: 24, color: Colors.yellowAccent), // Ikon kanan
                    ],
                  ),
                ),
              ),
              // Daftar Manga
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                padding: const EdgeInsets.all(8),
                itemCount: displayedManga.length,
                itemBuilder: (context, index) {
                  Manga varManga = displayedManga[index];
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
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
                        elevation: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  varManga.imageAsset,
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16, top: 8),
                              child: Text(
                                varManga.title,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, bottom: 8),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    varManga.malScore,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
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
        ),
      ),
    );
  }
}
