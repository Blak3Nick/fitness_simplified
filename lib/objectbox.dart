import 'objectbox.g.dart'; // created by `flutter pub run build_runner build`

class ObjectBox {

  /// The Store of this app.
  late final Store store;

  /// A Box of kettlebell exercises.
  late final Box<KettlebellExercise_> kettlebellExercises;

  /// A stream of all  kettlebell exercises ordered by date.
  late final Stream<Query<KettlebellExercise_>> queryStream;

  ObjectBox._create(this.store) {
    // Add any additional setup code, e.g. build queries.
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore();
    return ObjectBox._create(store);
  }

  void addKettlebellExercises() {
    final kbells = [

    ];
  }
}