// ✅ Orijinal Main Dosyası (PIN Kontrol + Login Akışı Entegre)
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'about_screen.dart';
import 'privacy_policy_screen.dart';
import 'network_widget.dart';
import 'login_screen.dart';
import 'register_screen/secure_entry_screen.dart';


void main() {
  runApp(const EtherIdentityApp());
}

class EtherIdentityApp extends StatelessWidget {
  const EtherIdentityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EtherIdentity',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 18, 18),
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey.shade700,
            foregroundColor: Colors.white,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.lightBlueAccent),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _hasRegistered = false;

  @override
  void initState() {
    super.initState();
    _checkIfRegistered();
  }

  Future<void> _checkIfRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    final registered = prefs.getBool('has_registered') ?? false;
    setState(() => _hasRegistered = registered);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          Positioned(
            left: screenWidth * 0.05,
            top: screenHeight * 0.25,
            child: SizedBox(
              width: screenWidth * 0.5,
              height: screenWidth * 0.5,
              child: const NetworkWidget(),
            ),
          ),
          Positioned(
            bottom: 250,
            right: -320,
            child: Opacity(
              opacity: 1.0,
              child: Image.asset('assets/Untitled design.png', width: 1350),
            ),
          ),
          Positioned(
            bottom: 320,
            right: -435,
            child: Opacity(
              opacity: 1.0,
              child: Image.asset('assets/logo.png', width: 1200),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                _hasRegistered ? const SecureEntryScreen() : const LoginScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(185, 0, 123, 255),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'About Us',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 0, 125, 250),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrivacyPolicyScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Privacy Policy',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 140, 255),
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
