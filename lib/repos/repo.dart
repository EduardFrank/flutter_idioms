import 'dart:math';

import 'package:idioms/core/constants.dart';
import 'package:idioms/models/idiom.dart';
import 'package:idioms/models/progress.dart';
import 'package:idioms/models/idiom_of_the_day.dart';
import 'package:idioms/objectbox.g.dart';

class Repo {
  static final Repo _instance = Repo._internal();
  factory Repo() => _instance;
  Repo._internal();

  late final Store _store;
  late final Box<Idiom> _idiomBox;
  late final Box<Progress> _progressBox;
  late final Box<IdiomOfTheDay> _idiomOfTheDayBox;

  bool _isInitialized = false;

  /// Call this once during app startup
  Future<void> init() async {
    if (_isInitialized) return;
    _store = await openStore();
    _idiomBox = _store.box<Idiom>();
    _progressBox = _store.box<Progress>();
    _idiomOfTheDayBox = _store.box<IdiomOfTheDay>();

    // Seed with initial data if empty
    if (_idiomBox.isEmpty()) {
      _seedIdioms();
    }

    _isInitialized = true;
  }

  /// Sample data to populate ObjectBox initially
  void _seedIdioms() {
    _progressBox.removeAll();
    _idiomBox.removeAll();
    _idiomBox.putMany(SAMPLE_IDIOMS);
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
        .query(Progress_.timesPracticed.greaterOrEqual(MASTER_IDIOMS_COUNT))
        .build();
    final count = query.count();
    query.close();
    return count;
  }

  int countMasteredByDifficulty(Difficulty difficulty) {
    // Step 1: Query all progress where timesPracticed > 5
    final query = _progressBox.query(Progress_.timesPracticed.greaterOrEqual(MASTER_IDIOMS_COUNT)).build();
    final results = query.find();
    query.close();

    // Step 2: Filter results by idiom difficulty
    final count = results
        .where((p) => p.idiom.target != null && p.idiom.target!.difficulty == difficulty)
        .length;

    return count;
  }

  /// Returns all idioms that were practiced/learned on a specific day
  List<Idiom> getIdiomsLearnedOnDate(DateTime date) {
    // Normalize date to ignore time
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final query = _progressBox
        .query(Progress_.lastPracticed.between(startOfDay.millisecondsSinceEpoch,
        endOfDay.millisecondsSinceEpoch - 1))
        .build();
    final results = query.find();
    query.close();

    // Return linked idioms, filter out nulls just in case
    return results.map((p) => p.idiom.target).whereType<Idiom>().toList();
  }

  int calculateDayStreak(DateTime fromDate) {
    // Step 1: Normalize the date to ignore time
    DateTime currentDate = DateTime(fromDate.year, fromDate.month, fromDate.day);

    int streak = 0;

    while (true) {
      // Step 2: Check if any idiom was learned on this date
      final learnedToday = getIdiomsLearnedOnDate(currentDate);
      if (learnedToday.isEmpty) {
        // No idioms learned on this day -> streak ends
        break;
      }

      // Step 3: Increment streak and go back one day
      streak += 1;
      currentDate = currentDate.subtract(const Duration(days: 1));
    }

    return streak;
  }

  /// Get all idioms that have not been learned yet
  List<Idiom> getUnlearnedIdioms() {
    final allIdioms = getAllIdioms();
    final learnedIds = <int>{};
    
    // Get IDs of all learned idioms
    final allProgress = _progressBox.getAll();
    for (final progress in allProgress) {
      learnedIds.add(progress.idiom.targetId);
    }
    
    // Filter out the learned idioms
    return allIdioms.where((idiom) => !learnedIds.contains(idiom.id)).toList();
  }

  /// Get idiom of the day for the current date
  Idiom? getIdiomOfTheDay() {
    // Create a date for today (without time)
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    
    // Check if we already have an idiom of the day for today
    final query = _idiomOfTheDayBox.query(
      IdiomOfTheDay_.date.equals(today.millisecondsSinceEpoch),
    ).build();
    final results = query.find();
    query.close();
    
    // If we have an idiom of the day for today, return it
    if (results.isNotEmpty) {
      final idiomOfTheDayEntry = results.first;
      return _idiomBox.get(idiomOfTheDayEntry.idiomId);
    }
    
    // If not, find an unlearned idiom and save it as the idiom of the day
    final unlearnedIdioms = getUnlearnedIdioms();
    if (unlearnedIdioms.isEmpty) {
      return null; // All idioms have been learned
    }
    
    // Generate a random index
    final randomIndex = today.millisecondsSinceEpoch % unlearnedIdioms.length;
    final selectedIdiom = unlearnedIdioms[randomIndex];
    
    // Save this idiom as the idiom of the day
    final idiomOfTheDay = IdiomOfTheDay(
      idiomId: selectedIdiom.id,
      date: today,
    );
    _idiomOfTheDayBox.put(idiomOfTheDay);
    
    return selectedIdiom;
  }

  List<Idiom> getRandomUnlearnedIdioms({int count = 5}) {
    // Step 1: Get all learned idiom IDs
    final learnedIds = _progressBox.getAll()
        .map((p) => p.idiom.target?.id)
        .whereType<int>()
        .toSet();

    // Step 2: Filter idioms that haven't been learned
    final unlearnedIdioms = _idiomBox.getAll()
        .where((idiom) => !learnedIds.contains(idiom.id))
        .toList();

    // Step 3: Shuffle and pick up to [count] idioms
    unlearnedIdioms.shuffle(Random());
    if (unlearnedIdioms.length <= count) {
      return unlearnedIdioms;
    }
    return unlearnedIdioms.sublist(0, count);
  }

  List<Idiom> getRandomIdioms({int count = 5}) {
    // Step 2: Filter idioms that haven't been learned
    final unlearnedIdioms = _idiomBox.getAll();

    // Step 3: Shuffle and pick up to [count] idioms
    unlearnedIdioms.shuffle(Random());
    if (unlearnedIdioms.length <= count) {
      return unlearnedIdioms;
    }
    return unlearnedIdioms.sublist(0, count);
  }

  void close() {
    _store.close();
  }
}