import 'package:flutter/material.dart';

class ExportsDialog extends StatefulWidget {
  final bool justOrders;
  final bool justSummary;

  const ExportsDialog(
      {Key? key, required this.justOrders, required this.justSummary})
      : super(key: key);

  @override
  _ExportsDialogState createState() => _ExportsDialogState();
}

class _ExportsDialogState extends State<ExportsDialog> {
  bool justOrders = true;
  bool justSummary = true;

  @override
  void initState() {
    super.initState();
    justOrders = widget.justOrders;
    justSummary = widget.justSummary;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Export ...'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                  value: justOrders,
                  onChanged: (value) {
                    setState(() {
                      justOrders = value!;
                    });
                  }),
              Text("Just Orders")
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            children: [
              Checkbox(
                  value: justSummary,
                  onChanged: (value) {
                    setState(() {
                      justSummary = value!;
                    });
                  }),
              Text("Just Summary")
            ],
          )
        ],
      ),
      actionsPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      actions: <Widget>[
        MaterialButton(
          onPressed: () =>
              Navigator.pop(context, <bool>[justOrders, justSummary]),
          child: Text("Yes"),
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
