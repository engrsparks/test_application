import 'package:intl/intl.dart';
import '../../models/distribution_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../models/inventory_model.dart';
import '../../models/checkout_model.dart';
import '../../models/system_reports_model.dart';

class InventoryTile extends StatefulWidget {
  final InventoryModel inventoryModel;
  const InventoryTile({Key? key, required this.inventoryModel})
      : super(key: key);

  @override
  State<InventoryTile> createState() => _InventoryTileState();
}

class _InventoryTileState extends State<InventoryTile> {


  final TextEditingController _costController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _minQuantityController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  final TextEditingController _presentPriceController = TextEditingController();
  final TextEditingController _newPriceController = TextEditingController();

  final TextEditingController _authorizationCodeController =
  TextEditingController();
  final String _authorizationCode = '1010';



  @override
  Widget build(BuildContext context) {
    final _distributionProvider =
    Provider.of<DistributionModelProvider>(context);
    final _inventoryProvider = Provider.of<InventoryModelProvider>(context);
    final _checkOutProvider = Provider.of<CheckOutModelProvider>(context);

    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return Builder(builder: (context) {
                return AlertDialog(
                  title: Text(
                    'PURCHASE PRODUCT',
                    style: TextStyle(fontSize: 12.sp, fontFamily: 'Quicksand'),
                  ),
                  content: Builder(builder: (context) {
                    return SizedBox(
                      height: 27.h,
                      width: 50.w,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(5.0.sp),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: _quantityController,
                                style: TextStyle(fontSize: 10.sp),
                                decoration: InputDecoration(
                                    hintText: 'Quantity',
                                    hintStyle: TextStyle(
                                        fontSize: 10.sp,
                                        fontFamily: 'Quicksand')),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0.sp),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: _discountController,
                                style: TextStyle(fontSize: 10.sp),
                                decoration: InputDecoration(
                                    hintText: 'Discount (Optional)',
                                    hintStyle: TextStyle(
                                        fontSize: 10.sp,
                                        fontFamily: 'Quicksand')),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5.h),
                              child: Container(
                                height: 5.h,
                                width: 18.w,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                    gradient: LinearGradient(colors: const [
                                      Colors.purple,
                                      Colors.red
                                    ],
                                        begin: Alignment.bottomRight,
                                        end: Alignment.topLeft)),
                                child: TextButton(
                                  onPressed: () {
                                    if (_quantityController.text.isNotEmpty &&
                                        _discountController.text.isNotEmpty) {
                                      _inventoryProvider.purchaseProduct(
                                          widget.inventoryModel.name,
                                          widget.inventoryModel.cost,
                                          widget.inventoryModel.price,
                                          widget.inventoryModel.quantity,
                                          int.parse(_quantityController.text),
                                          widget.inventoryModel.index,
                                          widget.inventoryModel.minimumQuantity,widget.inventoryModel.id!
                                      );
                                      _checkOutProvider.addCheckOut(
                                          widget.inventoryModel.name,
                                          widget.inventoryModel.cost,
                                          (widget.inventoryModel.price -
                                              double.parse(
                                                  _discountController.text)),
                                          int.parse(_quantityController.text),
                                          double.parse(
                                              _discountController.text),
                                          widget.inventoryModel.quantity,
                                          widget.inventoryModel.index, widget.inventoryModel.minimumQuantity,widget.inventoryModel.id!);

                                      _quantityController.clear();
                                      _discountController.clear();
                                      Navigator.of(context).pop();
                                    } else if (_discountController
                                        .text.isEmpty &&
                                        _quantityController.text.isNotEmpty) {
                                      _inventoryProvider.purchaseProduct(
                                          widget.inventoryModel.name,
                                          widget.inventoryModel.cost,
                                          widget.inventoryModel.price,
                                          widget.inventoryModel.quantity,
                                          int.parse(_quantityController.text),
                                          widget.inventoryModel.index,  widget.inventoryModel.minimumQuantity,widget.inventoryModel.id!);
                                      _checkOutProvider.addCheckOut(
                                          widget.inventoryModel.name,
                                          widget.inventoryModel.cost,
                                          widget.inventoryModel.price,
                                          int.parse(_quantityController.text),
                                          0.0,
                                          widget.inventoryModel.quantity,
                                          widget.inventoryModel.index,  widget.inventoryModel.minimumQuantity,widget.inventoryModel.id!);

                                      _quantityController.clear();
                                      _discountController.clear();
                                      Navigator.of(context).pop();
                                    } else {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: Text(
                                    'Confirm',
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        fontFamily: 'Quicksand',
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              });
            });
      },
      child: Card(
        elevation: 8,
        child: SizedBox(
          height: 6.h,
          child: Padding(
            padding: EdgeInsets.all(3.sp),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [

                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Builder(builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      'RETURN / EDIT PRODUCT',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontFamily: 'Quicksand',
                                      ),
                                    ),
                                    content: Builder(builder: (context) {
                                      return SizedBox(
                                        height: 22.h,
                                        width: 50.w,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(5.0.sp),
                                                child: TextField(
                                                  keyboardType:
                                                  TextInputType.number,
                                                  controller:
                                                  _quantityController,
                                                  style: TextStyle(
                                                      fontSize: 10.sp),
                                                  decoration: InputDecoration(
                                                      hintText: 'Quantity',
                                                      hintStyle: TextStyle(
                                                          fontSize: 10.sp,
                                                          fontFamily:
                                                          'Quicksand')),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(5.0.sp),
                                                child: TextField(
                                                  keyboardType:
                                                  TextInputType.number,
                                                  controller:
                                                  _minQuantityController,
                                                  style: TextStyle(
                                                      fontSize: 10.sp),
                                                  decoration: InputDecoration(
                                                      hintText: 'Min Quantity',
                                                      hintStyle: TextStyle(
                                                          fontSize: 10.sp,
                                                          fontFamily:
                                                          'Quicksand')),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                EdgeInsets.only(top: 5.h),
                                                child: Container(
                                                  height: 5.h,
                                                  width: 18.w,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20)),
                                                      gradient: LinearGradient(
                                                          colors: const [
                                                            Colors.purple,
                                                            Colors.red
                                                          ],
                                                          begin: Alignment.bottomRight,
                                                          end: Alignment.topLeft)),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      if (_quantityController
                                                          .text.isNotEmpty && _minQuantityController
                                                          .text.isNotEmpty) {
                                                        _inventoryProvider.returnProduct(
                                                            widget
                                                                .inventoryModel
                                                                .name,
                                                            widget
                                                                .inventoryModel
                                                                .cost,
                                                            widget
                                                                .inventoryModel
                                                                .price,
                                                            widget
                                                                .inventoryModel
                                                                .quantity,
                                                            int.parse(
                                                                _quantityController
                                                                    .text),
                                                            widget
                                                                .inventoryModel
                                                                .index,  widget.inventoryModel.minimumQuantity,widget.inventoryModel.id!, int.parse(_minQuantityController.text));
                                                        Provider.of<SystemReportsModelProvider>(
                                                            context,
                                                            listen: false)
                                                            .addReport(
                                                            'There are ${_quantityController.text} products of ${widget.inventoryModel.name} that were returned last,');
                                                        _quantityController
                                                            .clear();

                                                        Navigator.of(context)
                                                            .pop();
                                                      } else {
                                                        Navigator.of(context)
                                                            .pop();
                                                      }
                                                    },
                                                    child: Text(
                                                      'Confirm',
                                                      style: TextStyle(
                                                          fontSize: 10.sp,
                                                          fontFamily:
                                                          'Quicksand',
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  );
                                });
                              });
                        },
                        icon: Icon(
                          Icons.keyboard_return_rounded,
                          size: 12.sp,
                        )),
                    SizedBox(
                      width: 5.w,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return Builder(builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    'ADD PRODUCT',
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        fontFamily: 'Quicksand'),
                                  ),
                                  content: Builder(builder: (context) {
                                    return SizedBox(
                                      height: 27.h,
                                      width: 50.w,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(5.0.sp),
                                              child: TextField(
                                                keyboardType:
                                                TextInputType.number,
                                                controller: _quantityController,
                                                style:
                                                TextStyle(fontSize: 10.sp),
                                                decoration: InputDecoration(
                                                    hintText:
                                                    'Product Quantity',
                                                    hintStyle: TextStyle(
                                                        fontSize: 10.sp,
                                                        fontFamily:
                                                        'Quicksand')),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(5.0.sp),
                                              child: TextField(
                                                keyboardType:
                                                TextInputType.number,
                                                controller: _costController,
                                                style:
                                                TextStyle(fontSize: 10.sp),
                                                decoration: InputDecoration(
                                                    hintText: 'Product Cost',
                                                    hintStyle: TextStyle(
                                                        fontSize: 10.sp,
                                                        fontFamily:
                                                        'Quicksand')),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              EdgeInsets.only(top: 5.h),
                                              child: Container(
                                                height: 5.h,
                                                width: 18.w,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            20)),
                                                    gradient: LinearGradient(
                                                        colors: const [
                                                          Colors.green,
                                                          Colors.yellow
                                                        ])),
                                                child: TextButton(
                                                  onPressed: () {
                                                    if (_quantityController
                                                        .text.isNotEmpty &&
                                                        _costController
                                                            .text.isNotEmpty) {
                                                      _inventoryProvider.addProduct(
                                                          widget.inventoryModel
                                                              .name,
                                                          widget.inventoryModel
                                                              .price,
                                                          widget.inventoryModel
                                                              .quantity,
                                                          int.parse(
                                                              _quantityController
                                                                  .text),
                                                          double.parse(
                                                              _costController
                                                                  .text),
                                                          widget.inventoryModel
                                                              .index,  widget.inventoryModel.minimumQuantity,widget.inventoryModel.id!);
                                                      _distributionProvider
                                                          .addDistribution(
                                                          widget.inventoryModel
                                                              .index,
                                                          widget
                                                              .inventoryModel
                                                              .name,
                                                          double.parse(
                                                              _costController
                                                                  .text),
                                                          widget
                                                              .inventoryModel
                                                              .price,
                                                          int.parse(
                                                              _quantityController
                                                                  .text));

                                                      _quantityController
                                                          .clear();
                                                      _costController.clear();
                                                      Navigator.of(context)
                                                          .pop();
                                                    } else {
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  },
                                                  child: Text(
                                                    'Confirm',
                                                    style: TextStyle(
                                                        fontSize: 10.sp,
                                                        fontFamily: 'Quicksand',
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                );
                              });
                            });
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Text(
                          'QTY. ' + widget.inventoryModel.quantity.toString(),
                          style: TextStyle(
                              color: widget.inventoryModel.quantity<widget.inventoryModel.minimumQuantity?Colors.red:Colors.black,
                              fontSize: 8.5.sp,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.inventoryModel.name,
                      style: TextStyle(
                          fontSize: 8.5.sp,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      widget.inventoryModel.index.toString(),
                      style: TextStyle(
                        fontSize: 6.5.sp,
                        fontFamily: 'Quicksand',

                      ),
                    ),

                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return Builder(builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    'UPDATE SRP PRICE',
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        fontFamily: 'Quicksand'),
                                  ),
                                  content: Builder(builder: (context) {
                                    return SizedBox(
                                      height: 27.h,
                                      width: 50.w,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(5.0.sp),
                                              child: TextField(
                                                keyboardType:
                                                TextInputType.number,
                                                controller:
                                                _presentPriceController,
                                                style:
                                                TextStyle(fontSize: 10.sp),
                                                decoration: InputDecoration(
                                                    hintText: 'Present Price',
                                                    hintStyle: TextStyle(
                                                        fontSize: 10.sp,
                                                        fontFamily:
                                                        'Quicksand')),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(5.0.sp),
                                              child: TextField(
                                                keyboardType:
                                                TextInputType.number,
                                                controller: _newPriceController,
                                                style:
                                                TextStyle(fontSize: 10.sp),
                                                decoration: InputDecoration(
                                                    hintText: 'New Price',
                                                    hintStyle: TextStyle(
                                                        fontSize: 10.sp,
                                                        fontFamily:
                                                        'Quicksand')),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              EdgeInsets.only(top: 5.h),
                                              child: Container(
                                                height: 5.h,
                                                width: 18.w,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            20)),
                                                    gradient: LinearGradient(
                                                        colors: const [
                                                          Colors.green,
                                                          Colors.yellow
                                                        ])),
                                                child: TextButton(
                                                  onPressed: () {
                                                    if (_presentPriceController
                                                        .text.isNotEmpty &&
                                                        _newPriceController
                                                            .text.isNotEmpty) {
                                                      try {
                                                        _inventoryProvider.changePrice(
                                                            widget
                                                                .inventoryModel
                                                                .name,
                                                            widget
                                                                .inventoryModel
                                                                .cost,
                                                            widget
                                                                .inventoryModel
                                                                .price,
                                                            double.parse(
                                                                _newPriceController
                                                                    .text),
                                                            widget
                                                                .inventoryModel
                                                                .quantity,
                                                            widget
                                                                .inventoryModel
                                                                .index,  widget.inventoryModel.minimumQuantity,widget.inventoryModel.id!);
                                                        Provider.of<SystemReportsModelProvider>(
                                                            context,
                                                            listen: false)
                                                            .addReport(
                                                            'There was a change in the price of ${widget.inventoryModel.name} from ₱ ${widget.inventoryModel.price} to ₱ ${double.parse(_newPriceController.text)} last,');
                                                        Navigator.of(context)
                                                            .pop();
                                                      } catch (e) {
                                                        Navigator.of(context)
                                                            .pop();
                                                      }
                                                    } else {
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  },
                                                  child: Text(
                                                    'Confirm',
                                                    style: TextStyle(
                                                        fontSize: 10.sp,
                                                        fontFamily: 'Quicksand',
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                );
                              });
                            });
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Text(
                          '₱ ' +
                              NumberFormat()
                                  .format(widget.inventoryModel.price),
                          style: TextStyle(
                              fontSize: 8.5.sp, fontFamily: 'Quicksand'),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
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
                                content: Builder(builder: (context) {
                                  return SizedBox(
                                    height: 18.h,
                                    width: 50.w,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(5.0.sp),
                                            child: TextField(
                                              keyboardType: TextInputType.number,
                                              obscureText: true,
                                              controller:
                                              _authorizationCodeController,
                                              style: TextStyle(
                                                  fontSize: 10.sp,
                                                  fontFamily: 'Quicksand'),
                                              decoration: InputDecoration(
                                                  hintText:
                                                  'Enter Authorization Code',
                                                  hintStyle: TextStyle(
                                                      fontSize: 10.sp)),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            EdgeInsets.only(top: 4.h),
                                            child: Container(
                                              height: 5.h,
                                              width: 18.w,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          20)),
                                                  gradient: LinearGradient(
                                                      colors: const [
                                                        Colors.purple,
                                                        Colors.red
                                                      ],
                                                      begin: Alignment.bottomRight,
                                                      end: Alignment.topLeft)),
                                              child: TextButton(
                                                onPressed: () {
                                                  if (_authorizationCodeController
                                                      .text ==
                                                      _authorizationCode) {
                                                    Provider.of<SystemReportsModelProvider>(
                                                        context,
                                                        listen: false)
                                                        .addReport(
                                                        '${widget.inventoryModel.name} x ${widget.inventoryModel.quantity} was removed from the inventory section last,');
                                                    _inventoryProvider
                                                        .deleteInventoryData(
                                                        widget
                                                            .inventoryModel
                                                            .name, widget.inventoryModel.id!);
                                                    _authorizationCodeController
                                                        .clear();
                                                    Navigator.of(context)
                                                        .pop();
                                                  } else {
                                                    Navigator.of(context)
                                                        .pop();
                                                  }
                                                },
                                                child: Text(
                                                  'Confirm',
                                                  style: TextStyle(
                                                      fontSize: 10.sp,
                                                      fontFamily:
                                                      'Quicksand',
                                                      color: Colors.white),
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
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
