import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QtyDialog extends StatefulWidget {
  final TextEditingController qty;

  const QtyDialog({Key? key, required this.qty}) : super(key: key);

  @override
  State<QtyDialog> createState() => _QtyDialogState();
}

class _QtyDialogState extends State<QtyDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Input QTY'),
      content: TextField(
        autofocus: true,
        controller: widget.qty,
        decoration: InputDecoration(
            hintText: "Quantity",
            labelText: "Quantity",
            border: OutlineInputBorder()),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
      actionsPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      actions: <Widget>[
        MaterialButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: Text("OK"),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(width: 1.5)),
        ),
        MaterialButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: Text("Cancel"),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(width: 1.5)),
        ),
      ],
    );
  }
}
