import 'package:flutter/material.dart';
import 'package:idioms/models/idiom.dart';
import 'package:idioms/repositories/idiom_repository.dart';
import 'package:provider/provider.dart';
import 'package:idioms/providers/theme_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Idiom> _searchResults = [];
  late IdiomRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = Provider.of<IdiomRepository>(context, listen: false);

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    setState(() {
      _searchResults = _repository.searchIdioms(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Search Idioms',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search idioms...',
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Search Results',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _searchResults.isEmpty && _searchController.text.isNotEmpty ?
                  const Center(
                    child: Text('No results found for your search.'),
                  ) : ListView.builder(
                    itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                      final idiom = _searchResults[index];
                      return Card(
                        child: ListTile(
                          title: Text(idiom.idiom),
                          subtitle: Text(idiom.definition),
                        ),
                      );
                  }
              )
            ),
          ],
        ),
      ),
    );
  }
}