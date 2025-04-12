// ✅ TAM UI + HASH + JSON SIRALAMA DESTEKLİ register_step3.dart
// ... [register_step3.dart içeriği değişmedi]

// ✅ TAMAMLAMIŞ UI + KYC SİMÜLASYON + EXPORT BUTONU İLE register_step4.dart
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class RegisterStep4Screen extends StatefulWidget {
  final String jsonHash;
  final String kycHash;
  final String encryptedPath;

  const RegisterStep4Screen({
    super.key,
    required this.jsonHash,
    required this.kycHash,
    required this.encryptedPath,
  });

  @override
  State<RegisterStep4Screen> createState() => _RegisterStep4ScreenState();
}

class _RegisterStep4ScreenState extends State<RegisterStep4Screen> {
  final _keyController = TextEditingController();
  String? _decryptedJson;
  String? _calculatedKycHash;
  bool _kycProcessing = true;

  @override
  void initState() {
    super.initState();
    _simulateKYCProcess();
  }

  void _simulateKYCProcess() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    setState(() => _kycProcessing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "✅ Yapay zeka KYC doğrulaması başarıyla tamamlandı (%92).\n🔐 KYC Hash ve özel anahtar EtherIdentity sunucularına gönderildi.\n🪙 NFT mint edildi.",
        ),
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _decryptJsonFile() async {
    final keyText = _keyController.text;
    if (keyText.length != 64) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Özel anahtar 64 karakter uzunluğunda olmalıdır (hex format).",
          ),
        ),
      );
      return;
    }

    try {
      print("📂 Encrypted file path: ${widget.encryptedPath}");

      final encryptedBase64 = await File(widget.encryptedPath).readAsString();
      final fullBytes = base64Decode(encryptedBase64);
      final ivBytes = fullBytes.sublist(0, 16);
      final encryptedBytes = fullBytes.sublist(16);

      final encryptedData = encrypt.Encrypted(encryptedBytes);
      final iv = encrypt.IV(ivBytes);

      final keyBytes = Uint8List.fromList(
        List.generate(
          keyText.length ~/ 2,
          (i) => int.parse(keyText.substring(i * 2, i * 2 + 2), radix: 16),
        ),
      );
      final key = encrypt.Key(keyBytes);
      final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
      );
      final decrypted = encrypter.decrypt(encryptedData, iv: iv);
      print("🧩 Decrypted string: $decrypted");

      final decodedMap = jsonDecode(decrypted) as Map<String, dynamic>;
      final canonicalJson = jsonEncode(
        Map.fromEntries(
          decodedMap.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
        ),
      );

      final jsonHash = sha256.convert(utf8.encode(canonicalJson)).toString();
      final combined = jsonHash + keyText;
      final kycHash = sha256.convert(utf8.encode(combined)).toString();

      if (!mounted) return;
      setState(() {
        _decryptedJson = canonicalJson;
        _calculatedKycHash = kycHash;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("HATA: ${e.toString()}")));
    }
  }

  void _exportEncryptedFile() async {
    final file = File(widget.encryptedPath);
    if (await file.exists()) {
      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Şifreli KYC JSON dosyam');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Şifreli dosya bulunamadı.")),
      );
    }
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MVP Doğrulama Ekranı")),
      body:
          _kycProcessing
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("🧠 Yapay zeka KYC bilgilerinizi kontrol ediyor..."),
                  ],
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "🔐 JSON dosyası özel anahtar ile şifrelenmiştir.",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      const Text("SHA-256 ile hesaplanan JSON Hash:"),
                      Text(
                        widget.jsonHash,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 16),
                      const Text("KYC Hash (JSON Hash + Private Key):"),
                      Text(
                        widget.kycHash,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Divider(height: 32),
                      const Text(
                        "💡 Dosyayı açmak için özel anahtarınızı girin (64 karakter hex formatında)",
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _keyController,
                        decoration: const InputDecoration(
                          labelText: "Özel Anahtar",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _decryptJsonFile,
                        child: const Text("Dosyayı Aç ve Doğrula"),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _exportEncryptedFile,
                        child: const Text("Şifreli JSON Dosyasını Dışa Aktar"),
                      ),
                      const SizedBox(height: 20),
                      if (_decryptedJson != null) ...[
                        const Text("🔍 Çözülen ve Sıralı JSON İçeriği:"),
                        Text(
                          _decryptedJson!,
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 20),
                        const Text("✅ Hesaplanan KYC Hash:"),
                        Text(
                          _calculatedKycHash ?? '',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
    );
  }
}
