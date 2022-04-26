import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../models.dart';
import '../quiz/quiz.dart';


class KettleBellWorkoutDrawer extends StatelessWidget {
  final List<KettleBellWorkout> kbellworkouts;
  const KettleBellWorkoutDrawer({ Key? key, required this.kbellworkouts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.separated(
          shrinkWrap: true,
          itemCount: kbellworkouts.length,
          itemBuilder: (BuildContext context, int idx) {
            KettleBellWorkout kbellworkout = kbellworkouts[idx];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: Text(
                    kbellworkout.id,
                    // textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ),
                KWorkoutList(kettlebellworkout: kbellworkout)
              ],
            );
          },
          separatorBuilder: (BuildContext context, int idx) => const Divider()),
    );
  }
}

class KWorkoutList extends StatelessWidget {
  final KettleBellWorkout kettlebellworkout;
  const KWorkoutList({Key? key, required this.kettlebellworkout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: kettlebellworkout.groups.map(
            (group) {
          return Card(
            shape:
            const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            elevation: 4,
            margin: const EdgeInsets.all(4),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        QuizScreen(quizId: group.title),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(
                    group.title,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  subtitle: Text(
                    group.title,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  //leading: QuizBadge(topic: kettlebellworkout, quizId: quiz.id),
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}

class QuizBadge extends StatelessWidget {
  final String quizId;
  final Topic topic;

  const QuizBadge({Key? key, required this.quizId, required this.topic})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Report report = Provider.of<Report>(context);
    List completed = report.topics[topic.id] ?? [];
    if (completed.contains(quizId)) {
      return const Icon(FontAwesomeIcons.checkDouble, color: Colors.green);
    } else {
      return const Icon(FontAwesomeIcons.solidCircle, color: Colors.grey);
    }
  }
}