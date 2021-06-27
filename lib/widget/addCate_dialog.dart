import 'package:flutter/material.dart';

class AddCateDialog extends StatefulWidget {
  final TextEditingController name;

  const AddCateDialog({Key? key, required this.name}) : super(key: key);

  @override
  _AddCateDialogState createState() => _AddCateDialogState();
}

class _AddCateDialogState extends State<AddCateDialog> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add new category'),
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
        MaterialButton(
          onPressed: () {
            if(_formKey.currentState!.validate()) Navigator.pop(context, 'Add');
          },
          child: Text("Add"),
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
