import 'package:flutter/material.dart';
import 'package:idioms/models/idiom.dart';
import 'package:idioms/repos/repo.dart';
import 'package:idioms/widgets/idiom_item.dart';
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

    // Step 1: Get all sections containing idioms of this difficulty
    final sections = repo.getSectionsByDifficulty(widget.difficulty);

    // Step 2: Optional stats
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
                color: color.withOpacity(0.1),
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
              'Sections:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: sections.length,
                itemBuilder: (context, index) {
                  final section = sections[index];

                  // Get idioms for this section and difficulty
                  final idioms = repo
                      .getIdiomsForSection(section)
                      .where((i) => i.difficulty == widget.difficulty)
                      .toList();

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        showTrailingIcon: false,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                section.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              '${idioms.length} idiom${idioms.length != 1 ? 's' : ''}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        children: idioms.isEmpty
                            ? [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'No idioms in this section for this level.',
                              style: TextStyle(color: color.withOpacity(0.7)),
                            ),
                          ),
                        ]
                            : List.generate(idioms.length * 2 - 1, (i) {
                          if (i.isEven) {
                            final idiom = idioms[i ~/ 2];
                            return IdiomItem(
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
                          } else {
                            // Only between items, not after the last one
                            return const Divider(height: 1, thickness: 1);
                          }
                        }),
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
