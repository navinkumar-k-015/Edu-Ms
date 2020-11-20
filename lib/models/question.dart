import 'package:hive/hive.dart';

part 'question.g.dart';

@HiveType(typeId: 2)
class Question {
  @HiveField(0)
  String question;
  @HiveField(1)
  String option1;
  @HiveField(2)
  String option2;
  @HiveField(3)
  String option3;
  @HiveField(4)
  String option4;
  @HiveField(5)
  int correct;
  Question(this.question, this.option1, this.option2, this.option3,
      this.option4, this.correct);
}
