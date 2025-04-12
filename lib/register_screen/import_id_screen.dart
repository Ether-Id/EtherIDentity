import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:file_picker/file_picker.dart'; // file_picker import edildi
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_step4.dart';

class ImportIdScreen extends StatefulWidget {
  const ImportIdScreen({super.key});

  @override
  State<ImportIdScreen> createState() => _ImportIdScreenState();
}

class _ImportIdScreenState extends State<ImportIdScreen> {
  String? _filePath;
  final _privateKeyController = TextEditingController();
  String? _statusMessage;

  // Dosya seçici işlevi
  Future<void> _pickEncryptedFile() async {
    // file_picker ile dosya seçme işlemi
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'], // JSON dosyasını seçmemize izin verir
    );

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
      });
    }
  }

  // Dosya içeriğini çözme ve doğrulama işlemi
  Future<void> _tryImport() async {
    final path = _filePath;
    final privateKey = _privateKeyController.text.trim();

    if (path == null || privateKey.length != 64) {
      setState(() => _statusMessage = "File or Private Key is Missing.");
      return;
    }

    try {
      // Şifreli dosyanın içeriğini okuma ve çözme işlemi
      final base64Content = await File(path).readAsString();
      final fullBytes = base64Decode(base64Content);
      final iv = encrypt.IV(fullBytes.sublist(0, 16)); // IV kısmını alıyoruz
      final encryptedData = encrypt.Encrypted(
        fullBytes.sublist(16),
      ); // Şifreli veriyi alıyoruz

      // Anahtar çözme ve AES ile deşifre işlemi
      final keyBytes = Uint8List.fromList(
        List.generate(
          privateKey.length ~/ 2,
          (i) => int.parse(privateKey.substring(i * 2, i * 2 + 2), radix: 16),
        ),
      );
      final key = encrypt.Key(keyBytes);
      final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
      );

      final decrypted = encrypter.decrypt(encryptedData, iv: iv);
      final decodedMap = jsonDecode(decrypted) as Map<String, dynamic>;
      final sorted = Map.fromEntries(
        decodedMap.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
      );
      final canonicalJson = jsonEncode(sorted);

      final jsonHash = sha256.convert(utf8.encode(canonicalJson)).toString();
      final kycHash =
          sha256.convert(utf8.encode(jsonHash + privateKey)).toString();

      // Başarılı işlem sonrası veriyi SharedPreferences'a kaydediyoruz
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_registered', true);
      await prefs.setString('encrypted_path', path);
      await prefs.setString('json_hash', jsonHash);
      await prefs.setString('kyc_hash', kycHash);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => RegisterStep4Screen(
                jsonHash: jsonHash,
                kycHash: kycHash,
                encryptedPath: path,
              ),
        ),
      );
    } catch (e) {
      setState(() => _statusMessage = "File Parsing Failed: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Import Your Identity")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _pickEncryptedFile,
              child: const Text("Select Encrypted Json File"),
            ),
            const SizedBox(height: 16),
            if (_filePath != null) Text("📄 Dosya: $_filePath"),
            const SizedBox(height: 24),
            TextField(
              controller: _privateKeyController,
              decoration: const InputDecoration(
                labelText: "Private Key(64 Characters)",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _tryImport,
              child: const Text("Verify Your Identity and Sign In"),
            ),
            if (_statusMessage != null) ...[
              const SizedBox(height: 20),
              Text(_statusMessage!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}
