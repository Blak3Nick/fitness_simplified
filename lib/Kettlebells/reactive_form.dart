
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';


class KettlebellReactiveForm extends StatefulWidget {

  const KettlebellReactiveForm({Key? key}) : super(key: key);
  @override
  _ReactiveFormState createState() => _ReactiveFormState();


}

class _ReactiveFormState extends State<KettlebellReactiveForm> {
  int circuitIndex = 0;
  List<int> allCircuits = [];
  int circuitTracker = 0;
  UniqueKey redrawObject = UniqueKey();
  Map<int, Widget> circuitCards= {};
  TextEditingController textEditingController = TextEditingController();
  final form = FormGroup({
    'workoutName': FormControl<String>(validators: [Validators.required]),
  });
  Map<String, ReactiveTextField> circuitMaps = {};




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

    return ReactiveForm(formGroup: form,
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
                    borderSide: BorderSide(color: Colors.blueGrey, width: 5.0),
                  ),
                ),
              ),
              Padding(
                key: redrawObject,
                  padding: const EdgeInsets.all(10),
                  child: newCircuit(context, circuitIndex),
              ),
              TextButton(onPressed: (){
                setState(() {
                    circuitIndex += 1;
                    redrawObject = UniqueKey();
                });

              }, child: const Text('Add A Circuit'),
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                ),
              ),)
            ],
          ),
        ),
    ));
  }

Widget newCircuit(BuildContext context, int localIndex) {
  String circuitLabel = 'Circuit $localIndex';
  for(int i =0; i < circuitIndex; i ++) {
    circuitCards.putIfAbsent(i, () => circuitInterior(localIndex));
    developer.log('this is the i value $i');

  }

    return  ListView.separated(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemBuilder: (context, index) {
        return Column(
          children: [
            Row(
              children: [
                Flexible(child: circuitCards[index] as Widget)
              ],
            )
          ],
        );
    },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: circuitIndex);
}

Widget circuitInterior(int localIndex) {
    developer.log('the local index at time of creation is $localIndex');
    String ex1Name = 'C$circuitIndex' 'ex1';
    String ex1Time = 'c$circuitIndex' 'ex1Time';
    String ex2Name = 'C$circuitIndex' 'ex2';
    String ex2Time = 'c$circuitIndex' 'ex2Time';
    form.addAll({ex1Name: FormControl<String>(validators: [Validators.required])} );
    form.addAll({ex1Time: FormControl<String>(validators: [Validators.required])} );
    form.addAll({ex2Name: FormControl<String>(validators: [Validators.required])} );
    form.addAll({ex2Time: FormControl<String>(validators: [Validators.required])} );
    allCircuits.add(localIndex);
    UniqueKey buttonKey = UniqueKey();
    return  Card(
            child: Column(
                children: [
                  Row(
                      children: [
                        Flexible(
                          child: getReactiveTextField(ex1Name, 'First Exercise', TextInputType.text),
                        ),
                        Flexible(
                          child: ReactiveTextField(
                            formControlName: ex1Time,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Duration',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blueGrey, width: 5.0),
                              ),
                            ),
                          ),
                        ),

                      ]),
                  Row(
                    children: [
                      Flexible(
                        child: ReactiveTextField(
                          formControlName: ex2Name,
                          decoration: const InputDecoration(
                            labelText: 'Second Exercise',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey, width: 5.0),
                            ),
                          ),
                        ),
                      ),

                      Flexible(
                        child: ReactiveTextField(
                          formControlName: ex2Time,
                          keyboardType: TextInputType.number,

                          decoration: const InputDecoration(
                            labelText: 'Duration',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey, width: 5.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: (){
                        setState(() {
                          circuitIndex--;
                          developer.log('the local index is $localIndex');
                          developer.log('the circuit index is $circuitIndex');
                          circuitMaps.remove(ex1Name);
                          circuitMaps.remove(ex1Time);
                          circuitMaps.remove(ex2Name);
                          circuitMaps.remove(ex2Time);
                          developer.log(ex2Time + ' is the ex 2 name');
                          developer.log(circuitCards.remove(localIndex).toString());
                          developer.log(circuitCards.values.toString());
                          buttonKey = UniqueKey();
                        });

                      })
                ]),

    );
}

  ReactiveTextField getReactiveTextField(String formName, String label, TextInputType type) {
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
      developer.log(textField.runtimeType.toString());
      return textField;

}

void updateTextFields(){

}

}




