import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hacksrm/make_questions.dart';
import 'package:hacksrm/models/question.dart';
import 'package:hacksrm/models/studentinfo.dart';
import 'package:sms/sms.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LiveClass extends StatefulWidget {
  final String classname;
  LiveClass(this.classname);
  @override
  _LiveClassState createState() => _LiveClassState();
}

class _LiveClassState extends State<LiveClass> {
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  SmsReceiver receiver = new SmsReceiver();
  StreamSubscription<SmsMessage> willitwork;
  @override
  void initState() {
    print("init");
    willitwork = receiver.onSmsReceived.listen((SmsMessage msg) async {
      print(msg.body);
      String message = msg.body.trim();
      String phoneNo = msg.address;
      await Hive.openBox(phoneNo);
      if (message[0] == '.') {
        if (message.startsWith('.help')) {
        } else {
          try {
            int qId = int.parse(message.substring(1, message.indexOf(' ')));
            int op = int.parse(
                message.substring(message.length - 1, message.length));
            await Hive.openBox<bool>(widget.classname + qId.toString());
            if (Hive.box<bool>(widget.classname + qId.toString())
                    .get(phoneNo) ==
                null) {
              Question ques =
                  Hive.box<Question>(widget.classname + "questionsSent")
                      .get(qId);
              if (ques.correct == (op - 1)) {
                print(phoneNo + "correct");
                Hive.box<bool>(widget.classname + qId.toString())
                    .put(phoneNo, true);
              } else {
                Hive.box<bool>(widget.classname + qId.toString())
                    .put(phoneNo, false);
                print(phoneNo + "u r wrong");
              }
            } else {
              print("cheater");
            }
          } catch (e) {
            print(e.toString());
          }
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldkey,
        drawer: Drawer(),
        endDrawer: Container(
            width: width * .95,
            child: Drawer(
              child: ValueListenableBuilder(
                valueListenable:
                    Hive.box<Question>(widget.classname + 'questions')
                        .listenable(),
                builder: (context, Box<Question> box, widgets) {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: box.length,
                          itemBuilder: (context, index) {
                            Question _qus = box.getAt(index);
                            return ListTile(
                              title: Text(_qus.question),
                              onLongPress: () {
                                box.deleteAt(index);
                              },
                              onTap: () => sendSMS(
                                  "${_qus.question}\n\n1) ${_qus.option1}\n2) ${_qus.option2}\n3) ${_qus.option3}\n4) ${_qus.option4}",
                                  box.keyAt(index),
                                  _qus),
                            );
                          },
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MakeQuestions(widget.classname),
                                ),
                              );
                            },
                            child: Text(
                              "Add a Question",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            )),
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.question_answer_outlined),
              onPressed: () => _scaffoldkey.currentState.openEndDrawer(),
            )
          ],
        ),
      ),
    );
  }

  void sendSMS(String messageEntered, int qId, Question qus) async {
    messageEntered = "Question ID : $qId\n" + messageEntered;
    Box<Studentinfo> studentbox =
        Hive.box<Studentinfo>(widget.classname + "-StudentList");
    for (var i = 0; i < studentbox.length; i++) {
      Studentinfo _studentinfo = studentbox.getAt(i);
      SmsSender sender = new SmsSender();
      String address = _studentinfo.phone_no;
      SmsMessage message = new SmsMessage(address, messageEntered);
      sender.sendSms(message);
      message.onStateChanged.listen(
        (state) {
          if (state == SmsMessageState.Sent) {
            print("SMS is sent!");
          } else if (state == SmsMessageState.Delivered) {
            print("SMS is delivered!");
          }
        },
      );
    }
    Hive.box<Question>(widget.classname + "questionsSent").put(qId, qus);
    Hive.box<Question>(widget.classname + 'questions').delete(qId);
  }

  @override
  void dispose() {
    print("object");
    willitwork.cancel();
    super.dispose();
  }
}

// StreamSubscription<SmsMessage> willitwork = receiver.onSmsReceived.listen((SmsMessage msg) async {
//       print(msg.body);
//       String message = msg.body.trim();
//       String phoneNo = msg.address;
//       await Hive.openBox(phoneNo);
//       if (message[0] == '.') {
//         if (message.startsWith('.help')) {
//         } else {
//           try {
//             int qId = int.parse(message.substring(1, message.indexOf(' ')));
//             int op = int.parse(
//                 message.substring(message.length - 1, message.length));
//             await Hive.openBox<bool>(widget.classname + qId.toString());
//             if (Hive.box<bool>(widget.classname + qId.toString())
//                     .get(phoneNo) ==
//                 null) {
//               Question ques =
//                   Hive.box<Question>(widget.classname + "questionsSent")
//                       .get(qId);
//               if (ques.correct == (op - 1)) {
//                 print(phoneNo + "correct");
//                 Hive.box<bool>(widget.classname + qId.toString())
//                     .put(phoneNo, true);
//               } else {
//                 Hive.box<bool>(widget.classname + qId.toString())
//                     .put(phoneNo, false);
//                 print(phoneNo + "u r wrong");
//               }
//             } else {
//               print("cheater");
//             }
//           } catch (e) {
//             print(e.toString());
//           }
//         }
//       }
//     });
