import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';
part 'models.g.dart';

// ignore_for_file: public_member_api_docs

@Entity()
class KettlebellExercise {
  int id;
  String name;
  int workPeriod;
  int restPeriod;
  KettlebellExercise(
      {this.id = 0,
      required this.name,
      this.restPeriod = 30,
      this.workPeriod = 30});
}

@JsonSerializable()
class Group {
  int repeat;
  List<int> work_duration;
  int rest_duration;
  List<String> work_rest;

  Group(
      {this.repeat = 1,
      this.work_duration = const [],
      this.rest_duration = 1,
      this.work_rest = const []});
  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
  Map<String, dynamic> toJson() => _$GroupToJson(this);
}

@JsonSerializable()
class KettleBellWorkout {
  List<Group> groups;
  String id;
  String Total;
  KettleBellWorkout({this.groups = const [], this.id = '', this.Total = ''});
  factory KettleBellWorkout.fromJson(Map<String, dynamic> json) =>
      _$KettleBellWorkoutFromJson(json);
  Map<String, dynamic> toJson() => _$KettleBellWorkoutToJson(this);
}

//quiz
@JsonSerializable()
class Option {
  String value;
  String detail;
  bool correct;
  Option({this.value = '', this.detail = '', this.correct = false});
  factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);
  Map<String, dynamic> toJson() => _$OptionToJson(this);
}

@JsonSerializable()
class Question {
  String text;
  List<Option> options;
  Question({this.options = const [], this.text = ''});
  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}

@JsonSerializable()
class Quiz {
  String id;
  String title;
  String description;
  String video;
  String topic;
  List<Question> questions;

  Quiz(
      {this.title = '',
      this.video = '',
      this.description = '',
      this.id = '',
      this.topic = '',
      this.questions = const []});
  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);
  Map<String, dynamic> toJson() => _$QuizToJson(this);
}

@JsonSerializable()
class Topic {
  late final String id;
  final String title;
  final String description;
  final String img;
  final List<Quiz> quizzes;

  Topic(
      {this.id = '',
      this.title = '',
      this.description = '',
      this.img = 'default.png',
      this.quizzes = const []});

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
  Map<String, dynamic> toJson() => _$TopicToJson(this);
}

@JsonSerializable()
class Report {
  String uid;
  int total;
  Map topics;

  Report({this.uid = '', this.topics = const {}, this.total = 0});
  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
  Map<String, dynamic> toJson() => _$ReportToJson(this);
}

@JsonSerializable()
class WorkoutSet {
  String exerciseName;
  int weightUsed;
  double weightFactor;
  List repScheme;
  int reps;

  WorkoutSet(
      {this.exerciseName = '',
      this.weightUsed = 0,
      this.weightFactor = 0.0,
      this.repScheme = const [],
      this.reps = 0});
  factory WorkoutSet.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSetFromJson(json);
  Map<String, dynamic> toJson() => _$WorkoutSetToJson(this);
}
