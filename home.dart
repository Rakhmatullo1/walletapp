import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/card.dart';
import 'transfer_screen.dart';
import 'notification_screen.dart';
import 'setting_screen.dart';
import '../providers/transactions.dart';
import 'chart_screen.dart';
import '../providers/user.dart';

enum Page {
  wallet,
  chart,
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool init=true;
  int? ind;
  String? selVal;
  CardDetails? finalData;
  Page _page = Page.wallet;
  List<Transaction> finalTrans = [];
  List<Transaction> transactions = [];
  @override
void didChangeDependencies() {
    transactions = Provider.of<TransactionData>(context, listen: false).data;
    super.didChangeDependencies();
  }
  void dropdownCallBack(String? val) {
    List<Transaction> list1 = [];
    setState(() {
      selVal = val;
    });
    if (finalData != null) {
      // list1.addAll(transactions.where((trans) {
      //   for (int i = 0; i < finalData!.transID.length; i++) {
      //     return finalData!.transID[i]==trans.id;
      //   }
      //   return false ;
      // }));
      for (int i = 0; i < finalData!.transID.length; i++) {
        for (int j = 0; j < transactions.length; j++) {
          if (transactions[j].id == finalData!.transID[i]) {
            ind = j;
            break;
          }
        }
        list1.add(transactions[ind!]);
      }
      refresh1(list1);
      list1.clear();
    }
  }

  

  void refresh1(list) {
    setState(() {
      finalTrans = list.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context, listen: false).data[0];
    final data = Provider.of<Data>(context).data;
    final availableData= data.where((card){
      return userData.cardId.any((element) => element== card.id);
    }).toList();
    

    return Scaffold(
      body: _page == Page.chart
          ? const ChartScreen()
          : Padding(
              padding: EdgeInsets.only(
                  top: 72,
                  left: MediaQuery.of(context).size.width * 0.088,
                  right: MediaQuery.of(context).size.width * 0.088),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData.title,
                          style: const TextStyle(
                              color: Color.fromRGBO(19, 1, 56, 1),
                              fontSize: 28),
                        ),
                        Text(userData.status ? "Active" : "Non-Active",
                            style: const TextStyle(
                              color: Color.fromRGBO(189, 189, 189, 1),
                              fontSize: 20,
                            )),
                      ],
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Image.asset(
                          height: 56,
                          userData.profilePic,
                          fit: BoxFit.cover,
                        )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: DropdownButton(
                    hint: const Text("choose your card "),
                    items: [
                      for (int i = 0; i < availableData.length; i++)
                        DropdownMenuItem<String>(
                          value: availableData[i].id,
                          child: Text(availableData[i].bank),
                          onTap: () {
                            finalData = availableData.firstWhere(
                                (element) => element.id == availableData[i].id);
                          },
                        )
                    ],
                    icon: const Icon(Icons.arrow_forward_ios),
                    isExpanded: true,
                    onChanged: dropdownCallBack,
                    value: selVal,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, left: 2, right: 2),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/images/rectangle.png',
                        width: MediaQuery.of(context).size.width * 0.81,
                        height: MediaQuery.of(context).size.width * 0.37333,
                        fit: BoxFit.fill,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.81,
                        height: MediaQuery.of(context).size.width * 0.37333,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(91, 37, 159, 0.9),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      finalData == null
                          ? const Text('')
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Balance",
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontFamily: 'QuickSand-Bold',
                                      ),
                                    ),
                                    Text("\$ ${finalData!.balance.ceil()}",
                                        style: const TextStyle(
                                            fontSize: 24,
                                            color: Colors.white,
                                            fontFamily: 'QuickSand-Bold')),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Card",
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontFamily: 'QuickSand-Bold',
                                      ),
                                    ),
                                    Text(
                                      finalData!.bank,
                                      style: const TextStyle(
                                          fontSize: 24,
                                          color: Colors.white,
                                          fontFamily: 'QuickSand-Bold'),
                                    )
                                  ],
                                )
                              ],
                            )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                Transfer.routeName,
                                arguments: userData,
                              );
                            },
                            child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade300,
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: const Offset(0, 2.5),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(20)),
                                child:
                                    Image.asset('assets/images/convert.png')),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              "Transfer",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade300,
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: const Offset(0, 2.5),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(20)),
                                child: Image.asset('assets/images/export.png')),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              "Payment",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade300,
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: const Offset(0, 2.5),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(20)),
                                child: Image.asset(
                                    'assets/images/money-send.png')),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              "PayOut",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade300,
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: const Offset(0, 2.5),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(20)),
                                child: Image.asset(
                                    'assets/images/add-circle.png')),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              "Top Up",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Last Transactions",
                      style: TextStyle(fontSize: 18),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "View All",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 13),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 200,
                  child: ListView(scrollDirection: Axis.vertical, children: [
                    if (finalData != null)
                      for (int i = 0; i < finalTrans.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: finalData == null
                              ? const Text('')
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 15),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(17),
                                            child: finalTrans[i].transType ==
                                                    TransType.payment
                                                ? Image.network(
                                                    finalTrans[i].image,
                                                    height: 39,
                                                    width: 39,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    finalTrans[i].image,
                                                    height: 39,
                                                    width: 39,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              finalTrans[i].name,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            Text(
                                              finalTrans[i].type,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Color.fromRGBO(
                                                      189, 189, 189, 1)),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Text(
                                      '\$ ${finalTrans[i].price.ceil()}',
                                      style: const TextStyle(fontSize: 16),
                                    )
                                  ],
                                ),
                        ),
                  ]),
                )
              ]),
            ),
      floatingActionButton: Align(
        alignment: const Alignment(0.64, 1.05),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.872,
          height: MediaQuery.of(context).size.width * 0.218667,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: const Color.fromRGBO(47, 17, 85, 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _page == Page.wallet
                      ? GestureDetector(
                          onTap: () {},
                          child: Image.asset(
                            'assets/images/wallet-2.png',
                            height: 28,
                            fit: BoxFit.cover,
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              _page = Page.wallet;
                            });
                          },
                          child: Image.asset(
                            'assets/images/wallet-3.png',
                            height: 28,
                            fit: BoxFit.cover,
                          ),
                        ),
                  _page == Page.chart
                      ? GestureDetector(
                          onTap: () {},
                          child: Image.asset(
                            'assets/images/chart-1.png',
                            height: 28,
                            fit: BoxFit.cover,
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              _page = Page.chart;
                            });
                          },
                          child: Image.asset(
                            'assets/images/chart-2.png',
                            height: 28,
                            fit: BoxFit.cover,
                          ),
                        ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(NotificationScreen.routeName, arguments: userData.notId);
                    },
                    child: Image.asset(
                      'assets/images/notification-bing.png',
                      height: 28,
                      fit: BoxFit.cover,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(SettingScreen.routeName);
                    },
                    child: Image.asset(
                      'assets/images/setting.png',
                      height: 28,
                      fit: BoxFit.cover,
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
