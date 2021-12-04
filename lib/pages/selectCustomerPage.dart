import 'package:flutter/material.dart';
import 'package:invoice_manage/blocs/customerBloc.dart';
import 'package:invoice_manage/model/customer.dart';
import 'package:invoice_manage/widget/searchbar.dart';
import 'package:contacts_service/contacts_service.dart';

class SelectCustomerPage extends StatefulWidget {
  const SelectCustomerPage({Key? key}) : super(key: key);

  @override
  _SelectCustomerPageState createState() => _SelectCustomerPageState();
}

class _SelectCustomerPageState extends State<SelectCustomerPage> {
  final customerBloc = CustomerBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Customer"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, "CLEAR"),
            child: Text("CLEAR"),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: SearchBar(bloc: customerBloc),
          ),
          StreamBuilder<Iterable<Contact>>(
              stream: customerBloc.c,
              builder: (BuildContext context, AsyncSnapshot<Iterable<Contact>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(snapshot.data?.elementAt(index).displayName ?? ""),
                            subtitle: Text(snapshot.data?.elementAt(index).phones?.first.value ?? ""),
                            // onTap: () => Navigator.pop(context, snapshot.data![index].cusID),
                          );
                        },
                      ),
                    );
                  }else{
                    return Expanded(child: Center(child: Text("No customer yet.")));
                  }
                }else{
                  return Expanded(child: Center(child: CircularProgressIndicator()));
                }
              }
          ),
        ],
      ),
    );
  }
}
