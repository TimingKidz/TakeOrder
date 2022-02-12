import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:invoice_manage/blocs/catalogBloc.dart';
import 'package:invoice_manage/blocs/orderBloc.dart';
import 'package:invoice_manage/model/item.dart';
import 'package:invoice_manage/utils/Formatters.dart';
import 'package:invoice_manage/widget/addItem_dialog.dart';
import 'package:invoice_manage/widget/catalogedit_dialog.dart';
import 'package:invoice_manage/widget/searchbar.dart';
import 'package:invoice_manage/widget/yesno_dialog.dart';

class CatalogPage extends StatefulWidget {
  final OrderBloc orderBloc;

  const CatalogPage({Key? key, required this.orderBloc}) : super(key: key);

  @override
  _CatalogPageState createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final catalogBloc = CatalogBloc();
  var itemName = TextEditingController();
  var itemPrice = TextEditingController();
  var listPrice = TextEditingController();
  var qty = TextEditingController();
  final SlidableController slidableController = SlidableController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      catalogBloc.isShowKeyboardToggle(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: catalogBloc.isHaveItemSelected,
        builder: (context, isHaveItemSelectedSnapshot) {
          bool isHaveItemSelected = isHaveItemSelectedSnapshot.data ?? false;
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isHaveItemSelected
                    ? isHaveItemSelectedAppBar()
                    : AppBar(
                        key: ValueKey<int>(1),
                        title: Text("Select Item(s) from Catalog"),
                      ),
              ),
            ),
            floatingActionButton: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(child: child, scale: animation),
              child: isHaveItemSelected
                  ? fabAddToOrder()
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: FloatingActionButton.extended(
                        onPressed: () => addItem(),
                        icon: Icon(Icons.add),
                        label: Text("New Item"),
                      ),
                    ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: Column(
              children: [
                StreamBuilder<TextEditingController>(
                    stream: catalogBloc.searchTextEditingController,
                    builder: (context, snapshot) {
                      return Container(
                        padding: const EdgeInsets.all(8.0),
                        color: Theme.of(context).canvasColor,
                        child: SearchBar(
                            bloc: catalogBloc, blocSearchText: snapshot.data),
                      );
                    }),
                StreamBuilder<List<Item>>(
                    stream: catalogBloc.catalog,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Item>> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isNotEmpty) {
                          return Expanded(
                            child: ListView.separated(
                              controller: _scrollController,
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.only(bottom: 92),
                              itemCount: snapshot.data?.length ?? 0,
                              separatorBuilder: (_, index) {
                                return Divider(thickness: 1.5, height: 1.5);
                              },
                              itemBuilder: (BuildContext context, int index) {
                                return Slidable(
                                  key: Key(snapshot.data![index].itemName),
                                  controller: slidableController,
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.25,
                                  enabled: !isHaveItemSelected,
                                  child: ListTile(
                                    title: Text(snapshot.data![index].itemName),
                                    trailing: Text(NumberFormat.currency(
                                            symbol: "", decimalDigits: 2)
                                        .format(
                                            snapshot.data![index].itemPrice)),
                                    // onTap: () =>
                                    //     addItemToOrder(snapshot.data![index]),
                                    onTap: () {
                                      catalogBloc
                                          .setIsSelected(snapshot.data![index]);
                                    },
                                    selected:
                                        snapshot.data![index].isSelected ??
                                            false,
                                    selectedColor: Colors.black,
                                    selectedTileColor: Colors.black12,
                                  ),
                                  secondaryActions: <Widget>[
                                    IconSlideAction(
                                      caption: 'Edit',
                                      color: Colors.black45,
                                      icon: Icons.edit,
                                      onTap: () =>
                                          editItem(snapshot.data![index]),
                                    ),
                                    IconSlideAction(
                                      caption: 'Delete',
                                      color: Colors.red,
                                      icon: Icons.delete,
                                      onTap: () =>
                                          deleteItem(snapshot.data![index]),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        } else {
                          return Expanded(
                              child: Center(
                                  child: Text(
                                      "No item in catalog, please add your first item.")));
                        }
                      } else {
                        return Expanded(
                            child: Center(child: CircularProgressIndicator()));
                      }
                    }),
              ],
            ),
          );
        });
  }

  AppBar isHaveItemSelectedAppBar() {
    return AppBar(
      key: ValueKey<int>(0),
      elevation: 2,
      leading: IconButton(
          icon: Icon(Icons.clear), onPressed: catalogBloc.clearSelectedItems),
      title: Text(
          "${catalogBloc.selectedItem.length.toString()} item(s) selected"),
      backgroundColor: Colors.orange,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      foregroundColor: Colors.white,
    );
  }

  Widget fabAddToOrder() {
    return IntrinsicHeight(
      child: Card(
        elevation: 6,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        color: Colors.orange,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton.icon(
              label: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
                child: Text("Add to order"),
              ),
              icon: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(Icons.add),
              ),
              onPressed: () => addItemToOrder(),
              style: ButtonStyle(
                  foregroundColor:
                  MaterialStateProperty.all<Color>(Colors.white),
                  overlayColor: MaterialStateProperty.all(Colors.black12)),
            ),
            VerticalDivider(thickness: 1.5, width: 1.5, color: Colors.white24),
            TextButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("QTY: 1"),
              ),
              onPressed: () {
                // TODO: Implement QTY dialog.
              },
              style: ButtonStyle(
                  foregroundColor:
                  MaterialStateProperty.all<Color>(Colors.white),
                  overlayColor: MaterialStateProperty.all(Colors.black12)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addItemToOrder() async {
    await widget.orderBloc.addAllToOrder(catalogBloc.selectedItem);
    catalogBloc.clearSelectedItems();
  }

  Future<void> addItem() async {
    String t = await showDialog(
        context: context,
        builder: (BuildContext context) =>
            AddItemDialog(itemName: itemName, listPrice: itemPrice)) ??
        "Cancel";
    if (t == "Add") {
      double itemP =
      itemPrice.text.isNotEmpty ? double.parse(itemPrice.text) : 0;
      Item item = Item(itemName: itemName.text, itemPrice: itemP);
      catalogBloc.add(item);
    }
    itemName.clear();
    itemPrice.clear();
  }

  Future<void> editItem(Item item) async {
    itemName.text = item.itemName;
    itemPrice.text = textFieldPriceFormatter(item.itemPrice);
    String t = await showDialog(
        context: context,
        builder: (BuildContext context) =>
            CatalogEditDialog(itemName: itemName, itemPrice: itemPrice)) ??
        "Cancel";
    if (t == "Update") {
      double itemP =
      itemPrice.text.isNotEmpty ? double.parse(itemPrice.text) : 0;
      Item newItem = Item(itemName: itemName.text, itemPrice: itemP);
      catalogBloc.update(item, newItem);
    }
    itemName.clear();
    itemPrice.clear();
  }

  Future<void> deleteItem(Item item) async {
    String t = await showDialog(
        context: context,
        builder: (BuildContext context) =>
            YesNoDialog(title: 'Delete Item ${item.itemName}')) ??
        "Cancel";
    if (t == "Yes") {
      catalogBloc.delete(item);
    }
  }
}
