


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
        Column(
          children: [
            Card(
              child: TextField(
                controller: myController,
                decoration: const InputDecoration(
                  labelText: "Enter the Name of the Workout",
                ),
              ),
            ),
           Card(
            child: SizedBox(
              child: Column(
                children: [
                  Center(
                    child: Row(
                      children: const [
                        Text('Circuit 1'),
                      ],
                    ),
                  ),
                Row(
                    children: [
                      Flexible(
                        child: TextField(
                          controller: myController,
                          decoration: const InputDecoration(
                            labelText: "First Exercise",
                            border: OutlineInputBorder(
                            ),
                          ),

                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        child: TextField(
                          controller: myController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Time",
                            border: OutlineInputBorder(
                            ),
                          ),
                        ),
                      ),
                    ],
                ),
                  Row(
                    children: [
                      Flexible(
                        child: TextField(
                          controller: myController,
                          decoration: const InputDecoration(
                            labelText: "Second Exercise",
                            border: OutlineInputBorder(
                            ),
                          ),

                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        child: TextField(
                          controller: myController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Time",
                            border: OutlineInputBorder(
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child:
                    IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.deepPurple),
                        iconSize: 40,

                        onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const KettlebellReactiveForm()));
                        }),
                  ),
                ],
              ),
            ),
          ),
          ],

        ),

      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Retrieve the text the that user has entered by using the
                // TextEditingController.
                content: Text(myController.text),
              );
            },
          );
        },
        tooltip: 'Show me the value!',
        child: const Icon(Icons.text_fields),
      ),

    );
  }
  void addKWorkout() {
    List<String> strings = ['Swing', 'Rest'];
    Group group = Group(repeat: 1, title: 'Set 1', work_duration: 10, rest_duration: 10, work_rest: strings );
    List<Group> groups = [];
    groups.add(group);
    Group group1 = Group(repeat: 1, title: 'Set 2', work_duration: 10, rest_duration: 10, work_rest: strings );
    groups.add(group1);
    FirestoreService firestoreService = FirestoreService();
    Future upload() async {
      firestoreService.addNewKettlebellWorkout(groups, 'test');
    }
    upload();
  }
}