import 'package:flutter/material.dart';

class ItemEditDialog extends StatefulWidget {
  final TextEditingController listPrice;
  final TextEditingController qty;
  final String itemName;

  const ItemEditDialog({Key? key, required this.listPrice, required this.qty, required this.itemName}) : super(key: key);

  @override
  _ItemEditDialogState createState() => _ItemEditDialogState();
}

class _ItemEditDialogState extends State<ItemEditDialog> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Item "${widget.itemName}"'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: widget.listPrice,
              decoration: InputDecoration(
                  hintText: "List Price",
                  labelText: "List Price",
                  border: OutlineInputBorder()
              ),
              validator: (val) {
                if(val!.isNotEmpty) return null;
                else return "This can't be empty.";
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: widget.qty,
              decoration: InputDecoration(
                  hintText: "Quantity",
                  labelText: "Quantity",
                  border: OutlineInputBorder()
              ),
              validator: (val) {
                if(val!.isNotEmpty) return null;
                else return "This can't be empty.";
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

