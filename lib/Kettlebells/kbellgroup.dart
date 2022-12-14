import 'package:fitness_simplified/Kettlebells/begin_kbell_workout.dart';
import 'package:fitness_simplified/Kettlebells/kettlebell_workouts.dart';
import 'package:flutter/material.dart';


import '../models.dart';
import '../shared/progress_bar.dart';
import 'kbell_workout_overview_widget.dart';
import 'kettlebell_drawer.dart';

class KbellGroup extends StatelessWidget {
  final KettleBellWorkout kettleBellWorkout;
  const KbellGroup({ Key? key, required this.kettleBellWorkout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: Image.asset('assets/kbell.png'),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => KettleBellWorkoutScreen( kettleBellWorkout: kettleBellWorkout ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                child: Column(
                   children: [
                   Text(kettleBellWorkout.id,
                    style: const TextStyle(
                      height: 1.5,
                      fontWeight: FontWeight.bold,)),
                  //  SizedBox(
                  //   child: Image.asset(
                  //     'assets/kbell.png',
                  //     fit: BoxFit.scaleDown,
                  //   ),
                  // ),
                ]),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    "Total time: " + kettleBellWorkout.Total,
                    style: const TextStyle(
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ),
              ),
              //Flexible(child: TopicProgress(topic: topic)),
            ],
          ),
        ),
      ),
    );
  }
}

class KettleBellWorkoutScreen extends StatelessWidget {
  final KettleBellWorkout kettleBellWorkout;

  const KettleBellWorkoutScreen({Key? key,required this.kettleBellWorkout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(children: [
        ScrollableKettlebellWidget(kettleBellWorkout: kettleBellWorkout,),
        Text(
          kettleBellWorkout.id,
          style:
          const TextStyle(height: 2, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        //QuizList(topic: topic)
      ]),
    floatingActionButton: FloatingActionButton.extended(
      backgroundColor: Colors.deepPurple,
      onPressed: () {
      Navigator.pushNamed(context, '/beginKworkout', arguments: {'id': kettleBellWorkout.id });
    },
      icon: const Icon(Icons.fitness_center),
      label: const Text('Begin Workout'),

    ),

    );
  }
}