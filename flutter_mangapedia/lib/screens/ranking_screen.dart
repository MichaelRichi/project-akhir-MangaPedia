import 'package:flutter/material.dart';
import 'package:flutter_mangapedia/models/manga.dart';
import 'package:flutter_mangapedia/screens/detail_screen.dart';

class RankingScreen extends StatelessWidget {
  final List<Manga> mangaList;

  const RankingScreen({super.key, required this.mangaList});

  @override
  Widget build(BuildContext context) {
    // Urutkan manga berdasarkan MAL Score dari yang tertinggi ke terendah
    final sortedMangaList = List<Manga>.from(mangaList)
      ..sort((a, b) => double.parse(b.malScore).compareTo(double.parse(a.malScore)));

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Top Manga Ranking',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sortedMangaList.length,
        itemBuilder: (context, index) {
          Manga manga = sortedMangaList[index];
          return MouseRegion(
            cursor: SystemMouseCursors.click, // Menambahkan MouseRegion untuk kursor
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(manga: manga),
                  ),
                );
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
                    // Nama dan info MAL Score
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
                            // Menampilkan informasi MAL Score
                            Text(
                              'MAL Score: ${manga.malScore}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Tampilkan ranking
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Text(
                        '#${index + 1}', // Posisi ranking
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
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
