import 'package:flutter/material.dart';
import 'package:sms/sms.dart';

class LiveClass extends StatefulWidget {
  @override
  _LiveClassState createState() => _LiveClassState();
}

class _LiveClassState extends State<LiveClass> {
  @override
  void initState() {
    SmsReceiver receiver = new SmsReceiver();
    receiver.onSmsReceived.listen((SmsMessage msg) {
      if (msg.body.startsWith('.')) {
        print(msg.body);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
