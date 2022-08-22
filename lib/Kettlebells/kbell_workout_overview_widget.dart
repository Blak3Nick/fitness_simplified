import 'package:fitness_simplified/models.dart';
import 'package:flutter/material.dart';

class ScrollableKettlebellWidget extends StatelessWidget {
  final KettleBellWorkout kettleBellWorkout;
  const ScrollableKettlebellWidget({Key? key, required this.kettleBellWorkout})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        itemBuilder: (BuildContext context, int index) {
          return KettlebellWorkoutDetailWidget(
            title: "Overview",
            work_rest: kettleBellWorkout.groups[index].work_rest,
          );
        },
        itemCount: kettleBellWorkout.groups.length);
  }
}

class KettlebellWorkoutDetailWidget extends StatelessWidget {
  final String title;
  final List<String> work_rest;
  const KettlebellWorkoutDetailWidget(
      {required this.title, required this.work_rest});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(work_rest.toString()),
      ),
    );
  }
}
