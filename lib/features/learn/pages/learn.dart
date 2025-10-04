
import 'package:flutter/material.dart';
import 'package:idioms/core/constants.dart';
import 'package:idioms/features/learn/pages/learn_entry.dart';
import 'package:idioms/repos/repo.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {

  late bool canLearnMore = false;

  @override
  void initState() {
    final repo = Provider.of<Repo>(context, listen: false);
    canLearnMore = repo.getIdiomsLearnedOnDate(DateTime.now()).length < MAX_IDIOMS_PER_DAY;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat.yMMMMd().format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text(
                'Learn Idioms',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      canLearnMore ? Icons.emoji_objects : Icons.block,
                      color: canLearnMore ? Colors.green : Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      canLearnMore
                          ? 'Today you can learn up to $MAX_IDIOMS_PER_DAY idioms.\n'
                          : 'You have reached your daily limit of $MAX_IDIOMS_PER_DAY idioms.\nCome back tomorrow!',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    if (canLearnMore)
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LearnIdiomsEntryPage()),
                          );
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start Learning'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.green[600],
                        ),
                      ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                'Date: $today',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

