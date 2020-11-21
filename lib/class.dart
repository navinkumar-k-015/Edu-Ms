import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hacksrm/announcements.dart';
import 'package:hacksrm/individualReport.dart';
import 'package:hacksrm/live_class.dart';
import 'package:hacksrm/make_questions.dart';
import 'package:hacksrm/models/messagelogs.dart';
import 'package:hacksrm/models/question.dart';
import 'package:hacksrm/studentlist.dart';
import 'package:hacksrm/top_bar.dart';
import 'package:hive/hive.dart';

import 'models/studentinfo.dart';

class ClassRoom extends StatelessWidget {
  final String classroom;
  ClassRoom(this.classroom);
  @override
  Widget build(BuildContext context) {
    String studentist = classroom + "-StudentList";
    return NeumorphicBackground(
      padding: EdgeInsets.all(8),
      child: Scaffold(
        appBar: TopBar(
          title: classroom,
        ),
        body: GridView.count(
          crossAxisCount: 2,
          children: [
            InkWell(
              onTap: () async {
                await Hive.openBox<String>(classroom + "-Announcements");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Announcements(classroom),
                  ),
                );
              },
              child: PrettyTile(
                'Announcement',
                Icon(
                  Icons.settings_input_antenna,
                  size: 35,
                ),
              ),
            ),

            InkWell(
              onTap: () async {
                await Hive.openBox<Studentinfo>(studentist);
                print(studentist);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentList(studentist, classroom),
                  ),
                );
              },
              child: PrettyTile(
                'Student List',
                Icon(
                  Icons.supervisor_account_outlined,
                  size: 35,
                ),
              ),
            ),
            InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MakeQuestions(classroom),
                    ),
                  );
                },
                child: PrettyTile(
                  'Make Questions',
                  Icon(
                    Icons.assessment,
                    size: 35,
                  ),
                )),
            InkWell(
                onTap: () async {
                  await Hive.openBox<MessageLog>(classroom + 'messageLogs');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LiveClass(classroom),
                    ),
                  );
                },
                child: PrettyTile(
                  'Live Class',
                  Icon(
                    Icons.live_tv_outlined,
                    size: 35,
                  ),
                )),
            InkWell(
              onTap: () async {
                await Hive.openBox<Studentinfo>(studentist);
                await Hive.openBox<Question>(classroom + "questionsSent");
                print(studentist);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        IndividualReport(studentist, classroom),
                  ),
                );
              },
              child: PrettyTile(
                'Individual Report',
                Icon(
                  Icons.bookmark,
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

class PrettyTile extends StatelessWidget {
  final String _title;
  final Icon _icon;
  PrettyTile(this._title, this._icon);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 16),
            child: Neumorphic(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 54, left: 16, right: 16, bottom: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: SizedBox(width: 80, height: 80, child: _icon
                ),
          )
        ],
      ),
    );
  }
}
