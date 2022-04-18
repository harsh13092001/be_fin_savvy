import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import "package:be_fin_savvy/service/model.dart";
import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import "package:ff_navigation_bar/ff_navigation_bar.dart";
import 'task.dart';
import "package:be_fin_savvy/service/widget.dart";
import 'package:be_fin_savvy/service/service.dart';
import "package:be_fin_savvy/service/user.dart";

class Commission extends StatefulWidget {
  @override
  State<Commission> createState() => _CommissionState();
}

class _CommissionState extends State<Commission> {
  bool showGraph = false;
  List<Amount> data = [];
  var recommdCommission;
  void commissionGraph(int currentCommision, var recomdCommission) {
  
    data = [
      Amount(
        commisionName: "commission",
        Commission: currentCommision,
        barColor: charts.ColorUtil.fromDartColor(Colors.redAccent),
      ),
      Amount(
        commisionName: "Recommended commission",
        Commission: recomdCommission,
        barColor: charts.ColorUtil.fromDartColor(Colors.green),
      ),
    ];
  }

  @override
  TextEditingController _totalAmounController = TextEditingController();
  TextEditingController _commissionAmountController = TextEditingController();
  int selectedIndex = 0;
  int totalAmount = 0;
  var netSales;
  int commissionAmount = 0;
  final minPadding = 15.5;
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: appBarMain(context),
          body: Container(
            child: Center(
              child: ListView(children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: minPadding, bottom: 0.5),
                  child: TextField(
                    controller: _totalAmounController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Total sales",
                        hintText: "Enter Total Sales",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: minPadding, bottom: 0.5),
                  child: TextField(
                    controller: _commissionAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Commission sales",
                        hintText: "Enter commission sales",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                RaisedButton(
                    onPressed: () {
                      totalAmount = int.parse(_totalAmounController.text);
                      commissionAmount =
                          int.parse(_commissionAmountController.text);
                      netSales = totalAmount - commissionAmount;
                      recommdCommission = totalAmount * 0.05;
                      commissionGraph(commissionAmount, recommdCommission);
                      for (int i = 0; i < 1000; i++) {}
                      setState(() {
                        showGraph = true;
                      });
                      DatabaseMethods methods = new DatabaseMethods();
                      methods.addNetSales(netSales, Info.user_id);
                    },
                    child: Text(
                      "calculate",
                    )),
                showGraph
                    ? Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 9.5,
                            width: MediaQuery.of(context).size.width / 0.5,
                            color: Colors.purple[300],
                            child: Center(
                                child: Text(' your Net Sales is  ' +
                                    netSales.toString())),
                          ),
                          SubscriberChart(data: data),
                          commissionAmount - recommdCommission > 0
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      bottom: minPadding,
                                      left: 2.5,
                                      right: 2.5),
                                  child: Text(
                                      "You are paying too much commission. You can reduce commission from Rs ${commissionAmount} to Rs ${recommdCommission} and save Rs ${commissionAmount - recommdCommission}."))
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "You are doing well on commission.",
                                  ),
                                )
                        ],
                      )
                    : Container()
              ]),
            ),
          ),
          bottomNavigationBar: FFNavigationBar(
            theme: FFNavigationBarTheme(
              barBackgroundColor: Colors.black,
              selectedItemBackgroundColor: Colors.white,
              selectedItemIconColor: Colors.black,
              selectedItemLabelColor: Colors.white,
              barHeight: 70,
              itemWidth: 53,
            ),
            selectedIndex: selectedIndex,
            onSelectTab: (index) {
              if (index == 0) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Commission()));
              } else if (index == 1) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Task(false)));
              }
              setState(() {
                selectedIndex = index;
              });
            },
            items: [
              FFNavigationBarItem(
                iconData: Icons.monetization_on_rounded,
                label: 'commission guider',
              ),
              FFNavigationBarItem(
                iconData: Icons.work,
                label: 'Task',
              ),
            ],
          )),
    );
  }
}

class SubscriberChart extends StatelessWidget {
  final List<Amount> data;

  SubscriberChart({@required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Amount, String>> series = [
      charts.Series(
          id: "sales",
          data: data,
          domainFn: (Amount series, _) => series.commisionName,
          measureFn: (Amount series, _) => series.Commission,
          colorFn: (Amount series, _) => series.barColor)
    ];
    return Container(
      height: 400,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                "Commission",
                style: Theme.of(context).textTheme.body2,
              ),
              Expanded(
                child: charts.BarChart(series, animate: true),
              )
            ],
          ),
        ),
      ),
    );
  }
}
