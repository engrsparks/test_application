
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../models/sales_model.dart';
import '../../models/system_reports_model.dart';


class SalesTile extends StatefulWidget {
  final SalesModel salesModelTile;
  const SalesTile({Key? key, required this.salesModelTile}) : super(key: key);

  @override
  State<SalesTile> createState() => _SalesTileState();
}

class _SalesTileState extends State<SalesTile> {
  bool _expand = false;

  final Color _pressedColor = Colors.black12;
  final Color _unPressedColor = Colors.white;
  final TextEditingController _authorizationCodeController =
  TextEditingController();
  final String _authorizationCode = '1010';


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: widget.salesModelTile.isSelected
              ? _unPressedColor
              : _pressedColor,
          elevation: 8,
          child: SizedBox(
            height: 6.h,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  widget.salesModelTile.isSelected =
                  !widget.salesModelTile.isSelected;
                });

                !widget.salesModelTile.isSelected
                    ? Provider.of<SalesModelProvider>(context, listen: false)
                    .addSalesComputation(
                    widget.salesModelTile.index,
                    widget.salesModelTile.customerName,
                    widget.salesModelTile.cash,
                    widget.salesModelTile.discount,
                    widget.salesModelTile.gross,
                    widget.salesModelTile.soldProducts,
                    widget.salesModelTile.numberOfProducts,
                    widget.salesModelTile.deliveryCharge,
                    widget.salesModelTile.address,widget.salesModelTile.id!
                )
                    : Provider.of<SalesModelProvider>(context, listen: false)
                    .removeSalesCalculation(widget.salesModelTile.index);
              },
              child: Padding(
                padding: EdgeInsets.all(3.sp),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.salesModelTile.index.toString(),
                          style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          width: 3.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Expanded(
                                child: Text(
                                  'Cash: ₱ ' +
                                      NumberFormat()
                                          .format(widget.salesModelTile.cash),
                                  style: TextStyle(
                                    fontFamily: 'Quicksand',
                                    fontSize: 8.sp,
                                  ),
                                )),

                            Expanded(
                                child: Text(
                                  'Discount: ₱ ' +
                                      NumberFormat()
                                          .format(widget.salesModelTile.discount),
                                  style: TextStyle(
                                      fontFamily: 'Quicksand', fontSize: 8.sp),
                                )),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.salesModelTile.customerName.toString(),
                          style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          DateFormat().format(widget.salesModelTile.dateTime),
                          style: TextStyle(
                              fontFamily: 'Quicksand', fontSize: 7.sp),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      Text(
                          'Paid',
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 8.sp,
                              fontFamily: 'Quicksand',
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w700),
                        ),

                        SizedBox(
                          width: 1.w,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              children: [

                                Expanded(
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _expand = !_expand;
                                        });
                                      },
                                      icon: Icon(
                                        _expand
                                            ? Icons.expand_less
                                            : Icons.expand_more,
                                        size: 12.sp,
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            IconButton(
                                onPressed: () async {
                                  await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.warning,
                                              size: 20.sp,
                                            ),
                                            SizedBox(
                                              width: 2.w,
                                            ),
                                            Text(
                                              'WARNING!',
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontFamily: 'Quicksand'),
                                            ),
                                          ],
                                        ),
                                        content:
                                        Builder(builder: (context) {
                                          return SizedBox(
                                            height: 18.h,
                                            width: 50.w,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(
                                                        5.0.sp),
                                                    child: TextField(
                                                      keyboardType: TextInputType.number,
                                                      obscureText: true,
                                                      controller:
                                                      _authorizationCodeController,
                                                      style: TextStyle(

                                                          fontSize: 10.sp,
                                                          fontFamily:
                                                          'Quicksand'),
                                                      decoration: InputDecoration(
                                                          hintText:
                                                          'Enter Authorization Code',
                                                          hintStyle:
                                                          TextStyle(
                                                              fontSize:
                                                              10.sp)),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    EdgeInsets.only(
                                                        top: 4.h),
                                                    child: Container(
                                                      height: 5.h,
                                                      width: 18.w,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .all(Radius
                                                              .circular(
                                                              20)),
                                                          gradient:
                                                          LinearGradient(
                                                              colors: const [
                                                                Colors.purple,
                                                                Colors.red
                                                              ])),
                                                      child: TextButton(
                                                        onPressed: () {
                                                          if (_authorizationCodeController
                                                              .text ==
                                                              _authorizationCode) {
                                                            Provider.of<SystemReportsModelProvider>(
                                                                context,
                                                                listen:
                                                                false)
                                                                .addReport(
                                                                '(transaction) Customer name ${widget.salesModelTile.customerName} with invoice number ${widget.salesModelTile.index} was removed in the sales section last,');
                                                            Provider.of<SalesModelProvider>(
                                                                context,
                                                                listen:
                                                                false)
                                                                .deleteSalesTileData(widget
                                                                .salesModelTile
                                                                .index, widget.salesModelTile.id!);
                                                            _authorizationCodeController
                                                                .clear();
                                                            Navigator.of(
                                                                context)
                                                                .pop();
                                                          } else {
                                                            Navigator.of(
                                                                context)
                                                                .pop();
                                                          }
                                                        },
                                                        child: Text(
                                                          'Confirm',
                                                          style: TextStyle(
                                                              fontSize:
                                                              10.sp,
                                                              fontFamily:
                                                              'Quicksand',
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                      ));
                                },
                                icon: Icon(
                                  Icons.remove,
                                  size: 10.sp,
                                )),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_expand)
          Container(
            padding: EdgeInsets.all(5.0.sp),
            height: min(
                widget.salesModelTile.soldProducts.length * 20.h + 10.0, 180),
            child: Column(
              children: [
                Row(
                  children: [
                    widget.salesModelTile.deliveryCharge == 0
                        ? Container()
                        : Text(
                      'Delivery Fee: ₱ ' +
                          NumberFormat().format(
                              widget.salesModelTile.deliveryCharge),
                      style: TextStyle(fontSize: 7.5.sp),
                    ),
                    Spacer(),
                    Text(widget.salesModelTile.address,
                        style:
                        TextStyle(fontSize: 7.5.sp, fontFamily: 'Quicksand')),
                    Spacer(),
                  ],
                ),
                Expanded(
                  child: ListView(
                    children: widget.salesModelTile.soldProducts
                        .map((e) => Column(
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e.name,
                              style: TextStyle(
                                  fontSize: 7.5.sp,
                                  fontFamily: 'Quicksand'),
                            ),
                            Text('${e.quantity} x ₱ ${e.price}',
                                style: TextStyle(
                                    fontSize: 7.5.sp,
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
