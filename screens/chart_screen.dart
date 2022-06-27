import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:provider/provider.dart';
import 'package:walletapp/providers/user.dart';

import '../providers/notification.dart';

class ChartScreen extends StatefulWidget {
  String id;
  ChartScreen(this.id, {Key? key}) : super(key: key);

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

var init = true;

class _ChartScreenState extends State<ChartScreen> {
  double sum = 0;
  List<int> temp = [];
  double inSum = 0;
  double outSum = 0;
  bool selVal = true;
  List<NotificationDetails> nots = [];
  List<NotificationDetails> data = [];
  User? userData;
  TooltipBehavior? _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    data = Provider.of<NotificationData>(context, listen: false).data;
    userData = Provider.of<UserData>(context, listen: false).data.firstWhere(
          (e) => e.id == widget.id,
        );
    nots = data.where((e) {
      return userData!.notId.any((not) => not == e.id);
    }).toList();
    for (int i = 0; i < nots.length; i++) {
      if (nots[i].statusType) {
        inSum = inSum + nots[i].amount;
      } else {
        outSum = outSum + nots[i].amount;
      }
    }
    sum = inSum - outSum;
    super.initState();
  }

  void dropdownCallBack(bool? value) {
    setState(() {
      selVal = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.088),
        child: Padding(
          padding: const EdgeInsets.only(top: 56.0),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: const [
                      Text(
                        "Stats",
                        style: TextStyle(
                            fontSize: 21, color: Color.fromRGBO(19, 1, 56, 1)),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: SizedBox(
                      height: 212,
                      child: SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        enableAxisAnimation: true,
                        tooltipBehavior: _tooltipBehavior,
                        series: <SplineSeries>[
                          SplineSeries<NotificationDetails, DateTime>(
                              dataSource: nots,
                              xValueMapper: (NotificationDetails sales, ind) {
                                if (sales.statusType == selVal) {
                                  return sales.date;
                                }
                              },
                              yValueMapper: (NotificationDetails sales, _) {
                                double sum = 0;
                                for (int i = 0; i < nots.length; i++) {
                                  if (nots[i].date.month == sales.date.month) {
                                    sum = sum + nots[i].amount;
                                  }
                                }
                                return sum;
                              },
                              splineType: SplineType.cardinal,
                              cardinalSplineTension: 0.9,
                              dataLabelSettings:
                                  const DataLabelSettings(isVisible: true),
                              enableTooltip: true,
                              color: const Color.fromRGBO(132, 56, 255, 1))
                        ],
                        primaryXAxis: DateTimeAxis(
                            majorTickLines: const MajorTickLines(width: 0),
                            interval: 1,
                            isVisible: true,
                            majorGridLines: const MajorGridLines(width: 0),
                            axisLine: const AxisLine(width: 0),
                            edgeLabelPlacement: EdgeLabelPlacement.shift),
                        primaryYAxis: NumericAxis(
                            isVisible: false,
                            numberFormat:
                                NumberFormat.simpleCurrency(decimalDigits: 0)),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Text(
                      "Total Balance",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text('${sum.ceil()}'),
                  )
                ],
              ),
              DropdownButton(
                hint: const Text("Filter"),
                items: const [
                  DropdownMenuItem<bool>(
                    value: true,
                    child: Text("Income Stats"),
                  ),
                  DropdownMenuItem<bool>(
                    value: false,
                    child: Text("Outcome Stats"),
                  ),
                ],
                onChanged: dropdownCallBack,
                value: selVal,
              )
            ],
          ),
        ),
      ),
    );
  }
}
