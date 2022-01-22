import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  var listPriceFocusNode = FocusNode();
  var qtyFocusNode = FocusNode();

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
              focusNode: listPriceFocusNode,
              decoration: InputDecoration(
                  hintText: "List Price",
                  labelText: "List Price",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      widget.listPrice.clear();
                      listPriceFocusNode.requestFocus();
                    },
                    splashRadius: 18.0,
                  )),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
              ],
              validator: (val) {
                if (val!.isNotEmpty)
                  return null;
                else
                  return "This can't be empty.";
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: widget.qty,
              focusNode: qtyFocusNode,
              decoration: InputDecoration(
                  hintText: "Quantity",
                  labelText: "Quantity",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      widget.qty.clear();
                      qtyFocusNode.requestFocus();
                    },
                    splashRadius: 18.0,
                  )),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (val) {
                if (val!.isNotEmpty)
                  return null;
                else
                  return "This can't be empty.";
              },
            ),
          ],
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
      actionsPadding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      actions: <Widget>[
        Column(
          children: [
            Container(
              width: double.infinity,
              child: MaterialButton(
                onPressed: () {
                  if (_formKey.currentState!.validate())
                    Navigator.pop(context, 'Update');
                },
                child: Text("Update", style: TextStyle(color: Colors.green)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(width: 1.5, color: Colors.green)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    child: MaterialButton(
                      onPressed: () => Navigator.pop(context, 'Delete'),
                      child:
                          Text("Delete", style: TextStyle(color: Colors.red)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(width: 1.5, color: Colors.red)),
                    ),
                  ),
                ),
                SizedBox(width: 12.0),
                Expanded(
                  child: Container(
                    child: MaterialButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: Text("Cancel"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(width: 1.5)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

