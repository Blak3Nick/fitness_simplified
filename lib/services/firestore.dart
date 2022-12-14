import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../models.dart';
import 'auth.dart';
import 'dart:developer' as developer;

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Reads all documents from the topics collection
  Future<List<Topic>> getTopics() async {
    var ref = _db.collection('topics');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var topics = data.map((d) => Topic.fromJson(d));
    return topics.toList();
  }

  ///Reads all Kettlebell Workouts from the collection
  Future<List<KettleBellWorkout>> getKettlebellWorkouts() async {
    var ref = _db.collection('KettleBellWorkouts');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var kbell_workouts = data.map((d) => KettleBellWorkout.fromJson(d));
    developer.log(data.toString());
    return kbell_workouts.toList();
  }

  Future<KettleBellWorkout> getKWorkout(String kId) async {
    developer.log(kId);
    var ref = _db.collection('KettleBellWorkouts').doc(kId);
    var snapshot = await ref.get();
    //var data = snapshot.data()
    developer.log('printing kettlebell workout');
    developer.log(snapshot.data().toString());
    return KettleBellWorkout.fromJson(snapshot.data() ?? {});
  }

  /// Retrieves a single quiz document
  Future<Quiz> getQuiz(String quizId) async {
    var ref = _db.collection('quizzes').doc(quizId);
    var snapshot = await ref.get();
    developer.log('printing quiz');
    developer.log(snapshot.data().toString());
    return Quiz.fromJson(snapshot.data() ?? {});
  }

  /// Listens to current user's report document in Firestore
  Stream<Report> streamReport() {
    return AuthService().userStream.switchMap((user) {
      if (user != null) {
        var ref = _db.collection('reports').doc(user.uid);
        return ref.snapshots().map((doc) => Report.fromJson(doc.data()!));
      } else {
        return Stream.fromIterable([Report()]);
      }
    });
  }

  Future<List<KettleBellWorkout>> getUserKettlebellWorkouts() async {
    var user = AuthService().user!;
    var ref =
        _db.collection('users').doc(user.uid).collection('KettleBellWorkouts');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var kbell_workouts = data.map((d) => KettleBellWorkout.fromJson(d));
    developer.log(data.toString());
    return kbell_workouts.toList();
  }

  /// Updates the current user's report document after completing quiz
  Future<void> updateUserReport(Quiz quiz) {
    var user = AuthService().user!;
    var ref = _db.collection('reports').doc(user.uid);

    var data = {
      'total': FieldValue.increment(1),
      'topics': {
        quiz.topic: FieldValue.arrayUnion([quiz.id])
      }
    };

    return ref.set(data, SetOptions(merge: true));
  }

  /// Adds a workout to the main group
  Future<void> addNewKettlebellWorkout(List groups, String id) {
    //var user = AuthService().user!;
    var ref = _db.collection('KettleBellWorkouts').doc(id);
    var data = <String, dynamic>{};
    List myGroups = [];
    int totalDuration = 0;
    for (int i = 0; i < groups.length; i++) {
      Group group = groups[i] as Group;
      int tempDuration = 0;
      for (int duration in group.work_duration) {
        tempDuration += duration;
      }
      totalDuration += tempDuration * group.repeat;

      final nestedData = {
        'repeat': group.repeat,
        "rest_duration": group.rest_duration,
        "work_duration": group.work_duration,
        'work_rest': group.work_rest,
      };
      myGroups.add(nestedData);
    }
    totalDuration = (totalDuration / 60).ceil();
    data['Total'] = "~" + totalDuration.toString() + " min";
    data['id'] = id;
    data['groups'] = myGroups;

    return ref.set(data, SetOptions(merge: true));
  }

  Future<void> addNewUserKettlebellWorkout(List groups, String id) {
    var user = AuthService().user!;
    var ref = _db.collection('users').doc(user.uid).collection('KettleBellWorkouts').doc(id);
    var data = <String, dynamic>{};
    List myGroups = [];
    int totalDuration = 0;
    for (int i = 0; i < groups.length; i++) {
      Group group = groups[i] as Group;
      int tempDuration = 0;
      for (int duration in group.work_duration) {
        tempDuration += duration;
      }
      totalDuration += tempDuration * group.repeat;

      final nestedData = {
        'repeat': group.repeat,
        "rest_duration": group.rest_duration,
        "work_duration": group.work_duration,
        'work_rest': group.work_rest,
      };
      myGroups.add(nestedData);
    }
    totalDuration = (totalDuration / 60).ceil();
    data['Total'] = "~" + totalDuration.toString() + " min";
    data['id'] = id;
    data['groups'] = myGroups;

    return ref.set(data, SetOptions(merge: true));
  }



}
