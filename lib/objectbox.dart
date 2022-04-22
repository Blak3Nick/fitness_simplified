import 'models.dart';
import 'objectbox.g.dart'; // created by `flutter pub run build_runner build`

/// Provides access to the ObjectBox Store throughout the app.
///
/// Create this in the apps main function.
class ObjectBox {
  /// The Store of this app.
  late final Store store;

  /// A Box of notes.
  late final Box<Note> noteBox;
  late final Box<KettlebellExercise> kettlebellBox;

  /// A stream of all notes ordered by date.
  late final Stream<Query<Note>> queryStream;
  late final Stream<Query<KettlebellExercise>> kettlebellQueryStream;

  ObjectBox._create(this.store) {
    noteBox = Box<Note>(store);
    kettlebellBox = Box<KettlebellExercise> (store);

    final qBuilder = noteBox.query()
      ..order(Note_.date, flags: Order.descending);
    queryStream = qBuilder.watch(triggerImmediately: true);

    final kBuilder = kettlebellBox.query()
      ..order(KettlebellExercise_.name, flags: Order.descending);
    kettlebellQueryStream = kBuilder.watch(triggerImmediately: true);

    //throw in a check for update available flag here
    //when a new exercise is added have it run the kettlebell data method
    _addKettleBell_Data();

    // Add some demo data if the box is empty.
    if (noteBox.isEmpty()) {
      _putDemoData();
    }
  }
  // ObjectBox._create(this.kStore) {
  //
  // }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore();
    return ObjectBox._create(store);
  }

  void _putDemoData() {
    final demoNotes = [
      Note('Quickly add a note by writing text and pressing Enter'),
      Note('Delete notes by tapping on one'),
      Note('Write a demo app for ObjectBox')
    ];
    noteBox.putMany(demoNotes);
  }

  void _addKettleBell_Data() {
    final kettlebellExercises = [
      KettlebellExercise(name: 'Double Clean/ Press', restPeriod: 30, workPeriod: 30)
    ];
  }
}