

import 'package:fitness_simplified/Kettlebells/kbellgroup.dart';
import 'package:fitness_simplified/models.dart';


class WorkoutTemplate {
  int repeat;
  String title;
  int work_duration;
  int rest_duration;
  List<String> work_rest ;

  WorkoutTemplate(this.repeat, this.title, this.work_duration,
      this.rest_duration, this.work_rest);
}



