import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:idioms/models/idiom.dart';
import 'package:idioms/pages/learn.dart';
import 'package:idioms/pages/privacy.dart';
import 'package:idioms/pages/search.dart';
import 'package:idioms/pages/settings.dart';
import 'package:idioms/pages/test.dart';
import 'package:idioms/pages/vocabulary.dart';
import 'package:idioms/providers/theme_provider.dart';

final List<Idiom> idioms = [
  Idiom(
    idiom: "Break the ice",
    definition: "To initiate conversation in a social setting.",
    examples: ["He told a joke to break the ice at the party.", "He told a joke to break the ice at the party."],
    translations: {
      "de": "So das Eis brechen (German)"
    },
  ),
  Idiom(
    idiom: "Hit the sack",
    definition: "To go to bed or go to sleep.",
    examples: ["I'm really tired, so I'm going to hit the sack early tonight.", "I'm really tired, so I'm going to hit the sack early tonight."],
    translations: {
      "de": "Ins Bett gehen (German)"
    },
  ),
  Idiom(
    idiom: "Piece of cake",
    definition: "Something very easy to do.",
    examples: ["This math problem was a piece of cake.", "This math problem was a piece of cake."],
    translations: {
      "de": "Kinderspiel"
    },
  ),
  Idiom(
    idiom: "Under the weather",
    definition: "Feeling ill or unwell.",
    examples: ["I'm feeling a bit under the weather today.", "I'm feeling a bit under the weather today."],
    translations: {
      "de": "Sich unwohl fühlen"
    },
  ),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // We'll create the pages with data here
  List<Widget> get _pages => <Widget>[
    LearnPage(idioms: idioms),
    TestPage(),
    VocabularyPage(),
  ];

  final List<String> _pageTitles = <String>[
    'Learn Idioms',
    'Test Your Knowledge',
    'My Vocabulary',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Text(
                      'Idioms App',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.search),
                    title: const Text('Search'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SearchPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsPage()),
                      );
                    },
                  ),
                  const ListTile(
                    leading: Icon(Icons.rate_review),
                    title: Text('Rate App'),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    leading: Icon(Icons.info),
                    title: Text('About'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip),
                    title: const Text('Privacy'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PrivacyPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                final version = snapshot.data?.version ?? '1.0.0';
                return ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('Version'),
                  subtitle: Text('v$version'),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex]),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Test',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Vocabulary',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}