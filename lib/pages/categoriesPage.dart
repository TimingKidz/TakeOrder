import 'package:flutter/material.dart';
import 'package:invoice_manage/blocs/categoriesBloc.dart';
import 'package:invoice_manage/blocs/customerBloc.dart';
import 'package:invoice_manage/blocs/memoBloc.dart';
import 'package:invoice_manage/model/catagories.dart';
import 'package:invoice_manage/widget/addCate_dialog.dart';
import 'package:invoice_manage/widget/editCate_dialog.dart';

class CategoriesPage extends StatefulWidget {
  final CategoriesBloc cateBloc;
  final CustomerBloc? cusBloc;
  final MemoBloc? memoBloc;

  const CategoriesPage({Key? key, required this.cateBloc, this.cusBloc, this.memoBloc}) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  var name = TextEditingController();
  bool isCus = true;

  @override
  void initState() {
    super.initState();
    isCus = widget.memoBloc == null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Categories"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addCate(),
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<List<Categories>>(
        stream: widget.cateBloc.categories,
        builder: (BuildContext context, AsyncSnapshot<List<Categories>> snapshot) {
          if(widget.cateBloc.all.isNotEmpty){
            return ListView.separated(
              padding: EdgeInsets.only(bottom: 92),
              itemCount: widget.cateBloc.all.length,
              itemBuilder: (BuildContext context, int index) {
                Categories data = widget.cateBloc.all[index];
                return ListTile(
                  title: Text(data.cateName),
                  onTap: () => editCate(data),
                );
              },
              separatorBuilder: (_, index) {
                return Divider(thickness: 2);
              },
            );
          }else{
            return Center(child: Text("No category yet."));
          }
        },
      ),
    );
  }

  Future<void> addCate() async {
    String t = await showDialog(
        context: context,
        builder: (BuildContext context) => AddCateDialog(name: name)
    ) ?? "Cancel";

    if(t == "Add") widget.cateBloc.add(Categories(cateName: name.text));

    name.clear();
  }

  Future<void> editCate(Categories cate) async {
    name.text = cate.cateName;

    String t = await showDialog(
        context: context,
        builder: (BuildContext context) => EditCateDialog(name: name)
    ) ?? "Cancel";

    if(t == "Update") {
      widget.cateBloc.update(cate, Categories(cateName: name.text));
      isCus ? widget.cusBloc?.getCustomer() : widget.memoBloc?.getMemo();
    } else if(t == "Delete") {
      widget.cateBloc.delete(cate);
      isCus ? widget.cusBloc?.getCustomer() : widget.memoBloc?.getMemo();
    }

    name.clear();
  }
}
