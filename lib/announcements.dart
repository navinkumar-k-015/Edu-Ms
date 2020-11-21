import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hacksrm/models/studentinfo.dart';
import 'package:hacksrm/top_bar.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sms/sms.dart';

class Announcements extends StatefulWidget {
  final String classname;

  Announcements(this.classname);

  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  TextEditingController _controller = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Box<String> announced =
        Hive.box<String>(widget.classname + "-Announcements");
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return NeumorphicBackground(
      padding: EdgeInsets.all(8.0),
      child: Scaffold(
        key: _scaffoldkey,
        appBar: TopBar(
          title: "Announcements",
        ),
        // ignore: missing_required_param
        floatingActionButton: FloatingActionButton(
          child: NeumorphicButton(
            padding: EdgeInsets.all(18),
            style: NeumorphicStyle(
              boxShape: NeumorphicBoxShape.circle(),
              shape: NeumorphicShape.flat,
            ),
            child: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      "New Announcement",
                      textAlign: TextAlign.center,
                    ),
                    content: Container(
                      width: width * .8,
                      height: height * .35,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Divider(
                            thickness: 2,
                          ),
                          TextField(
                            minLines: 7,
                            maxLines: null,
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 2)),
                              border: OutlineInputBorder(),
                              hintText: 'Type the announcement here',
                              helperText: 'Keep it short for students sake.',
                              labelText: 'Announcement',
                              labelStyle: TextStyle(),
                            ),
                            controller: _controller,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: NeumorphicButton(
                              child: Icon(Icons.send),
                              onPressed: () {
                                sendSMS(_controller.text.trim());
                                _controller.clear();
                                Navigator.pop(context);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        body: ValueListenableBuilder(
          valueListenable: announced.listenable(),
          builder: (context, Box<String> box, child) {
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(announced.getAt(index), overflow: TextOverflow.ellipsis, maxLines: 3,),);
              },
            );
          },
        ),
      ),
    );
  }

  void sendSMS(String msg) async {
    Box<Studentinfo> studentbox =
        Hive.box<Studentinfo>(widget.classname + "-StudentList");
    for (var i = 0; i < studentbox.length; i++) {
      Studentinfo _studentinfo = studentbox.getAt(i);
      SmsSender sender = new SmsSender();
      String address = _studentinfo.phone_no;
      SmsMessage message = new SmsMessage(address, "Announcement:\n" + msg);
      sender.sendSms(message);
      message.onStateChanged.listen(
        (state) {
          if (state == SmsMessageState.Sent) {
            print("SMS is sent!");
          } else if (state == SmsMessageState.Delivered) {
            print("SMS is delivered!");
          } else if (state == SmsMessageState.Fail) {
            _scaffoldkey.currentState.showSnackBar(
                SnackBar(content: Text("Message not dilivered to $address")));
          }
        },
      );
    }
    Hive.box<String>(widget.classname + "-Announcements").add(msg);
  }
  @override
  void dispose() {
    Hive.box<String>(widget.classname + "-Announcements").close();
    super.dispose();
  }
}
