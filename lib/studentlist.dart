import 'package:flutter/material.dart';
import 'package:hacksrm/models/studentinfo.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StudentList extends StatefulWidget {
  final String studentlist;
  StudentList(this.studentlist);
  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  String newstudentidname;
  String newstudentidphone;
  @override
  Widget build(BuildContext context) {
    Box<Studentinfo> studentbox = Hive.box<Studentinfo>(widget.studentlist);
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Add a Student"),
                content: Form(
                  key: _form,
                  child: Container(
                    height: height * .25,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(hintText: "Student Name"),
                          onSaved: (newValue) => newstudentidname = newValue,
                          validator: (value) {
                            if (value.length < 3) {
                              return 'like this difficult';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          maxLength: 10,
                          decoration:
                              InputDecoration(hintText: "Student Phone"),
                          onSaved: (newValue) => newstudentidphone = newValue,
                          validator: (value) {
                            if (value.length < 10) {
                              return 'like this difficult';
                            }
                            return null;
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FlatButton.icon(
                              onPressed: () async {
                                if (_form.currentState.validate()) {
                                  _form.currentState.save();
                                  final newstudentinfo = Studentinfo(
                                      newstudentidname, newstudentidphone);
                                  studentbox.add(newstudentinfo);
                                  await Hive.openBox(newstudentidphone);
                                  Navigator.pop(context);
                                }
                              },
                              icon: Icon(
                                Icons.done,
                                color: Colors.green,
                              ),
                              label: Text(
                                "Add",
                                style: TextStyle(color: Colors.green),
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
      body: ValueListenableBuilder(
        valueListenable: studentbox.listenable(),
        builder: (context, Box<Studentinfo> box, widget) {
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final studentinfo = box.getAt(index);
              return ListTile(
                title: Text(studentinfo.name),
                subtitle: Text(studentinfo.phone_no),
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Add a Student"),
                        content: Form(
                          key: _form,
                          child: Container(
                            height: height * .25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextFormField(
                                  initialValue: studentinfo.name,
                                  decoration:
                                      InputDecoration(hintText: "Student Name"),
                                  onSaved: (newValue) =>
                                      newstudentidname = newValue,
                                  validator: (value) {
                                    if (value.length < 3) {
                                      return 'like this difficult';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  initialValue: studentinfo.phone_no,
                                  maxLength: 10,
                                  decoration: InputDecoration(
                                      hintText: "Student Phone"),
                                  onSaved: (newValue) =>
                                      newstudentidphone = newValue,
                                  validator: (value) {
                                    if (value.length < 10) {
                                      return 'like this difficult';
                                    }
                                    return null;
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    FlatButton.icon(
                                        onPressed: () {
                                          studentbox.deleteAt(index);
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        label: Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.red),
                                        )),
                                    FlatButton.icon(
                                      onPressed: () {
                                        if (_form.currentState.validate()) {
                                          _form.currentState.save();
                                          final newstudentinfo = Studentinfo(
                                              newstudentidname,
                                              newstudentidphone);
                                          studentbox.putAt(
                                              index, newstudentinfo);
                                          Navigator.pop(context);
                                        }
                                      },
                                      icon: Icon(
                                        Icons.done,
                                        color: Colors.green,
                                      ),
                                      label: Text(
                                        "Add",
                                        style: TextStyle(color: Colors.green),
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
              );
            },
          );
        },
      ),
    );
  }

}
