import 'package:flutter/material.dart';
import 'package:idioms/features/overview/overview/overview.dart';
import 'package:idioms/features/home/pages/privacy.dart';
import 'package:idioms/features/home/pages/search.dart';
import 'package:idioms/features/home/pages/settings.dart';
import 'package:idioms/features/learn/pages/learn.dart';
import 'package:idioms/features/vocabulary/pages/vocabularies.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sz_fancy_bottom_navigation/sz_fancy_bottom_navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final bottomNavigationKey = GlobalKey();

  late PageController _pageController;

  int _selectedIndex = 0;
  
  final List<String> _pageTitles = <String>[
    'Overview',
    'Learn',
    'Vocabulary',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.lightBlueAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                            width: 90,
                            image: AssetImage('assets/icon.png')
                        ),
                        SizedBox(height: 10),
                        Text(
                          'English Idioms',
                          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.search),
                    title: const Text('Search'),
                    onTap: () {
                      Navigator.pop(context);
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
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.rate_review),
                    title: Text('Rate App'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text('About'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip),
                    title: const Text('Privacy'),
                    onTap: () {
                      Navigator.pop(context);
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
      body: PageView(
        controller: _pageController,
        children: [
          const OverviewPage(),
          const LearnPage(),
          const VocabulariesPage(),
        ],
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: FancyBottomNavigation(
        pageController: _pageController,
        initialSelection: 0,
        key: bottomNavigationKey,
        hidden: false,
        shadowColor: Colors.black12,
        tabs: [
          TabData(
            iconData: Icons.school,
            title: 'Overview',
          ),
          TabData(
            iconData: Icons.quiz,
            title: 'Learn',
          ),
          TabData(
            iconData: Icons.menu_book,
            title: 'Vocabulary',
          )
        ],
      ),
    );
  }
}