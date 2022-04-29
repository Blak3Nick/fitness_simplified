import 'dart:async';
import 'dart:io';
import 'package:fitness_simplified/services/firestore.dart';
import 'package:flutter/cupertino.dart';
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
   int seconds = 10;
   int maxSeconds = 60;
   int maxGroups = 0;
   int workRestMax = 1;
   int currentWorkRestNum = 0;
   int currentGroupNum = 0;
   Future<KettleBellWorkout>? databaseFuture;
   KettleBellWorkout? kettleBellWorkout;
   bool firstPass = true;
   String currentExerciseName = '';
   String nextExerciseName = '';
   @override
   void didChangeDependencies() {
     super.didChangeDependencies();
     var arg = ModalRoute.of(context)?.settings.arguments as Map;
     String id = arg['id'];
     databaseFuture = FirestoreService().getKWorkout(id);
   }

   void startTimer() {
     const oneSec = Duration(seconds: 1);
     timer = Timer.periodic(
       oneSec, (Timer timer) {
         if (seconds == 0) {
           setState(() {
             assignSeconds();
             assignExName();
           });
         } else {
           setState(() {
             seconds--; });
         }
       },
     );
   }

   @override
   void dispose() {
     timer?.cancel();
     super.dispose();
   }
   Widget startButton(KettleBellWorkout kettleBellWorkout ) {
     final isRunning = timer == null ? false : timer!.isActive;
     return isRunning
      ? IconButton(onPressed: () {
        stopTimer(reset: false);
    }, icon: isRunning ? const Icon(Icons.pause_circle_filled, color: Colors.deepPurple,)
        :const Icon(Icons.play_circle, color: Colors.deepPurple,),
      iconSize: 78.0,
    )
      : Column(
      children:
      <Widget>[
          IconButton(onPressed: () {
            startTimer();
          }, icon: const Icon(Icons.play_circle, color: Colors.deepPurple,),
            tooltip: 'Start Workout',
            iconSize: 78.0,
          ),
          const Text('Start Workout')
        ],
    );
  }

   Widget buildTime(){
     return SafeArea(
        minimum: const EdgeInsets.only(top: 15, bottom: 15),
       child: SizedBox(
         width: 150,
         height: 150,
         child: Stack(
           fit: StackFit.expand,
           children: [
             CircularProgressIndicator(
               value: seconds / maxSeconds,
               strokeWidth: 18,
               color: Colors.pinkAccent,

             ),
             Center(
               child: Text('$seconds',
                 style: const TextStyle(
                   fontWeight: FontWeight.bold,
                   color: Colors.white,
                   fontSize: 80,
                 ),
               ),
             ),
           ],
         ),
       ),
     );
   }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<KettleBellWorkout>(
      future: databaseFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return Center(
            child: ErrorMessage(message: snapshot.error.toString()),
          );
        } else if (snapshot.hasData) {
          kettleBellWorkout ??= snapshot.data!;
          //int startingMax = kettlebellworkout.groups[0].work_duration;
          if(kettleBellWorkout != null && firstPass == true){
            maxGroups =  kettleBellWorkout?.groups.length! as int;
            seconds = kettleBellWorkout?.groups[0].work_duration as int;
            workRestMax = kettleBellWorkout?.groups[0].work_rest.length as int;
            assignExName();
            firstPass = false;
          }
          return SafeArea(
            child: Scaffold(
            appBar: AppBar(
              title: const Text('Workout'),
              backgroundColor: Colors.deepPurple,

            ),
              body: Center(
                child: Column (
                      children: [
                        Text(currentExerciseName,
                        style: const TextStyle(fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 80),
                        ),
                        buildTime(),
                        startButton(kettleBellWorkout!),
                        const Text('Next Exercise',
                          style: TextStyle(fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 40),
                        ),
                        Text(nextExerciseName,
                            style: const TextStyle(fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 40),
                        ),
                      ],
                ),
              )


            ),
          );
        } else {
          return const Text('No workouts found. Contact Support');
        }
      },
    );
  }
void assignExName(){
     currentExerciseName = kettleBellWorkout?.groups[currentGroupNum].work_rest[currentWorkRestNum] as String;
     if (currentWorkRestNum < workRestMax){
       nextExerciseName = kettleBellWorkout?.groups[currentGroupNum].work_rest[currentWorkRestNum+1] as String;
     }

}

  void stopTimer({bool reset = true}) {
     if (reset) {

     }
      setState(() => timer?.cancel());
  }

  void assignSeconds() {
     if(currentWorkRestNum % 2 == 0 ) {
       seconds = kettleBellWorkout?.groups[currentGroupNum].work_duration as int;
     }
     else {
       seconds = kettleBellWorkout?.groups[currentGroupNum].rest_duration as int;
     }
     currentWorkRestNum++;
     maxSeconds = seconds;
     if (kettleBellWorkout?.groups[currentGroupNum].work_rest.length as int < currentWorkRestNum) {
       currentWorkRestNum = 0;
       currentGroupNum++;
       if (currentGroupNum > maxGroups){
         ///TO DO end workout
         developer.log('ended workout');
       }
     }
  }

}











