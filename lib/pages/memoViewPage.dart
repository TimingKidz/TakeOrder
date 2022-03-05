import 'package:flutter/material.dart';
import 'package:invoice_manage/blocs/EachMemoBloc.dart';
import 'package:invoice_manage/blocs/categoriesBloc.dart';
import 'package:invoice_manage/model/memo.dart';
import 'package:invoice_manage/widget/yesno_dialog.dart';

class MemoViewPage extends StatefulWidget {
  final CategoriesBloc cateBloc;
  final Memo memo;

  const MemoViewPage({Key? key, required this.cateBloc, required this.memo})
      : super(key: key);

  @override
  _MemoViewPageState createState() => _MemoViewPageState();
}

class _MemoViewPageState extends State<MemoViewPage> {
  late final EachMemoBloc _eachMemoBloc;
  late Memo temp;
  final content = TextEditingController();
  String dropdownValue = "None";

  @override
  void initState() {
    super.initState();
    _eachMemoBloc = EachMemoBloc(widget.memo);
    temp = _eachMemoBloc.fMemo;
    content.text = temp.memoContent ?? "";
    dropdownValue = temp.memoCateName ?? "None";
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> allCate = widget.cateBloc.genDropdownMenu();
    return StreamBuilder<Memo>(
        stream: _eachMemoBloc.memo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Memo _memo = snapshot.data!;
            return WillPopScope(
              onWillPop: () async {
                if(content.text.isEmpty) {
                  await _eachMemoBloc.delete(_memo);
                  Navigator.pop(context, true);
                }else{
                  Navigator.pop(context, false);
                }
                _eachMemoBloc.dispose();
                return false;
              },
              child: Scaffold(
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.orange,
                  onPressed: () async {
                    if (content.text == _eachMemoBloc.fMemo.memoContent &&
                        _eachMemoBloc.fMemoEdited == null) {
                      Navigator.pop(context, false);
                    }else if(content.text.isEmpty){
                      await _eachMemoBloc.delete(_memo);
                      Navigator.pop(context, true);
                    }else{
                      _eachMemoBloc.setMemoContent(content.text);
                      await _eachMemoBloc.update();
                      Navigator.pop(context, true);
                    }
                    _eachMemoBloc.dispose();
                  },
                  child: Icon(Icons.check),
                ),
                appBar: AppBar(
                  actions: [
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
                          value: _memo.memoCateName ?? "None",
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          underline: Container(
                            height: 2,
                            // color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? newValue) {
                            int? cateID = newValue == "None"
                                ? null
                                : widget.cateBloc.all
                                .firstWhere((element) =>
                            element.cateName == newValue)
                                .cateID;
                            _eachMemoBloc.setMemoCategory(newValue!, cateID!);
                          },
                          items: <DropdownMenuItem<String>>[
                            DropdownMenuItem<String>(
                              value: "None",
                              child: Text("None"),
                            ),
                            for (DropdownMenuItem<String> c in allCate) c,
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
          } else {
            _eachMemoBloc.getMemo(widget.memo);
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
        });
  }

  Future<void> deleteMemo(Memo m) async {
    String t = await showDialog(
            context: context,
            builder: (BuildContext context) =>
                YesNoDialog(title: 'Delete this memo.')) ??
        "Cancel";
    if (t == "Yes") {
      _eachMemoBloc.delete(m);
      Navigator.of(context).pop(true);
    }
  }
}
