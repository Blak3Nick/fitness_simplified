import 'package:flutter/material.dart';

class GetMaxes extends StatefulWidget {
  const GetMaxes({Key? key}) : super(key: key);

  @override
  _GetMaxesState createState() => _GetMaxesState();
}

class _GetMaxesState extends State<GetMaxes> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  final exerciseController = TextEditingController();
  final workRestController = TextEditingController();
  final repeatNumberController = TextEditingController();
  List<String> maxNames = [
    "Back Squat",
    "Deadlift",
    "Overhead Press",
    "Bench Press"
  ];
  String workoutName = "";
  bool isName = true;
  bool atLeastOneCircuit = false;
  int circuitNumber = 1;
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
        title: const Text('Getting Your Maxes'),
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
                    const Text("Time to estimate your 1-rep maxes",
                        style: TextStyle(fontSize: 35)),
                    const Spacer(),
                    ElevatedButton(
                      child: const Text('Assign Maxes'),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _GetMaxNumberPopup(context));
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
                      "Max Numbers",
                      style: TextStyle(
                          fontSize: 30, decoration: TextDecoration.underline),
                    ),
                    ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: maxNames.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(child: Text(maxNames[index]));
                        }),
                    const Spacer(),
                    ElevatedButton(
                      child: const Text('Return Home'),
                      onPressed: () {
                        //clearCircuit();
                        //Cancel adding the maxes. Keep bool showing no maxes on users account
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
                            child: (currentWorkRest.isNotEmpty)
                                ? ElevatedButton(
                                    child: const Text('Complete Circuit'),
                                    onPressed: () {
                                      //addToGroup();
                                      // showDialog(
                                      //     context: context,
                                      //     builder: circuitSavedAlert);
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
                              child: (currentCircuitEmpty)
                                  ? const Text("New Circuit")
                                  : const Text('Add to Circuit'),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (isName)
                                        ? (BuildContext context) =>
                                            _GetMaxNumberPopup(context)
                                        : (BuildContext context) =>
                                            _GetMaxNumberPopup(context));
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

  Widget _GetMaxNumberPopup(BuildContext context) {
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
}
