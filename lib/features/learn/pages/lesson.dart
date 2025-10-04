import 'dart:async';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:idioms/core/constants.dart';
import 'package:idioms/core/utils.dart';
import 'package:idioms/models/idiom.dart';
import 'package:idioms/repos/repo.dart';
import 'package:provider/provider.dart';

enum LessonMode { idiomToDefinition, definitionToIdiom, example }

class LessonPage extends StatefulWidget {
  final List<Idiom>? lessonIdioms;

  const LessonPage({
    super.key,
    required this.lessonIdioms
  });

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  final int maxTimeSeconds = 15;

  late List<Idiom> lessonIdioms;
  late List<Idiom> randomIdioms;
  List<Map<String, dynamic>> remainingQuestions = [];
  int currentIndex = 0;
  LessonMode currentMode = LessonMode.idiomToDefinition;

  List<String> options = [];
  String? selectedOption;
  bool showAnswer = false;

  Timer? timer;
  double timeLeft = 1.0;

  // For progress insights
  Map<int, int> correctCounts = {}; // idiom index → correct answers count
  Map<int, double> totalTime = {}; // idiom index → cumulative time spent

  // Confetti
  late ConfettiController _confettiController;

  get totalQuestions {
    return lessonIdioms.length * 3;
  }

  get answeredQuestions {
    return totalQuestions - (remainingQuestions.length + 1);
  }

  @override
  void initState() {
    super.initState();
    final repo = Provider.of<Repo>(context, listen: false);

    if (widget.lessonIdioms != null) {
      lessonIdioms = widget.lessonIdioms!;
    } else {
      // Pick 5 random idioms
      lessonIdioms = repo.getRandomUnlearnedIdioms(count: MAX_IDIOMS_PER_DAY);
    }

    randomIdioms = repo.getRandomIdioms(count: 20);
    // Initialize questions queue (each idiom in both modes)
    for (int i = 0; i < lessonIdioms.length; i++) {
      remainingQuestions.add({'index': i, 'mode': LessonMode.idiomToDefinition});
      remainingQuestions.add({'index': i, 'mode': LessonMode.definitionToIdiom});
      remainingQuestions.add({'index': i, 'mode': LessonMode.example});
    }

    // Shuffle the questions so that two related questions don't appear consecutively
    remainingQuestions.shuffle();

    _confettiController = ConfettiController(duration: const Duration(seconds: 3));

    _nextQuestion();
  }

  void _startTimer() {
    timer?.cancel();
    timeLeft = 1.0;
    timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      setState(() {
        timeLeft -= 0.1 / maxTimeSeconds;
        if (timeLeft <= 0) {
          timeLeft = 0;
          t.cancel();
          _timeOut();
        }
      });
    });
  }

  void _timeOut() {
    _checkAnswer(isTimeout: true);
  }

  void _setOptions() {
    final current = lessonIdioms[currentIndex];
    String correct;
    List<Idiom> wrongOptions;

    // Determine correct answer based on mode
    if (currentMode == LessonMode.idiomToDefinition) {
      correct = current.definition;
      wrongOptions = randomIdioms.where((e) => e.idiom != correct).toList();
    } else {
      correct = current.idiom;
      wrongOptions = randomIdioms.where((e) => e.idiom != correct).toList();
    }

    options = [correct];
    wrongOptions.shuffle();

    // Add 3 wrong options
    options.addAll(wrongOptions.take(3).map((e) => currentMode == LessonMode.idiomToDefinition ? e.definition : e.idiom));

    options.shuffle();
  }

  void _checkAnswer({bool isTimeout = false}) {
    timer?.cancel();
    final correctAnswer = currentMode == LessonMode.idiomToDefinition
        ? lessonIdioms[currentIndex].definition
        : lessonIdioms[currentIndex].idiom;
    final correct = !isTimeout && selectedOption == correctAnswer;

    // Update progress insights
    totalTime[currentIndex] = (totalTime[currentIndex] ?? 0) + (maxTimeSeconds * timeLeft);
    if (correct) correctCounts[currentIndex] = (correctCounts[currentIndex] ?? 0) + 1;

    setState(() {
      showAnswer = true;
      if (isTimeout) selectedOption = null; // No selection for timeout
    });

    // If incorrect or timeout, push the question to the end of the queue
    if (!correct) {
      remainingQuestions.add({'index': currentIndex, 'mode': currentMode});
    }
  }

  void _nextQuestion() {
    if (remainingQuestions.isEmpty) {
      _confettiController.play(); // Celebrate lesson completion
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lesson Complete! 🎉')),
      );

      _showLessonSummary(() {
          final repo = Provider.of<Repo>(context, listen: false);

          for (final idiom in lessonIdioms) {
            repo.markIdiomAsLearned(idiom);
          }
      }); // Show summary
      return;
    }

    final next = remainingQuestions.removeAt(0);
    currentIndex = next['index'];
    currentMode = next['mode'];
    selectedOption = null;
    showAnswer = false;
    _setOptions();
    _startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String question = '';
    String correctAnswer = '';

    switch (currentMode) {
      case LessonMode.idiomToDefinition:
        question = lessonIdioms[currentIndex].idiom;
        correctAnswer = lessonIdioms[currentIndex].definition;
        break;
      case LessonMode.definitionToIdiom:
        question = lessonIdioms[currentIndex].definition;
        correctAnswer = lessonIdioms[currentIndex].idiom;
        break;
      case LessonMode.example: {
        question = maskIdiomInSentence(lessonIdioms[currentIndex].idiom, lessonIdioms[currentIndex].examples[0]);
        correctAnswer = lessonIdioms[currentIndex].idiom;
        break;
      }
    }

    final accuracy = (correctCounts.values.fold(0, (int a, int b) => a + b) / totalQuestions * 100).toStringAsFixed(0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${currentMode == LessonMode.idiomToDefinition ? "Idiom - Definition" : "Definition - Idiom"} • $answeredQuestions / $totalQuestions • $accuracy%'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Animated Icon Progress
                  buildProgressIcons(),
                  SizedBox(height: 8),
                  // Timer + Idiom Card
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 4,
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: timeLeft,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      timeLeft > 0.6
                                          ? Colors.green
                                          : timeLeft > 0.3
                                          ? Colors.yellow
                                          : Colors.red,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${(timeLeft * maxTimeSeconds).ceil()}s',
                                  style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(question,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Options
                  Expanded(
                    child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options[index];
                        final isSelected = option == selectedOption;
                        Color? cardColor;
                        if (showAnswer) {
                          if (option == correctAnswer) {
                            cardColor = Colors.greenAccent;
                          } else if (isSelected && option != correctAnswer) {
                            cardColor = Colors.redAccent;
                          }
                        } else if (isSelected) {
                          cardColor = Colors.grey[300];
                        }

                        return AnimatedScale(
                          scale: isSelected ? 1.05 : 1.0,
                          duration: const Duration(milliseconds: 150),
                          child: Card(
                            color: cardColor,
                            child: ListTile(
                              title: Text(option),
                              onTap: () {
                                if (!showAnswer) {
                                  setState(() {
                                    selectedOption = option;
                                  });
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (!showAnswer && selectedOption == null)
                              ? null // disable button if no selection
                              : () {
                            if (!showAnswer) {
                              _checkAnswer();
                            } else {
                              _nextQuestion();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: (!showAnswer && selectedOption == null)
                                ? Colors.grey // disabled color
                                : Colors.blue,  // active color
                          ),
                          child: Text(!showAnswer ? 'Check' : 'Continue'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Confetti
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProgressIcons() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: totalQuestions,
        itemBuilder: (context, index) {
          Color color;
          if (index < answeredQuestions) {
            color = Colors.green; // completed
          } else if (index == answeredQuestions) {
            color = Colors.blue; // current
          } else {
            color = Colors.grey; // remaining
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: index == answeredQuestions
                    ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ]
                    : [],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showLessonSummary(VoidCallback onClose) {
    final avgTimePerQuestion = totalTime.values.isNotEmpty
        ? totalTime.values.reduce((a, b) => a + b) / totalTime.length
        : 0;
    bool alreadyClosed = false;

    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              children: [
                Center(
                  child: Text(
                    'Lesson Summary 🎉',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Overall Accuracy: ${accuracy()}%\n'),
                Text('Average Time per Question: ${avgTimePerQuestion.toStringAsFixed(1)}s\n'),
                const SizedBox(height: 16),
                const Text('Per-Idiom Performance:'),
                const SizedBox(height: 8),
                ...List.generate(lessonIdioms.length, (i) {
                  int correct = correctCounts[i] ?? 0;
                  double time = totalTime[i] ?? 0;
                  return ListTile(
                    title: Text(lessonIdioms[i].idiom),
                    subtitle: Text(
                      'Correct in $correct/2 attempts, Avg Time: ${(time / 2).toStringAsFixed(1)}s',
                    ),
                  );
                }),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (!alreadyClosed) {
                        alreadyClosed = true;
                        onClose();
                      }
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((result) {
      if (!alreadyClosed) {
        alreadyClosed = true;
        onClose();
      }
    });
  }

  String accuracy() {
    final totalCorrect = correctCounts.values.fold(0, (int a, int b) => a + b);
    return ((totalCorrect / totalQuestions) * 100).toStringAsFixed(0);
  }
}
