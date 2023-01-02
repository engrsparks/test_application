import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:provider/provider.dart';
import '../../models/checkout_model.dart';
import 'dart:async';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class ReceiptPrinter extends StatefulWidget {
  final Map<String, CheckOutModel> itemsForPrint;
  final String enterpriseNameForPrint;
  final String addressForPrint;
  final String phoneNumberForPrint;
  final String email;
  final double total;
  final double deliveryFee;
  final double cash;
  final double change;
  final int invoiceNumber;

  const ReceiptPrinter(
      {Key? key,
        required this.itemsForPrint,
        required this.enterpriseNameForPrint,
        required this.addressForPrint,
        required this.phoneNumberForPrint,
        required this.email,
        required this.total,
        required this.deliveryFee,
        required this.cash,
        required this.change,
        required this.invoiceNumber})
      : super(key: key);

  @override
  _ReceiptPrinterState createState() => _ReceiptPrinterState();
}

class _ReceiptPrinterState extends State<ReceiptPrinter> {
  @override
  void initState() {
    super.initState();
  }

  bool connected = true;
  List availableBluetoothDevices = [];

  Future<void> getBluetooth() async {
    final List bluetooths = await BluetoothThermalPrinter.getBluetooths ?? [];
    //  print("Print $bluetooths");
    setState(() {
      availableBluetoothDevices = bluetooths;
    });
  }

  Future<void> setConnect(String mac) async {
    final String? result = await BluetoothThermalPrinter.connect(mac);
    //  print("state connected $result");
    if (result == 'true') {
      setState(() {
        connected = true;
      });
    }
  }

  Future<void> printTicket() async {
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == 'true') {
      List<int> bytes = await getTicket();

      await BluetoothThermalPrinter.writeBytes(bytes);
      //  print("Print $result");
    } else {}
  }

  Future<List<int>> getTicket() async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    bytes += generator.text(widget.enterpriseNameForPrint,
        styles: PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
        linesAfter: 1);

    bytes += generator.text(widget.addressForPrint,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));
    bytes += generator.text(widget.phoneNumberForPrint,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));
    bytes += generator.text(widget.email,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
        linesAfter: 1);
    bytes += generator.text('Invoice No.',
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));
    bytes += generator.text((widget.invoiceNumber - 1).toString(),
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
        linesAfter: 1);

    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
          text: 'Qty',
          width: 3,
          styles: PosStyles(
            align: PosAlign.left,
            bold: true,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(
          text: 'Item',
          width: 6,
          styles: PosStyles(
            align: PosAlign.center,
            bold: true,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(
          text: 'Price',
          width: 3,
          styles: PosStyles(
            align: PosAlign.right,
            bold: true,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
    ]);
    for (var i = 0; i < widget.itemsForPrint.length; i++) {
      bytes += generator.row([
        PosColumn(
            text: '${widget.itemsForPrint.values.toList()[i].quantity}',
            width: 3,
            styles: PosStyles(
              align: PosAlign.left,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            )),
        PosColumn(
            text: widget.itemsForPrint.values.toList()[i].name,
            width: 6,
            styles: PosStyles(
              align: PosAlign.center,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            )),
        PosColumn(
            text: NumberFormat()
                .format(widget.itemsForPrint.values.toList()[i].price),
            width: 3,
            styles: PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            )),
      ]);
    }
    bytes += generator.hr(linesAfter: 1);
    bytes += generator.row([
      PosColumn(
          text: 'Service Fee:',
          width: 6,
          styles: PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(
          text: NumberFormat().format(widget.deliveryFee),
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'Total:',
          width: 6,
          styles: PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(
          text: NumberFormat().format(widget.total),
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'Cash:',
          width: 6,
          styles: PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(
          text: NumberFormat().format(widget.cash),
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'Change:',
          width: 6,
          styles: PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(
          text: NumberFormat().format(widget.change),
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
    ]);
    bytes += generator.hr(ch: '=', linesAfter: 1);

    bytes += generator.text('\nThank you!',
        styles: PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));

    bytes += generator.text(DateFormat().format(DateTime.now()),
        styles: PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
        linesAfter: 1);

    bytes += generator.text('',
        styles: PosStyles(align: PosAlign.center, bold: false));
    bytes += generator.cut();
    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    final _clearScreen = Provider.of<CheckOutModelProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        leading: IconButton(
          onPressed: () {
            _clearScreen.clear();
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
          icon: Icon(
            Icons.arrow_back,
            size: 12.sp,
          ),
        ),
        automaticallyImplyLeading: false,
        title: Text(
          'Bluetooth Thermal Printer',
          style: TextStyle(fontSize: 12.sp, fontFamily: 'Quicksand'),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search Thermal Printer',
              style: TextStyle(fontSize: 12.sp, fontFamily: 'Quicksand'),
            ),
            TextButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: Colors.blue, width: 2)))),
              onPressed: () {
                getBluetooth();
              },
              child: Icon(
                Icons.bluetooth,
                size: 16.sp,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: availableBluetoothDevices.isNotEmpty
                    ? availableBluetoothDevices.length
                    : 0,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      String select = availableBluetoothDevices[index];
                      List list = select.split('#');
                      // String name = list[0];
                      String mac = list[1];
                      setConnect(mac);
                    },
                    title: Text('${availableBluetoothDevices[index]}',
                        style: TextStyle(fontFamily: 'Quicksand')),
                    subtitle: Text(
                      'Click to connect',
                      style: TextStyle(fontFamily: 'Quicksand'),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            TextButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: Colors.blue, width: 2)))),
              onPressed: connected ? printTicket : null,
              child: Text(
                'Print Receipt',
                style: TextStyle(fontSize: 12.sp, fontFamily: 'Quicksand'),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
          ],
        ),
      ),
    );
  }
}
