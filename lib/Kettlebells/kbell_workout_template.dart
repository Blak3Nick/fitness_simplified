

import 'package:fitness_simplified/Kettlebells/kbellgroup.dart';
import 'package:fitness_simplified/models.dart';


class WorkoutTemplate {
  List<Group> groups;
  List<String> work_rest = [];

  WorkoutTemplate( this.groups);

  void addGroup(Group group) {
    groups.add(group);
  }

}

class WorkRestPair {
      String workName;
      int workDuration;
      int restDuration;

      WorkRestPair(this.workName, this.workDuration, this.restDuration);
      void addWorkRest(){

      }
      void createGroup(String title, ){

      }
}



