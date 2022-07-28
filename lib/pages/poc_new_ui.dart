import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:invoice_manage/core/constants/spacing_constants.dart';
import 'package:invoice_manage/widget/circle_icon_border_button.dart';

import '../core/localize/localize_en.dart';
import '../features/summary/presenter/summary_provider.dart';
import '../model/order_item.dart';

class PocNewUI extends ConsumerWidget {
  const PocNewUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double summary =
        ref.watch(summaryDisplayProvider.select((value) => value.totals));
    List<OrderItem> summaryItem = ref.watch(
        summaryDisplayProvider.select((summary) => summary.orderItemList));

    Widget bottomContent = Padding(
        padding: const EdgeInsets.symmetric(horizontal: spacingNormal),
        child: Row(
          textBaseline: TextBaseline.alphabetic,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(summaryTotal, style: Theme.of(context).textTheme.headline6),
            Flexible(
              child: Text(
                  NumberFormat.currency(symbol: "", decimalDigits: 2)
                      .format(summary),
                  style: Theme.of(context).textTheme.headline6,
                  overflow: TextOverflow.visible),
            )
          ],
        ));

    Widget cardView = Card(
      margin: const EdgeInsets.all(spacingSmallX),
      elevation: spacingZero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: Colors.black12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                spacingSmall, spacingSmallX, spacingSmall, spacingSmallXX),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: spacingSmallX),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text("Take An Order!",
                              style: Theme.of(context).textTheme.headline6,
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              softWrap: false),
                        ),
                        SizedBox(width: spacingSmallXXX),
                        Icon(Icons.navigate_next)
                      ],
                    ),
                  ),
                ),
                SizedBox(width: spacingSmallX),
                OutlinedButton(
                  child: Text("Clear",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold)),
                  onPressed: () => {},
                  style: OutlinedButton.styleFrom(
                    primary: Colors.redAccent,
                    shape: StadiumBorder(),
                    side: BorderSide(width: 1.5, color: Colors.red),
                  ),
                )
              ],
            ),
          ),
          Divider(height: spacingZero),
          Expanded(
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                ListView.separated(
                  padding: const EdgeInsets.only(bottom: 48),
                  itemCount: summaryItem.length + 1,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == summaryItem.length) {
                      return Center(
                          child: Padding(
                        padding: const EdgeInsets.all(spacingSmallXX),
                        child: Text("${summaryItem.length} items",
                            style: Theme.of(context).textTheme.caption),
                      ));
                    }
                    OrderItem data = summaryItem.elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: spacingSmallX, horizontal: spacingSmall),
                      child: Row(
                        children: [
                          Container(
                              margin:
                                  const EdgeInsets.only(left: spacingSmallXX),
                              constraints: BoxConstraints(minWidth: 28),
                              child: Text("${data.qty}")),
                          SizedBox(width: spacingSmallX),
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(data.itemName,
                                          overflow: TextOverflow.visible),
                                      Text(
                                          NumberFormat.currency(
                                                  symbol: "", decimalDigits: 2)
                                              .format(data.subTotal),
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption),
                                    ],
                                  ),
                                ),
                                SizedBox(width: spacingSmallXX),
                                Text(NumberFormat.currency(
                                        symbol: "", decimalDigits: 2)
                                    .format(data.subTotal)),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (_, index) {
                    return Divider(
                        height: spacingZero,
                        indent: spacingSmall,
                        endIndent: spacingSmall);
                  },
                ),
                Container(
                  height: 40,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white, Colors.white.withAlpha(0)],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter)),
                ),
                bottomContent,
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                spacingZero, spacingZero, spacingSmall, spacingSmallX),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(width: 12.0),
                        OutlinedButton(
                          child: Text("Cash Sale",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          onPressed: () => {},
                          style: OutlinedButton.styleFrom(
                            primary: Colors.black12,
                            backgroundColor: Colors.indigo,
                            shape: StadiumBorder(),
                            side: BorderSide(width: 1.5, color: Colors.indigo),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        OutlinedButton(
                          child: Text("Invoice",
                              style: TextStyle(
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.bold)),
                          onPressed: () => {},
                          style: OutlinedButton.styleFrom(
                            primary: Colors.black12,
                            shape: StadiumBorder(),
                            side: BorderSide(width: 1.5, color: Colors.indigo),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                CircleIconBorderButton(
                  iconData: Icons.add,
                  iconColor: Colors.white,
                  backgroundColor: Colors.indigo,
                  borderColor: Colors.indigo,
                )
              ],
            ),
          )
        ],
      ),
    );

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: PageView(
                children: [
                  cardView,
                  cardView,
                  Card(
                    margin: const EdgeInsets.all(spacingSmallX),
                    elevation: spacingZero,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(color: Colors.black12)),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, size: 48),
                          SizedBox(height: spacingNormal),
                          Text("Add New Order",
                              style: Theme.of(context).textTheme.headline6)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(width: spacingSmallX),
                        CircleIconBorderButton(iconData: Icons.add),
                        SizedBox(width: spacingSmallX),
                        CircleIconBorderButton(
                            iconData: Icons.delete_outline_rounded),
                        SizedBox(width: spacingSmallX),
                        CircleIconBorderButton(iconData: Icons.ios_share),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleIconBorderButton(
                        iconData: Icons.chevron_left_rounded,
                        padding: spacingSmallXX),
                    SizedBox(width: spacingSmallX),
                    InkWell(
                      customBorder: StadiumBorder(),
                      onTap: () => {},
                      child: Ink(
                        child: Row(
                          textBaseline: TextBaseline.alphabetic,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            Ink(
                              child: Text("1",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              decoration: ShapeDecoration(
                                color: Theme.of(context).canvasColor,
                                shape: StadiumBorder(
                                    side: BorderSide(color: Colors.black12)),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: spacingSmallXX,
                                  vertical: spacingSmallXXX),
                            ),
                            Text(" /"),
                            Text("2")
                          ],
                        ),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: StadiumBorder(
                              side: BorderSide(color: Colors.black12)),
                        ),
                        padding: EdgeInsets.all(spacingSmallX),
                      ),
                    ),
                    SizedBox(width: spacingSmallX),
                    CircleIconBorderButton(
                        iconData: Icons.chevron_right_rounded,
                        padding: spacingSmallXX),
                    SizedBox(width: spacingSmallX)
                  ],
                )
              ],
            ),
            SizedBox(height: spacingSmallX),
            Divider(height: spacingZero, color: Colors.black12, thickness: 1)
          ],
        ),
      ),
    );
  }
}
