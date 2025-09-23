
import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:idioms/main.dart';
import 'package:idioms/models/idiom.dart';
import 'package:idioms/pages/home.dart';
import 'package:idioms/widgets/tindercard.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<Idiom> quizIdioms;
  int score = 0;
  int currentIndex = 0;
  late CardController controller;
  late ConfettiController confettiController;

  Timer? countdownTimer;
  int remainingSeconds = 10;

  @override
  void initState() {
    super.initState();
    quizIdioms = List.from(idioms)..shuffle();
    controller = CardController();
    confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
    _startTimer();
  }

  void _startTimer() {
    countdownTimer?.cancel();
    // Adaptive timer: starts at 10s and decreases 1s every card, min 5s
    remainingSeconds = max(5, 10 - currentIndex);
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        remainingSeconds--;
      });

      if (remainingSeconds <= 0) {
        countdownTimer?.cancel();
        controller.triggerRight();
      }
    });
  }

  void _onSwipe(int index, CardSwipeOrientation orientation) {
    final idiom = quizIdioms[index];
    bool correct = orientation == CardSwipeOrientation.right;

    if (correct) {
      score++;
      confettiController.play();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(correct ? "✅ Correct!" : "❌ Wrong!"),
        duration: const Duration(seconds: 1),
      ),
    );

    currentIndex++;

    if (currentIndex >= quizIdioms.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("🎉 Quiz Finished! Score: $score")),
      );
      countdownTimer?.cancel();
    } else {
      _startTimer();
    }
  }

  @override
  void dispose() {
    confettiController.dispose();
    countdownTimer?.cancel();
    super.dispose();
  }

  double get progress => (currentIndex + 1) / quizIdioms.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dynamic Swipe Idioms"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: progress,
                  color: Colors.greenAccent,
                  backgroundColor: Colors.white,
                  minHeight: 8,
                ),
                const SizedBox(height: 5),
                Text(
                  "Score: $score | Time left: $remainingSeconds s",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          ConfettiWidget(
            confettiController: confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            maxBlastForce: 20,
            minBlastForce: 5,
          ),
          Center(
            child: TinderSwapCard(
              swipeUp: false,
              swipeDown: false,
              orientation: AmassOrientation.bottom,
              totalNum: quizIdioms.length,
              stackNum: 3,
              maxWidth: MediaQuery.of(context).size.width * 0.95,
              maxHeight: MediaQuery.of(context).size.height * 0.85,
              minWidth: MediaQuery.of(context).size.width * 0.9,
              minHeight: MediaQuery.of(context).size.height * 0.8,
              cardController: controller,
              swipeCompleteCallback: (orientation, index) {
                _onSwipe(index, orientation);
              },
              cardBuilder: (context, index) {
                final idiom = quizIdioms[index];
                return FlipCard(
                  front: _buildCardFront(idiom),
                  back: _buildCardBack(idiom),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFront(Idiom idiom) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                idiom.idiom,
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                "Swipe RIGHT if you know the definition, LEFT if not.\nFlip the card to check!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                "$remainingSeconds s",
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardBack(Idiom idiom) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Definition:",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent)),
            const SizedBox(height: 8),
            Text(idiom.definition, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            Text("Example:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(idiom.examples[0],
                style: const TextStyle(fontSize: 17, fontStyle: FontStyle.italic)),
            const SizedBox(height: 16),
            Text("Translation:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(idiom.translations["de"]!,
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
