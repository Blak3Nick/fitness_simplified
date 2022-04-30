
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';

import '../Kettlebells/kettlebell_workouts.dart';
import '../login/login.dart';
import '../services/auth.dart';
import '../shared/error.dart';
import '../shared/loading.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return const Center(
            child: ErrorMessage(),
          );
        } else if (snapshot.hasData) {
          return const KettleBellWorkoutsScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
