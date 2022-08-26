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
  bool currentCircuitEmpty = true;
  List<int> currentWorkDuration = [];
  int currentRestDuration = 1;
  List<String> currentWorkRest = [];
  int numberOfExercises = 1;
  bool groupsEmpty = true;
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
              child: Expanded(
                child: Column(
                  children: [
                    const Spacer(),
                    const Text("Let's build the workout!",
                        style: TextStyle(fontSize: 35)),
                    const Spacer(),
                    ElevatedButton(
                      child: const Text('Build Workout'),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildWorkoutNamePopup(context));
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blueAccent),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(10)),
                          textStyle: MaterialStateProperty.all(
                              const TextStyle(fontSize: 30))),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: !isName,
              child: Flexible(
                flex: 1,
                child: Column(
                  children: [
                    const Text(
                      "Current Circuit List",
                      style: TextStyle(
                          fontSize: 35, decoration: TextDecoration.underline),
                    ),
                    ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: currentWorkRest.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(child: Text(currentWorkRest[index]));
                        }),
                    const Spacer(),
                    ElevatedButton(
                      child: const Text('Cancel Workout'),
                      onPressed: () {
                        clearCircuit();
                        Navigator.pushNamed(context, '/kettlebellworkouts');
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red[300]),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(10)),
                          textStyle: MaterialStateProperty.all(
                              const TextStyle(fontSize: 20))),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: (groups.isNotEmpty &&
                                    currentWorkRest.isEmpty)
                                ? ElevatedButton(
                                    child: const Text('Complete Workout'),
                                    onPressed: () {
                                      //save workout, pop up confirmation go back to workout screen

                                      showDialog(
                                          context: context,
                                          builder: workoutBuiltAlert);
                                      addKWorkout();

                                      Navigator.pushNamed(
                                          context, '/kettlebellworkouts');
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.deepPurpleAccent),
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.all(10)),
                                        textStyle: MaterialStateProperty.all(
                                            const TextStyle(fontSize: 30))),
                                  )
                                : null),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: (currentWorkRest.isNotEmpty)
                                ? ElevatedButton(
                                    child: const Text('Complete Circuit'),
                                    onPressed: () {
                                      addToGroup();
                                      showDialog(
                                          context: context,
                                          builder: circuitSavedAlert);
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.deepPurpleAccent),
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.all(5)),
                                        textStyle: MaterialStateProperty.all(
                                            const TextStyle(fontSize: 20))),
                                  )
                                : null),
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: ElevatedButton(
                              child: (currentCircuitEmpty) ?
                              const Text("New Circuit"): const Text('Add to Circuit'),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (isName)
                                        ? (BuildContext context) =>
                                            _buildWorkoutNamePopup(context)
                                        : (BuildContext context) =>
                                            _buildCircuitPopup(context));
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blueAccent),
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.all(5)),
                                  textStyle: MaterialStateProperty.all(
                                      const TextStyle(fontSize: 20))),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget circuitSavedAlert(BuildContext context) {
    return AlertDialog(
      title: const Text("Circuit Added"),
      content: const Text("The circuit was added to the workout."),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Okay'))
      ],
    );
  }

  Widget workoutBuiltAlert(BuildContext context) {
    return AlertDialog(
      title: const Text("Workout Built"),
      content: const Text("The workout was saved."),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Okay'))
      ],
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
      title: const Text('Fill out the circuit information'),
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
              enabled: (currentCircuitEmpty) ? true: false,
              decoration: InputDecoration(
                labelText: (currentCircuitEmpty) ? "Circuit repeats": "Read only for reference",
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
                labelText: "Exercise Name",
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
                        atLeastOneCircuit = true;
                        currentCircuitEmpty = false;
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

  void test() {}

  void clearCircuit() {
    currentRepeat = 1;
    currentWorkDuration.clear();
    currentRestDuration = 1;
    currentWorkRest.clear();
    numberOfExercises = 1;
    currentCircuitEmpty = true;
    setState(() {});
  }

  bool addToGroup() {
    Group group = Group(
        repeat: currentRepeat,
        work_duration: currentWorkDuration.toList(),
        rest_duration: currentRestDuration,
        work_rest: currentWorkRest.toList());
    groups.add(group);
    clearCircuit();
    return true;
  }

  void addKWorkout() {
    FirestoreService firestoreService = FirestoreService();
    Future upload() async {
      firestoreService.addNewKettlebellWorkout(groups, workoutName);
    }

    upload();
  }
}
