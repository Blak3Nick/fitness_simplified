import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class KettlebellReactiveForm extends StatefulWidget {
  const KettlebellReactiveForm({Key? key}) : super(key: key);
  @override
  _ReactiveFormState createState() => _ReactiveFormState();
}

class _ReactiveFormState extends State<KettlebellReactiveForm> {
  int circuitIndex = 1;
  List<int> allCircuits = [];
  int circuitTracker = 0;
  UniqueKey redrawObject = UniqueKey();
  Map<int, Widget> circuitCards = {};
  TextEditingController textEditingController = TextEditingController();
  final form = FormGroup({
    'workoutName': FormControl<String>(validators: [Validators.required]),
  });
  Map<String, ReactiveTextField> circuitMaps = {};
  List<int> currentCircuits = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Create Kettlebell Workout'),
      ),
      body: mainForm(),
    );
  }

  mainForm() {
    return ReactiveForm(
        formGroup: form,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                ReactiveTextField(
                  formControlName: 'workoutName',
                  decoration: const InputDecoration(
                    labelText: 'Workout Name',
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueGrey, width: 5.0),
                    ),
                  ),
                ),
                Padding(
                  key: redrawObject,
                  padding: const EdgeInsets.all(10),
                  child: newCircuit(context, 2),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      circuitIndex += 1;
                      circuitTracker++;
                      redrawObject = UniqueKey();
                    });
                  },
                  child: const Text('Add A Circuit'),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                    ),
                  ),
                ),
                if (circuitIndex > 1)
                  FloatingActionButton.extended(
                    onPressed: () {
                      setState(() {
                        if (circuitCards.length > 1) {
                          circuitIndex--;
                          circuitCards.remove(circuitIndex);
                          currentCircuits.removeLast();
                          circuitTracker--;
                        }
                        redrawObject = UniqueKey();
                      });
                    },
                    label: const Text('Delete Last Circuit'),
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    backgroundColor: Colors.grey,
                  )
              ],
            ),
          ),
        ));
  }

  Widget newCircuit(BuildContext context, int localIndex) {
    currentCircuits.add(2);
    bool addButton = false;

    for (int i = 0; i < circuitIndex; i++) {
      if (i == circuitIndex - 1) {
        addButton = true;
      }
      circuitCards.putIfAbsent(i, () => circuitInterior(localIndex, addButton));
    }

    return ListView.separated(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemBuilder: (context, index) {
          return Column(
            children: [
              Row(
                children: [Flexible(child: circuitCards[index] as Widget)],
              )
            ],
          );
        },
        separatorBuilder: (context, index) => const Divider(),
        itemCount: circuitIndex);
  }

  Widget circuitInterior(int localIndex, bool addButton) {
    List<String> allExNames = [];
    List<String> allExTimes = [];
    int maxCircuits = currentCircuits[circuitTracker];
    developer.log(' Max circuits:  $maxCircuits');
    for (int i = 1; i <= maxCircuits; i++) {
      String exName = 'C$circuitIndex' 'ex$i';
      String exTime = 'C$circuitIndex' 'ex$i' 'time';
      allExNames.add(exName);
      allExTimes.add(exTime);
      form.addAll({
        exName: FormControl<String>(validators: [Validators.required])
      });

      form.addAll({
        exTime: FormControl<String>(validators: [Validators.required])
      });
    }
    final int thisTracker = circuitTracker;
    allCircuits.add(localIndex);
    int itemCount = maxCircuits ~/ 2;
    UniqueKey buttonKey = UniqueKey();
    return Card(
        child: ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Column(children: [
          Row(children: [
            Flexible(
              child: getReactiveTextField(
                  allExNames[index], 'Exercise', TextInputType.text),
            ),
            Flexible(
              child: getReactiveTextField(
                  allExTimes[index], 'Time', TextInputType.number),
            ),
          ]),
          Row(
            children: [
              Flexible(
                  child: getReactiveTextField(
                      allExTimes[index + 1], 'Exercise', TextInputType.text)),
              Flexible(
                child: getReactiveTextField(
                    allExTimes[index + 1], 'Time', TextInputType.number),
              ),
            ],
          ),
          if (itemCount == index + 1 && addButton == true)
            Row(
              children: [
                IconButton(
                    icon: const Icon(Icons.add, color: Colors.deepPurple),
                    onPressed: () {
                      setState(() {
                        currentCircuits[thisTracker] += 2;

                        circuitCards[thisTracker] =
                            circuitInterior(2, addButton);
                        buttonKey = UniqueKey();
                      });
                    }),
                IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        currentCircuits[thisTracker] -= 2;
                        circuitCards[thisTracker] =
                            circuitInterior(2, addButton);
                        buttonKey = UniqueKey();
                      });
                    }),
              ],
            )
        ]);
      },
      itemCount: itemCount,
    ));
  }

  ReactiveTextField getReactiveTextField(
      String formName, String label, TextInputType type) {
    // if (circuitMaps.containsKey(formName)) {
    //   return circuitMaps[formName] as ReactiveTextField;
    // }

    ReactiveTextField textField = ReactiveTextField(
      formControlName: formName,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey, width: 5.0),
        ),
      ),
    );
    circuitMaps.putIfAbsent(formName, () => textField);
    return textField;
  }

  void updateTextFields() {}
}
