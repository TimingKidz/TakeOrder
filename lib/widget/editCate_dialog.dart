import 'package:flutter/material.dart';

class EditCateDialog extends StatefulWidget {
  final TextEditingController name;

  const EditCateDialog({Key? key, required this.name}) : super(key: key);

  @override
  _EditCateDialogState createState() => _EditCateDialogState();
}

class _EditCateDialogState extends State<EditCateDialog> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit category'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: widget.name,
              decoration: InputDecoration(
                  hintText: "Category Name",
                  labelText: "Category Name",
                  border: OutlineInputBorder()
              ),
              validator: (val) {
                if(val!.isNotEmpty) return null;
                else return "Please fill in category name.";
              },
            ),
          ],
        ),
      ),
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
                onPressed: () {
                  if(_formKey.currentState!.validate()) Navigator.pop(context, 'Update');
                },
                child: Text("Update"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(width: 1.5)),
              ),
            ),
            Container(
              width: double.infinity,
              child: MaterialButton(
                onPressed: () => Navigator.pop(context, 'Delete'),
                child: Text("Delete"),
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
