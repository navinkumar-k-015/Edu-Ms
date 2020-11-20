import 'package:flutter/material.dart';
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
          ),
        ],
      ),
    );
  }
}
