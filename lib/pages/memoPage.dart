import 'package:flutter/material.dart';
import 'package:invoice_manage/blocs/categoriesBloc.dart';
import 'package:invoice_manage/blocs/memoBloc.dart';
import 'package:invoice_manage/model/catagories.dart';
import 'package:invoice_manage/model/memo.dart';
import 'package:invoice_manage/pages/addMemoPage.dart';
import 'package:invoice_manage/pages/categoriesPage.dart';
import 'package:invoice_manage/pages/memoViewPage.dart';
import 'package:invoice_manage/widget/searchbar.dart';

import '../main.dart';

class MemoPage extends StatefulWidget {
  const MemoPage({Key? key}) : super(key: key);

  @override
  _MemoPageState createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  final cateBloc = CategoriesBloc();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    memoBloc = MemoBloc();
    _scrollController.addListener(() {
      memoBloc.isShowKeyboardToggle(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Memos"),
        actions: [
          StreamBuilder<List<Categories>>(
              stream: cateBloc.categories,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Categories>> snapshot) {
                return StreamBuilder<List<Memo>>(
                    stream: memoBloc.memo,
                    builder: (context, _) {
                      List<DropdownMenuItem<String>> allCate =
                          cateBloc.genDropdownMenu();
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
                              value: memoBloc.dropdownValue,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              underline: Container(
                                height: 2,
                                // color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String? newValue) {
                                if (newValue == "Edit Categories...") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CategoriesPage(
                                            cateBloc: cateBloc,
                                            memoBloc: memoBloc)),
                                  );
                                } else {
                                  memoBloc.dropdownValue = newValue!;
                                  memoBloc.filter();
                                }
                              },
                              items: <DropdownMenuItem<String>>[
                                DropdownMenuItem<String>(
                                  value: "All",
                                  child: Text("All"),
                                ),
                                for (DropdownMenuItem<String> c in allCate) c,
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
                    });
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AddMemo(memoBloc: memoBloc, cateBloc: cateBloc)),
        ),
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(20.0)),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: SearchBar(bloc: memoBloc),
            ),
          ),
          StreamBuilder<List<Memo>>(
              stream: memoBloc.memo,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Memo>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return Expanded(
                      child: ListView.separated(
                        controller: _scrollController,
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.only(bottom: 92),
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(
                                memoBloc.memoTitle(
                                    snapshot.data![index].memoContent ?? ""),
                                overflow: TextOverflow.ellipsis),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MemoViewPage(
                                        cateBloc: cateBloc,
                                        memo: snapshot.data![index])),
                              ).then((value) {
                                if (value != null && value) {
                                  memoBloc.getMemo();
                                }
                              });
                            },
                          );
                        },
                        separatorBuilder: (_, index) {
                          return Divider(thickness: 1.5, height: 1.5);
                        },
                      ),
                    );
                  } else {
                    return Expanded(child: Center(child: Text("No memo.")));
                  }
                } else {
                  return Expanded(
                      child: Center(child: CircularProgressIndicator()));
                }
              }),
        ],
      ),
    );
  }
}
