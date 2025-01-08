import 'dart:typed_data';
import 'dart:convert'; // Untuk encoding base64
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_mangapedia/data/user_data.dart';
import 'package:flutter_mangapedia/models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int favoriteCount = 0;
  User? loggedInUser;
  Uint8List? profileImage; // Ganti File dengan Uint8List

  @override
void initState() {
  super.initState();
  _loadLoggedInUser().then((_) {
    if (loggedInUser != null) {
      _loadFavoriteCount(loggedInUser!.email); // Load jumlah favorit sesuai user
      _loadProfilePicture(loggedInUser!.email); // Load gambar profil sesuai user
    }
  });
}

  // Fungsi untuk menyimpan data manga favorit berdasarkan email user
  Future<void> _saveFavoriteMangas(String email, List<String> favoriteMangas) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favoriteMangas_$email', favoriteMangas);
  }

  // Fungsi untuk memuat data manga favorit berdasarkan email user
  Future<void> _loadFavoriteCount(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteMangas = prefs.getStringList('favoriteMangas_$email') ?? [];
    setState(() {
      favoriteCount = favoriteMangas.length;
    });
  }

  // Fungsi untuk mengambil data pengguna yang sedang login dari SharedPreferences
  Future<void> _loadLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');

    if (email != null) {
      User? user = userList.firstWhere(
        (user) => user.email == email,
        orElse: () => User(name: 'Unknown', email: 'unknown@example.com', password: '',profilePicture:'images/default_profile.jpg' ),
      );

      setState(() {
        loggedInUser = user;
      });
    }
  }

  // Fungsi untuk menyimpan gambar profil berdasarkan email user
  Future<void> _saveProfilePicture(String email, Uint8List imageBytes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('profilePicture_$email', base64Encode(imageBytes));
  }


// Fungsi untuk memuat gambar profil berdasarkan email user
  Future<void> _loadProfilePicture(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imageBase64 = prefs.getString('profilePicture_$email');

  if (imageBase64 != null) {
    setState(() {
      profileImage = base64Decode(imageBase64);
    });
  } else {
    setState(() {
      profileImage = null; // Default jika tidak ada gambar
    });
  }
}

  // Fungsi untuk memilih gambar profil menggunakan ImagePicker
  Future<void> _pickProfileImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Uint8List imageBytes = await pickedFile.readAsBytes();

      if (loggedInUser != null) {
        await _saveProfilePicture(loggedInUser!.email, imageBytes); // Simpan gambar profil
      }

      setState(() {
        profileImage = imageBytes; // Perbarui gambar di memori
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile picture updated successfully!')),
      );
    }
  }

  // Widget untuk menampilkan informasi pengguna
  Widget _buildUserInfoRow(
      IconData icon, Color iconColor, String label, String value) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: Row(
                children: [
                  Icon(icon, color: iconColor),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Text(
                ": $value",
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Foto Profil
              CircleAvatar(
                radius: 80,
                backgroundImage: profileImage != null
                    ? MemoryImage(profileImage!) // Tampilkan gambar dari memori
                    : const AssetImage('images/default_profile.jpg')
                        as ImageProvider,
              ),
              const SizedBox(height: 10),

              // Tombol untuk mengganti foto profil
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _pickProfileImage,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Change profile picture',
                        style:
                            TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.edit_square,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 60),

              _buildUserInfoRow(Icons.email, Colors.amber, "Email",
                  loggedInUser?.email ?? 'Loading...'),
              _buildUserInfoRow(Icons.person, Colors.blue, "Name",
                  loggedInUser?.name ?? 'Loading...'),
              _buildUserInfoRow(
                  Icons.favorite, Colors.red, "Favorite", "$favoriteCount"),
              const SizedBox(height: 20),

              // Tombol Logout
              ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('email'); // Hapus email pengguna yang login
                  prefs.remove('profilePicture'); // Hapus gambar profil

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You have successfully logged out!'),
                      duration: Duration(seconds: 2),
                    ),
                  );

                  await Future.delayed(const Duration(seconds: 1));

                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Log Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
