import 'dart:async';
import 'dart:io';
import 'package:fitness_simplified/services/firestore.dart';
import 'package:flutter/material.dart';
import '../services/firestore.dart';
import '../models.dart';
import '../shared/error.dart';
import '../shared/loading.dart';
import 'dart:developer' as developer;

class BeginKettlebellWorkout extends StatefulWidget {
  final int mainIndex = 0;
  const BeginKettlebellWorkout({Key? key }) : super(key: key);
  @override
  _BeginKettlebellWorkoutState createState() => _BeginKettlebellWorkoutState();

}

class _BeginKettlebellWorkoutState extends State<BeginKettlebellWorkout> {
///TO DO fix main index double reference
   int mainIndex = 0;
  _BeginKettlebellWorkoutState();
  Timer? timer;

  Widget startButton(KettleBellWorkout kettleBellWorkout, int index) {
      void initializeTimer(int index){
        if(index %2 == 0){

        }
        developer.log(kettleBellWorkout.groups.toString());
        int timerMax = kettleBellWorkout.groups[index].work_duration;
        int seconds = timerMax;
        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() => seconds--);
        });
      }
    return Column(
      children:
        <Widget>[
          IconButton(onPressed: () {
            initializeTimer(index);
          }, icon: const Icon(Icons.play_circle, color: Colors.deepPurple,),
            tooltip: 'Start Workout',
            iconSize: 58.0,

          ),
          const Text('Start Workout')
        ],


    );
  }
  

  @override
  Widget build(BuildContext context) {

    var arg = ModalRoute.of(context)?.settings.arguments as Map;
    String id = arg['id'];
    developer.log('Debugging.....');
    return FutureBuilder<KettleBellWorkout>(
      future: FirestoreService().getKWorkout(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return Center(
            child: ErrorMessage(message: snapshot.error.toString()),
          );
        } else if (snapshot.hasData) {
          var kettlebellworkout = snapshot.data!;
          developer.log(mainIndex.toString());
          developer.log('This is a debugging line...............');
          developer.log(kettlebellworkout.groups.length.toString());

          return Scaffold(
          appBar: AppBar(
            title: const Text('Workout'),
            backgroundColor: Colors.deepPurple,
          ),
            body: Center(

              child: startButton(kettlebellworkout, mainIndex++),
            ),
          );
        } else {
          return const Text('No workouts found. Contact Support');
        }
      },
    );
  }
}











