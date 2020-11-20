import 'package:flutter/material.dart';
import 'package:hacksrm/live_class.dart';
import 'package:hacksrm/make_questions.dart';
import 'package:hacksrm/studentlist.dart';
import 'package:hive/hive.dart';

import 'models/studentinfo.dart';

class ClassRoom extends StatelessWidget {
  final String classroom;
  ClassRoom(this.classroom);
  @override
  Widget build(BuildContext context) {
    String studentist = classroom + "-StudentList";
    return Scaffold(
      appBar: AppBar(
        title: Text(classroom),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.settings_input_antenna),
            title: Text("Announcment"),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text("Student List"),
            onTap: () async {
              await Hive.openBox<Studentinfo>(studentist);
              print(studentist);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentList(studentist),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.assessment),
            title: Text("Make questions"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MakeQuestions(classroom),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.live_tv_outlined),
            title: Text("Live Class"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LiveClass(classroom),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
