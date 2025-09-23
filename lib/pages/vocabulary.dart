
import 'package:flutter/material.dart';
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
              color: Colors.green,
              total: 20,
              learned: 5,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DifficultyLevelPage(
                      level: 'Basic',
                      color: Colors.green,
                    ),
                  ),
                );
              },
            ),
            _buildDifficultyCard(
              context: context,
              title: 'Intermediate',
              color: Colors.orange,
              total: 30,
              learned: 12,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DifficultyLevelPage(
                      level: 'Intermediate',
                      color: Colors.orange,
                    ),
                  ),
                );
              },
            ),
            _buildDifficultyCard(
              context: context,
              title: 'Advanced',
              color: Colors.red,
              total: 25,
              learned: 3,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DifficultyLevelPage(
                      level: 'Advanced',
                      color: Colors.red,
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
    required String title,
    required Color color,
    required int total,
    required int learned,
    required VoidCallback onTap,
  }) {
    Color startColor = color;
    Color endColor = color.withOpacity(0.7);
    
    // Define specific gradients for each difficulty level
    if (color == Colors.green) {
      startColor = Colors.green.shade600;
      endColor = Colors.lightGreen.shade300;
    } else if (color == Colors.orange) {
      startColor = Colors.orange.shade600;
      endColor = Colors.amber.shade300;
    } else if (color == Colors.red) {
      startColor = Colors.red.shade600;
      endColor = Colors.pink.shade300;
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
                      value: total.toString(),
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      label: 'Learned',
                      value: learned.toString(),
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
  final String level;
  final Color color;

  const DifficultyLevelPage({
    super.key,
    required this.level,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
                      _buildStatItem('Total', '20', color),
                      _buildStatItem('Learned', '5', color),
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
                itemCount: 5, // Placeholder count
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text('Idiom $index'),
                      subtitle: Text('Definition for this idiom'),
                      trailing: const Icon(Icons.arrow_forward_ios),
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