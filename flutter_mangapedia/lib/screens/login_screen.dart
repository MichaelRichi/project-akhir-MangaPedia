import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mangapedia/data/user_data.dart';
import 'package:flutter_mangapedia/models/user.dart';
import 'package:flutter_mangapedia/screens/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //TODO: 1. Logo Aplikasi
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.5, // 40% dari lebar layar
                    height: MediaQuery.of(context).size.width *
                        0.5, // 40% dari lebar layar
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset('images/mangapedia.png'),
                    ),
                  ),
                ),
                //TODO: 2. TEXTFIELD EMAIL
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Email'),
                ),
                //TODO: 3. TEXTFIELD PASSWORD
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Password'),
                  obscureText: true,
                ),
                //TODO: 4. TOMBOL LOGIN
                const SizedBox(height: 16),
                ElevatedButton(
                    onPressed: () async {
                      String email = _emailController.text;
                      String password = _passwordController.text;

                      if (validateLogin(email, password)) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setBool('isLoggedIn', true);
                        await prefs.setString('email', email);
                        Navigator.pushReplacementNamed(context, '/home');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Invalid email or password')));
                      }
                    },
                    child: const Text('Login')),

                const SizedBox(height: 20),
                // Link untuk Sign Up
                RichText(
                  text: TextSpan(
                    text: "Don't have an account?",
                    style:
                        const TextStyle(color: Colors.deepPurple, fontSize: 16),
                    children: [
                      TextSpan(
                        text: " Register",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateLogin(String email, String password) {
    for (User user in userList) {
      if (user.email == email && user.password == password) {
        return true;
      }
    }

    return false;
  }
}
