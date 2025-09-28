
import 'package:flutter/material.dart';
import 'package:idioms/features/vocabulary/pages/vocabulary.dart';
import 'package:idioms/models/idiom.dart';
import 'package:idioms/repos/repo.dart';
import 'package:provider/provider.dart';

class VocabulariesPage extends StatelessWidget {
  const VocabulariesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<Repo>(context, listen: false);
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
                          builder: (context) => const VocabularyPage(
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
                          builder: (context) => const VocabularyPage(
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
                          builder: (context) => const VocabularyPage(
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
    final repo = Provider.of<Repo>(context, listen: false);
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
