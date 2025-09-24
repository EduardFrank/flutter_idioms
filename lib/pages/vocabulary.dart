
import 'package:flutter/material.dart';
import 'package:idioms/pages/home.dart';
import 'package:idioms/repositories/idiom_repository.dart';
import 'package:idioms/widgets/idiom_dialog.dart';
import 'package:provider/provider.dart';
import 'package:idioms/main.dart';
import 'package:idioms/models/idiom.dart';
import 'package:idioms/providers/theme_provider.dart';

class VocabularyPage extends StatelessWidget {
  const VocabularyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(4.0),
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
    );
  }

  Widget _buildDifficultyCard({
    required BuildContext context,
    required Difficulty difficulty,
    required String title,
    required VoidCallback onTap,
  }) {
    final idiomRepository = Provider.of<IdiomRepository>(context, listen: false);
    final count = idiomRepository.countByDifficulty(difficulty);
    final learned = idiomRepository.learnedByDifficulty(difficulty);

    Color startColor = Colors.white;
    Color endColor = Colors.white.withOpacity(0.7);

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
                      value: '$count',
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      label: 'Learned',
                      value: '$learned',
                      color: Colors.white.withOpacity(0.3),
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
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class DifficultyLevelPage extends StatelessWidget {
  final Difficulty difficulty;

  const DifficultyLevelPage({
    super.key,
    required this.difficulty,
  });

  get level {
    switch (difficulty) {
      case Difficulty.basic:
        return 'Basic';
      case Difficulty.intermediate:
        return 'Intermediate';
      case Difficulty.advanced:
        return 'Advanced';
    }
  }

  get color {
    switch (difficulty) {
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
    final idiomRepository = Provider.of<IdiomRepository>(context, listen: false);
    final idioms = idiomRepository.getIdiomsByDifficulty(difficulty);
    final count = idiomRepository.countByDifficulty(difficulty);
    final learned = idiomRepository.learnedByDifficulty(difficulty);

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
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('Total', '$count', color),
                      _buildStatItem('Learned', '$learned', color),
                    ],
                  ),
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
                  return InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => IdiomDialog(idiom: idioms[index]),
                      );
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(idioms[index].idiom),
                        subtitle: Text(idioms[index].definition),
                        trailing: const Icon(Icons.arrow_forward_ios),
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
            color: color.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}