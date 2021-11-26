import 'package:flutter/material.dart';
import 'package:invoice_manage/blocs/categoriesBloc.dart';
import 'package:invoice_manage/blocs/customerBloc.dart';
import 'package:invoice_manage/model/customer.dart';
import 'package:invoice_manage/widget/formField.dart';

class AddOrEditCustomerPage extends StatefulWidget {
  final CustomerBloc cusBloc;
  final CategoriesBloc cateBloc;
  final Customer? cusToEdit;

  const AddOrEditCustomerPage({Key? key, required this.cusBloc, this.cusToEdit, required this.cateBloc}) : super(key: key);

  @override
  _AddOrEditCustomerPageState createState() => _AddOrEditCustomerPageState();
}

class _AddOrEditCustomerPageState extends State<AddOrEditCustomerPage> {
  final _formKey = GlobalKey<FormState>();
  bool isAddTrue = true;
  String dropdownValue = "None";

  var companyName = TextEditingController();
  var cusName = TextEditingController();
  var workNum = TextEditingController();
  var mobileNum = TextEditingController();
  var address = TextEditingController();

  @override
  void initState() {
    super.initState();
    isAddTrue = widget.cusToEdit == null ? true : false;
    if(!isAddTrue){
      companyName.text = widget.cusToEdit?.companyName ?? "";
      cusName.text = widget.cusToEdit?.cusName ?? "";
      workNum.text = widget.cusToEdit?.workNum ?? "";
      mobileNum.text = widget.cusToEdit?.mobileNum ?? "";
      address.text = widget.cusToEdit?.address ?? "";
      dropdownValue = widget.cusToEdit?.cusCateName ?? "None";
    }else{
      dropdownValue = widget.cusBloc.dropdownValue == "All" || widget.cusBloc.dropdownValue == "Unfiled" ? "None" : widget.cusBloc.dropdownValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isAddTrue ? "Add Customer" : "Edit Customer"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () async {
          if(_formKey.currentState!.validate()){
            int? cateID = dropdownValue == "None"
            ? null
            : widget.cateBloc.all.firstWhere((element) => element.cateName == dropdownValue).cateID;
            Customer cus = Customer(
              companyName: companyName.text,
              cusName: cusName.text,
              workNum: workNum.text,
              mobileNum: mobileNum.text,
              address: address.text,
              cusCateID: cateID
            );
            isAddTrue ? await widget.cusBloc.add(cus) : await widget.cusBloc.update(widget.cusToEdit ?? Customer(), cus);
            Navigator.pop(context, cus);
          }
        },
        child: Icon(Icons.check),
      ),
      body: Form(
        key: _formKey,
        child: ListView.separated(
          padding: const EdgeInsets.all(16.0),
          itemCount: _formList().length,
          itemBuilder: (BuildContext context, int index) {
            return _formList().elementAt(index);
          },
          separatorBuilder: (_, int index) {
            return SizedBox(height: 16.0);
          },
        )
      ),
    );
  }

  List<Widget> _formList(){
    List<DropdownMenuItem<String>> allCate = widget.cateBloc.genDropdownMenu();
    return [
      FormBox(controller: companyName, label: "Company Name", isValidate: true),
      FormBox(controller: cusName, label: "Customer Name", isValidate: true),
      FormBox(controller: workNum, label: "Work Number", inputType: TextInputType.number),
      FormBox(controller: mobileNum, label: "Mobile Number", isValidate: true, inputType: TextInputType.number),
      FormBox(controller: address, label: "Address", inputType: TextInputType.multiline, maxLines: 4),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black38),
            borderRadius: BorderRadius.circular(5.0)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Category", style: Theme.of(context).textTheme.subtitle1),
            DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              underline: Container(
                height: 2,
                // color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: <DropdownMenuItem<String>>[
                DropdownMenuItem<String>(
                  value: "None",
                  child: Text("None"),
                ),
                for(DropdownMenuItem<String> c in allCate) c,
              ],
            ),
          ],
        ),
      ),
      SizedBox(height: 60.0)
    ];
  }
}
