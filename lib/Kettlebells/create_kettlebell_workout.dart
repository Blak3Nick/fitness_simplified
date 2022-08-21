


import 'package:fitness_simplified/Kettlebells/kbell_workout_template.dart';
import 'package:fitness_simplified/Kettlebells/reactive_form.dart';
import 'package:fitness_simplified/Kettlebells/temp.dart';
import 'package:flutter/material.dart';

import '../models.dart';
import '../services/firestore.dart';


class CreateKettleBellWorkout extends StatefulWidget {
  const CreateKettleBellWorkout({Key? key}) : super(key: key);

  @override
  _CreateKettleBellWorkoutState createState() => _CreateKettleBellWorkoutState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _CreateKettleBellWorkoutState extends State<CreateKettleBellWorkout> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();
  final exerciseController = TextEditingController();
  final exerciseDurationController = TextEditingController();
  final restDurationController = TextEditingController();
  String workoutName = "";
  bool isName = true;
  bool atLeastOneCircuit = false;
  int circuitNumber = 1;
  List<Group> groups = [];
  int currentRepeat = 1;
  int currentWorkDuration = 1;
  int currentRestDuration = 1;
  List<String> currentWorkRest = [];
  int numberOfExercises = 1;



  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Kettlebell Workout'),
        backgroundColor: Colors.deepPurple,
      ),
      body:
        Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: isName,
                  child: const Text("Let's build the workout!",
                      style: TextStyle(fontSize: 35)),
                ),
                Visibility(
                  visible: !isName,
                  child: Text("Circuit $circuitNumber",
                      style: const TextStyle(fontSize: 35)),)
                    ],
            ),

          ),

      floatingActionButton: TextButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () {          
          showDialog(
            context: context,
            builder: (isName)
                ? (BuildContext context) => _buildWorkoutNamePopup(context)
                : (BuildContext context) => _buildCircuitPopup(context)
          );
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child:(atLeastOneCircuit)
                  ? const Text("Finish Workout",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.red,
                  ),
              ) : null,
            ),
            const Spacer(),
            const Text("Next", style: TextStyle(fontSize: 25)),
          ],
        ),
      ),

    );
  }

  Widget _buildWorkoutNamePopup(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm the workout name'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: myController,
            decoration: const InputDecoration(
              labelText: "Enter the Name of the Workout",
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            primary: Colors.red,
          ),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            workoutName = myController.text;
            isName = false;
            test();
            setState(() {
              isName = isName;
            });
            Navigator.of(context).pop();

          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }

  Widget _buildCircuitPopup(BuildContext context) {
    return AlertDialog(
      title: const Text('How many Exercises in first Circuit?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: exerciseController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Number of Exercises",
            ),
          ),
          TextField(
            controller: exerciseDurationController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Work Duration",
            ),
          ),
          TextField(
            controller: restDurationController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Rest Duration",
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            clearCircuit();
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            primary: Colors.red,
          ),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            primary: Colors.amberAccent,
          ),
          child: const Text('Add exercise'),
        ),
        TextButton(
          onPressed: () {
            workoutName = myController.text;
            isName = false;
            test();
            setState(() {
              isName = isName;
            });
            Navigator.of(context).pop();

          },
          child: const Text('Finish'),
        ),
      ],
    );
  }

  void test(){
    print(workoutName);
    print(isName);

  }
  void clearCircuit() {
    currentRepeat = 1;
    currentWorkDuration = 1;
    currentRestDuration = 1;
    currentWorkRest.clear();
    numberOfExercises = 1;
  }
  void addToGroup(int repeat, int restDuration, int workDuration, List<String> workRest){
      Group group = Group( repeat: repeat, title: "Group $circuitNumber", work_duration: workDuration, rest_duration: restDuration, work_rest: workRest);
      groups.add(group);
  }


  void addKWorkout() {
    FirestoreService firestoreService = FirestoreService();
    Future upload() async {
      firestoreService.addNewKettlebellWorkout(groups, workoutName);
    }
    upload();
  }
}