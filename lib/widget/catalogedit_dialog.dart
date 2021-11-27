import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CatalogEditDialog extends StatefulWidget {
  final TextEditingController itemName;
  final TextEditingController itemPrice;

  const CatalogEditDialog({Key? key, required this.itemName, required this.itemPrice}) : super(key: key);

  @override
  _CatalogEditDialogState createState() => _CatalogEditDialogState();
}

class _CatalogEditDialogState extends State<CatalogEditDialog> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Item'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: widget.itemName,
              decoration: InputDecoration(
                  hintText: "Item Name",
                  labelText: "Item Name",
                  border: OutlineInputBorder()
              ),
              validator: (val) {
                if(val!.isNotEmpty) return null;
                else return "Please fill in item name.";
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: widget.itemPrice,
              decoration: InputDecoration(
                  hintText: "Item Price",
                  labelText: "Item Price",
                  border: OutlineInputBorder()
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
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
            if(_formKey.currentState!.validate()) Navigator.pop(context, 'Update');
          },
          child: Text("Update"),
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
