import '../../models/hive_boxes.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../models/pdf_api.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/cash_out_model.dart';
import '../../models/system_reports_model.dart';

class CashOutScreen extends StatefulWidget {
  const CashOutScreen({Key? key}) : super(key: key);

  @override
  State<CashOutScreen> createState() => _CashOutScreenState();
}

class _CashOutScreenState extends State<CashOutScreen> {
  @override
  Widget build(BuildContext context) {
    final _cashOutProvider = Provider.of<CashOutModelProvider>(context);
    final TextEditingController _cashOutAmountController =
    TextEditingController();
    final TextEditingController _descriptionController =
    TextEditingController();
    final TextEditingController _authorizationCodeController =
    TextEditingController();
    final String _authorizationCode = '1010';

    return Scaffold(
      floatingActionButton: SizedBox(
        height: 10.h,
        width: 10.w,
        child: FloatingActionButton(
          backgroundColor: Color(0xfff6be00),
          onPressed: () async {
            await showDialog(
                context: context,
                builder: (context) {
                  return Builder(builder: (context) {
                    return AlertDialog(
                      title: Text(
                        'CASH OUT INFO',
                        style:
                        TextStyle(fontSize: 12.sp, fontFamily: 'Quicksand'),
                      ),
                      content: Builder(builder: (context) {
                        return SizedBox(
                          height: 25.h,
                          width: 60.w,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [

                                Padding(
                                  padding: EdgeInsets.all(5.0.sp),
                                  child: TextField(
                                    controller: _descriptionController,

                                    style: TextStyle(fontSize: 10.sp),
                                    decoration: InputDecoration(
                                        hintText: 'Description',
                                        hintStyle: TextStyle(
                                            fontSize: 10.sp,
                                            fontFamily: 'Quicksand')),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5.0.sp),
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: _cashOutAmountController,
                                    style: TextStyle(fontSize: 10.sp),
                                    decoration: InputDecoration(
                                        hintText: 'Amount',
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        gradient: LinearGradient(colors: const [
                                          Colors.purple,
                                          Colors.red
                                        ],
                                            begin: Alignment.bottomRight,
                                            end: Alignment.topLeft)),
                                    child: TextButton(
                                      onPressed: () {
                                                 try{
                                                   _cashOutProvider.addCashOut(double.parse(_cashOutAmountController.text),
                                                       _descriptionController.text);
                                                   Navigator.of(context).pop();
                                                 }catch(e){
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
          child: Icon(
            Icons.add,
            size: 12.sp,
          ),
        ),
      ),
      body: Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: ()async {
                  try {

                    PdfDocument document = PdfDocument();
                    final page = document.pages.add();
                    //Draw rectangle
                    page.graphics.drawRectangle(
                        brush: PdfSolidBrush(PdfColor(66, 182, 245, 255)),
                        bounds: Rect.fromLTWH(0, 0, 70.w, 8.h));
                    //Draw string

                    page.graphics.drawString(
                        '${Hive.box('enterprise_info').get('enterpriseName')}',
                        PdfStandardFont(PdfFontFamily.helvetica, 20),
                        brush: PdfBrushes.white,
                        bounds: Rect.fromLTWH(10, 17.2, 70.w, 8.h),
                        format: PdfStringFormat(
                            alignment: PdfTextAlignment.center,
                            lineSpacing: 5,
                            lineAlignment: PdfVerticalAlignment.top));
                    page.graphics.drawString(
                        'EXPENSES REPORT \n' +
                            DateFormat.yMMMd().format(DateTime.now()),
                        PdfStandardFont(PdfFontFamily.helvetica, 15),
                        brush: PdfBrushes.white,
                        bounds: Rect.fromLTWH(10, 17.2, 70.w, 8.h),
                        format: PdfStringFormat(
                            alignment: PdfTextAlignment.center,
                            lineSpacing: 5,
                            lineAlignment: PdfVerticalAlignment.middle));


                    page.graphics.drawString(
                      'Total Expenses: ' +
                          NumberFormat()
                              .format(_cashOutProvider.overallCashOut),
                      PdfStandardFont(PdfFontFamily.helvetica, 13),
                      brush: PdfBrushes.black,
                      bounds: Rect.fromLTWH(10, 145, 70.w, 8.h),
                    );


                    PdfGrid grid = PdfGrid();
                    grid.style = PdfGridStyle(
                      font: PdfStandardFont(
                        PdfFontFamily.helvetica,
                        4.5.sp,
                      ),
                    );
                    grid.columns.add(count: 2);
                    grid.headers.add(1);

                    PdfGridRow header = grid.headers[0];
                    header.cells[0].value = 'Description';
                    header.cells[1].value = 'Amount';


                    grid.applyBuiltInStyle(
                        PdfGridBuiltInStyle.gridTable5DarkAccent3);

                    for (int i = 0;
                    i <  _cashOutProvider.listOfCashOuts.length;
                    i++) {
                      PdfGridRow row = grid.rows.add();
                      row.cells[0].value =
                          _cashOutProvider.listOfCashOuts[i].description;

                      row.cells[0].stringFormat = PdfStringFormat(
                          lineAlignment: PdfVerticalAlignment.middle,
                          alignment: PdfTextAlignment.center);
                      row.cells[1].value = NumberFormat().format(
                          _cashOutProvider.listOfCashOuts[i].cashOut);
                      row.cells[1].stringFormat = PdfStringFormat(
                          lineAlignment: PdfVerticalAlignment.middle,
                          alignment: PdfTextAlignment.center);




                    }
                    for (int i = 0; i < header.cells.count; i++) {
                      header.cells[i].style.stringFormat = PdfStringFormat(
                          lineAlignment: PdfVerticalAlignment.middle,
                          alignment: PdfTextAlignment.center);
                    }

                    grid.draw(
                      page: page,
                      bounds: Rect.fromLTWH(0, 15.5.h, 0, 0),
                    );

                    List<int> bytes = await document.save();
                    document.dispose();

                    saveAndLaunchFile(bytes, 'expenses_report.pdf');
                  } catch (e) {
                    Navigator.of(context).pop();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 2.w, right: 2.w, top: 1.h, bottom: 1.h),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.all(
                          Radius.elliptical(20.w, 10.h)),
                    ),
                    padding: EdgeInsets.all(2.sp),
                    child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(3.sp),
                            child: Text(
                                'Total Cash Out: ₱ ' +
                                    NumberFormat().format(_cashOutProvider.overallCashOut),
                                style: TextStyle(
                                    fontSize: 9.sp,
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.bold)),
                          ),
                        ]),
                  ),
                ),
              ),

            ],
          ),
          Expanded(
              child: ValueListenableBuilder<Box<CashOutModel>>(
                valueListenable: HiveBoxes.getCashOutData().listenable(),
                builder: (context, box, _) {
                  _cashOutProvider.listOfCashOuts =
                      box.values.toList().cast<CashOutModel>();
                  return GroupedListView<CashOutModel, DateTime>(
                    elements: _cashOutProvider.listOfCashOuts,
                    groupBy: (e) => e.dateTime,
                    itemBuilder: (context, e) {
                      return Card(
                        elevation: 8.0,
                        child: Padding(
                          padding: EdgeInsets.all(3.0.sp),
                          child: SizedBox(
                            height: 5.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(

                                        e.description,
                                        style: TextStyle(
                                            fontSize: 8.sp,
                                            fontFamily: 'Quicksand',
                                            color: Colors.black
                                        )),
                                    Text(
                                      DateFormat().format(e.dateTime),
                                      style: TextStyle(
                                          fontSize: 7.sp,
                                          fontFamily: 'Quicksand',
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [

                                    Text(
                                        'Amount: ₱ ' +
                                            NumberFormat().format(e.cashOut),
                                        style: TextStyle(
                                            fontSize: 8.sp,
                                            fontFamily: 'Quicksand',
                                            color: Colors.black
                                        )),
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
                                                              controller: _authorizationCodeController,
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
                                                                      ])),
                                                              child: TextButton(
                                                                onPressed: () {

                                                                  if (_authorizationCodeController
                                                                      .text ==
                                                                      _authorizationCode) {
                                                                    Provider.of<SystemReportsModelProvider>(
                                                                        context,
                                                                        listen: false)
                                                                        .addReport(
                                                                        '${e.description} x ${e.cashOut} was removed from the inventory section last,');
                                                                        _cashOutProvider.deleteCashOutData(e, e.id);
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
                      );
                    },
                    groupSeparatorBuilder: (DateTime date) => Text(
                      '',
                      style: TextStyle(fontSize: 2),
                    ),
                    itemComparator: (item1, item2) =>
                        item2.dateTime.compareTo(item1.dateTime),
                    order: GroupedListOrder.ASC,
                  );
                },
              ))
        ],
      ),
    );
  }
}
