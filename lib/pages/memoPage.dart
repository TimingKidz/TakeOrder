import 'package:flutter/material.dart';
import 'package:invoice_manage/blocs/categoriesBloc.dart';
import 'package:invoice_manage/blocs/memoBloc.dart';
import 'package:invoice_manage/model/catagories.dart';
import 'package:invoice_manage/model/memo.dart';
import 'package:invoice_manage/pages/addOrEditMemoPage.dart';
import 'package:invoice_manage/pages/categoriesPage.dart';
import 'package:invoice_manage/pages/memoViewPage.dart';
import 'package:invoice_manage/widget/searchbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemoPage extends StatefulWidget {
  const MemoPage({Key? key}) : super(key: key);

  @override
  _MemoPageState createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  final memoBloc = MemoBloc();
  final cateBloc = CategoriesBloc();
  // String dropdownValue = "All";

  @override
  void initState() {
    super.initState();
    // init();
  }

  // init() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String f = prefs.getString("cate") ?? "All";
  //   print("page: $f");
  //   dropdownValue = f;
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Memos"),
        actions: [
          StreamBuilder<List<Categories>>(
              stream: cateBloc.categories,
              builder: (BuildContext context, AsyncSnapshot<List<Categories>> snapshot) {
                return StreamBuilder<List<Memo>>(
                    stream: memoBloc.memo,
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
                              value: memoBloc.dropdownValue,
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
                                    MaterialPageRoute(builder: (context) => CategoriesPage(cateBloc: cateBloc, memoBloc: memoBloc)),
                                  );
                                }else{
                                  memoBloc.dropdownValue = newValue!;
                                  memoBloc.filter();
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
        backgroundColor: Colors.orange,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddOrEditMemo(memoBloc: memoBloc, cateBloc: cateBloc)),
        ),
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: SearchBar(bloc: memoBloc),
            ),
          ),
          StreamBuilder<List<Memo>>(
            stream: memoBloc.memo,
            builder: (BuildContext context, AsyncSnapshot<List<Memo>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  return Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.only(bottom: 92),
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(memoTitle(snapshot.data![index].memoContent ?? ""), overflow: TextOverflow.ellipsis),
                          // subtitle: Text(snapshot.data![index].memoContent ?? "", maxLines: 4),
                          onTap: () {
                            memoBloc.fMemo = snapshot.data![index];
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MemoViewPage(memoBloc: memoBloc, cateBloc: cateBloc)),
                            );
                          },
                        );
                      },
                      separatorBuilder: (_, index) {
                        return Divider(thickness: 1.5);
                      },
                    ),
                  );
                }else{
                  return Expanded(child: Center(child: Text("No memo.")));
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

  String memoTitle(String s) {
    int idx = s.indexOf("\n");
    print(idx);
    if(idx < 0){
      // if(s.length > 10) s = s.substring(0, 20).trim();
    }else{
      s = s.substring(0,idx).trim();
    }
    print(s);
    return s;
  }
}
