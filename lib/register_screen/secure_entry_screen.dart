// ✅ SecureEntryScreen: Uygulama açıldığında PIN kontrolü yapan ekran
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_step4.dart';

class SecureEntryScreen extends StatefulWidget {
  const SecureEntryScreen({super.key});

  @override
  State<SecureEntryScreen> createState() => _SecureEntryScreenState();
}

class _SecureEntryScreenState extends State<SecureEntryScreen> {
  final _pinController = TextEditingController();
  String? _storedPin;
  String? _encryptedPath;
  String? _jsonHash;
  String? _kycHash;

  @override
  void initState() {
    super.initState();
    _loadStoredData();
  }

  Future<void> _loadStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedPin = prefs.getString('user_pin');
      _encryptedPath = prefs.getString('encrypted_path');
      _jsonHash = prefs.getString('json_hash');
      _kycHash = prefs.getString('kyc_hash');
    });
  }

  void _validatePinAndOpen() {
    final inputPin = _pinController.text;
    if (inputPin == _storedPin && _encryptedPath != null && File(_encryptedPath!).existsSync()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterStep4Screen(
            jsonHash: _jsonHash!,
            kycHash: _kycHash!,
            encryptedPath: _encryptedPath!,
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Authentication Failed"),
          content: const Text("PIN yanlış veya veri eksik. Lütfen uygulamayı sıfırlayın."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PIN ile Giriş")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Lütfen 4 haneli PIN kodunuzu girin", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            TextField(
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "PIN",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _validatePinAndOpen,
              child: const Text("Devam Et"),
            ),
          ],
        ),
      ),
    );
  }
}
