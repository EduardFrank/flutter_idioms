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
import 'package:idioms/repositories/idiom_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<Widget> get _pages => <Widget>[
    LearnPage(),
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