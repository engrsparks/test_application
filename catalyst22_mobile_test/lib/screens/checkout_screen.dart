import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/inventory_model.dart';
import '../models/checkout_model.dart';
import '../models/sales_model.dart';
import '../models/sales_report_model.dart';
import 'thermal_bluetooth_printer.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({Key? key}) : super(key: key);

  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {

  final TextEditingController _customerName = TextEditingController();
  final TextEditingController _deliveryCharge = TextEditingController();

  int _salesInvoiceNumber = 0;

  @override
  void initState() {
    super.initState();
    _readInvoice();
  }

  _incrementInvoice() async {
    SharedPreferences preferencesNumber = await SharedPreferences.getInstance();

    setState(() {
      _salesInvoiceNumber++;
      preferencesNumber.setInt('salesInvoice', _salesInvoiceNumber);
    });
  }

  _readInvoice() async {
    SharedPreferences preferencesNumber = await SharedPreferences.getInstance();
    setState(() {
      _salesInvoiceNumber = (preferencesNumber.getInt('salesInvoice') ?? 0);
    });
  }

  String _enterAmount = '';

  @override
  Widget build(BuildContext context) {
    final _checkOutProvider = Provider.of<CheckOutModelProvider>(context);
    final _salesProvider = Provider.of<SalesModelProvider>(context);
    final _salesReportProvider = Provider.of<SalesReportModelProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            if (_checkOutProvider.checkOutProducts.isNotEmpty &&
                _deliveryCharge.text.isNotEmpty ||
                (_checkOutProvider.totalDiscount != 0)) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                fontSize: 12.sp, fontFamily: 'Quicksand'),
                          ),
                        ],
                      ),
                      content: Builder(builder: (context) {
                        return SizedBox(
                          height: 4.h,
                          width: 88.w,
                          child: Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.all(2.0.sp),
                                  child: Text(
                                    'Failed to initialize because the field is not empty.',
                                    style: TextStyle(
                                        fontSize: 9.sp,
                                        fontFamily: 'Quicksand'),
                                  )),
                            ],
                          ),
                        );
                      }),
                    );
                  });
            } else {
              Navigator.of(context).pop();
            }
          },
          icon: Icon(
            Icons.arrow_back_sharp,
            size: 12.sp,
          ),
        ),
        title: Text(
          'CHECKOUT',
          style: TextStyle(fontSize: 12.sp, fontFamily: 'Quicksand'),
        ),
        actions: [
          IconButton(
              onPressed: (_checkOutProvider.checkOutProducts.isEmpty ||
                  _enterAmount.isNotEmpty)
                  ? null
                  : () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Builder(builder: (context) {
                        return AlertDialog(
                          title: Text(
                            'DELIVERY CHARGE',
                            style: TextStyle(
                                fontSize: 12.sp, fontFamily: 'Quicksand'),
                          ),
                          content: Builder(builder: (context) {
                            return SizedBox(
                              height: 20.h,
                              width: 50.w,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(5.0.sp),
                                      child: TextField(
                                        keyboardType:
                                        TextInputType.number,
                                        controller: _deliveryCharge,
                                        style: TextStyle(fontSize: 10.sp),
                                        decoration: InputDecoration(
                                            hintText:
                                            'Charge per Products',
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
                                            BorderRadius.all(
                                                Radius.circular(20)),
                                            gradient: LinearGradient(
                                                colors: const [
                                                  Colors.purple,
                                                  Colors.red
                                                ],
                                                begin: Alignment.bottomRight,
                                                end: Alignment.topLeft)),
                                        child: TextButton(
                                          onPressed: _deliveryCharge
                                              .text.isNotEmpty
                                              ? null
                                              : () {
                                            try {
                                              _checkOutProvider
                                                  .addDeliveryCharge(
                                                  double.parse(
                                                      _deliveryCharge
                                                          .text));
                                              Navigator.of(context)
                                                  .pop();
                                            } catch (e) {
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
              icon: Icon(
                FontAwesomeIcons.truck,
                size: 12.sp,
              )),
          SizedBox(
            width: 2.w,
          )
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 2.w, top: 1.h),
                child: Text(
                  'TOTAL: ₱ ' +
                      NumberFormat().format(_checkOutProvider.totalAmount),
                  style: TextStyle(fontSize: 10.sp, fontFamily: 'Quicksand'),
                ),
              ),
              SizedBox(
                width: 35.w,
              ),
              _deliveryCharge.text.isNotEmpty
                  ? Padding(
                padding: EdgeInsets.only(left: 2.w, top: 1.h),
                child: Text(
                  'SERVICE CHARGE: ₱ ' +
                      NumberFormat().format(
                          double.parse(_deliveryCharge.text) *
                              _checkOutProvider.numberOfProductsSold),
                  style:
                  TextStyle(fontSize: 10.sp, fontFamily: 'Quicksand'),
                ),
              )
                  : Padding(
                padding: EdgeInsets.only(left: 2.w, top: 1.h),
                child: Text(
                  'SERVICE CHARGE: ₱ 0.0',
                  style:
                  TextStyle(fontSize: 10.sp, fontFamily: 'Quicksand'),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(5.0.sp),
                child: SizedBox(
                  width: 90.w,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      _enterAmount = val;
                      setState(() {
                        try {
                          _checkOutProvider.checkOutChange =
                              double.parse(_enterAmount) -
                                  _checkOutProvider.totalAmount;
                        } catch (e) {
                          _checkOutProvider.checkOutChange = 0.0;
                        }
                      });
                    },
                    style: TextStyle(fontSize: 10.sp),
                    decoration: InputDecoration(
                      hintText: 'Enter Amount',
                      hintStyle:
                      TextStyle(fontSize: 10.sp, fontFamily: 'Quicksand'),
                      suffix: Text(
                        'Cash',
                        style:
                        TextStyle(fontSize: 8.sp, fontFamily: 'Quicksand'),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.black)),
                    ),
                  ),
                ),
              ),
              Spacer(),
              TextButton(
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                        fontSize: 12.sp, fontFamily: 'Quicksand'),
                                  ),

                            ],
                          ),
                          content: SizedBox(
                            height: 12.h,
                            width: 70.w,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Are you sure do you want to take this action?',
                                  style: TextStyle(
                                      fontSize: 9.sp,
                                      fontFamily: 'Quicksand'),
                                ),
                                SizedBox(height: 3.h),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 4.h,
                                      width: 18.w,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          gradient: LinearGradient(
                                              colors: const [
                                                Colors.purple,
                                                Colors.red
                                              ],
                                              begin: Alignment.bottomRight,
                                              end: Alignment.topLeft)),
                                      child: TextButton(
                                          onPressed: () {
                                            try {
                                              Navigator.of(context).pop();
                                              if (_checkOutProvider.checkOutProducts.isNotEmpty && _enterAmount.isNotEmpty && _deliveryCharge.text.isEmpty && _checkOutProvider.checkOutChange >= 0) {
                                                _salesProvider.addSales(_salesInvoiceNumber,  _customerName.text, _checkOutProvider.totalAmount, _checkOutProvider.totalDiscount,
                                                    _checkOutProvider.totalCost, _checkOutProvider.checkOutProducts.values.toList(), _checkOutProvider.numberOfProductsSold, 0.0, '');
                                                // _salesProvider.addSales(_salesInvoiceNumber, _customerName.text, _checkOutProvider.totalAmount, 0.0, 0.0, _checkOutProvider.totalDiscount, (_checkOutProvider.totalCost), _checkOutProvider.checkOutProducts.values.toList(), _checkOutProvider.numberOfProductsSold, 0.0, '');
                                                _salesReportProvider.addSalesReport(_salesInvoiceNumber, _customerName.text, _checkOutProvider.totalAmount, _checkOutProvider.totalDiscount, (_checkOutProvider.totalCost),
                                                    _checkOutProvider.checkOutProducts.values.toList(), _checkOutProvider.numberOfProductsSold);

                                                _incrementInvoice();

                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                                  return ReceiptPrinter(
                                                    itemsForPrint: _checkOutProvider.checkOutProducts,
                                                    enterpriseNameForPrint:
                                                    Hive.box('enterprise_info').get('enterpriseName'),
                                                    addressForPrint: Hive.box('enterprise_info').get('enterpriseAddress'),
                                                    phoneNumberForPrint: Hive.box('enterprise_info').get('enterprisePhoneNumber'),
                                                    email: Hive.box('enterprise_info').get('enterpriseEmail'),
                                                    total: _checkOutProvider.totalAmount,
                                                    deliveryFee: (0.0),
                                                    cash: double.parse(_enterAmount),
                                                    change: _checkOutProvider.checkOutChange,

                                                    invoiceNumber: (_salesInvoiceNumber),
                                                  );
                                                }));
                                              } else if (_checkOutProvider.checkOutProducts.isNotEmpty && _enterAmount.isNotEmpty && _deliveryCharge.text.isNotEmpty && _checkOutProvider.checkOutChange >= 0) {
                                                _salesProvider.addSales(_salesInvoiceNumber, _customerName.text, _checkOutProvider.totalAmount,  _checkOutProvider.totalDiscount, (_checkOutProvider.totalCost),
                                                    _checkOutProvider.checkOutProducts.values.toList(), _checkOutProvider.numberOfProductsSold, (_checkOutProvider.numberOfProductsSold * double.parse(_deliveryCharge.text)), '');
                                                _salesReportProvider.addSalesReport(_salesInvoiceNumber, _customerName.text, _checkOutProvider.totalAmount,  _checkOutProvider.totalDiscount,
                                                    (_checkOutProvider.totalCost), _checkOutProvider.checkOutProducts.values.toList(),
                                                    _checkOutProvider.numberOfProductsSold);

                                                _incrementInvoice();

                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                                  return ReceiptPrinter(
                                                    itemsForPrint: _checkOutProvider.checkOutProducts,
                                                    enterpriseNameForPrint:
                                                    Hive.box('enterprise_info').get('enterpriseName'),
                                                    addressForPrint: Hive.box('enterprise_info').get('enterpriseAddress'),
                                                    phoneNumberForPrint: Hive.box('enterprise_info').get('enterprisePhoneNumber'),
                                                    email: Hive.box('enterprise_info').get('enterpriseEmail'),
                                                    total: _checkOutProvider.totalAmount,
                                                    deliveryFee: (_checkOutProvider.numberOfProductsSold * double.parse(_deliveryCharge.text)),
                                                    cash: double.parse(_enterAmount),
                                                    change: _checkOutProvider.checkOutChange,

                                                    invoiceNumber: (_salesInvoiceNumber),
                                                  );
                                                }));
                                              } else {
                                                Navigator.of(context).pop();
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
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
                                                              style: TextStyle(fontSize: 12.sp, fontFamily: 'Quicksand'),
                                                            ),
                                                          ],
                                                        ),
                                                        content: Builder(builder: (context) {
                                                          return SizedBox(
                                                            height: 4.h,
                                                            width: 98.w,
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                    padding: EdgeInsets.all(2.0.sp),
                                                                    child: Text(
                                                                      'This action can\'t proceed, an invalid text field value is detected.',
                                                                      style: TextStyle(fontSize: 9.sp, fontFamily: 'Quicksand'),
                                                                    )),
                                                              ],
                                                            ),
                                                          );
                                                        }),
                                                      );
                                                    });
                                              }
                                            } catch (e) {
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: Text(
                                            'Yes',
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                fontFamily: 'Quicksand',
                                                color: Colors.white),
                                          )),
                                    ),

                                    Container(
                                      height: 4.h,
                                      width: 18.w,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          gradient: LinearGradient(
                                              colors: const [
                                                Colors.purple,
                                                Colors.red
                                              ],
                                              begin: Alignment.bottomRight,
                                              end: Alignment.topLeft)),
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();

                                          },
                                          child: Text(
                                            'No',
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                fontFamily: 'Quicksand',
                                                color: Colors.white),
                                          )),
                                    ),
                                    // Container(
                                    //   height: 4.h,
                                    //   width: 18.w,
                                    //   decoration: BoxDecoration(
                                    //       borderRadius: BorderRadius.all(
                                    //           Radius.circular(20)),
                                    //       gradient: LinearGradient(
                                    //           colors: const [
                                    //             Colors.green,
                                    //             Colors.blue
                                    //           ])),
                                    //   child: TextButton(
                                    //       onPressed: () {
                                    //         Navigator.of(context).pop();
                                    //         showDialog(
                                    //             context: context,
                                    //             builder: (context) {
                                    //               return Builder(
                                    //                   builder: (context) {
                                    //                     return AlertDialog(
                                    //                       title: Text(
                                    //                         'CUSTOMER INFO',
                                    //                         style: TextStyle(
                                    //                             fontSize: 12.sp,
                                    //                             fontFamily:
                                    //                             'Quicksand'),
                                    //                       ),
                                    //                       content: Builder(
                                    //                           builder:
                                    //                               (context) {
                                    //                             return SizedBox(
                                    //                               height: 20.h,
                                    //                               width: 50.w,
                                    //                               child:
                                    //                               SingleChildScrollView(
                                    //                                 child: Column(
                                    //                                   children: [
                                    //                                     Padding(
                                    //                                       padding: EdgeInsets
                                    //                                           .all(5.0
                                    //                                           .sp),
                                    //                                       child:
                                    //                                       TextField(
                                    //                                         controller:
                                    //                                         _customerName,
                                    //                                         style: TextStyle(
                                    //                                             fontSize:
                                    //                                             10.sp),
                                    //                                         decoration: InputDecoration(
                                    //                                             hintText:
                                    //                                             'Customer Name',
                                    //                                             hintStyle:
                                    //                                             TextStyle(fontSize: 10.sp, fontFamily: 'Quicksand')),
                                    //                                       ),
                                    //                                     ),
                                    //                                     Padding(
                                    //                                       padding: EdgeInsets.only(
                                    //                                           top: 5
                                    //                                               .h),
                                    //                                       child:
                                    //                                       Container(
                                    //                                         height:
                                    //                                         5.h,
                                    //                                         width:
                                    //                                         18.w,
                                    //                                         decoration: BoxDecoration(
                                    //                                             borderRadius: BorderRadius.all(Radius.circular(
                                    //                                                 20)),
                                    //                                             gradient:
                                    //                                             LinearGradient(colors: const [
                                    //                                               Colors.green,
                                    //                                               Colors.blue
                                    //                                             ])),
                                    //                                         child:
                                    //                                         TextButton(
                                    //                                           onPressed:
                                    //                                               () {
                                    //                                             try {
                                    //                                               if (_checkOutProvider.checkOutProducts.isNotEmpty && _enterAmount.isNotEmpty && _deliveryCharge.text.isEmpty && _checkOutProvider.checkOutChange >= 0) {
                                    //                                                 _salesProvider.addSales(_salesInvoiceNumber, _customerName.text, _checkOutProvider.totalAmount, 0.0, _checkOutProvider.totalDiscount, _checkOutProvider.totalCost,
                                    //                                                     _checkOutProvider.checkOutProducts.values.toList(), _checkOutProvider.numberOfProductsSold, 0.0, '');
                                    //                                                 _salesReportProvider.addSalesReport(_salesInvoiceNumber, _customerName.text, 0.0, _checkOutProvider.totalAmount, 0.0, _checkOutProvider.totalDiscount, (_checkOutProvider.totalCost), _checkOutProvider.checkOutProducts.values.toList(), _checkOutProvider.numberOfProductsSold);
                                    //
                                    //                                                 _incrementInvoice();
                                    //                                                 Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                    //                                                   return ReceiptPrinter(
                                    //                                                     itemsForPrint: _checkOutProvider.checkOutProducts,
                                    //                                                     enterpriseNameForPrint:
                                    //                                                     Hive.box('enterprise_info').get('enterpriseName'),
                                    //                                                     addressForPrint: Hive.box('enterprise_info').get('enterpriseAddress'),
                                    //                                                     phoneNumberForPrint: Hive.box('enterprise_info').get('enterprisePhoneNumber'),
                                    //                                                     email: Hive.box('enterprise_info').get('enterpriseEmail'),
                                    //                                                     total: _checkOutProvider.totalAmount,
                                    //                                                     deliveryFee: (0.0),
                                    //                                                     cash: double.parse(_enterAmount),
                                    //                                                     change: _checkOutProvider.checkOutChange,
                                    //                                                     customerName: _customerName.text,
                                    //                                                     invoiceNumber: (_salesInvoiceNumber),
                                    //                                                   );
                                    //                                                 }));
                                    //
                                    //                                                 Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                    //                                                   return ReceiptPrinter(
                                    //                                                     itemsForPrint: _checkOutProvider.checkOutProducts,
                                    //                                                     enterpriseNameForPrint:
                                    //                                                     Hive.box('enterprise_info').get('enterpriseName'),
                                    //                                                     addressForPrint: Hive.box('enterprise_info').get('enterpriseAddress'),
                                    //                                                     phoneNumberForPrint: Hive.box('enterprise_info').get('enterprisePhoneNumber'),
                                    //                                                     email: Hive.box('enterprise_info').get('enterpriseEmail'),
                                    //                                                     total: _checkOutProvider.totalAmount,
                                    //                                                     deliveryFee: (0.0),
                                    //                                                     cash: double.parse(_enterAmount),
                                    //                                                     change: _checkOutProvider.checkOutChange,
                                    //                                                     customerName: _customerName.text,
                                    //                                                     invoiceNumber: (_salesInvoiceNumber),
                                    //                                                   );
                                    //                                                 }));
                                    //                                               } else if (_checkOutProvider.checkOutProducts.isNotEmpty && _enterAmount.isNotEmpty && _deliveryCharge.text.isNotEmpty && _checkOutProvider.checkOutChange >= 0) {
                                    //                                                 _salesProvider.addSales(_salesInvoiceNumber, _customerName.text, _checkOutProvider.totalAmount, 0.0, _checkOutProvider.totalDiscount, _checkOutProvider.totalCost,
                                    //                                                     _checkOutProvider.checkOutProducts.values.toList(), _checkOutProvider.numberOfProductsSold,(_checkOutProvider.numberOfProductsSold * double.parse(_deliveryCharge.text)) , '');
                                    //                                                 // _salesProvider.addSales(_salesInvoiceNumber, _customerName.text, 0.0, _checkOutProvider.totalAmount, 0.0, _checkOutProvider.totalDiscount, (_checkOutProvider.totalCost), _checkOutProvider.checkOutProducts.values.toList(), _checkOutProvider.numberOfProductsSold, 0.0, 0.0, (_checkOutProvider.numberOfProductsSold * double.parse(_deliveryCharge.text)), '');
                                    //                                                 _salesReportProvider.addSalesReport(_salesInvoiceNumber, _customerName.text, 0.0, _checkOutProvider.totalAmount, 0.0, _checkOutProvider.totalDiscount, (_checkOutProvider.totalCost), _checkOutProvider.checkOutProducts.values.toList(), _checkOutProvider.numberOfProductsSold);
                                    //                                                 //
                                    //                                                 // Provider.of<CashRegisterModelProvider>(context, listen: false).addCashRegister(
                                    //                                                 //   _customerName.text,
                                    //                                                 //   _salesInvoiceNumber,
                                    //                                                 //   0.0,
                                    //                                                 //   _checkOutProvider.totalAmount,
                                    //                                                 // );
                                    //                                                 // Provider.of<CashFlowReportsModelProvider>(context, listen: false).addCashFlowReports(_customerName.text, _salesInvoiceNumber, 0.0, _checkOutProvider.totalAmount, _checkOutProvider.numberOfProductsSold);
                                    //
                                    //                                                 _incrementInvoice();
                                    //
                                    //                                                 Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                    //                                                   return ReceiptPrinter(
                                    //                                                     itemsForPrint: _checkOutProvider.checkOutProducts,
                                    //                                                     enterpriseNameForPrint:
                                    //                                                     Hive.box('enterprise_info').get('enterpriseName'),
                                    //                                                     addressForPrint: Hive.box('enterprise_info').get('enterpriseAddress'),
                                    //                                                     phoneNumberForPrint: Hive.box('enterprise_info').get('enterprisePhoneNumber'),
                                    //                                                     email: Hive.box('enterprise_info').get('enterpriseEmail'),
                                    //                                                     total: _checkOutProvider.totalAmount,
                                    //                                                     deliveryFee: (_checkOutProvider.numberOfProductsSold * double.parse(_deliveryCharge.text)),
                                    //                                                     cash: double.parse(_enterAmount),
                                    //                                                     change: _checkOutProvider.checkOutChange,
                                    //                                                     customerName: _customerName.text,
                                    //                                                     invoiceNumber: (_salesInvoiceNumber),
                                    //                                                   );
                                    //                                                 }));
                                    //                                               } else {
                                    //                                                 Navigator.of(context).pop();
                                    //                                                 showDialog(
                                    //                                                     context: context,
                                    //                                                     builder: (context) {
                                    //                                                       return AlertDialog(
                                    //                                                         title: Row(
                                    //                                                           mainAxisAlignment: MainAxisAlignment.center,
                                    //                                                           children: [
                                    //                                                             Icon(
                                    //                                                               Icons.warning,
                                    //                                                               size: 20.sp,
                                    //                                                             ),
                                    //                                                             SizedBox(
                                    //                                                               width: 2.w,
                                    //                                                             ),
                                    //                                                             Text(
                                    //                                                               'WARNING!',
                                    //                                                               style: TextStyle(fontSize: 12.sp, fontFamily: 'Quicksand'),
                                    //                                                             ),
                                    //                                                           ],
                                    //                                                         ),
                                    //                                                         content: Builder(builder: (context) {
                                    //                                                           return SizedBox(
                                    //                                                             height: 4.h,
                                    //                                                             width: 98.w,
                                    //                                                             child: Column(
                                    //                                                               children: [
                                    //                                                                 Padding(
                                    //                                                                     padding: EdgeInsets.all(2.0.sp),
                                    //                                                                     child: Text(
                                    //                                                                       'This action can\'t proceed, an invalid text field value is detected.',
                                    //                                                                       style: TextStyle(fontSize: 9.sp, fontFamily: 'Quicksand'),
                                    //                                                                     )),
                                    //                                                               ],
                                    //                                                             ),
                                    //                                                           );
                                    //                                                         }),
                                    //                                                       );
                                    //                                                     });
                                    //                                               }
                                    //                                             } catch (e) {
                                    //                                               Navigator.of(context).pop();
                                    //                                             }
                                    //                                           },
                                    //                                           child:
                                    //                                           Text(
                                    //                                             'Confirm',
                                    //                                             style: TextStyle(
                                    //                                                 fontSize: 10.sp,
                                    //                                                 fontFamily: 'Quicksand',
                                    //                                                 color: Colors.white),
                                    //                                           ),
                                    //                                         ),
                                    //                                       ),
                                    //                                     ),
                                    //                                   ],
                                    //                                 ),
                                    //                               ),
                                    //                             );
                                    //                           }),
                                    //                     );
                                    //                   });
                                    //             });
                                    //       },
                                    //       child: Text(
                                    //         'Cheque',
                                    //         style: TextStyle(
                                    //             fontSize: 12.sp,
                                    //             fontFamily: 'Quicksand',
                                    //             color: Colors.white),
                                    //       )),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ));
                  },
                  child: Text(
                    'CONFIRM',
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'Quicksand',
                        color: Colors.black),
                  )),
              // Spacer(),
              // TextButton(
              //     onPressed: () async {
              //       await showDialog(
              //           context: context,
              //           builder: (context) {
              //             return Builder(builder: (context) {
              //               return AlertDialog(
              //                 title: Row(
              //                   mainAxisAlignment:
              //                   MainAxisAlignment.spaceBetween,
              //                   children: [
              //                     Text(
              //                       'CUSTOMER INFO \n(Credit Form)',
              //                       style: TextStyle(
              //                           fontSize: 12.sp,
              //                           fontFamily: 'Quicksand'),
              //                     ),
              //                     Container(
              //                       height: 4.h,
              //                       width: 16.w,
              //                       decoration: BoxDecoration(
              //                           borderRadius: BorderRadius.all(
              //                               Radius.circular(20)),
              //                           gradient: LinearGradient(colors: const [
              //                             Colors.green,
              //                             Colors.blue
              //                           ])),
              //                       child: TextButton(
              //                         onPressed: () {
              //                           Navigator.of(context).pop();
              //                           showDialog(
              //                               context: context,
              //                               builder: (context) => AlertDialog(
              //                                 title: Text(
              //                                   'PAYMENT TYPE',
              //                                   style: TextStyle(
              //                                       fontSize: 12.sp,
              //                                       fontFamily:
              //                                       'Quicksand'),
              //                                 ),
              //                                 content: SizedBox(
              //                                   height: 10.h,
              //                                   width: 70.w,
              //                                   child: Column(
              //                                     mainAxisAlignment:
              //                                     MainAxisAlignment
              //                                         .center,
              //                                     children: [
              //                                       Row(
              //                                         mainAxisSize:
              //                                         MainAxisSize.max,
              //                                         mainAxisAlignment:
              //                                         MainAxisAlignment
              //                                             .spaceBetween,
              //                                         children: [
              //                                           Container(
              //                                             height: 4.h,
              //                                             width: 18.w,
              //                                             decoration: BoxDecoration(
              //                                                 borderRadius:
              //                                                 BorderRadius.all(
              //                                                     Radius.circular(
              //                                                         20)),
              //                                                 gradient:
              //                                                 LinearGradient(
              //                                                     colors: const [
              //                                                       Colors
              //                                                           .green,
              //                                                       Colors
              //                                                           .blue
              //                                                     ])),
              //                                             child: TextButton(
              //                                                 onPressed:
              //                                                     () {
              //                                                   try {
              //                                                     if (_checkOutProvider.checkOutProducts.isNotEmpty &&
              //                                                         _customerName
              //                                                             .text
              //                                                             .isNotEmpty &&
              //                                                         _enterAmount
              //                                                             .isNotEmpty &&
              //                                                         _deliveryCharge
              //                                                             .text
              //                                                             .isEmpty &&
              //                                                         (double.parse(_gradient.text) !=
              //                                                             0) &&
              //                                                         _checkOutProvider.checkOutChange <
              //                                                             0) {
              //                                                       // if (double.parse(_enterAmount) != 0) {
              //                                                       //
              //                                                       // }
              //                                                       _salesProvider.addSales(
              //                                                           _salesInvoiceNumber,
              //                                                           _customerName
              //                                                               .text,
              //                                                           (_checkOutProvider.totalAmount +
              //                                                               _checkOutProvider.checkOutChange),
              //                                                           0.0,
              //                                                           _checkOutProvider.checkOutChange,
              //                                                           _checkOutProvider.totalDiscount,
              //                                                           (_checkOutProvider.totalCost),
              //                                                           _checkOutProvider.checkOutProducts.values.toList(),
              //                                                           _checkOutProvider.numberOfProductsSold,
              //                                                           double.parse(_interestCost.text),
              //                                                           double.parse(_gradient.text),
              //                                                           (0.0),
              //                                                           _address.text);
              //                                                       _salesReportProvider.addSalesReport(
              //                                                           _salesInvoiceNumber,
              //                                                           _customerName
              //                                                               .text,
              //                                                           (_checkOutProvider.totalAmount +
              //                                                               _checkOutProvider.checkOutChange),
              //                                                           0.0,
              //                                                           _checkOutProvider.checkOutChange,
              //                                                           _checkOutProvider.totalDiscount,
              //                                                           (_checkOutProvider.totalCost),
              //                                                           _checkOutProvider.checkOutProducts.values.toList(),
              //                                                           _checkOutProvider.numberOfProductsSold);
              //
              //
              //                                                       _incrementInvoice();
              //                                                       Navigator.of(context).push(MaterialPageRoute(builder:
              //                                                           (context) {
              //                                                         return ReceiptPrinter(
              //                                                           itemsForPrint:
              //                                                           _checkOutProvider.checkOutProducts,
              //
              //                                                           enterpriseNameForPrint:
              //                                                             Hive.box('enterprise_info').get('enterpriseName'),
              //                                                           addressForPrint:
              //                                                           Hive.box('enterprise_info').get('enterpriseAddress'),
              //                                                           phoneNumberForPrint:
              //                                                           Hive.box('enterprise_info').get('enterprisePhoneNumber'),
              //                                                           email:
              //                                                           Hive.box('enterprise_info').get('enterpriseEmail'),
              //                                                           total:
              //                                                           _checkOutProvider.totalAmount,
              //                                                           deliveryFee:
              //                                                           (0.0),
              //                                                           cash:
              //                                                           double.parse(_enterAmount),
              //                                                           change:
              //                                                           _checkOutProvider.checkOutChange,
              //                                                           customerName:
              //                                                           _customerName.text,
              //                                                           invoiceNumber:
              //                                                           (_salesInvoiceNumber),
              //                                                         );
              //                                                       }));
              //                                                     } else if (_checkOutProvider.checkOutProducts.isNotEmpty &&
              //                                                         _customerName
              //                                                             .text
              //                                                             .isNotEmpty &&
              //                                                         _enterAmount
              //                                                             .isNotEmpty &&
              //                                                         _deliveryCharge
              //                                                             .text
              //                                                             .isNotEmpty &&
              //                                                         (double.parse(_gradient.text) !=
              //                                                             0) &&
              //                                                         _checkOutProvider.checkOutChange <
              //                                                             0) {
              //
              //                                                       _salesProvider.addSales(
              //                                                           _salesInvoiceNumber,
              //                                                           _customerName
              //                                                               .text,
              //                                                           (_checkOutProvider.totalAmount +
              //                                                               _checkOutProvider.checkOutChange),
              //                                                           0.0,
              //                                                           _checkOutProvider.checkOutChange,
              //                                                           _checkOutProvider.totalDiscount,
              //                                                           (_checkOutProvider.totalCost),
              //                                                           _checkOutProvider.checkOutProducts.values.toList(),
              //                                                           _checkOutProvider.numberOfProductsSold,
              //                                                           double.parse(_interestCost.text),
              //                                                           double.parse(_gradient.text),
              //                                                           (_checkOutProvider.numberOfProductsSold * double.parse(_deliveryCharge.text)),
              //                                                           _address.text);
              //                                                       _salesReportProvider.addSalesReport(
              //                                                           _salesInvoiceNumber,
              //                                                           _customerName
              //                                                               .text,
              //                                                           (_checkOutProvider.totalAmount +
              //                                                               _checkOutProvider.checkOutChange),
              //                                                           0.0,
              //                                                           _checkOutProvider.checkOutChange,
              //                                                           _checkOutProvider.totalDiscount,
              //                                                           (_checkOutProvider.totalCost),
              //                                                           _checkOutProvider.checkOutProducts.values.toList(),
              //                                                           _checkOutProvider.numberOfProductsSold);
              //
              //
              //
              //                                                       _incrementInvoice();
              //                                                       Navigator.of(context).push(MaterialPageRoute(builder:
              //                                                           (context) {
              //                                                         return ReceiptPrinter(
              //                                                           itemsForPrint:
              //                                                           _checkOutProvider.checkOutProducts,
              //                                                           enterpriseNameForPrint:
              //                                                           Hive.box('enterprise_info').get('enterpriseName'),
              //                                                           addressForPrint:
              //                                                           Hive.box('enterprise_info').get('enterpriseAddress'),
              //                                                           phoneNumberForPrint:
              //                                                           Hive.box('enterprise_info').get('enterprisePhoneNumber'),
              //                                                           email:
              //                                                           Hive.box('enterprise_info').get('enterpriseEmail'),
              //                                                           total:
              //                                                           _checkOutProvider.totalAmount,
              //                                                           deliveryFee:
              //                                                           (_checkOutProvider.numberOfProductsSold * double.parse(_deliveryCharge.text)),
              //                                                           cash:
              //                                                           double.parse(_enterAmount),
              //                                                           change:
              //                                                           _checkOutProvider.checkOutChange,
              //                                                           customerName:
              //                                                           _customerName.text,
              //                                                           invoiceNumber:
              //                                                           (_salesInvoiceNumber),
              //                                                         );
              //                                                       }));
              //                                                     } else {
              //                                                       Navigator.of(context)
              //                                                           .pop();
              //                                                       showDialog(
              //                                                           context:
              //                                                           context,
              //                                                           builder:
              //                                                               (context) {
              //                                                             return AlertDialog(
              //                                                               title: Row(
              //                                                                 mainAxisAlignment: MainAxisAlignment.center,
              //                                                                 children: [
              //                                                                   Icon(
              //                                                                     Icons.warning,
              //                                                                     size: 20.sp,
              //                                                                   ),
              //                                                                   SizedBox(
              //                                                                     width: 2.w,
              //                                                                   ),
              //                                                                   Text(
              //                                                                     'WARNING!',
              //                                                                     style: TextStyle(fontSize: 12.sp, fontFamily: 'Quicksand'),
              //                                                                   ),
              //                                                                 ],
              //                                                               ),
              //                                                               content: Builder(builder: (context) {
              //                                                                 return SizedBox(
              //                                                                   height: 6.h,
              //                                                                   width: 85.w,
              //                                                                   child: Column(
              //                                                                     children: [
              //                                                                       Padding(
              //                                                                           padding: EdgeInsets.all(2.0.sp),
              //                                                                           child: Text(
              //                                                                             'This action can\'t proceed, an empty text field or\ninvalid text field value is detected.',
              //                                                                             style: TextStyle(fontSize: 9.sp, fontFamily: 'Quicksand'),
              //                                                                           )),
              //                                                                     ],
              //                                                                   ),
              //                                                                 );
              //                                                               }),
              //                                                             );
              //                                                           });
              //                                                     }
              //                                                   } catch (e) {
              //                                                     Navigator.of(
              //                                                         context)
              //                                                         .pop();
              //                                                   }
              //                                                 },
              //                                                 child: Text(
              //                                                   'Cash',
              //                                                   style: TextStyle(
              //                                                       fontSize: 12
              //                                                           .sp,
              //                                                       fontFamily:
              //                                                       'Quicksand',
              //                                                       color: Colors
              //                                                           .white),
              //                                                 )),
              //                                           ),
              //                                           Container(
              //                                             height: 4.h,
              //                                             width: 18.w,
              //                                             decoration: BoxDecoration(
              //                                                 borderRadius:
              //                                                 BorderRadius.all(
              //                                                     Radius.circular(
              //                                                         20)),
              //                                                 gradient:
              //                                                 LinearGradient(
              //                                                     colors: const [
              //                                                       Colors
              //                                                           .green,
              //                                                       Colors
              //                                                           .blue
              //                                                     ])),
              //                                             child: TextButton(
              //                                                 onPressed:
              //                                                     () {
              //                                                   try {
              //                                                     if (_checkOutProvider.checkOutProducts.isNotEmpty &&
              //                                                         _customerName
              //                                                             .text
              //                                                             .isNotEmpty &&
              //                                                         _enterAmount
              //                                                             .isNotEmpty &&
              //                                                         _deliveryCharge
              //                                                             .text
              //                                                             .isEmpty &&
              //                                                         (double.parse(_gradient.text) !=
              //                                                             0) &&
              //                                                         _checkOutProvider.checkOutChange <
              //                                                             0) {
              //
              //                                                       _salesProvider.addSales(
              //                                                           _salesInvoiceNumber,
              //                                                           _customerName
              //                                                               .text,
              //                                                           0.0,
              //                                                           (_checkOutProvider.totalAmount +
              //                                                               _checkOutProvider.checkOutChange),
              //                                                           _checkOutProvider.checkOutChange,
              //                                                           _checkOutProvider.totalDiscount,
              //                                                           (_checkOutProvider.totalCost),
              //                                                           _checkOutProvider.checkOutProducts.values.toList(),
              //                                                           _checkOutProvider.numberOfProductsSold,
              //                                                           double.parse(_interestCost.text),
              //                                                           double.parse(_gradient.text),
              //                                                           (0.0),
              //                                                           _address.text);
              //                                                       _salesReportProvider.addSalesReport(
              //                                                           _salesInvoiceNumber,
              //                                                           _customerName
              //                                                               .text,
              //                                                           0.0,
              //                                                           (_checkOutProvider.totalAmount +
              //                                                               _checkOutProvider.checkOutChange),
              //                                                           _checkOutProvider.checkOutChange,
              //                                                           _checkOutProvider.totalDiscount,
              //                                                           (_checkOutProvider.totalCost),
              //                                                           _checkOutProvider.checkOutProducts.values.toList(),
              //                                                           _checkOutProvider.numberOfProductsSold);
              //
              //
              //                                                       _incrementInvoice();
              //                                                       Navigator.of(context).push(MaterialPageRoute(builder:
              //                                                           (context) {
              //                                                         return ReceiptPrinter(
              //                                                           itemsForPrint:
              //                                                           _checkOutProvider.checkOutProducts,
              //                                                           enterpriseNameForPrint:
              //                                                           Hive.box('enterprise_info').get('enterpriseName'),
              //                                                           addressForPrint:
              //                                                           Hive.box('enterprise_info').get('enterpriseAddress'),
              //                                                           phoneNumberForPrint:
              //                                                           Hive.box('enterprise_info').get('enterprisePhoneNumber'),
              //                                                           email:
              //                                                           Hive.box('enterprise_info').get('enterpriseEmail'),
              //                                                           total:
              //                                                           _checkOutProvider.totalAmount,
              //                                                           deliveryFee:
              //                                                           (0.0),
              //                                                           cash:
              //                                                           double.parse(_enterAmount),
              //                                                           change:
              //                                                           _checkOutProvider.checkOutChange,
              //                                                           customerName:
              //                                                           _customerName.text,
              //                                                           invoiceNumber:
              //                                                           (_salesInvoiceNumber),
              //                                                         );
              //                                                       }));
              //                                                     } else if (_checkOutProvider.checkOutProducts.isNotEmpty &&
              //                                                         _customerName
              //                                                             .text
              //                                                             .isNotEmpty &&
              //                                                         _enterAmount
              //                                                             .isNotEmpty &&
              //                                                         _deliveryCharge
              //                                                             .text
              //                                                             .isNotEmpty &&
              //                                                         (double.parse(_gradient.text) !=
              //                                                             0) &&
              //                                                         _checkOutProvider.checkOutChange <
              //                                                             0) {
              //
              //                                                       _salesProvider.addSales(
              //                                                           _salesInvoiceNumber,
              //                                                           _customerName
              //                                                               .text,
              //                                                           0.0,
              //                                                           (_checkOutProvider.totalAmount +
              //                                                               _checkOutProvider.checkOutChange),
              //                                                           _checkOutProvider.checkOutChange,
              //                                                           _checkOutProvider.totalDiscount,
              //                                                           (_checkOutProvider.totalCost),
              //                                                           _checkOutProvider.checkOutProducts.values.toList(),
              //                                                           _checkOutProvider.numberOfProductsSold,
              //                                                           double.parse(_interestCost.text),
              //                                                           double.parse(_gradient.text),
              //                                                           (_checkOutProvider.numberOfProductsSold * double.parse(_deliveryCharge.text)),
              //                                                           _address.text);
              //                                                       _salesReportProvider.addSalesReport(
              //                                                           _salesInvoiceNumber,
              //                                                           _customerName
              //                                                               .text,
              //                                                           0.0,
              //                                                           (_checkOutProvider.totalAmount +
              //                                                               _checkOutProvider.checkOutChange),
              //                                                           _checkOutProvider.checkOutChange,
              //                                                           _checkOutProvider.totalDiscount,
              //                                                           (_checkOutProvider.totalCost),
              //                                                           _checkOutProvider.checkOutProducts.values.toList(),
              //                                                           _checkOutProvider.numberOfProductsSold);
              //
              //
              //
              //                                                       _incrementInvoice();
              //                                                       Navigator.of(context).push(MaterialPageRoute(builder:
              //                                                           (context) {
              //                                                         return ReceiptPrinter(
              //                                                           itemsForPrint:
              //                                                           _checkOutProvider.checkOutProducts,
              //                                                           enterpriseNameForPrint:
              //                                                           Hive.box('enterprise_info').get('enterpriseName'),
              //                                                           addressForPrint:
              //                                                           Hive.box('enterprise_info').get('enterpriseAddress'),
              //                                                           phoneNumberForPrint:
              //                                                           Hive.box('enterprise_info').get('enterprisePhoneNumber'),
              //                                                           email:
              //                                                           Hive.box('enterprise_info').get('enterpriseEmail'),
              //                                                           total:
              //                                                           _checkOutProvider.totalAmount,
              //                                                           deliveryFee:
              //                                                           (_checkOutProvider.numberOfProductsSold * double.parse(_deliveryCharge.text)),
              //                                                           cash:
              //                                                           double.parse(_enterAmount),
              //                                                           change:
              //                                                           _checkOutProvider.checkOutChange,
              //                                                           customerName:
              //                                                           _customerName.text,
              //                                                           invoiceNumber:
              //                                                           (_salesInvoiceNumber),
              //                                                         );
              //                                                       }));
              //                                                     } else {
              //                                                       Navigator.of(context)
              //                                                           .pop();
              //                                                       showDialog(
              //                                                           context:
              //                                                           context,
              //                                                           builder:
              //                                                               (context) {
              //                                                             return AlertDialog(
              //                                                               title: Row(
              //                                                                 mainAxisAlignment: MainAxisAlignment.center,
              //                                                                 children: [
              //                                                                   Icon(
              //                                                                     Icons.warning,
              //                                                                     size: 20.sp,
              //                                                                   ),
              //                                                                   SizedBox(
              //                                                                     width: 2.w,
              //                                                                   ),
              //                                                                   Text(
              //                                                                     'WARNING!',
              //                                                                     style: TextStyle(fontSize: 12.sp, fontFamily: 'Quicksand'),
              //                                                                   ),
              //                                                                 ],
              //                                                               ),
              //                                                               content: Builder(builder: (context) {
              //                                                                 return SizedBox(
              //                                                                   height: 6.h,
              //                                                                   width: 85.w,
              //                                                                   child: Column(
              //                                                                     children: [
              //                                                                       Padding(
              //                                                                           padding: EdgeInsets.all(2.0.sp),
              //                                                                           child: Text(
              //                                                                             'This action can\'t proceed, an empty text field or\ninvalid text field value is detected.',
              //                                                                             style: TextStyle(fontSize: 9.sp, fontFamily: 'Quicksand'),
              //                                                                           )),
              //                                                                     ],
              //                                                                   ),
              //                                                                 );
              //                                                               }),
              //                                                             );
              //                                                           });
              //                                                     }
              //                                                   } catch (e) {
              //                                                     Navigator.of(
              //                                                         context)
              //                                                         .pop();
              //                                                   }
              //                                                 },
              //                                                 child: Text(
              //                                                   'Cheque',
              //                                                   style: TextStyle(
              //                                                       fontSize: 12
              //                                                           .sp,
              //                                                       fontFamily:
              //                                                       'Quicksand',
              //                                                       color: Colors
              //                                                           .white),
              //                                                 )),
              //                                           ),
              //                                         ],
              //                                       )
              //                                     ],
              //                                   ),
              //                                 ),
              //                               ));
              //                         },
              //                         child: Text(
              //                           'Confirm',
              //                           style: TextStyle(
              //                               fontSize: 10.sp,
              //                               fontFamily: 'Quicksand',
              //                               color: Colors.white),
              //                         ),
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //                 content: Builder(builder: (context) {
              //                   return SizedBox(
              //                     height: 28.h,
              //                     width: 70.w,
              //                     child: SingleChildScrollView(
              //                       child: Column(
              //                         children: [
              //                           Padding(
              //                             padding: EdgeInsets.all(5.0.sp),
              //                             child: TextField(
              //                               controller: _customerName,
              //                               style: TextStyle(fontSize: 10.sp),
              //                               decoration: InputDecoration(
              //                                   hintText: 'Customer Name',
              //                                   hintStyle: TextStyle(
              //                                       fontSize: 10.sp,
              //                                       fontFamily: 'Quicksand')),
              //                             ),
              //                           ),
              //                           Padding(
              //                             padding: EdgeInsets.all(5.0.sp),
              //                             child: TextField(
              //                               controller: _address,
              //                               style: TextStyle(fontSize: 10.sp),
              //                               decoration: InputDecoration(
              //                                   hintText: 'Address',
              //                                   hintStyle: TextStyle(
              //                                       fontSize: 10.sp,
              //                                       fontFamily: 'Quicksand')),
              //                             ),
              //                           ),
              //                           Padding(
              //                             padding: EdgeInsets.all(5.0.sp),
              //                             child: TextField(
              //                               keyboardType: TextInputType.number,
              //                               controller: _interestCost,
              //                               style: TextStyle(fontSize: 10.sp),
              //                               decoration: InputDecoration(
              //                                   hintText: 'Interest Cost',
              //                                   hintStyle: TextStyle(
              //                                       fontSize: 10.sp,
              //                                       fontFamily: 'Quicksand')),
              //                             ),
              //                           ),
              //                           Padding(
              //                             padding: EdgeInsets.all(5.0.sp),
              //                             child: TextField(
              //                               keyboardType: TextInputType.number,
              //                               controller: _gradient,
              //                               style: TextStyle(fontSize: 10.sp),
              //                               decoration: InputDecoration(
              //                                   hintText:
              //                                   'Number of Days/Months/Year',
              //                                   hintStyle: TextStyle(
              //                                       fontSize: 10.sp,
              //                                       fontFamily: 'Quicksand')),
              //                             ),
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //                   );
              //                 }),
              //               );
              //             });
              //           });
              //     },
              //     child: Text(
              //       'CREDIT',
              //       style: TextStyle(
              //           fontSize: 12.sp,
              //           fontFamily: 'Quicksand',
              //           color: Colors.black),
              //     )),
              Spacer()
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 2.w, bottom: 2.h),
                child: Text(
                  'CHANGE: ₱ ' +
                      NumberFormat().format(_checkOutProvider.checkOutChange),
                  style: TextStyle(fontSize: 10.sp, fontFamily: 'Quicksand'),
                ),
              ),
            ],
          ),
          Expanded(
              child: ListView.builder(
                itemCount: _checkOutProvider.checkOutProducts.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 8,
                    child: SizedBox(
                      height: 6.h,
                      child: Padding(
                        padding: EdgeInsets.all(3.0.sp),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'QTY. ' +
                                  _checkOutProvider.checkOutProducts.values
                                      .toList()[index]
                                      .quantity
                                      .toString(),
                              style: TextStyle(
                                  fontSize: 9.sp, fontFamily: 'Quicksand'),
                            ),
                            Text(
                              _checkOutProvider.checkOutProducts.values
                                  .toList()[index]
                                  .name,
                              style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Quicksand'),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '₱ ' +
                                      _checkOutProvider.checkOutProducts.values
                                          .toList()[index]
                                          .price
                                          .toString(),
                                  style: TextStyle(
                                      fontSize: 9.sp, fontFamily: 'Quicksand'),
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                IconButton(
                                  onPressed: () {
                                    Provider.of<InventoryModelProvider>(context,
                                        listen: false)
                                        .cancelProduct(
                                      _checkOutProvider.checkOutProducts.values
                                          .toList()[index]
                                          .name,
                                      _checkOutProvider.checkOutProducts.values
                                          .toList()[index]
                                          .cost,
                                      _checkOutProvider.checkOutProducts.values
                                          .toList()[index]
                                          .price,
                                      _checkOutProvider.checkOutProducts.values
                                          .toList()[index]
                                          .initialQuantity,
                                      _checkOutProvider.checkOutProducts.values
                                          .toList()[index]
                                          .discount,
                                      _checkOutProvider.checkOutProducts.values
                                          .toList()[index].index
                                          ,
                                      _checkOutProvider.checkOutProducts.values.toList()[index].minimumQuantity,
                                        _checkOutProvider.checkOutProducts.values.toList()[index].id
                                    );
                                    _checkOutProvider.removeCheckOutProduct(
                                        _checkOutProvider.checkOutProducts.values
                                            .toList()[index]
                                            .name);
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    size: 12.sp,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ))
        ],
      ),
    );
  }
}
