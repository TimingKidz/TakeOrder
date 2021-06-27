import 'package:flutter/material.dart';

class DeleteOrderDialog extends StatelessWidget {
  const DeleteOrderDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Order(s)'),
      actionsPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0)
      ),
      actions: <Widget>[
        Column(
          children: [
            Container(
              width: double.infinity,
              child: MaterialButton(
                onPressed: () => Navigator.pop(context, 'Delete'),
                child: Text("Delete This Order"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(width: 1.5)),
              ),
            ),
            Container(
              width: double.infinity,
              child: MaterialButton(
                onPressed: () => Navigator.pop(context, 'DeleteAll'),
                child: Text("Delete All Orders"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(width: 1.5)),
              ),
            ),
            Container(
              width: double.infinity,
              child: MaterialButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: Text("Cancel"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(width: 1.5)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}