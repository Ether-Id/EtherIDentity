// ✅ TAM UI + HASH + JSON SIRALAMA DESTEKLİ register_step3.dart

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'set_pin_screen.dart';

class RegisterStep3Screen extends StatefulWidget {
  final String privateKey;
  final Map<String, String> userInfo;

  const RegisterStep3Screen({
    super.key,
    required this.privateKey,
    required this.userInfo,
  });

  @override
  State<RegisterStep3Screen> createState() => _RegisterStep3ScreenState();
}

class _RegisterStep3ScreenState extends State<RegisterStep3Screen> {
  final _phoneCodeController = TextEditingController();
  final _emailCodeController = TextEditingController();
  bool _phoneVerified = false;
  bool _emailVerified = false;
  bool _phoneCodeSent = false;
  bool _emailCodeSent = false;
  bool _livenessVerified = false;

  File? _idFront;
  File? _idBack;
  File? _selfie;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source, String type) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        if (type == 'front') _idFront = File(image.path);
        if (type == 'back') _idBack = File(image.path);
        if (type == 'selfie') _selfie = File(image.path);
      });
    }
  }

  void _verifyPhoneCode() {
    if (_phoneCodeController.text == "123456") {
      setState(() => _phoneVerified = true);
    }
  }

  void _verifyEmailCode() {
    if (_emailCodeController.text == "654321") {
      setState(() => _emailVerified = true);
    }
  }

  bool _areAllImagesUploaded() {
    return _idFront != null && _idBack != null && _selfie != null;
  }

  Future<String> _imageToBase64(File file) async {
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> _finalizeKYCAndProceed() async {
    final aiScore = "98.2%";

    final idFrontBase64 = await _imageToBase64(_idFront!);
    final idBackBase64 = await _imageToBase64(_idBack!);
    final selfieBase64 = await _imageToBase64(_selfie!);

    final jsonContent = {
      'first_name': widget.userInfo['firstName'],
      'last_name': widget.userInfo['lastName'],
      'id_number': widget.userInfo['idNumber'],
      'address': widget.userInfo['address'],
      'phone': widget.userInfo['phone'],
      'email': widget.userInfo['email'],
      'ai_score': aiScore,
      'id_front_image': idFrontBase64,
      'id_back_image': idBackBase64,
      'selfie_image': selfieBase64,
    };

    final sortedJson = Map.fromEntries(
      jsonContent.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );

    final canonicalJson = jsonEncode(sortedJson);
    final jsonHash = sha256.convert(utf8.encode(canonicalJson)).toString();
    final combined = '$jsonHash${widget.privateKey}';
    final kycHash = sha256.convert(utf8.encode(combined)).toString();

    final keyBytes = Uint8List.fromList(
      List.generate(
        widget.privateKey.length ~/ 2,
        (i) => int.parse(widget.privateKey.substring(i * 2, i * 2 + 2), radix: 16),
      ),
    );
    final key = encrypt.Key(keyBytes);
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
    );
    final encrypted = encrypter.encrypt(canonicalJson, iv: iv);

    final dir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${dir.path}/kyc_data_$timestamp.json.enc');
    final fullBytes = iv.bytes + encrypted.bytes;
    final fullBase64 = base64Encode(fullBytes);
    await file.writeAsString(fullBase64);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_registered', true);
    await prefs.setString('encrypted_path', file.path);
    await prefs.setString('json_hash', jsonHash);
    await prefs.setString('kyc_hash', kycHash);

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SetPinScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _phoneCodeController.dispose();
    _emailCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phone = widget.userInfo['phone'] ?? 'Unknown';
    final email = widget.userInfo['email'] ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(title: const Text('Verify Your Identity')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Phone Number: $phone'),
              if (!_phoneVerified) ...[
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => setState(() => _phoneCodeSent = true),
                  child: const Text('Send SMS Code'),
                ),
                if (_phoneCodeSent) ...[
                  TextField(
                    controller: _phoneCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Enter SMS Code',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  ElevatedButton(
                    onPressed: _verifyPhoneCode,
                    child: const Text('Verify Phone'),
                  ),
                ],
              ] else
                const Text('✅ Phone verified'),
              const SizedBox(height: 24),
              Text('Email Address: $email'),
              if (!_emailVerified) ...[
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => setState(() => _emailCodeSent = true),
                  child: const Text('Send Email Code'),
                ),
                if (_emailCodeSent) ...[
                  TextField(
                    controller: _emailCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Email Code',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  ElevatedButton(
                    onPressed: _verifyEmailCode,
                    child: const Text('Verify Email'),
                  ),
                ],
              ] else
                const Text('✅ Email verified'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.camera, 'front'),
                child: const Text('Take Photo: Front of ID Card'),
              ),
              if (_idFront != null)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  width: 300,
                  height: 190,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.file(_idFront!, fit: BoxFit.cover),
                ),
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.camera, 'back'),
                child: const Text('Take Photo: Back of ID Card'),
              ),
              if (_idBack != null)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  width: 300,
                  height: 190,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.file(_idBack!, fit: BoxFit.cover),
                ),
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.camera, 'selfie'),
                child: const Text('Take Selfie with ID'),
              ),
              if (_selfie != null) Text('✅ Selfie Uploaded'),
              const SizedBox(height: 24),
              if (!_livenessVerified)
                ElevatedButton(
                  onPressed: () => setState(() => _livenessVerified = true),
                  child: const Text('Simulate Liveness Check'),
                )
              else
                const Text('✅ Liveness Check Passed'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _phoneVerified &&
                        _emailVerified &&
                        _livenessVerified &&
                        _areAllImagesUploaded()
                    ? _finalizeKYCAndProceed
                    : null,
                child: const Text('Finalize KYC'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
