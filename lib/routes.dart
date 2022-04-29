
import 'package:fitness_simplified/Kettlebells/begin_kbell_workout.dart';
import 'package:fitness_simplified/Kettlebells/kettlebell_workouts.dart';
import 'package:fitness_simplified/home/home.dart';
import 'package:fitness_simplified/models.dart';
import 'package:fitness_simplified/profile/profile.dart';
import 'package:fitness_simplified/topics/topics.dart';

import 'about/about.dart';
import 'login/login.dart';



var appRoutes = {
  '/': (context) => const HomeScreen(),
  '/login': (context) => const LoginScreen(),
  '/topics': (context) => const TopicsScreen(),
  '/profile': (context) => const ProfileScreen(),
  '/about': (context) => const AboutScreen(),
  '/kettlebellworkouts': (context) => const KettleBellWorkoutsScreen(),
  'beginKworkout': (context) =>  const BeginKettlebellWorkout(),
};