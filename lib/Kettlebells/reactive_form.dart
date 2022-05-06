
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
  final form = FormGroup({
    'workoutName': FormControl<String>(validators: [Validators.required]),
  });
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

Widget newCircuit(BuildContext context, int index) {
  String circuitLabel = 'Circuit $index';
    return  ListView.separated(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemBuilder: (context, index) {
        return Column(
          children: [
            Row(
              children: [
                Flexible(child: circuitInterior(circuitTracker++))
              ],
            )
          ],
        );
    },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: circuitIndex);
}

Widget circuitInterior(int index) {
    String ex1Name = 'C$index' ' ex1';
    String ex1Time = 'c$index' ' ex1Time';
    String ex2Name = 'C$index' ' ex2';
    String ex2Time = 'c$index' ' ex2Time';
    form.addAll({ex1Name: FormControl<String>(validators: [Validators.required])} );
    form.addAll({ex1Time: FormControl<String>(validators: [Validators.required])} );
    form.addAll({ex2Name: FormControl<String>(validators: [Validators.required])} );
    form.addAll({ex2Time: FormControl<String>(validators: [Validators.required])} );
    allCircuits.add(index);
    developer.log('Circuit index is:  $circuitIndex');
    UniqueKey buttonKey = UniqueKey();
    return
       Card(
         child: Column(
           children: [
             Row(
            children: [
              Flexible(
                child: ReactiveTextField(
                  formControlName: ex1Name,
                  decoration: const InputDecoration(
                    labelText: 'First Exercise',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueGrey, width: 5.0),
                    ),
                  ),
                ),
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
                  key: Key(index.toString()),
                 icon: const Icon(Icons.delete, color: Colors.redAccent),
                 onPressed: (){
                  setState(() {
                    developer.log('The key for the button is ');
                    circuitIndex--;
                    buttonKey = UniqueKey();
                  });

             })
         ]),
       );
}

}

class StatefulCircuit extends StatefulWidget {
  const StatefulCircuit({ Key? key }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}




