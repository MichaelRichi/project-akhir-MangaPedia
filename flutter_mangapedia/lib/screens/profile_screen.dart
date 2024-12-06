import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Profile')),
      ),
      body: const Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Ini adalah halaman profile')),
    );
  }
}
