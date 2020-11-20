import 'package:flutter/material.dart';
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
  @override
  void initState() {
    SmsReceiver receiver = new SmsReceiver();
    receiver.onSmsReceived.listen((SmsMessage msg) {
      if (msg.body.startsWith('.')) {
        print(msg.body);
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
                builder: (context, Box<Question> box, widget) {
                  return ListView.builder(
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
                            box.keyAt(index).toString()),
                      );
                    },
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

  void sendSMS(String messageEntered, String qId) async {
    messageEntered = "Question ID : ${qId}\n" + messageEntered;
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
  }
}
