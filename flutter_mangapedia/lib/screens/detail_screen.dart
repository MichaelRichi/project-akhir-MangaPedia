import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_mangapedia/models/manga.dart';

class DetailScreen extends StatefulWidget {
  final Manga manga;

  const DetailScreen({super.key, required this.manga});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus(); // Muat status favorit saat widget dimulai
  }

  // Memuat status favorit dari SharedPreferences
  Future<void> _loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool(widget.manga.title) ?? false;
    });
  }

  // Mengubah status favorit dan menyimpannya ke SharedPreferences
  Future<void> _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = !isFavorite; // Balik status favorit
    });
    await prefs.setBool(widget.manga.title, isFavorite); // Simpan ke SharedPreferences

    // Menghitung jumlah favorit yang tersimpan
    _updateFavoriteCount();
  }

  // Mengupdate jumlah favorit yang tersimpan
  Future<void> _updateFavoriteCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteMangas = prefs.getStringList('favoriteMangas') ?? [];
    
    if (isFavorite) {
      favoriteMangas.add(widget.manga.title);
    } else {
      favoriteMangas.remove(widget.manga.title);
    }

    // Simpan daftar favorit ke SharedPreferences
    await prefs.setStringList('favoriteMangas', favoriteMangas);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Utama dengan Ikon Love dan Tombol Back
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        widget.manga.imageAsset,
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 255,
                    right: 16,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: _toggleFavorite, // Panggil fungsi toggle favorit
                        icon: Icon(
                          Icons.favorite,
                          color: isFavorite ? Colors.red : Colors.grey, // Ubah warna ikon
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Detail Informasi Manga
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 90,
                          child: Text(
                            'Manga Title :',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(widget.manga.title),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 50,
                          child: Text(
                            'Genre :',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(widget.manga.genre),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 100,
                          child: Text(
                            'Release Date :',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(widget.manga.releaseDate),
                        ),
                      ],
                    ),
                    // Detail lainnya
                    // ...
                    const SizedBox(height: 16),
                    const Text(
                      'Synopsis:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.manga.synopsis,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
