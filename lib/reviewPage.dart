import 'package:flutter/material.dart';
import 'package:hacksrm/models/question.dart';
import 'package:hive/hive.dart';

class ReviewPage extends StatefulWidget {
  final String question, correct, wrong1, wrong2, wrong3, classname;
  ReviewPage(this.question, this.correct, this.wrong1, this.wrong2, this.wrong3,
      this.classname);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    Box questionBox = Hive.box<Question>(widget.classname + 'questions');
    int correctop;
    List list = ['correct', 'wrong1', 'wrong2', 'wrong3'];
    list.shuffle();
    correctop = list.indexOf('correct');
    list[correctop] = widget.correct;
    list[list.indexOf('wrong1')] = widget.wrong1;
    list[list.indexOf('wrong2')] = widget.wrong2;
    list[list.indexOf('wrong3')] = widget.wrong3;
    print(list);
    print(correctop);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Question ID : xxxx\n${widget.question}\n\n1) ${list[0]}\n2) ${list[1]}\n3) ${list[2]}\n4) ${list[3]}',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton.icon(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.edit),
                    label: Text("Edit")),
                FlatButton.icon(
                    onPressed: () {
                      final Question newQuestion = Question(widget.question,
                          list[0], list[1], list[2], list[3], correctop);
                      questionBox.add(newQuestion);
                      onadded();
                    },
                    icon: Icon(Icons.add),
                    label: Text("Add"))
              ],
            ),
          )
        ],
      ),
    );
  }

  onadded() {
    int count = 0;
    Navigator.popUntil(context, (route) => count++ == 2);
  }
}
