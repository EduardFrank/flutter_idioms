
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:idioms/models/idiom.dart';
import 'package:idioms/providers/theme_provider.dart';
import 'package:idioms/repositories/idiom_repository.dart';
import 'package:idioms/widgets/idiom_dialog.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context) {
    final idiomRepository = Provider.of<IdiomRepository>(context, listen: false);
    final idioms = idiomRepository.getAllIdioms();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn Idioms'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode 
                    ? Icons.light_mode 
                    : Icons.dark_mode,
                ),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Learn English Idioms',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: idioms.length,
                itemBuilder: (context, index) {
                  final idiom = idioms[index];
                  return Card(
                    child: ListTile(
                      title: Text(idiom.idiom),
                      subtitle: Text(idiom.definition),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Show idiom details
                        showDialog(
                          context: context,
                          builder: (context) => IdiomDialog(idiom: idiom)
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
