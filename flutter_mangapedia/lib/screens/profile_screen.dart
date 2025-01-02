import 'package:flutter/material.dart';
import 'package:flutter_mangapedia/data/user_data.dart';
import 'package:flutter_mangapedia/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int favoriteCount = 0;
  User? loggedInUser;

  @override
  void initState() {
    super.initState();
    _loadFavoriteCount();
    _loadLoggedInUser();
  }

    // user info row
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

  // Mengambil jumlah manga favorit dari SharedPreferences
  Future<void> _loadFavoriteCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteMangas = prefs.getStringList('favoriteMangas') ?? [];
    setState(() {
      favoriteCount = favoriteMangas.length;
    });
  }

  // Mengambil data pengguna yang sedang login dari SharedPreferences
  Future<void> _loadLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email'); // Ambil email pengguna yang login

    if (email != null) {
      // Cari data pengguna berdasarkan email
      User? user = userList.firstWhere(
        (user) => user.email == email,
      );

      setState(() {
        loggedInUser = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child:  Text('Profile',style: TextStyle(fontWeight: FontWeight.bold)))),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Foto Profil
              CircleAvatar(
                radius: 80,
                backgroundImage: loggedInUser != null
                  ? AssetImage(loggedInUser!.profilePicture)
                  : const AssetImage('assets/default_profile.png'),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: (){
                },
              
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Change profile picture',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5), // Memberi jarak antara ikon dan teks
                    Icon(
                      Icons.edit_square, // Ikon untuk mengubah profil
                      size: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            
              const SizedBox(height: 60),

              _buildUserInfoRow(Icons.email, Colors.amber, "Email", loggedInUser?.email ?? 'Loading...'),
              _buildUserInfoRow(Icons.person, Colors.blue, "Name", loggedInUser?.name ?? 'Loading...'),
              _buildUserInfoRow(Icons.favorite, Colors.red, "Favorite",
                  "$favoriteCount"),
              const SizedBox(height: 20),
              // Tampilkan Username
              // Text(
              //   'Username: ${loggedInUser?.name ?? 'Loading...'}',
              //   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 10),
              // // Tampilkan Email
              // Text(
              //   'Email: ${loggedInUser?.email ?? 'Loading...'}',
              //   style: const TextStyle(fontSize: 18),
              // ),
              // const SizedBox(height: 30),
              // // Tampilkan Jumlah Favorit
              // Text(
              //   'Favorite Manga: $favoriteCount',
              //   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 30),

              // Tombol Logout
              ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.remove('email'); // Hapus email pengguna yang login
                  
                  // Tampilkan pesan logout berhasil
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You have successfully logged out!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  
                  // Berikan delay sebelum navigasi ke halaman login
                  await Future.delayed(const Duration(seconds: 1));
                  
                  // Navigasi ke halaman login setelah delay
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
