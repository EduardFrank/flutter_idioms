
class Idiom {
  final Difficulty difficulty;
  final String idiom;
  final String definition;
  final List<String> examples;
  final Map<String, String> translations;

  Idiom({
    required this.difficulty,
    required this.idiom,
    required this.definition,
    required this.examples,
    required this.translations,
  });
}

enum Difficulty {
  basic,
  intermediate,
  advanced
}