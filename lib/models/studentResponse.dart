import 'package:hacksrm/models/question.dart';
import 'package:hive/hive.dart';

part 'studentResponse.g.dart';

@HiveType(typeId: 3)
class StudentResponse {
  @HiveField(0)
  String questionId;
  @HiveField(1)
  String optionSelected;
  @HiveField(2)
  bool result;

  StudentResponse(this.questionId, this.optionSelected, this.result);
}
