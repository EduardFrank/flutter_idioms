import 'package:objectbox/objectbox.dart';

@Entity()
class IdiomOfTheDay {
  @Id()
  int id;

  int idiomId; // Reference to the idiom
  @Property(type: PropertyType.date)
  DateTime date; // Date for which this idiom is selected

  IdiomOfTheDay({
    this.id = 0,
    required this.idiomId,
    required this.date,
  });
}