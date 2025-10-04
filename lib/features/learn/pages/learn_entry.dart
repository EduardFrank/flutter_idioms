import 'package:flutter/material.dart';
import 'package:idioms/core/constants.dart';
import 'package:idioms/features/learn/pages/lesson.dart';
import 'package:idioms/models/idiom.dart';
import 'package:idioms/providers/tts_provider.dart';
import 'package:idioms/repos/repo.dart';
import 'package:idioms/widgets/tindercard.dart';
import 'package:provider/provider.dart';

class LearnIdiomsEntryPage extends StatefulWidget {
  const LearnIdiomsEntryPage({super.key});

  @override
  State<LearnIdiomsEntryPage> createState() => _LearnIdiomsEntryPageState();
}

class _LearnIdiomsEntryPageState extends State<LearnIdiomsEntryPage> {
  late List<Idiom> _lessonIdioms;
  late CardController _cardController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    final repo = Provider.of<Repo>(context, listen: false);

    _lessonIdioms = repo.getRandomUnlearnedIdioms(count: MAX_IDIOMS_PER_DAY);
    _cardController = CardController();
  }

  void _onSwipe(int index, CardSwipeOrientation orientation) {
    _currentIndex++;

    if (index >= _lessonIdioms.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LessonPage(lessonIdioms: _lessonIdioms)),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Learn Idioms"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: buildProgressIcons(),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TinderSwapCard(
                swipeUp: false,
                swipeDown: false,
                orientation: AmassOrientation.bottom,
                totalNum: _lessonIdioms.length,
                stackNum: 3,
                maxWidth: MediaQuery.of(context).size.width * 0.95,
                maxHeight: MediaQuery.of(context).size.height * 0.85,
                minWidth: MediaQuery.of(context).size.width * 0.9,
                minHeight: MediaQuery.of(context).size.height * 0.8,
                cardController: _cardController,
                swipeCompleteCallback: (orientation, index) {
                  _onSwipe(index, orientation);
                },
                cardBuilder: (context, index) {
                  final idiom = _lessonIdioms[index];
                  return _buildCard(idiom);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Idiom idiom) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      idiom.idiom,
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _speak(idiom.idiom),
                    icon: const Icon(Icons.volume_up),
                    color: Theme.of(context).primaryColor,
                    tooltip: 'Speak idiom',
                  ),
                ]
            ),
            const SizedBox(height: 20),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text("Definition:", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  IconButton(
                    onPressed: () => _speak(idiom.definition),
                    icon: const Icon(Icons.volume_up),
                    color: Theme.of(context).primaryColor,
                    tooltip: 'Speak idiom',
                  ),
                ]
            ),
            const SizedBox(height: 8),
            Text(idiom.definition, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text("Example:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  IconButton(
                    onPressed: ()  {
                      String examplesText = idiom.examples.join('. ');
                      _speak(examplesText);
                    },
                    icon: const Icon(Icons.volume_up),
                    color: Theme.of(context).primaryColor,
                    tooltip: 'Speak idiom',
                  ),
                ]
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: idiom.examples.asMap().entries.map((entry) =>
                  Text('${entry.key + 1}. ${entry.value}', style: const TextStyle(fontSize: 17, fontStyle: FontStyle.italic))
              ).toList(),
            ),

            const SizedBox(height: 16),
            Text("Translation:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(idiom.translations["de"]!,
                style: const TextStyle(fontSize: 17, fontStyle: FontStyle.italic)),
            const Spacer(),
            Align(
              alignment: Alignment.center,
              child: Text("Swipe to see the next card", style: TextStyle(color: Colors.grey)),
            )
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
        itemCount: _lessonIdioms.length,
        itemBuilder: (context, index) {
          Color color;
          if (index < _currentIndex) {
            color = Colors.green; // completed
          } else if (index == _currentIndex) {
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
                boxShadow: index == _currentIndex
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

  Future<void> _speak(String text) async {
    final ttsProvider = Provider.of<TtsProvider>(context, listen: false);
    await ttsProvider.speak(text);
  }
}
