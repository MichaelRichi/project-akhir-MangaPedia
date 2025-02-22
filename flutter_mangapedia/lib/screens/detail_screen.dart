import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mangapedia/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_mangapedia/models/manga.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  final Manga manga;

  const DetailScreen({super.key, required this.manga});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFavorite = false;
  String? loggedInUserEmail;

  @override
  void initState() {
    super.initState();
    _loadLoggedInUser().then((email) {
      setState(() {
        loggedInUserEmail = email;
      });
      _loadFavoriteStatus();
    });
  }

  Future<String?> _loadLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email'); // Mendapatkan email user yang login
  }

  // Fungsi untuk memuat status favorit manga
  Future<void> _loadFavoriteStatus() async {
    if (loggedInUserEmail == null) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool(
              'favorite_${loggedInUserEmail!}_${widget.manga.title}') ??
          false;
    });
  }

  // Fungsi untuk menambah atau menghapus manga dari daftar favorit
  Future<void> _toggleFavorite() async {
    if (loggedInUserEmail == null) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = !isFavorite;
      prefs.setBool(
          'favorite_${loggedInUserEmail!}_${widget.manga.title}', isFavorite);
    });

    // Perbarui daftar manga favorit user
    List<String> favoriteMangas =
        prefs.getStringList('favoriteMangas_${loggedInUserEmail!}') ?? [];
    String message;

    if (isFavorite) {
      favoriteMangas.add(widget.manga.title);
      message = "${widget.manga.title} has been added to favorites";
    } else {
      favoriteMangas.remove(widget.manga.title);
      message = "${widget.manga.title} has been removed from favorites";
    }
    await prefs.setStringList(
        'favoriteMangas_${loggedInUserEmail!}', favoriteMangas);

    // Snackbar
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          backgroundColor: isFavorite ? Colors.green : Colors.red,
        ),
      );
    }
    // Delay before navigating back to the previous page
    if (mounted) {
      await Future.delayed(const Duration(
          milliseconds: 500)); // Delay for smooth transition // Pop after delay
    }
  }

  Future<void> _launchMangaLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImagePage(imageUrl: imageUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        fit: BoxFit.scaleDown,
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
                        onPressed: () => Navigator.pop(context),
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
                      // Tombol favorit
                      child: IconButton(
                        onPressed: () {
                          _toggleFavorite().then((_) {
                            if (!isFavorite) {
                              Navigator.pop(context,
                                  true); // Mengirim nilai 'true' jika manga dihapus dari favorit
                            } // Kirim 'true' saat favorit diubah
                          });
                        },
                        icon: Icon(
                          Icons.favorite,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Manga Title', widget.manga.title),
                    _buildInfoRow('Chapter', widget.manga.chapter),
                    _buildInfoRow('Genre', widget.manga.genre),
                    _buildInfoRow('Release Date', widget.manga.releaseDate),
                    _buildInfoRow('MAL Score', widget.manga.malScore),
                    _buildInfoRow('Author', widget.manga.author),
                    _buildInfoRow('Status', widget.manga.status),
                    _buildInfoRow('Serialization', widget.manga.serialization),
                    _buildInfoRow(
                        'Anime Adaptation', widget.manga.animeAdaptation),
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

                    // tombol baca manga
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () => _launchMangaLink(widget.manga.mangaLink),
                      icon: const Icon(
                        Icons.open_in_browser,
                        size:
                            20, // Ukuran ikon yang tetap kecil untuk kesan minimalis
                      ),
                      label: const Text(
                        'Read Manga',
                        style: TextStyle(
                          fontSize: 16, // Ukuran teks sedikit lebih kecil
                          fontWeight: FontWeight.w500, // Teks lebih ringan
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .blueAccent, // Latar belakang dengan warna ungu muda
                        foregroundColor:
                            Colors.white, // Warna teks dan ikon menjadi putih
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              30), // Bentuk lebih melengkung untuk kesan lembut
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20), // Padding yang proporsional
                        elevation: 5, // Tambahkan bayangan halus untuk efek 3D
                        shadowColor: Colors.deepPurple.withOpacity(
                            0.4), // Warna bayangan disesuaikan dengan tema
                      ),
                    ),

                    // gallery
                    const SizedBox(height: 16),
                    const Text(
                      'Gallery',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.manga.imageUrls.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () => _showFullImage(
                                  context, widget.manga.imageUrls[index]),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.deepPurple.shade100,
                                    width: 2,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.manga.imageUrls[index],
                                    height: 200,
                                    width: 150,
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) => Container(
                                      width: 150,
                                      height: 200,
                                      color: Colors.deepPurple[50],
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
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
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenImagePage extends StatefulWidget {
  final String imageUrl;

  const FullScreenImagePage({super.key, required this.imageUrl});

  @override
  State<FullScreenImagePage> createState() => _FullScreenImagePageState();
}

class _FullScreenImagePageState extends State<FullScreenImagePage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(
                    color: Colors.deepPurple,
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, color: Colors.white),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
