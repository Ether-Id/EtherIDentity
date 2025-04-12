import 'package:flutter/material.dart';
import 'dart:math';
import 'register_step2.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late String _privateKey;
  final TextEditingController _verifyController = TextEditingController();
  String _message = '';
  bool _showVerification = false;
  int _startIndex = 0;
  final int _length = 4;

  @override
  void initState() {
    super.initState();
    _generatePrivateKey();
  }

  void _generatePrivateKey() {
    final random = Random.secure();
    final values = List<int>.generate(
      32,
      (i) => random.nextInt(256),
    ); // 32 byte -> 64 hex karakter
    _privateKey =
        values
            .map((e) => e.toRadixString(16).padLeft(2, '0'))
            .join(); // hex format
    _startIndex = Random().nextInt(_privateKey.length - _length);
  }

  void _verifyKey() {
    final expected = _privateKey.substring(_startIndex, _startIndex + _length);
    if (_verifyController.text == expected) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterStep2Screen(privateKey: _privateKey),
        ),
      );
    } else {
      setState(() {
        _message = 'Incorrect input. Please check again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New ID')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Private Key',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SelectableText(
              _privateKey,
              style: const TextStyle(fontSize: 16, fontFamily: 'Courier'),
            ),
            const SizedBox(height: 20),
            const Text(
              '⚠️ Please copy and securely store your private key. You will not be able to recover it later.',
              style: TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 20),
            if (!_showVerification)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showVerification = true;
                    });
                  },
                  child: const Text('I have saved my key'),
                ),
              ),
            if (_showVerification) ...[
              const SizedBox(height: 20),
              Text(
                'To continue, enter characters ${_startIndex + 1} to ${_startIndex + _length} of your key:',
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _verifyController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Key Segment',
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _verifyKey,
                child: const Text('Continue'),
              ),
              const SizedBox(height: 10),
              Text(_message, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}
