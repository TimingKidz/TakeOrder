import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:invoice_manage/blocs/customerBloc.dart';
import 'package:invoice_manage/widget/searchbar.dart';

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
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: SearchBar(bloc: customerBloc),
          ),
          StreamBuilder<Iterable<Contact>>(
              stream: customerBloc.customer,
              builder: (BuildContext context,
                  AsyncSnapshot<Iterable<Contact>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return Expanded(
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data?.length ?? 0,
                        separatorBuilder: (_, index) {
                          return Divider(thickness: 1.5, height: 1.5);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(
                                snapshot.data?.elementAt(index).displayName ??
                                    ""),
                            onTap: () => Navigator.pop(context,
                                snapshot.data?.elementAt(index).displayName),
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
