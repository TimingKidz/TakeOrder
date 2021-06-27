import 'package:flutter/material.dart';
import 'package:invoice_manage/blocs/categoriesBloc.dart';
import 'package:invoice_manage/blocs/customerBloc.dart';
import 'package:invoice_manage/model/catagories.dart';
import 'package:invoice_manage/model/customer.dart';
import 'package:invoice_manage/pages/addOrEditCustomerPage.dart';
import 'package:invoice_manage/pages/categoriesPage.dart';
import 'package:invoice_manage/pages/customerViewPage.dart';
import 'package:invoice_manage/widget/searchbar.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({Key? key}) : super(key: key);

  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final customerBloc = CustomerBloc();
  final cateBloc = CategoriesBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
        actions: [
          StreamBuilder<List<Categories>>(
            stream: cateBloc.categories,
            builder: (BuildContext context, AsyncSnapshot<List<Categories>> snapshot) {
              return StreamBuilder<List<Customer>>(
                stream: customerBloc.customer,
                builder: (context, _) {
                  List<DropdownMenuItem<String>> allCate = cateBloc.genDropdownMenu();
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.only(left: 16.0, right: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0.0, 0.0), //(x,y)
                            ),
                          ],
                        ),
                        child: DropdownButton<String>(
                          value: customerBloc.dropdownValue,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          underline: Container(
                            height: 2,
                            // color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? newValue) {
                            if(newValue == "Edit Categories..."){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CategoriesPage(cateBloc: cateBloc, cusBloc: customerBloc)),
                              );
                            }else{
                              // newValue);
                              customerBloc.dropdownValue = newValue!;
                              customerBloc.filter();
                            }
                          },
                          items: <DropdownMenuItem<String>>[
                            DropdownMenuItem<String>(
                              value: "All",
                              child: Text("All"),
                            ),
                            for(DropdownMenuItem<String> c in allCate) c,
                            DropdownMenuItem<String>(
                              value: "Unfiled",
                              child: Text("Unfiled"),
                            ),
                            DropdownMenuItem<String>(
                              value: "Edit Categories...",
                              child: Text("Edit Categories..."),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              );
            }
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddOrEditCustomerPage(cusBloc: customerBloc, cateBloc: cateBloc)),
        ),
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: SearchBar(bloc: customerBloc),
          ),
          StreamBuilder<List<Customer>>(
            stream: customerBloc.customer,
            builder: (BuildContext context, AsyncSnapshot<List<Customer>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  return Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.only(bottom: 92),
                      itemCount: snapshot.data?.length ?? 0,
                      separatorBuilder: (_, index) {
                        return Divider(thickness: 1.5);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(snapshot.data![index].companyName ?? ""),
                          subtitle: Text(snapshot.data![index].cusName ?? ""),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Row(
                              //   mainAxisSize: MainAxisSize.min,
                              //   children: [
                              //     snapshot.data![index].workNum == "" ? Text("-") : Text("${snapshot.data![index].workNum ?? ""}"),
                              //     Icon(Icons.phone, size: 20)
                              //   ],
                              // ),
                              // SizedBox(height: 8.0),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("${snapshot.data![index].mobileNum ?? " "}"),
                                  Icon(Icons.smartphone, size: 20)
                                ],
                              ),
                            ],
                          ),
                          onTap: () {
                            customerBloc.fCus = snapshot.data![index];
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CustomerViewPage(cusBloc: customerBloc, cateBloc: cateBloc)),
                            );
                          },
                        );
                      },
                    ),
                  );
                }else{
                  return Expanded(child: Center(child: Text("No contact.")));
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
