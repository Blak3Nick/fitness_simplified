
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';
part 'models.g.dart';

// ignore_for_file: public_member_api_docs

@Entity()
class Note {
  int id;

  String text;
  String? comment;

  /// Note: Stored in milliseconds without time zone info.
  DateTime date;

  Note(this.text, {this.id = 0, this.comment, DateTime? date})
      : date = date ?? DateTime.now();

  String get dateFormat => DateFormat('dd.MM.yyyy hh:mm:ss').format(date);
}

@Entity()
class KettlebellExercise {
  int id;
  String name;
  int workPeriod;
  int restPeriod;

  KettlebellExercise({this.id = 0, required this.name, this.restPeriod = 30, this.workPeriod = 30});


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