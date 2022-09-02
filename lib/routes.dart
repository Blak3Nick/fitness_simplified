
import 'package:fitness_simplified/Kettlebells/begin_kbell_workout.dart';
import 'package:fitness_simplified/Kettlebells/create_kettlebell_workout.dart';
import 'package:fitness_simplified/Kettlebells/kettlebell_workout_ended.dart';
import 'package:fitness_simplified/Kettlebells/kettlebell_workouts.dart';
import 'package:fitness_simplified/home/home.dart';
import 'package:fitness_simplified/profile/profile.dart';

import 'Kettlebells/user_kettlebell_workouts.dart';
import 'about/about.dart';
import 'login/login.dart';



var appRoutes = {
  '/': (context) => const HomeScreen(),
  '/login': (context) => const LoginScreen(),
  '/profile': (context) => const ProfileScreen(),
  '/about': (context) => const AboutScreen(),
  '/kettlebellworkouts': (context) => const KettleBellWorkoutsScreen(),
  '/userkettlebellworkouts': (context) => const UserKettleBellWorkoutsScreen(),
  '/beginKworkout': (context) =>  const BeginKettlebellWorkout(),
  '/endKettlebellWorkout': (context) => const KettleBellEndedScreen(),
  '/createKettlebellWorkout' : (context) => const CreateKettleBellWorkout(),
};