import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddItemDialog extends StatefulWidget {
  final TextEditingController itemName;
  final TextEditingController listPrice;

  const AddItemDialog({Key? key, required this.itemName, required this.listPrice}) : super(key: key);

  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Item'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: widget.itemName,
              decoration: InputDecoration(
                  hintText: "Item",
                  labelText: "Item",
                  border: OutlineInputBorder()
              ),
              validator: (val) {
                if(val!.isNotEmpty) return null;
                else return "Please fill in item name.";
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: widget.listPrice,
              decoration: InputDecoration(
                  hintText: "Item Price",
                  labelText: "Item Price",
                  border: OutlineInputBorder()
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
