import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddToOrderDialog extends StatefulWidget {
  final String itemName;
  final TextEditingController listPrice;
  final TextEditingController qty;

  const AddToOrderDialog({Key? key, required this.itemName, required this.qty, required this.listPrice}) : super(key: key);

  @override
  _AddToOrderDialogState createState() => _AddToOrderDialogState();
}

class _AddToOrderDialogState extends State<AddToOrderDialog> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add "${widget.itemName}" to Order'),
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
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
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
              keyboardType: TextInputType.number,
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
