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
              // Tampilkan Username
              Text(
                'Username: ${loggedInUser?.name ?? 'Loading...'}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Tampilkan Email
              Text(
                'Email: ${loggedInUser?.email ?? 'Loading...'}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              // Tampilkan Jumlah Favorit
              Text(
                'Favorite Count: $favoriteCount',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              // Tombol Logout
              ElevatedButton(
                onPressed: () {
                  SharedPreferences.getInstance().then((prefs) {
                    prefs.remove('email'); // Hapus email pengguna yang login
                    Navigator.pushReplacementNamed(context, '/login');
                  });
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
