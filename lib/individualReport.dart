import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hacksrm/models/question.dart';
import 'package:hacksrm/models/studentResponse.dart';
import 'package:hacksrm/top_bar.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sms/sms.dart';
import 'models/studentinfo.dart';

class IndividualReport extends StatefulWidget {
  final String studentlist;
  final String classroom;
  IndividualReport(this.studentlist, this.classroom);
  @override
  _IndividualReportState createState() => _IndividualReportState();
}

class _IndividualReportState extends State<IndividualReport> {
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var classroom = widget.classroom;
    Box<Question> questionBox = Hive.box<Question>(classroom + 'questionsSent');
    var total = questionBox.length;
    var correct = 0;
    var wrong = 0;
    Box<Studentinfo> student = Hive.box<Studentinfo>(widget.studentlist);
    return NeumorphicBackground(
      padding: EdgeInsets.all(8),
      child: Scaffold(
        key: _scaffoldkey,
        appBar: TopBar(
          title: "Individual Report",
        ),
        body: ValueListenableBuilder(
            valueListenable: student.listenable(),
            builder: (context, Box<Studentinfo> box, widget) {
              return ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  final studentinfo = box.getAt(index);
                  return ListTile(
                    title: Text(studentinfo.name),
                    subtitle: Text(studentinfo.phone_no),
                    onTap: () async {
                      await Hive.openBox<StudentResponse>(
                          studentinfo.phone_no + "-Responses");
                      var studentResponse = Hive.box<StudentResponse>(
                          studentinfo.phone_no + "-Responses");
                      correct = 0;
                      wrong = 0;
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Container(
                                width: width * .8,
                                height: height * .8,
                                child: Column(
                                  children: [
                                    Text(
                                      "Responses",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Divider(
                                      thickness: 2.0,
                                      color: Colors.blueAccent,
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable:
                                          studentResponse.listenable(),
                                      builder: (context,
                                          Box<StudentResponse> box, child) {
                                        return box.length == 0
                                            ? Text(
                                                'No Responses available!',
                                                style: TextStyle(
                                                    color: Colors.redAccent),
                                              )
                                            : ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: box.length,
                                                itemBuilder: (context, index) {
                                                  StudentResponse studentRes =
                                                      box.getAt(index);
                                                  studentRes.result
                                                      ? correct++
                                                      : wrong++;
                                                  Question _question =
                                                      questionBox.get(int.parse(
                                                          studentRes
                                                              .questionId));
                                                  return Column(
                                                    children: [
                                                      ListTile(
                                                        title: Text(
                                                          _question.question,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                        trailing: studentRes
                                                                .result
                                                            ? Icon(
                                                                Icons.check,
                                                                color: Colors
                                                                    .green,
                                                              )
                                                            : Icon(
                                                                Icons.close,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                      ),
                                                      Divider(
                                                        thickness: 0.5,
                                                        color: Colors.grey,
                                                      )
                                                    ],
                                                  );
                                                },
                                              );
                                      },
                                    ),
                                    RaisedButton(
                                      child: Text('Send Report'),
                                      onPressed: () {
                                        sendSMS(studentinfo.phone_no, total,
                                            correct + wrong, correct, wrong);
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                  );
                },
              );
            }),
      ),
    );
  }

  void sendSMS(
      String phoneNo, int total, int ans, int correct, int wrong) async {
    SmsSender sender = new SmsSender();
    String address = phoneNo;
    String msg = "----*Overall Report*----\n" +
        "Total Questions sent: " +
        total.toString() +
        "\nTotal Questions answered: " +
        ans.toString() +
        "\nNum. of correct answers: " +
        correct.toString() +
        "\nNum. of wrong answers: " +
        wrong.toString() +
        "\nAverage: " +
        (correct / total * 100).toString();
    SmsMessage message = new SmsMessage(address, msg);
    sender.sendSms(message);
    message.onStateChanged.listen(
      (state) {
        if (state == SmsMessageState.Sent) {
          print("SMS is sent!");
        } else if (state == SmsMessageState.Delivered) {
          print("SMS is delivered!");
          _scaffoldkey.currentState.showSnackBar(
              SnackBar(content: Text("Message dilivered to $address")));
        } else if (state == SmsMessageState.Fail) {
          _scaffoldkey.currentState.showSnackBar(
              SnackBar(content: Text("Message not dilivered to $address")));
        }
      },
    );
  }
}
