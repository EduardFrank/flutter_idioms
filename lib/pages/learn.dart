
import 'package:flutter/material.dart';
import 'package:idioms/repositories/repository.dart';
import 'package:idioms/widgets/idiom_dialog.dart';
import 'package:provider/provider.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context) {
    final idiomRepository = Provider.of<Repository>(context, listen: false);
    final idioms = idiomRepository.getAllIdioms();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
