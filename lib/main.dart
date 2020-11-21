import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hacksrm/class.dart';
import 'package:hacksrm/models/messagelogs.dart';
import 'package:hacksrm/models/question.dart';
import 'package:hacksrm/models/studentResponse.dart';
import 'package:hacksrm/models/studentinfo.dart';
import 'package:hacksrm/top_bar.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<String>("Classes");
  Hive.registerAdapter(StudentinfoAdapter());
  Hive.registerAdapter(QuestionAdapter());
  Hive.registerAdapter(StudentResponseAdapter());
  Hive.registerAdapter(MessageLogAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: ThemeMode.light,
      theme: NeumorphicThemeData(
          lightSource: LightSource.topLeft,
          depth: 10,
          accentColor: Colors.black),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  String newclassname;
  @override
  Widget build(BuildContext context) {
    final classlist = Hive.box<String>("Classes");
    var height = MediaQuery.of(context).size.height;
    return NeumorphicBackground(
      padding: EdgeInsets.all(8),
      child: Scaffold(
        appBar: TopBar(
          title: "Home",
          actions: <Widget>[
            NeumorphicButton(
              padding: EdgeInsets.all(18),
              style: NeumorphicStyle(
                boxShape: NeumorphicBoxShape.circle(),
                shape: NeumorphicShape.flat,
              ),
              child: Icon(
                Icons.settings,
                color: NeumorphicTheme.isUsingDark(context)
                    ? Colors.white70
                    : Colors.black87,
              ),
              onPressed: () {},
            )
          ],
        ),
        // ignore: missing_required_param
        floatingActionButton: FloatingActionButton(
          child: NeumorphicButton(
            padding: EdgeInsets.all(18),
            style: NeumorphicStyle(
              boxShape: NeumorphicBoxShape.circle(),
              shape: NeumorphicShape.flat,
            ),
            child: Icon(
              Icons.add,
              color: NeumorphicTheme.isUsingDark(context)
                  ? Colors.white70
                  : Colors.black87,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0))),
                    backgroundColor: NeumorphicTheme.baseColor(context),
                    title: Text("Add a Classroom"),
                    content: Form(
                      key: _form,
                      child: Container(
                        height: height * .17,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextFormField(
                              onSaved: (newValue) => newclassname = newValue,
                              validator: (value) {
                                if (value.length <= 3) {
                                  return 'like this difficult';
                                }
                                return null;
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                NeumorphicButton(
                                  onPressed: () async {
                                    if (_form.currentState.validate()) {
                                      _form.currentState.save();
                                      classlist.add(newclassname);
                                      await Hive.openBox<Question>(
                                          newclassname + 'questions');
                                      await Hive.openBox<Question>(
                                          newclassname + 'questionsSent');
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Icon(
                                    Icons.done,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        body: ValueListenableBuilder(
          valueListenable: Hive.box<String>("Classes").listenable(),
          builder: (context, Box<String> box, widget) {
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Neumorphic(
                    child: ListTile(
                      leading: Icon(Icons.class__outlined),
                      onTap: () async {
                        await Hive.openBox<Studentinfo>(
                            box.getAt(index) + '-StudentList');
                        await Hive.openBox<Question>(
                            box.getAt(index) + 'questions');
                        await Hive.openBox<Question>(
                            box.getAt(index) + 'questionsSent');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClassRoom(box.getAt(index)),
                          ),
                        );
                      },
                      onLongPress: () {
                        classlist.deleteAt(index);
                      },
                      title: Text(box.getAt(index)),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    Hive.box("Classes").close();
    super.dispose();
  }
}
