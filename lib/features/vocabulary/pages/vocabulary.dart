
import 'package:flutter/material.dart';
import 'package:idioms/models/idiom.dart';
import 'package:idioms/repos/repo.dart';
import 'package:idioms/widgets/idiom_card.dart';
import 'package:provider/provider.dart';

class VocabularyPage extends StatefulWidget {
  final Difficulty difficulty;

  const VocabularyPage({
    super.key,
    required this.difficulty,
  });

  @override
  State<VocabularyPage> createState() => _VocabularyPageState();
}

class _VocabularyPageState extends State<VocabularyPage> {

  get level {
    switch (widget.difficulty) {
      case Difficulty.basic:
        return 'Basic';
      case Difficulty.intermediate:
        return 'Intermediate';
      case Difficulty.advanced:
        return 'Advanced';
    }
  }

  get color {
    switch (widget.difficulty) {
      case Difficulty.basic:
        return Colors.green;
      case Difficulty.intermediate:
        return Colors.orange;
      case Difficulty.advanced:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<Repo>(context, listen: false);
    final idioms = repo.getIdiomsByDifficulty(widget.difficulty);
    final countIdioms = repo.countIdiomsByDifficulty(widget.difficulty);
    final countLearned = repo.countLearnedByDifficulty(widget.difficulty);
    final countMastered = repo.countMasteredByDifficulty(widget.difficulty);

    return Scaffold(
      appBar: AppBar(
        title: Text('$level Idioms'),
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Level: $level',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Total', '$countIdioms', color),
                  _buildStatItem('Learned', '$countLearned', color),
                  _buildStatItem('Mastered', '$countMastered', color),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Idioms in this level:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: idioms.length, // Placeholder count
                itemBuilder: (context, index) {
                  final idiom = idioms[index];

                  return IdiomCard(
                    idiom: idiom,
                    progress: repo.getProgressByIdiom(idiom),
                    onLearnedPressed: () {
                        repo.markIdiomAsLearned(idiom);
                        setState(() {});
                    },
                    onResetPressed: () {
                        setState(() {});
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: color.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}