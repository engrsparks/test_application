import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../models/daily_sales_model.dart';

class DailySalesTile extends StatefulWidget {
  final DailySalesModel dailySalesModelTile;
  const DailySalesTile({Key? key, required this.dailySalesModelTile})
      : super(key: key);

  @override
  State<DailySalesTile> createState() => DailySalesTileState();
}

class DailySalesTileState extends State<DailySalesTile> {
  bool _expand = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 8,
          child: SizedBox(
            height: 8.5.h,
            child: Padding(
              padding: EdgeInsets.all(3.sp),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Text(
                            'Cash: ₱ ' +
                                NumberFormat()
                                    .format(widget.dailySalesModelTile.cash),
                            style:
                            TextStyle(fontFamily: 'Quicksand', fontSize: 8.sp),
                          )),


                      Expanded(
                          child: Text(
                            'Number of Products Sold: ' +
                                NumberFormat().format(
                                    widget.dailySalesModelTile.numberOfProducts),
                            style:
                            TextStyle(fontFamily: 'Quicksand', fontSize: 8.sp),
                          )),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('MMMM dd, yyyy')
                            .format(widget.dailySalesModelTile.dateTime),
                        // DateFormat.yMMMd()
                        //     .format(widget.dailySalesModelTile.dateTime),
                        style:
                        TextStyle(fontFamily: 'Quicksand', fontSize: 8.sp),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              _expand = !_expand;
                            });
                          },
                          icon: Icon(
                            _expand ? Icons.expand_less : Icons.expand_more,
                            size: 12.sp,
                          )),

                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
        if (_expand)
          Container(
            padding: EdgeInsets.all(5.0.sp),
            height: min(
                widget.dailySalesModelTile.soldProducts.length * 20.h + 10.0,
                180),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: widget.dailySalesModelTile.soldProducts
                        .map((e) => Column(
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e.index.toString(),
                              style: TextStyle(
                                  fontSize: 8.sp,
                                  fontFamily: 'Quicksand'),
                            ),
                            Text('QTY: ${e.numberOfProducts}',
                                style: TextStyle(
                                    fontSize: 8.sp,
                                    fontFamily: 'Quicksand'))
                          ],
                        )
                      ],
                    ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
