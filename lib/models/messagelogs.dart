import 'package:hive/hive.dart';

part 'messagelogs.g.dart';

@HiveType(typeId: 4)
class MessageLog {
  @HiveField(0)
  String phoneNo;
  @HiveField(1)
  String message;
  @HiveField(2)
  bool senderOrrecever;

  MessageLog(this.message, this.phoneNo, this.senderOrrecever);
}
