import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'distribution_tile.dart';
import '../../models/distribution_model.dart';
import '../../models/hive_boxes.dart';

class DistributionScreen extends StatefulWidget {
  const DistributionScreen({Key? key}) : super(key: key);

  @override
  State<DistributionScreen> createState() => _DistributionScreenState();
}

class _DistributionScreenState extends State<DistributionScreen> {

  bool _viewDistributions = true;
  final TextEditingController _authorizationCodeController =
  TextEditingController();
  final String _authorizationCode = '1010';

  @override
  Widget build(BuildContext context) {
    final _distributionProvider =
    Provider.of<DistributionModelProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(5.0.sp),
                child: SizedBox(
                  width: 90.w,
                  child: TextField(
                    onChanged: (val) {
                      _distributionProvider.googleListOfDistribution(val);
                    },
                    style: TextStyle(fontSize: 10.sp),
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle:
                      TextStyle(fontSize: 10.sp, fontFamily: 'Quicksand'),
                      prefixIcon:IconButton(onPressed: ()async{
                      await  showDialog(
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
                                                  setState(() {
                                                    _viewDistributions=false;
                                                  });
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

                      }, icon: Icon(Icons.search,size: 12.sp,)) ,

                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.black)),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Text(
                'DISTRIBUTION COST: ₱ ' +
                    NumberFormat()
                        .format(_distributionProvider.totalDistributionCost),
                style: TextStyle(fontSize: 10.sp, fontFamily: 'Quicksand'),
              ),
              Spacer()
            ],
          ),
          _viewDistributions?Container():
          Expanded(
              child: ValueListenableBuilder<Box<DistributionModel>>(
                  valueListenable: HiveBoxes.getDistributionData().listenable(),
                  builder: (context, box, _) {
                    final _distributionProducts =
                    box.values.toList().cast<DistributionModel>();
                    return Consumer<DistributionModelProvider>(
                      builder: (context, data, child) {
                        return GroupedListView<DistributionModel, DateTime>(
                          elements: _distributionProducts,
                          groupBy: (e) => e.dateTime,
                          itemBuilder: (context, e) {
                            if (_distributionProvider
                                .getDistributionSearch()
                                .isEmpty) {
                              return DistributionTile(distributionModelTile: e);
                            } else if (DateFormat()
                                .format(e.dateTime)
                                .toLowerCase()
                                .contains(_distributionProvider
                                .getDistributionSearch())) {
                              return DistributionTile(distributionModelTile: e);
                            } else {
                              return Container();
                            }
                          },
                          groupSeparatorBuilder: (DateTime date) => Text(
                            '',
                            style: TextStyle(fontSize: 0),
                          ),
                          itemComparator: (item1, item2) =>
                              item1.dateTime.compareTo(item2.dateTime),
                          order: GroupedListOrder.DESC,
                        );
                      },
                    );
                  }))
        ],
      ),
    );
  }
}
