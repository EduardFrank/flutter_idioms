import 'dart:convert';
import 'package:objectbox/objectbox.dart';

@Entity()
class Idiom {
  @Id()
  int id;

  int difficultyValue; // store enum as int
  String idiom;
  String definition;
  String examplesJson;
  String translationsJson;

  // 👇 Default constructor for ObjectBox
  Idiom({
    this.id = 0,
    required this.difficultyValue,
    required this.idiom,
    required this.definition,
    required this.examplesJson,
    required this.translationsJson,
  });

  // 👇 Convenience constructor for easier object creation in app
  @Transient()
  factory Idiom.create({
    int id = 0,
    required Difficulty difficulty,
    required String idiom,
    required String definition,
    required List<String> examples,
    required Map<String, String> translations,
  }) {
    return Idiom(
      id: id,
      difficultyValue: difficulty.index,
      idiom: idiom,
      definition: definition,
      examplesJson: jsonEncode(examples),
      translationsJson: jsonEncode(translations),
    );
  }

  Difficulty get difficulty => Difficulty.values[difficultyValue];

  List<String> get examples => List<String>.from(jsonDecode(examplesJson));

  Map<String, String> get translations =>
      Map<String, String>.from(jsonDecode(translationsJson));

  factory Idiom.fromJson(Map<String, dynamic> json) {
    return Idiom(
      id: 0,
      difficultyValue: Difficulty.values.firstWhere(
            (e) => e.name == json['difficulty'],
        orElse: () => Difficulty.basic,
      ).index,
      idiom: json['idiom'] as String,
      definition: json['definition'] as String,
      examplesJson: jsonEncode(json['examples']),
      translationsJson: jsonEncode(json['translations']),
    );
  }
}

enum Difficulty {
  basic,
  intermediate,
  advanced,
}