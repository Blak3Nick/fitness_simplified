import 'package:objectbox/objectbox.dart';

@Entity()
class KettlebellExercise {
  // Annotate with @Id() if name isn't "id" (case insensitive).
  int id = 0;
  String? name;
  int reps = -1;
  int workPeriod = 30;
  int restPeriod = 10;
}