
import 'package:idioms/models/idiom.dart';

class IdiomRepository {
  static final IdiomRepository _instance = IdiomRepository._internal();
  factory IdiomRepository() => _instance;
  IdiomRepository._internal();

  final List<Idiom> _idioms = [
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

  List<Idiom> getAllIdioms() {
    return List.from(_idioms);
  }

  List<Idiom> getIdiomsByDifficulty(String difficulty) {
    // For now, we'll return all idioms and in the future we can implement
    // actual difficulty filtering
    return List.from(_idioms);
  }

  Idiom? getIdiomById(int id) {
    if (id < 0 || id >= _idioms.length) {
      return null;
    }
    return _idioms[id];
  }

  List<Idiom> searchIdioms(String query) {
    if (query.isEmpty) {
      return [];
    }
    return _idioms
        .where((idiom) =>
            idiom.idiom.toLowerCase().contains(query.toLowerCase())
        )
        .toList();
  }

  void addIdiom(Idiom idiom) {
    _idioms.add(idiom);
  }

  void updateIdiom(int index, Idiom updatedIdiom) {
    if (index >= 0 && index < _idioms.length) {
      _idioms[index] = updatedIdiom;
    }
  }

  void deleteIdiom(int index) {
    if (index >= 0 && index < _idioms.length) {
      _idioms.removeAt(index);
    }
  }

  int getTotalIdiomsCount() {
    return _idioms.length;
  }

  int getLearnedIdiomsCount() {
    // For now, return a mock value - in real implementation this would track learned idioms
    return 2; // Mock value for demonstration
  }
}