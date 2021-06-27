import 'package:flutter/material.dart';
import 'package:invoice_manage/blocs/categoriesBloc.dart';
import 'package:invoice_manage/blocs/memoBloc.dart';
import 'package:invoice_manage/model/memo.dart';

class AddOrEditMemo extends StatefulWidget {
  final MemoBloc memoBloc;
  final CategoriesBloc cateBloc;
  final Memo? memoToEdit;

  const AddOrEditMemo({Key? key, required this.memoBloc, this.memoToEdit, required this.cateBloc}) : super(key: key);

  @override
  _AddOrEditMemoState createState() => _AddOrEditMemoState();
}

class _AddOrEditMemoState extends State<AddOrEditMemo> {
  bool isAddTrue = true;
  String dropdownValue = "None";

  var content = TextEditingController();

  @override
  void initState() {
    super.initState();
    isAddTrue = widget.memoToEdit == null ? true : false;
    if(!isAddTrue){
      content.text = widget.memoToEdit?.memoContent ?? "";
      dropdownValue = widget.memoToEdit?.memoCateName ?? "None";
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> allCate = widget.cateBloc.genDropdownMenu();
    return Scaffold(
      appBar: AppBar(
        title: Text(isAddTrue ? "Add Memo" : "Edit Memo"),
        actions: [
          Padding(
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
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () async {
          int? cateID = dropdownValue == "None"
              ? null
              : widget.cateBloc.all.firstWhere((element) => element.cateName == dropdownValue).cateID;
          Memo memo = Memo(
              memoContent: content.text,
              memoCateID: cateID
          );
          isAddTrue ? await widget.memoBloc.add(memo) : await widget.memoBloc.update(widget.memoToEdit ?? Memo(), memo);
          Navigator.pop(context, memo);
        },
        child: Icon(Icons.check),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 92.0),
        child: TextFormField(
          scrollPhysics: BouncingScrollPhysics(),
          controller: content,
          style: Theme.of(context).textTheme.headline6,
          decoration: InputDecoration.collapsed(
            hintText: "Content ...",
          ),
          keyboardType: TextInputType.multiline,
          maxLines: null,
        ),
      ),
    );
  }
}
