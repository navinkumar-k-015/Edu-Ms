import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hacksrm/make_questions.dart';
import 'package:hacksrm/messagebubble.dart';
import 'package:hacksrm/models/messagelogs.dart';
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
  final messageTextController = TextEditingController();
  String messageText;
  final private_msg = TextEditingController();
  String pvtMsg;

  @override
  void initState() {
    print("init");
    Hive.openBox<List<int>>(widget.classname + "qId_response");
    willitwork = receiver.onSmsReceived.listen((SmsMessage msg) async {
      String message = msg.body.trim();
      String phoneNo = msg.address;
      await Hive.openBox(phoneNo);
      if (message[0] == '.') {
        if (message.startsWith('.help')) {
          Box<MessageLog> messagelogdb =
              Hive.box<MessageLog>(widget.classname + 'messageLogs');
          if (message.length > 6) {
            MessageLog messageLog =
                MessageLog(message.substring(6), phoneNo, false);
            messagelogdb.add(messageLog);
          }
        } else {
          try {
            int qId = int.parse(message.substring(1, message.indexOf(' ')));
            int op = int.parse(
                message.substring(message.length - 1, message.length));
            await Hive.openBox<bool>(widget.classname + qId.toString());
            Box<List<int>> classname_qid_response =
                Hive.box<List<int>>(widget.classname + "qId_response");
            if (Hive.box<bool>(widget.classname + qId.toString())
                    .get(phoneNo) ==
                null) {
              Question ques =
                  Hive.box<Question>(widget.classname + "questionsSent")
                      .get(qId);
              List<int> response =
                  classname_qid_response.get(qId, defaultValue: [0, 0]);
              if (ques.correct == (op - 1)) {
                print(phoneNo + "correct");
                Hive.box<bool>(widget.classname + qId.toString())
                    .put(phoneNo, true);
                classname_qid_response.put(qId, [response[0] + 1, response[1]]);
              } else {
                Hive.box<bool>(widget.classname + qId.toString())
                    .put(phoneNo, false);
                classname_qid_response.put(qId, [response[0], response[1] + 1]);
                print(phoneNo + "u r wrong");
              }
            } else {
              print("cheater");
            }
            Hive.box<bool>(widget.classname + qId.toString()).close();
          } catch (e) {}
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double radius = 40;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldkey,
        body: Column(
          children: [
            Expanded(
                child: ValueListenableBuilder(
              valueListenable:
                  Hive.box<MessageLog>(widget.classname + 'messageLogs')
                      .listenable(),
              builder: (context, Box<MessageLog> box, child) {
                return ListView.builder(
                  reverse: true,
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    index = box.length - index - 1;
                    MessageLog messageLog = box.getAt(index);
                    return InkWell(
                      child: MessageBubble(
                        sender: messageLog.phoneNo,
                        text: messageLog.message,
                        isMe: messageLog.senderOrrecever,
                      ),
                      onDoubleTap: () {
                        if (!messageLog.senderOrrecever) {
                          showDialog(
                              useSafeArea: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Container(
                                    width: width * .5,
                                    height: height * .5,
                                    child: Column(
                                      children: [
                                        Expanded(
                                            child: SingleChildScrollView(
                                          child: MessageBubble(
                                            sender: messageLog.phoneNo,
                                            text: messageLog.message,
                                            isMe: messageLog.senderOrrecever,
                                          ),
                                        )),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                              child: TextField(
                                                controller: private_msg,
                                                onChanged: (value) {
                                                  pvtMsg = value;
                                                },
                                                decoration: InputDecoration(
                                                  hintText: 'Send message...',
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                            FlatButton(
                                                onPressed: () {
                                                  SmsSender sender =
                                                      new SmsSender();
                                                  String address =
                                                      messageLog.phoneNo;
                                                  SmsMessage message =
                                                      new SmsMessage(
                                                          address, pvtMsg);
                                                  sender.sendSms(message);
                                                  message.onStateChanged.listen(
                                                    (state) {
                                                      if (state ==
                                                          SmsMessageState
                                                              .Sent) {
                                                        print("SMS is sent!");
                                                      } else if (state ==
                                                          SmsMessageState
                                                              .Delivered) {
                                                        print(
                                                            "SMS is delivered!");
                                                      } else if (state ==
                                                          SmsMessageState
                                                              .Fail) {
                                                        _scaffoldkey
                                                            .currentState
                                                            .showSnackBar(SnackBar(
                                                                content: Text(
                                                                    "message not dilivered to $address")));
                                                      }
                                                    },
                                                  );
                                                  private_msg.clear();
                                                  Navigator.pop(context);
                                                },
                                                child: Icon(Icons.send)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }
                      },
                    );
                  },
                );
              },
            )),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        hintText: 'Type your message here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      sendSMS(messageText);
                      messageTextController.clear();
                    },
                    child: Text(
                      'Send',
                      style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: ValueListenableBuilder(
            valueListenable:
                Hive.box<Question>(widget.classname + 'questionsSent')
                    .listenable(),
            builder: (context, Box<Question> boxs, child) {
              return Align(
                alignment: Alignment.topCenter,
                child: ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: boxs.length,
                  itemBuilder: (context, index) {
                    var qId = boxs.keyAt(index);
                    Question _qus = boxs.getAt(index);

                    return ValueListenableBuilder(
                      valueListenable:
                          Hive.box<List<int>>(widget.classname + "qId_response")
                              .listenable(),
                      builder: (context, Box<List<int>> box, child) {
                        List<int> stats = box.get(qId, defaultValue: [0, 0]);
                        int length = Hive.box<Studentinfo>(
                                widget.classname + "-StudentList")
                            .length;
                        // double correct = stats[0].toDouble();
                        return ExpansionTile(
                          title: Text(_qus.question),
                          children: [
                            Container(
                              width: width * .38,
                              height: width * .38,
                              child: Center(
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(100.0)),
                                  child: PieChart(PieChartData(
                                      sectionsSpace: 3.0,
                                      centerSpaceRadius: 26.66,
                                      borderData: FlBorderData(
                                        show: false,
                                      ),
                                      sections: [
                                        PieChartSectionData(
                                            showTitle:
                                                stats[1] == 0 ? false : true,
                                            title: stats[1].toString(),
                                            titleStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                            radius: radius,
                                            value: stats[1].toDouble(),
                                            color: Colors.redAccent),
                                        PieChartSectionData(
                                            title:
                                                (length - stats[0] - stats[1])
                                                    .toString(),
                                            showTitle:
                                                length - stats[0] - stats[1] ==
                                                        0
                                                    ? false
                                                    : true,
                                            titleStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                            radius: radius,
                                            value:
                                                (length - stats[0] - stats[1])
                                                    .toDouble(),
                                            color: Color(0xff0086F3)),
                                        PieChartSectionData(
                                            showTitle:
                                                stats[0] == 0 ? false : true,
                                            title: stats[0].toString(),
                                            titleStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                            radius: radius,
                                            value: stats[0].toDouble(),
                                            color: Color(0xff00D27C)),
                                      ])),
                                ),
                              ),
                            ),
                            RaisedButton(
                              child: Text("Responses"),
                              onPressed: () async {
                                await Hive.openBox<bool>(
                                    widget.classname + qId.toString());
                                var student = Hive.box<Studentinfo>(
                                    widget.classname + "-StudentList");
                                showDialog(
                                    useSafeArea: false,
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Divider(
                                                thickness: 2.0,
                                                color: Colors.blueAccent,
                                              ),
                                              ValueListenableBuilder(
                                                valueListenable: Hive.box<bool>(
                                                        widget.classname +
                                                            qId.toString())
                                                    .listenable(),
                                                builder: (context,
                                                    Box<bool> box, child) {
                                                  return ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: student.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      Studentinfo studentinfo =
                                                          student.getAt(index);

                                                      return ListTile(
                                                        title: Text((index + 1)
                                                                .toString() +
                                                            ") " +
                                                            studentinfo.name),
                                                        trailing: (box.get(
                                                                    studentinfo
                                                                        .phone_no)) ==
                                                                null
                                                            ? Icon(
                                                                Icons
                                                                    .help_outline_outlined,
                                                                color: Colors
                                                                    .blueAccent,
                                                              )
                                                            : box.get(studentinfo
                                                                        .phone_no) ==
                                                                    true
                                                                ? Icon(
                                                                    Icons.check,
                                                                    color: Colors
                                                                        .green,
                                                                  )
                                                                : Icon(
                                                                    Icons.close,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                      );
                                                    },
                                                  );
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }).whenComplete(() {
                                  Hive.box<bool>(
                                          widget.classname + qId.toString())
                                      .close();
                                });
                              },
                              color: Colors.yellow,
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
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
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        ExpansionTile(
                                          title: RichText(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            strutStyle: StrutStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold),
                                            text: TextSpan(
                                                style: TextStyle(
                                                    color: Colors.black),
                                                text: _qus.question),
                                          ),
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Expanded(
                                                  child: Chip(
                                                    backgroundColor: _qus
                                                                .correct ==
                                                            0
                                                        ? Colors
                                                            .greenAccent[100]
                                                        : Colors
                                                            .blueAccent[100],
                                                    label: Text(
                                                      _qus.option1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Chip(
                                                    backgroundColor: _qus
                                                                .correct ==
                                                            1
                                                        ? Colors
                                                            .greenAccent[100]
                                                        : Colors
                                                            .blueAccent[100],
                                                    label: Text(
                                                      _qus.option2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Expanded(
                                                  child: Chip(
                                                    backgroundColor: _qus
                                                                .correct ==
                                                            2
                                                        ? Colors
                                                            .greenAccent[100]
                                                        : Colors
                                                            .blueAccent[100],
                                                    label: Text(
                                                      _qus.option3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Chip(
                                                    backgroundColor: _qus
                                                                .correct ==
                                                            3
                                                        ? Colors
                                                            .greenAccent[100]
                                                        : Colors
                                                            .blueAccent[100],
                                                    label: Text(
                                                      _qus.option4,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                width: width * .75 / 2,
                                                child: RaisedButton(
                                                  color: Colors.redAccent,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.delete,
                                                        color: Colors.black54,
                                                      ),
                                                      Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54),
                                                      )
                                                    ],
                                                  ),
                                                  onPressed: () {
                                                    box.deleteAt(index);
                                                  },
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                width: width * .75 / 2,
                                                child: RaisedButton(
                                                  color: Colors.green[500],
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.send,
                                                        color: Colors.black54,
                                                      ),
                                                      Text('  Send')
                                                    ],
                                                  ),
                                                  onPressed: () {
                                                    sendSMS(
                                                        "${_qus.question}\n\n1) ${_qus.option1}\n2) ${_qus.option2}\n3) ${_qus.option3}\n4) ${_qus.option4}",
                                                        qId: box.keyAt(index),
                                                        qus: _qus);
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )),
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

  void sendSMS(String messageEntered, {int qId, Question qus}) async {
    if (qId == null && qus == null) {
      Box<MessageLog> messagelogdb =
          Hive.box<MessageLog>(widget.classname + 'messageLogs');
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
            } else if (state == SmsMessageState.Fail) {
              _scaffoldkey.currentState.showSnackBar(
                  SnackBar(content: Text("message not dilivered to $address")));
            }
          },
        );
      }
      MessageLog messageLog = MessageLog(messageEntered, "its You", true);
      messagelogdb.add(messageLog);
    } else {
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
  }

  @override
  void dispose() {
    print("object");
    willitwork.cancel();
    Hive.box<List<int>>(widget.classname + "qId_response").close();
    super.dispose();
  }
}
