import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('About EtherIdentity')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Decentralized Identity. Reimagined.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'EtherIdentity is a decentralized identity platform that empowers individuals to control their personal information securely and transparently. Unlike traditional systems that rely on centralized storage, EtherIdentity uses blockchain technology to provide a trustless, tamper-proof, and user-owned identity solution.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Text(
                'Core Features',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '- AES-256 encrypted identity data stored locally\n'
                '- NFT-based verification without revealing personal data\n'
                '- Compatible with major EVM chains like Polygon and Arbitrum\n'
                '- Zero-knowledge proof (ZKP) based validation\n'
                '- Seamless integration with Web3 login systems',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Text(
                'Follow Us',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () => _launchURL('https://github.com/etheridentity'),
                child: const Text(
                  '🔗 GitHub: github.com/etheridentity',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _launchURL('https://twitter.com/etheridentity'),
                child: const Text(
                  '🔗 Twitter: twitter.com/etheridentity',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _launchURL('https://gitcoin.co/etheridentity'),
                child: const Text(
                  '🔗 Gitcoin: gitcoin.co/etheridentity',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
