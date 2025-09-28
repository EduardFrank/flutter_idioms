
import 'package:flutter/material.dart';
import 'package:idioms/core/constants.dart';
import 'package:idioms/models/idiom.dart';
import 'package:idioms/repos/repo.dart';
import 'package:idioms/widgets/idiom_dialog.dart';
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
                  final progress = repo.getProgressByIdiom(idiom);
                  final isLearned = progress != null;
                  final practiceCount = isLearned ? progress.timesPracticed : 0;
                  // Calculate progress: max at 5 practices = 1.0, anything 5+ is full
                  final progressValue = practiceCount >= MASTER_IDIOMS_COUNT ? 1.0 : practiceCount / (MASTER_IDIOMS_COUNT.toDouble());

                  return Card(
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => IdiomDialog(
                            idiom: idiom,
                            onLearnedPressed: () {
                              repo.markIdiomAsLearned(idiom);
                              setState(() {});
                            },
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: practiceCount > 0 ? [
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Reset Progress'),
                                        content: Text('Do you want to reset the learning progress for "${idiom.idiom}"?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              final repo = Provider.of<Repo>(context, listen: false);
                                              repo.markIdiomAsUnlearned(idiom);
                                              setState(() {});
                                              Navigator.of(context).pop(); // Close dialog
                                            },
                                            child: const Text('Reset'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: CircularProgressIndicator(
                                      value: progressValue,
                                      strokeWidth: 4,
                                      backgroundColor: Colors.grey.withValues(alpha: 0.3),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        practiceCount >= MASTER_IDIOMS_COUNT
                                            ? Colors.green
                                            : practiceCount >= 3
                                            ? Colors.orange
                                            : Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  '$practiceCount',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ] : [ const SizedBox(width: 40, height: 40)],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          idiom.idiom,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(idiom.definition),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ),
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