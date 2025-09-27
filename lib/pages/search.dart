import 'package:flutter/material.dart';
import 'package:idioms/models/idiom.dart';
import 'package:idioms/repositories/repository.dart';
import 'package:idioms/widgets/idiom_dialog.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Idiom> _searchResults = [];
  late Repository _repository;

  @override
  void initState() {
    super.initState();
    _repository = Provider.of<Repository>(context, listen: false);

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

    if (query.length >= 3) {
      setState(() {
        _searchResults = _repository.searchIdioms(query);
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
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
                      return InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => IdiomDialog(idiom: idiom),
                          );
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(idiom.idiom),
                            subtitle: Text(idiom.definition),
                          ),
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