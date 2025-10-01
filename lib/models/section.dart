import 'package:objectbox/objectbox.dart';

import 'idiom.dart';

@Entity()
class Section {
  @Id()
  int id;

  /// A unique global ID (e.g. from server or JSON)
  int globalId;

  /// The section title, e.g. "Abrupt Change & Withdrawal"
  String name;

  /// One-to-many relationship: a Section can have many Idioms
  @Backlink('section')
  final idioms = ToMany<Idiom>();

  Section({
    this.id = 0,
    required this.globalId,
    required this.name,
  });

  /// Factory to build a Section from JSON
  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      globalId: json.containsKey('id') ? json['id'] as int : 0,
      name: json['section'] as String,
    );
  }
}