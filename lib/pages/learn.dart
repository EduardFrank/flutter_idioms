
import 'package:flutter/material.dart';
import 'package:idioms/models/idiom.dart';
import 'package:idioms/widgets/idiom_dialog.dart';

// This will be passed from the parent widget
class LearnPage extends StatelessWidget {
  final List<Idiom> idioms;

  const LearnPage({
    super.key,
    required this.idioms,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
