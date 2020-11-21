import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hacksrm/reviewPage.dart';
import 'package:hacksrm/top_bar.dart';

class MakeQuestions extends StatefulWidget {
  final String classname;
  MakeQuestions(this.classname);
  @override
  _MakeQuestionsState createState() => _MakeQuestionsState();
}

class _MakeQuestionsState extends State<MakeQuestions> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode _option1;
  FocusNode _option2;
  FocusNode _option3;
  FocusNode _option4;
  String question, correct, wrong1, wrong2, wrong3;
  @override
  void initState() {
    _option1 = FocusNode();
    _option2 = FocusNode();
    _option3 = FocusNode();
    _option4 = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _option1.dispose();
    _option2.dispose();
    _option3.dispose();
    _option4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NeumorphicBackground(
      padding: EdgeInsets.all(8),
          child: Scaffold(
        appBar: TopBar( title: 'Make Question',),
        body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Neumorphic(
                              child: Column(
                  children: [
        Padding(
          padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
          child: TextFormField(
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (value) {
                FocusScope.of(context).requestFocus(_option1);
            },
            onSaved: (newValue) => question = newValue.trim(),
            validator: (value) {
                if (value.trim().length <= 3) {
                  return 'Like this difficult';
                }
                return null;
            },
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2)
              ),
                  border: OutlineInputBorder(
                  ),
                  hintText: 'Type the question here',
                  helperText: 'Keep it short for students sake.',
                  labelText: 'Question',
                  labelStyle: TextStyle()),
            maxLines: 7,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextFormField(
            style: TextStyle(color: Colors.green[800]),
            onFieldSubmitted: (value) {
                FocusScope.of(context).requestFocus(_option2);
            },
            validator: (value) {
                if (value.trim().isEmpty) return "Option can't be empty";
                return null;
            },
            onSaved: (newValue) => correct = newValue.trim(),
            focusNode: _option1,
            decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.black, width: 2.0),
                ),
               
                border: OutlineInputBorder(),
                hintText: 'Type the Correct option here',
                labelText: 'Correct option',
            ),
            maxLines: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextFormField(
            style: TextStyle(color: Colors.red[800]),
            onFieldSubmitted: (value) {
                FocusScope.of(context).requestFocus(_option3);
            },
            validator: (value) {
                if (value.trim().isEmpty) return "Option can't be empty";
                return null;
            },
            onSaved: (newValue) => wrong1 = newValue.trim(),
            focusNode: _option2,
            decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.black, width: 2),
                ),
                border: OutlineInputBorder(),
                hintText: 'Type the option here',
                labelText: 'Wrong Option',
            ),
            maxLines: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextFormField(
            style: TextStyle(color: Colors.red[800]),
            onFieldSubmitted: (value) {
                FocusScope.of(context).requestFocus(_option4);
            },
            validator: (value) {
                if (value.trim().isEmpty) return "Option can't be empty";
                return null;
            },
            onSaved: (newValue) => wrong2 = newValue.trim(),
            focusNode: _option3,
            decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.black, width: 2),
                ),
                border: OutlineInputBorder(),
                hintText: 'Type the option here',
                labelText: 'Wrong Option',
            ),
            maxLines: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextFormField(
            style: TextStyle(color: Colors.red[800]),
            focusNode: _option4,
            validator: (value) {
                if (value.trim().isEmpty) return "Option can't be empty";
                return null;
            },
            onSaved: (newValue) => wrong3 = newValue.trim(),
            decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.black, width: 2),
                ),

                border: OutlineInputBorder(),
                hintText: 'Type the option here',
                labelText: 'Wrong Option',
                // labelStyle:
            ),
            maxLines: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 16.0),
                  child: RaisedButton.icon(
                    color: Colors.white,
                    
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.white)),
                    onPressed: () {
                      _formKey.currentState.reset();
                    },
                    icon: Icon(Icons.refresh),
                    label: Text("Reset"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 16.0),
                  child: RaisedButton.icon(
                      color: Colors.white,
                      
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.white)),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewPage(question,
                                  correct, wrong1, wrong2, wrong3,widget.classname),
                            ),
                          );
                        }
                      },
                      icon: Icon(Icons.done),
                      label: Text("Submit")),
                ),
            ],
          ),
        )
                  ],
                ),
              ),
            ),
          ),
      ),
    );
  }
}
