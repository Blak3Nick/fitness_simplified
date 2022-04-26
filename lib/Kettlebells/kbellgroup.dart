import 'package:fitness_simplified/Kettlebells/kettlebell_workouts.dart';
import 'package:flutter/material.dart';


import '../models.dart';
import '../shared/progress_bar.dart';
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
                child: SizedBox(
                  child: Image.asset(
                    'assets/kbell.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    kettleBellWorkout.id,
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
        backgroundColor: Colors.transparent,
      ),
      body: ListView(children: [
        Hero(
          tag: 'assets/kbell.png',
          child: Image.asset('assets/kbell.png',
              width: MediaQuery.of(context).size.width),
        ),
        Text(
          kettleBellWorkout.id,
          style:
          const TextStyle(height: 2, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        //QuizList(topic: topic)
      ]),
    );
  }
}