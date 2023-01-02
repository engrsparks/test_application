import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'inventory_tile.dart';
import 'checkout_screen.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../models/pdf_api.dart';
import '../../models/hive_boxes.dart';
import '../../models/inventory_model.dart';
import '../../models/distribution_model.dart';
import '../../models/checkout_model.dart';


class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _minimumQuantityController = TextEditingController();
  final TextEditingController _indexController = TextEditingController();

  int _salesInvoiceNumber = 0;

  String _search = '';

  @override
  void initState() {
    super.initState();
    _readInvoice();
  }

  _incrementInvoice() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      _salesInvoiceNumber++;
      preferences.setInt('invoice', _salesInvoiceNumber);
    });
  }

  _readInvoice() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _salesInvoiceNumber = (preferences.getInt('invoice') ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _inventoryProvider = Provider.of<InventoryModelProvider>(context);
    final _checkOutProvider = Provider.of<CheckOutModelProvider>(context);
    return Scaffold(
      floatingActionButton: SizedBox(

        height: 10.h,
        width: 10.w,
        child: FloatingActionButton(
          // backgroundColor: Color.fromRGBO(220, 182, 38, 2.0),
          backgroundColor: Color(0xfff6be00),
          onPressed: () {
            (Hive.box('enterprise_info').isEmpty ||
                _checkOutProvider.checkOutProducts.values.toList().isEmpty)
                ? showDialog(
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
                        height: 8.h,
                        width: 88.w,
                        child: Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.all(2.0.sp),
                                child: Text(
                                  'This action can\'t proceed, enterprise data is null.',
                                  style: TextStyle(
                                      fontSize: 9.sp,
                                      fontFamily: 'Quicksand'),
                                )),
                            Padding(
                                padding: EdgeInsets.all(2.0.sp),
                                child: Text(
                                  'Please inform your admin for this issue.',
                                  style: TextStyle(
                                      fontSize: 9.sp,
                                      fontFamily: 'Quicksand'),
                                )),
                          ],
                        ),
                      );
                    }),
                  );
                })
                : Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CheckOutScreen()));
          },
          child: Icon(
            Icons.add_shopping_cart,
            size: 12.sp,

          ),
        ),
      ),
      body: Consumer<InventoryModelProvider>(
        builder: (context, data, _) => Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                    onPressed: () async {
                      try {
                        PdfDocument document = PdfDocument();
                        final page = document.pages.add();
                        //Draw rectangle
                        page.graphics.drawRectangle(
                          brush: PdfSolidBrush(PdfColor(66, 182, 245, 255)),
                          bounds: Rect.fromLTWH(0, 0, 70.w, 8.h),
                        );

                        page.graphics.drawString(
                            '', PdfStandardFont(PdfFontFamily.helvetica, 20),
                            brush: PdfBrushes.white,
                            bounds: Rect.fromLTWH(10, 17.2, 70.w, 8.h),
                            format: PdfStringFormat(
                                alignment: PdfTextAlignment.center,
                                lineSpacing: 5,
                                lineAlignment: PdfVerticalAlignment.top));

                        page.graphics.drawString(
                            'INVENTORY STATUS REPORT \n' +
                                DateFormat.yMMMd().format(DateTime.now()),
                            PdfStandardFont(PdfFontFamily.helvetica, 15),
                            brush: PdfBrushes.white,
                            bounds: Rect.fromLTWH(10, 17.2, 70.w, 8.h),
                            format: PdfStringFormat(
                                alignment: PdfTextAlignment.center,
                                lineSpacing: 5,
                                lineAlignment: PdfVerticalAlignment.middle));

                        PdfGrid grid = PdfGrid();
                        grid.style = PdfGridStyle(
                          font: PdfStandardFont(
                            PdfFontFamily.helvetica,
                            4.5.sp,
                          ),
                        );
                        grid.columns.add(count: 3);
                        grid.headers.add(1);

                        PdfGridRow header = grid.headers[0];
                        header.cells[0].value = 'Quantity';
                        header.cells[1].value = 'Item Name';
                        header.cells[2].value = 'Product Price SRP';

                        grid.applyBuiltInStyle(
                            PdfGridBuiltInStyle.gridTable5DarkAccent3);

                        for (int i = 0;
                        i < _inventoryProvider.listOfInventoryData.length;
                        i++) {
                          PdfGridRow row = grid.rows.add();

                          row.cells[0].value = NumberFormat().format(
                              _inventoryProvider
                                  .listOfInventoryData[i].quantity);
                          row.cells[0].stringFormat = PdfStringFormat(
                              lineAlignment: PdfVerticalAlignment.middle,
                              alignment: PdfTextAlignment.center);
                          row.cells[1].value =
                              _inventoryProvider.listOfInventoryData[i].name;
                          row.cells[1].stringFormat = PdfStringFormat(
                              lineAlignment: PdfVerticalAlignment.middle,
                              alignment: PdfTextAlignment.center);
                          row.cells[2].value = NumberFormat().format(
                              _inventoryProvider.listOfInventoryData[i].price);
                          row.cells[2].stringFormat = PdfStringFormat(
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
                          bounds: Rect.fromLTWH(0, 12.h, 0, 0),
                        );

                        List<int> bytes = await document.save();
                        document.dispose();

                        saveAndLaunchFile(bytes, 'inventory_status_report.pdf');
                      } catch (e) {
                        Navigator.of(context).pop();
                      }
                    },
                    icon: Icon(
                      Icons.print,
                      size: 12.sp,
                    )),
                Padding(
                  padding: EdgeInsets.all(5.0.sp),
                  child: SizedBox(
                    width: 90.w,
                    child: TextField(
                      onChanged: (val) => setState(() {
                        _search = val;
                      }),
                      style: TextStyle(fontSize: 10.sp),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle:
                        TextStyle(fontSize: 10.sp, fontFamily: 'Quicksand'),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 12.sp,
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
                    onPressed:  () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Builder(builder: (context) {
                              return AlertDialog(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'PRODUCT INFO',
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontFamily: 'Quicksand'),
                                    ),
                                    Container(
                                        height: 4.h,
                                        width: 15.w,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(20)),
                                            gradient: LinearGradient(colors: const [
                                              Colors.purple,
                                              Colors.red
                                            ],
                                              begin: Alignment.bottomRight,
                                              end: Alignment.topLeft
                                            )),
                                        child: TextButton(
                                          onPressed: () {
                                            if (_nameController.text.isNotEmpty &&
                                                _costController.text
                                                    .isNotEmpty &&
                                                _priceController
                                                    .text
                                                    .isNotEmpty) {
                                              Provider.of<InventoryModelProvider>(
                                                  context,
                                                  listen: false)
                                                  .addInventory(
                                                  _nameController
                                                      .text,
                                                  double.parse(
                                                      _costController
                                                          .text),
                                                  double.parse(
                                                      _priceController
                                                          .text),
                                                  int.parse(
                                                      _quantityController
                                                          .text),

                                                  _indexController
                                                      .text,
                                                  int.parse(_minimumQuantityController.text),

                                              );

                                              Provider.of<DistributionModelProvider>(
                                                  context,
                                                  listen: false)
                                                  .addDistribution(

                                                  _indexController
                                                      .text,
                                                  _nameController
                                                      .text,
                                                  double.parse(
                                                      _costController
                                                          .text),
                                                  double.parse(
                                                      _priceController
                                                          .text),
                                                  int.parse(
                                                      _quantityController
                                                          .text));
                                              _incrementInvoice();
                                              _nameController
                                                  .clear();
                                              _costController
                                                  .clear();
                                              _priceController
                                                  .clear();
                                              _quantityController
                                                  .clear();
                                              _minimumQuantityController.clear();
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
                                                color:
                                                Colors.white),
                                          ),
                                        ),
                                    )
                                  ],
                                ),
                                content: Builder(builder: (context) {
                                  return SizedBox(
                                    height: 40.h,
                                    width: 55.w,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                            EdgeInsets.all(5.0.sp),
                                            child: TextField(
                                              controller:
                                              _indexController,
                                              style: TextStyle(
                                                  fontSize: 10.sp),
                                              decoration: InputDecoration(
                                                  hintText: 'Product Type',
                                                  hintStyle: TextStyle(
                                                      fontSize: 10.sp,
                                                      fontFamily:
                                                      'Quicksand')),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            EdgeInsets.all(5.0.sp),
                                            child: TextField(
                                              controller: _nameController,
                                              style: TextStyle(
                                                  fontSize: 10.sp),
                                              decoration: InputDecoration(
                                                  hintText:
                                                  'Product Name',
                                                  hintStyle: TextStyle(
                                                      fontSize: 10.sp,
                                                      fontFamily:
                                                      'Quicksand')),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            EdgeInsets.all(5.0.sp),
                                            child: TextField(
                                              keyboardType:
                                              TextInputType.number,
                                              controller: _costController,
                                              style: TextStyle(
                                                  fontSize: 10.sp),
                                              decoration: InputDecoration(
                                                  hintText:
                                                  'Product Cost',
                                                  hintStyle: TextStyle(
                                                      fontSize: 10.sp,
                                                      fontFamily:
                                                      'Quicksand')),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            EdgeInsets.all(5.0.sp),
                                            child: TextField(
                                              keyboardType:
                                              TextInputType.number,
                                              controller:
                                              _priceController,
                                              style: TextStyle(
                                                  fontSize: 10.sp),
                                              decoration: InputDecoration(
                                                  hintText:
                                                  'Product Price SRP',
                                                  hintStyle: TextStyle(
                                                      fontSize: 10.sp,
                                                      fontFamily:
                                                      'Quicksand')),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            EdgeInsets.all(5.0.sp),
                                            child: TextField(
                                              keyboardType:
                                              TextInputType.number,
                                              controller:
                                              _quantityController,
                                              style: TextStyle(
                                                  fontSize: 10.sp),
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
                                            padding:
                                            EdgeInsets.all(5.0.sp),
                                            child: TextField(
                                              keyboardType:
                                              TextInputType.number,
                                              controller:
                                              _minimumQuantityController,
                                              style: TextStyle(
                                                  fontSize: 10.sp),
                                              decoration: InputDecoration(
                                                  hintText:
                                                  'Minimum Quantity',
                                                  hintStyle: TextStyle(
                                                      fontSize: 10.sp,
                                                      fontFamily:
                                                      'Quicksand')),
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
                    child: Text(
                      'ADD NEW ITEM',
                      style:
                      TextStyle(fontSize: 10.sp, fontFamily: 'Quicksand', color: Colors.black),
                    )),
                Spacer()
              ],
            ),
            Expanded(
              child: ValueListenableBuilder<Box<InventoryModel>>(
                  valueListenable: HiveBoxes.getInventoryData().listenable(),
                  builder: (context, box, _) {
                    _inventoryProvider.listOfInventoryData =
                        box.values.toList().cast<InventoryModel>();
                    return GroupedListView<InventoryModel, String>(
                      groupComparator: (item1, item2){
                        return item1.compareTo(item2);
                      },
                      elements: _inventoryProvider.listOfInventoryData,
                      groupBy: (e) => e.index,
                      itemBuilder: (context, e) {
                        if (_search.isEmpty) {
                          return InventoryTile(inventoryModel: e);
                        } else if (e.name.toLowerCase().contains(_search)) {
                          return InventoryTile(inventoryModel: e);
                        } else if (e.index.toLowerCase().contains(_search)) {
                          return InventoryTile(inventoryModel: e);
                        }
                        else {
                          return Container();
                        }
                      },
                      groupSeparatorBuilder: (String index) {

                        if (index.toString().toLowerCase().contains(_search)) {
                          return Text(
                              index.toString(),
                              style: TextStyle(
                                  fontSize: 6.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Quicksand'),

                          );
                        } else {
                          return Container();
                        }

                      },
                      itemComparator: (item1, item2) =>
                          item1.index.compareTo(item2.index),
                      order: GroupedListOrder.ASC,
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
