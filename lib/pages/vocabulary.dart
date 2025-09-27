
import 'package:flutter/material.dart';
import 'package:idioms/core/constants.dart';
import 'package:idioms/pages/home.dart';
import 'package:idioms/repositories/repository.dart';
import 'package:idioms/widgets/idiom_dialog.dart';
import 'package:provider/provider.dart';
import 'package:idioms/main.dart';
import 'package:idioms/models/idiom.dart';
import 'package:idioms/providers/theme_provider.dart';

class VocabularyPage extends StatelessWidget {
  const VocabularyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<Repository>(context, listen: false);
    final countIdioms = repo.countIdioms();
    final countLearned = repo.countLearned();
    final countMastered = repo.countMastered();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Total', '$countIdioms', Colors.black),
                  _buildStatItem('Learned', '$countLearned', Colors.black),
                  _buildStatItem('Mastered', '$countMastered', Colors.black),
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 8,
                childAspectRatio: 2.9, // Wider than tall
                children: [
                  _buildDifficultyCard(
                    context: context,
                    title: 'Basic',
                    difficulty: Difficulty.basic,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DifficultyLevelPage(
                            difficulty: Difficulty.basic,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDifficultyCard(
                    context: context,
                    title: 'Intermediate',
                    difficulty: Difficulty.intermediate,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DifficultyLevelPage(
                            difficulty: Difficulty.intermediate,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDifficultyCard(
                    context: context,
                    title: 'Advanced',
                    difficulty: Difficulty.advanced,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DifficultyLevelPage(
                            difficulty: Difficulty.advanced,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyCard({
    required BuildContext context,
    required Difficulty difficulty,
    required String title,
    required VoidCallback onTap,
  }) {
    final repo = Provider.of<Repository>(context, listen: false);
    final countIdioms = repo.countIdiomsByDifficulty(difficulty);
    final countLearned = repo.countLearnedByDifficulty(difficulty);
    final countMastered = repo.countMasteredByDifficulty(difficulty);

    Color startColor = Colors.white;
    Color endColor = Colors.white.withValues(alpha: 0.7);

    // Define specific gradients for each difficulty level
    switch (difficulty) {
      case Difficulty.basic:
        startColor = Colors.green.shade600;
        endColor = Colors.lightGreen.shade300;
        break;
      case Difficulty.intermediate:
        startColor = Colors.orange.shade600;
        endColor = Colors.amber.shade300;
        break;
      case Difficulty.advanced:
        startColor = Colors.red.shade600;
        endColor = Colors.pink.shade300;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [startColor, endColor],
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      label: 'Total',
                      value: '$countIdioms',
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      label: 'Learned',
                      value: '$countLearned',
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      label: 'Mastered',
                      value: '$countMastered',
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
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

class DifficultyLevelPage extends StatefulWidget {
  final Difficulty difficulty;

  const DifficultyLevelPage({
    super.key,
    required this.difficulty,
  });

  @override
  State<DifficultyLevelPage> createState() => _DifficultyLevelPageState();
}

class _DifficultyLevelPageState extends State<DifficultyLevelPage> {

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
    final repo = Provider.of<Repository>(context, listen: false);
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
                                              final repo = Provider.of<Repository>(context, listen: false);
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