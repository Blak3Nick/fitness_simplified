import 'package:flutter/material.dart';

import '../models.dart';
import '../services/firestore.dart';

class CreateKettleBellWorkout extends StatefulWidget {
  const CreateKettleBellWorkout({Key? key}) : super(key: key);

  @override
  _CreateKettleBellWorkoutState createState() =>
      _CreateKettleBellWorkoutState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _CreateKettleBellWorkoutState extends State<CreateKettleBellWorkout> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  final exerciseController = TextEditingController();
  final workRestController = TextEditingController();
  final repeatNumberController = TextEditingController();
  String workoutName = "";
  bool isName = true;
  bool atLeastOneCircuit = false;
  int circuitNumber = 1;
  List<Group> groups = [];
  int currentRepeat = 1;
  List<int> currentWorkDuration = [];
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
      body: Center(
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
              child: Flexible(
                flex: 1,
                child: Column(
                  children: [
                    const Text("Current Circuit List"),
                    ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: currentWorkRest.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return Center(child: Text(currentWorkRest[index]));
                        }),
                  ],
                ),
              ),
            )
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
                  : (BuildContext context) => _buildCircuitPopup(context));
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: (atLeastOneCircuit)
                  ? const Text(
                      "Finish Workout",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.red,
                      ),
                    )
                  : null,
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
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: myController,
          builder: (context, value, child) {
            return ElevatedButton(
              onPressed: value.text.isNotEmpty
                  ? () {
                      workoutName = myController.text;
                      isName = false;
                      test();
                      setState(() {
                        isName = isName;
                      });
                      Navigator.of(context).pop();
                    }
                  : null,
              child: const Text('Confirm'),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCircuitPopup(BuildContext context) {
    return AlertDialog(
      title: const Text('How many times will this circuit be repeated?'),
      content: formWidget(context),
    );
  }

  Widget formWidget(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: repeatNumberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Circuit repeats",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter number of times the circuit will repeat.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: workRestController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Work Duration",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter how long each set is.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: exerciseController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: "First Exercise Name",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter how long each set is.';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        print('testing');
                        currentRepeat = int.parse(repeatNumberController.text);
                        currentWorkDuration
                            .add(int.parse(workRestController.text));
                        currentWorkRest.add(exerciseController.text);
                        setState(() {});
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void test() {
    print(currentRepeat);
    print(workoutName);
    print(isName);
  }

  void clearCircuit() {
    currentRepeat = 1;
    currentWorkDuration.clear();
    currentRestDuration = 1;
    currentWorkRest.clear();
    numberOfExercises = 1;
  }

  void addToGroup() {
    Group group = Group(
        repeat: currentRepeat,
        work_duration: currentWorkDuration,
        rest_duration: currentRestDuration,
        work_rest: currentWorkRest);
    groups.add(group);
    clearCircuit();
  }

  void addKWorkout() {
    FirestoreService firestoreService = FirestoreService();
    Future upload() async {
      firestoreService.addNewKettlebellWorkout(groups, workoutName);
    }

    upload();
  }
}
