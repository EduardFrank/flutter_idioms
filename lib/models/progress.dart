import 'package:objectbox/objectbox.dart';
import 'idiom.dart';

@Entity()
class Progress {
  @Id()
  int id;

  /// Link to the learned idiom
  final ToOne<Idiom> idiom = ToOne<Idiom>();

  /// How many times the idiom was practiced
  int timesPracticed;

  /// When it was last practiced
  @Property(type: PropertyType.date)
  DateTime lastPracticed;

  /// Default constructor for ObjectBox
  Progress({
    this.id = 0,
    int? timesPracticed,
    DateTime? lastPracticed,
  })  : timesPracticed = timesPracticed ?? 0,
        lastPracticed = lastPracticed ?? DateTime.now();

  /// Convenience constructor for creating progress with a linked idiom
  @Transient()
  factory Progress.create({
    int id = 0,
    required Idiom learnedIdiom,
    int timesPracticed = 0,
    DateTime? lastPracticed,
  }) {
    final progress = Progress(
      id: id,
      timesPracticed: timesPracticed,
      lastPracticed: lastPracticed,
    );
    progress.idiom.target = learnedIdiom;
    return progress;
  }
}