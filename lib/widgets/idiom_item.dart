
import 'package:flutter/material.dart';
import 'package:idioms/core/constants.dart';
import 'package:idioms/models/idiom.dart';
import 'package:idioms/models/progress.dart';
import 'package:idioms/repos/repo.dart';
import 'package:idioms/widgets/idiom_dialog.dart';
import 'package:provider/provider.dart';

class IdiomItem extends StatelessWidget {
  final Idiom idiom;
  final Progress? progress;
  final VoidCallback? onLearnedPressed;
  final VoidCallback? onResetPressed;

  const IdiomItem({
    super.key,
    required this.idiom,
    required this.progress,
    this.onLearnedPressed,
    this.onResetPressed
  });

  @override
  Widget build(BuildContext context) {
    final practiceCount = progress != null ? progress!.timesPracticed : 0;
    final progressValue = practiceCount >= MASTER_IDIOMS_COUNT ? 1.0 : practiceCount / (MASTER_IDIOMS_COUNT.toDouble());

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => IdiomDialog(
            idiom: idiom,
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

                              if (onResetPressed != null) {
                                onResetPressed!();
                              }

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
    );
  }
}
