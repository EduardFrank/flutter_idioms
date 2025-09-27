import 'package:idioms/core/constants.dart';
import 'package:idioms/models/idiom.dart';
import 'package:idioms/models/progress.dart';
import 'package:idioms/objectbox.g.dart';

class Repository {
  static final Repository _instance = Repository._internal();
  factory Repository() => _instance;
  Repository._internal();

  late final Store _store;
  late final Box<Idiom> _idiomBox;
  late final Box<Progress> _progressBox;

  bool _isInitialized = false;

  /// Call this once during app startup
  Future<void> init() async {
    if (_isInitialized) return;
    _store = await openStore();
    _idiomBox = _store.box<Idiom>();
    _progressBox = _store.box<Progress>();

    // Seed with initial data if empty
    if (_idiomBox.isEmpty()) {
      _seedIdioms();
    }

    _isInitialized = true;
  }

  /// Sample data to populate ObjectBox initially
  void _seedIdioms() {
    final sampleIdioms = [
      Idiom.create(
        difficulty: Difficulty.basic,
        idiom: "Break the ice",
        definition: "To initiate conversation in a social setting.",
        examples: [
          "He told a joke to break the ice at the party.",
          "He told a joke to break the ice at the party."
        ],
        translations: {"de": "So das Eis brechen (German)"},
      ),
      Idiom.create(
        difficulty: Difficulty.intermediate,
        idiom: "Hit the sack",
        definition: "To go to bed or go to sleep.",
        examples: [
          "I'm really tired, so I'm going to hit the sack early tonight.",
          "I'm really tired, so I'm going to hit the sack early tonight."
        ],
        translations: {"de": "Ins Bett gehen (German)"},
      ),
      Idiom.create(
        difficulty: Difficulty.advanced,
        idiom: "Piece of cake",
        definition: "Something very easy to do.",
        examples: [
          "This math problem was a piece of cake.",
          "This math problem was a piece of cake."
        ],
        translations: {"de": "Kinderspiel"},
      ),
      Idiom.create(
        difficulty: Difficulty.basic,
        idiom: "Under the weather",
        definition: "Feeling ill or unwell.",
        examples: [
          "I'm feeling a bit under the weather today.",
          "I'm feeling a bit under the weather today."
        ],
        translations: {"de": "Sich unwohl fühlen"},
      ),
    ];

    _idiomBox.putMany(sampleIdioms);
  }

  /// CRUD Operations
  List<Idiom> getAllIdioms() {
    return _idiomBox.getAll();
  }

  Idiom? getIdiomById(int id) {
    return _idiomBox.get(id);
  }

  void addIdiom(Idiom idiom) {
    _idiomBox.put(idiom);
  }

  void updateIdiom(int id, Idiom updatedIdiom) {
    if (_idiomBox.contains(id)) {
      updatedIdiom.id = id;
      _idiomBox.put(updatedIdiom);
    }
  }

  void deleteIdiom(int id) {
    _idiomBox.remove(id);

    // Also delete progress related to this idiom
    final query = _progressBox.query(Progress_.idiom.equals(id)).build();
    _progressBox.removeMany(query.findIds());
    query.close();
  }

  /// Queries
  int countIdiomsByDifficulty(Difficulty difficulty) {
    final query = _idiomBox
        .query(Idiom_.difficultyValue.equals(difficulty.index))
        .build();
    final count = query.count();
    query.close();
    return count;
  }

  List<Idiom> getIdiomsByDifficulty(Difficulty difficulty) {
    final query = _idiomBox
        .query(Idiom_.difficultyValue.equals(difficulty.index))
        .build();
    final results = query.find();
    query.close();
    return results;
  }

  List<Idiom> searchIdioms(String queryText) {
    if (queryText.isEmpty) return [];

    final query = _idiomBox
        .query(Idiom_.idiom.contains(queryText, caseSensitive: false))
        .build();
    final results = query.find();
    query.close();
    return results;
  }

  int countLearnedByDifficulty(Difficulty difficulty) {
    // Step 1: Get all progress records
    final allProgress = _progressBox.getAll();

    // Step 2: Filter only those where the linked idiom matches the difficulty
    final count = allProgress
        .where((p) => p.idiom.target != null && p.idiom.target!.difficulty == difficulty)
        .length;

    return count;
  }

  /// Mark an idiom as learned / increment practice count
  void markIdiomAsLearned(Idiom idiom) {
    // Check if progress exists
    final query = _progressBox.query(Progress_.idiom.equals(idiom.id)).build();
    final results = query.find();
    query.close();

    Progress progress;
    if (results.isEmpty) {
      progress = Progress.create(learnedIdiom: idiom, timesPracticed: 1);
    } else {
      progress = results.first;
      progress.timesPracticed += 1;
      progress.lastPracticed = DateTime.now();
    }

    _progressBox.put(progress);
  }

  void markIdiomAsUnlearned(Idiom idiom) {
    final query = _progressBox.query(Progress_.idiom.equals(idiom.id)).build();
    final results = query.findIds(); // Get all matching progress IDs
    _progressBox.removeMany(results); // Delete them
    query.close();
  }

  /// Get progress for a specific idiom
  Progress? getProgressByIdiom(Idiom idiom) {
    final query = _progressBox.query(Progress_.idiom.equals(idiom.id)).build();
    final result = query.findFirst();
    query.close();
    return result;
  }

  /// Total learned idioms
  int getLearnedIdiomsCount() {
    return _progressBox.count();
  }

  /// Get idioms practiced more than N times
  List<Idiom> getIdiomsPracticedMoreThan(int times) {
    final query = _progressBox.query(Progress_.timesPracticed.greaterThan(times)).build();
    final results = query.find();
    query.close();
    return results.map((p) => p.idiom.target).whereType<Idiom>().toList();
  }
  
  // Aliases for the VocabularyPage to maintain consistent naming
  int countIdioms() {
    return _idiomBox.count();;
  }
  
  int countLearned() {
    return _progressBox.count();
  }

  int countMastered() {
    final query = _progressBox
        .query(Progress_.timesPracticed.greaterThan(MASTER_IDIOMS_COUNT))
        .build();
    final count = query.count();
    query.close();
    return count;
  }

  int countMasteredByDifficulty(Difficulty difficulty) {
    // Step 1: Query all progress where timesPracticed > 5
    final query = _progressBox.query(Progress_.timesPracticed.greaterThan(MASTER_IDIOMS_COUNT)).build();
    final results = query.find();
    query.close();

    // Step 2: Filter results by idiom difficulty
    final count = results
        .where((p) => p.idiom.target != null && p.idiom.target!.difficulty == difficulty)
        .length;

    return count;
  }

  void close() {
    _store.close();
  }
}