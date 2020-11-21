import 'package:flutter/material.dart';
import 'package:hacksrm/live_class.dart';
import 'package:hacksrm/make_questions.dart';
import 'package:hacksrm/models/messagelogs.dart';
import 'package:hacksrm/studentlist.dart';
import 'package:hive/hive.dart';

import 'models/studentinfo.dart';

class ClassRoom extends StatelessWidget {
  final String classroom;
  ClassRoom(this.classroom);
  @override
  Widget build(BuildContext context) {
    String studentist = classroom + "-StudentList";
    return Container(
      color: Color(0xFFF2F3F8),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              classroom,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                fontSize: 18,
                letterSpacing: 0.5,
                color: Color(0xFF17262A),
              ),
            ),
            iconTheme: IconThemeData(),
          ),
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              // ListTile(
              //   leading: Icon(Icons.account_circle),
              //   title: Text("Student List"),
              //   onTap: () async {
              //     await Hive.openBox<Studentinfo>(studentist);
              //     print(studentist);
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => StudentList(studentist, classroom),
              //       ),
              //     );
              //   },
              // ),
              // ListTile(
              //   leading: Icon(Icons.assessment),
              //   title: Text("Make questions"),
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => MakeQuestions(classroom),
              //       ),
              //     );
              //   },
              // ),
              // ListTile(
              //   leading: Icon(Icons.live_tv_outlined),
              //   title: Text("Live Class"),
              //   onTap: () async {
              //     await Hive.openBox<MessageLog>(classroom + 'messageLogs');
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => LiveClass(classroom),
              //       ),
              //     );
              //   },
              // ),
              PrettyTile(
                  'Announcement',
                  Icon(
                    Icons.settings_input_antenna,
                    size: 35,
                  ),'#FA7D82','#FFB295'
                  ),

              InkWell(
                  onTap: () async {
                    await Hive.openBox<Studentinfo>(studentist);
                    print(studentist);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            StudentList(studentist, classroom),
                      ),
                    );
                  },
                  child: PrettyTile(
                      'Student List',
                      Icon(
                        Icons.live_tv_outlined,
                        size: 35,
                      ),'#738AE6','#5C5EDD'),),
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
                      ),'#FE95B6','#FF5287')),
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
                        Icons.account_circle,
                        size: 35,
                      ),'#6F72CA','#1E1466'))
            ],
          ),
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
  String _title;
  Icon _icon;
  String _startcolor;
  String _endcolor;
  PrettyTile(this._title, this._icon, this._startcolor, this._endcolor);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(top: 32, left: 8, right: 8, bottom: 16),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: HexColor(_endcolor).withOpacity(0.6),
                      offset: const Offset(1.1, 4.0),
                      blurRadius: 8.0),
                ],
                color: HexColor(_startcolor),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(54.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 54, left: 16, right: 16, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        //fontFamily: FitnessAppTheme.fontName,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        letterSpacing: 0.2,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: Color(0xFFFAFAFA).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: SizedBox(width: 80, height: 80, child: _icon
                //child: Image.asset(mealsListData.imagePath),
                ),
          )
        ],
      ),
    );
  }
}
