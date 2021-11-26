import 'package:flutter/material.dart';
import 'package:invoice_manage/blocs/categoriesBloc.dart';
import 'package:invoice_manage/blocs/memoBloc.dart';
import 'package:invoice_manage/model/memo.dart';
import 'package:invoice_manage/widget/yesno_dialog.dart';

class MemoViewPage extends StatefulWidget {
  final MemoBloc memoBloc;
  final CategoriesBloc cateBloc;

  const MemoViewPage({Key? key, required this.memoBloc, required this.cateBloc}) : super(key: key);

  @override
  _MemoViewPageState createState() => _MemoViewPageState();
}

class _MemoViewPageState extends State<MemoViewPage> {
  late Memo temp;
  final content = TextEditingController();
  String dropdownValue = "None";

  @override
  void initState() {
    super.initState();
    temp = widget.memoBloc.fMemo;
    content.text = temp.memoContent ?? "";
    dropdownValue = temp.memoCateName ?? "None";
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> allCate = widget.cateBloc.genDropdownMenu();
    temp = widget.memoBloc.fMemo;
    content.text = temp.memoContent ?? "";
    return WillPopScope(
      onWillPop: () async {
        int? cateID = dropdownValue == "None"
            ? null
            : widget.cateBloc.all.firstWhere((element) => element.cateName == dropdownValue).cateID;
        Memo memo = Memo(
            memoContent: content.text,
            memoCateID: cateID
        );
        widget.memoBloc.update(temp, memo);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            // IconButton(
            //   onPressed: () => Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => AddOrEditMemo(memoBloc: widget.memoBloc, memoToEdit: temp)),
            //   ).then((value) {
            //     if (value != null) {
            //       setState(() {
            //         widget.memoBloc.fMemo = value;
            //       });
            //     }
            //   }),
            //   icon: Icon(Icons.edit),
            //   tooltip: "Edit",
            // ),
            Center(
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
            IconButton(
              onPressed: () => deleteMemo(temp),
              icon: Icon(Icons.delete),
              tooltip: "Delete",
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextFormField(
            expands: true,
            controller: content,
            style: Theme.of(context).textTheme.headline6,
            decoration: InputDecoration.collapsed(
              hintText: "Content ...",
            ),
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
        ),
      ),
    );
  }

  Future<void> deleteMemo(Memo m) async {
    String t = await showDialog(
        context: context,
        builder: (BuildContext context) => YesNoDialog(title: 'Delete this memo.')
    ) ?? "Cancel";
    if(t == "Yes") {
      widget.memoBloc.delete(m);
      Navigator.of(context).pop();
    }
  }
}
