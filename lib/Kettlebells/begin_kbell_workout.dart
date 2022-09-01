import 'dart:async';
import 'package:fitness_simplified/services/firestore.dart';
import 'package:flutter/material.dart';
import '../services/firestore.dart';
import '../models.dart';
import '../shared/error.dart';
import '../shared/loading.dart';
import 'dart:developer' as developer;

class BeginKettlebellWorkout extends StatefulWidget {
  final int mainIndex = 0;
  const BeginKettlebellWorkout({Key? key}) : super(key: key);
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
  int exerciseTracker = 0;
  List<String> allExercises = [];
  List<int> allTimes = [];
  final String workoutOver = 'Workout Over';
  Future<KettleBellWorkout>? databaseFuture;
  KettleBellWorkout? kettleBellWorkout;
  bool firstPass = true;
  String currentExerciseName = '';
  String nextExerciseName = '';
  int currentRepeat = 1;
  int timesTracker = 0;
  bool lastExercise = true;
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
      oneSec,
      (Timer timer) {
        if (seconds == 0) {
          setState(() {
            assignSeconds();
            assignExName();
          });
        } else {
          setState(() {
            seconds--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget startButton(KettleBellWorkout kettleBellWorkout) {
    final isRunning = timer == null ? false : timer!.isActive;
    return isRunning
        ? IconButton(
            onPressed: () {
              stopTimer(reset: false);
            },
            icon: isRunning
                ? const Icon(
                    Icons.pause_circle_filled,
                    color: Colors.deepPurple,
                  )
                : const Icon(
                    Icons.play_circle,
                    color: Colors.deepPurple,
                  ),
            iconSize: 78.0,
          )
        : Column(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  startTimer();
                },
                icon: const Icon(
                  Icons.play_circle,
                  color: Colors.deepPurple,
                ),
                tooltip: 'Start Workout',
                iconSize: 78.0,
              ),
              const Text('Start Workout')
            ],
          );
  }

  Widget buildTime() {
    return SafeArea(
      minimum: const EdgeInsets.only(top: 15, bottom: 15),
      child: SizedBox(
        width: 150,
        height: 150,
        child: Stack(
          fit: StackFit.expand,
          children: [
            lastExercise
                ? CircularProgressIndicator(
                    value: seconds / maxSeconds,
                    strokeWidth: 18,
                    color: Colors.pinkAccent,
                  )
                : const Text(''),
            Center(
              child: Text(
                '$seconds',
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
          if (kettleBellWorkout != null && firstPass == true) {
            maxGroups = kettleBellWorkout?.groups.length as int;
            seconds = kettleBellWorkout?.groups[0].work_duration[0] as int;
            workRestMax = kettleBellWorkout?.groups[0].work_rest.length as int;
            setExerciseData();
            assignExName();
            assignSeconds();
            firstPass = false;
          }
          return SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  title: const Text('Workout'),
                  backgroundColor: Colors.deepPurple,
                ),
                body: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            currentExerciseName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 80),
                          ),
                        ),
                        buildTime(),
                        startButton(kettleBellWorkout!),
                        const Text(
                          'Next Exercise',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 40),
                        ),
                        nextExercise(),
                      ],
                    ),
                  ),
                )),
          );
        } else {
          return const Text('No workouts found. Contact Support');
        }
      },
    );
  }

  void assignExName() {
    currentExerciseName = allExercises[exerciseTracker];
    try {
      nextExerciseName = allExercises[exerciseTracker + 1];
    } catch (e) {
      developer.log('last exercise');
    }
    developer.log('Assigning exercise' + currentExerciseName);
    exerciseTracker++;
    developer.log(exerciseTracker.toString());
  }

  void stopTimer({bool reset = true}) {
    if (reset) {}
    setState(() => timer?.cancel());
  }

  void assignSeconds() {
    try {
      seconds = allTimes[timesTracker];
    } on RangeError {
      lastExercise = false;
      developer.log('end workout');
      Navigator.pushNamedAndRemoveUntil(
          context, '/endKettlebellWorkout', (_) => false);
    }
    maxSeconds = seconds;
    timesTracker++;
  }

  void setExerciseData() {
    int numGroups = kettleBellWorkout?.groups.length as int;
    for (int i = 0; i < numGroups; i++) {
      int repeat = kettleBellWorkout?.groups[i].repeat as int;
      List<String> workRest =
          kettleBellWorkout?.groups[i].work_rest as List<String>;
      int timeFactor = (workRest.length ~/ 2);
      developer.log('This is the time factor ' + timeFactor.toString());
      List<int> times = kettleBellWorkout?.groups[i].work_duration as List<int>;
      // int workTime = kettleBellWorkout?.groups[i].work_duration as int;
      // int restTime = kettleBellWorkout?.groups[i].rest_duration as int;
      // times.add(workTime);
      // times.add(restTime);
      for (int j = 0; j < repeat; j++) {
        allExercises.addAll(workRest);
        for (int k = 0; k < workRest.length; k++) {
          allTimes.addAll(times);
        }
      }
    }
    allExercises.add(workoutOver);
    developer.log('All the exercises');
    developer.log(allExercises.toString());
    developer.log('All the times');
    developer.log(allTimes.toString());
  }

  Widget nextExercise() {
    return SizedBox(
        width: MediaQuery.of(context).size.width - 30,
        height: 100,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Column(
            children: [
              Text(
                nextExerciseName,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 28),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () {
                    assignSeconds();
                    assignExName();
                  },
                  icon: const Icon(
                    Icons.skip_next,
                    color: Colors.lightBlue,
                  ),
                  tooltip: 'Skip',
                  iconSize: 38.0,
                ),
              ),
            ],
          ),
        ));
  }
}
