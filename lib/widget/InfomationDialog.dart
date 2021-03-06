import 'package:flutter/material.dart';

class InformationDialog extends StatelessWidget {
  final String content;

  const InformationDialog({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(content),
      actionsPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      actions: <Widget>[
        MaterialButton(
          onPressed: () => Navigator.pop(context),
          child: Text("OK"),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(width: 1.5)),
        ),
      ],
    );
  }
}
