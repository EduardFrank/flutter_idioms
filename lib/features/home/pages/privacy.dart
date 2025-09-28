import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Effective Date: September 23, 2025',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      'Information We Collect',
                      'We do not collect any personal information from users of this application. '
                      'The app only uses locally stored data for educational purposes.',
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      'How We Use Information',
                      'We do not collect any personal data, so there is no information to use or share. '
                      'All idioms and learning materials are for educational purposes only.',
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      'Data Security',
                      'Since we do not collect personal information, we have no personal data to secure. '
                      'The app stores all data locally on your device and does not transmit any personal '
                      'information over the internet.',
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      'Contact Us',
                      'If you have any questions about this Privacy Policy, please contact us '
                      'through the app settings.',
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'This application is committed to protecting your privacy. '
                        'We do not collect, store, or transmit any personal information.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}