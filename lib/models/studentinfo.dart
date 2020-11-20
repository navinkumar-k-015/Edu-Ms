import 'package:hive/hive.dart';

part 'studentinfo.g.dart';

@HiveType(typeId: 1)
class Studentinfo{
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String phone_no;

  Studentinfo(this.name, this.phone_no);
  
}