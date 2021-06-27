import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:invoice_manage/blocs/categoriesBloc.dart';
import 'package:invoice_manage/blocs/customerBloc.dart';
import 'package:invoice_manage/model/customer.dart';
import 'package:invoice_manage/pages/addOrEditCustomerPage.dart';
import 'package:invoice_manage/widget/yesno_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerViewPage extends StatefulWidget {
  final CustomerBloc cusBloc;
  final CategoriesBloc cateBloc;

  const CustomerViewPage({Key? key, required this.cusBloc, required this.cateBloc}) : super(key: key);

  @override
  _CustomerViewPageState createState() => _CustomerViewPageState();
}

class _CustomerViewPageState extends State<CustomerViewPage> {
  @override
  Widget build(BuildContext context) {
    Customer temp = widget.cusBloc.fCus;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddOrEditCustomerPage(cusBloc: widget.cusBloc, cusToEdit: temp, cateBloc: widget.cateBloc)),
            ).then((value) {
              if (value != null) {
                setState(() {
                  widget.cusBloc.fCus = value;
                });
              }
            }),
            icon: Icon(Icons.edit),
            tooltip: "Edit",
          ),
          IconButton(
            onPressed: () => deleteCustomer(temp),
            icon: Icon(Icons.delete),
            tooltip: "Delete",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${temp.companyName ?? ""}',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '${temp.cusName ?? ""}',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Category:", style: Theme.of(context).textTheme.bodyText1),
                Text(temp.cusCateName ?? "-", style: Theme.of(context).textTheme.bodyText1),
              ],
            ),
            SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Work Number:", style: Theme.of(context).textTheme.bodyText1),
                temp.workNum != ""
                ? SelectableText.rich(
                    TextSpan(
                        style: TextStyle(
                            color: Colors.black
                        ),
                        children: [
                          TextSpan(
                            text: '${temp.workNum ?? ""}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final url = 'tel:${temp.workNum ?? ""}';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                          )
                        ]
                    )
                )
                : Text("-", style: Theme.of(context).textTheme.bodyText1)
              ],
            ),
            SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Mobile Number:", style: Theme.of(context).textTheme.bodyText1),
                SelectableText.rich(
                  TextSpan(
                    style: TextStyle(
                        color: Colors.black
                    ),
                    children: [
                      TextSpan(
                        text: '${temp.mobileNum ?? ""}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            final url = 'tel:${temp.mobileNum ?? ""}';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                      )
                    ]
                  )
                ),
              ],
            ),
            SizedBox(height: 12.0),
            Text("Address:", style: Theme.of(context).textTheme.bodyText1),
            SizedBox(height: 8.0),
            Container(
              padding: EdgeInsets.all(8.0),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(10.0)
              ),
              child: temp.address == ""
              ? Text("No address")
              : SelectableText(
                '${temp.address ?? ""}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteCustomer(Customer c) async {
    String t = await showDialog(
        context: context,
        builder: (BuildContext context) => YesNoDialog(title: 'Delete "${c.companyName}"')
    ) ?? "Cancel";
    if(t == "Yes") {
      widget.cusBloc.delete(c);
      Navigator.of(context).pop();
    }
  }
}
