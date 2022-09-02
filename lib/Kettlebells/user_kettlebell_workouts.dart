import 'package:fitness_simplified/Kettlebells/kbellgroup.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models.dart';
import '../services/firestore.dart';
import '../shared/bottom_nav.dart';
import '../shared/error.dart';
import '../shared/loading.dart';


class UserKettleBellWorkoutsScreen extends StatelessWidget {
  const UserKettleBellWorkoutsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<KettleBellWorkout>>(
      future: FirestoreService().getUserKettlebellWorkouts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return Center(
            child: ErrorMessage(message: snapshot.error.toString()),
          );
        } else if (snapshot.hasData) {
          var kettlebellworkouts = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepPurple,
              title: const Text('Kettlebell Workouts'),
              actions: [
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.circleUser,
                    color: Colors.pink[200],
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/profile'),
                )
              ],
            ),
            body:  GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20.0),
              crossAxisSpacing: 10.0,
              crossAxisCount: 2,
              children: kettlebellworkouts.map<Widget>((kettlebellworkout) => KbellGroup(kettleBellWorkout: kettlebellworkout)).toList(),
            ),

            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, '/createKettlebellWorkout');
              },
              label: const Text('Add New Workout'),
              icon: const Icon(Icons.thumb_up),
              backgroundColor: Colors.pink,
            ),
            bottomNavigationBar: const BottomNavBar(),

          );
        } else {
          return const Text('No workouts found. Contact Support');
        }
      },
    );
  }

}