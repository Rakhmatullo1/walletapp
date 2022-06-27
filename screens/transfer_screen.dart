import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/card.dart';
import '../providers/user.dart';
import 'transfer_more.dart';

class Transfer extends StatefulWidget {
  static const routeName = '/transfer';
  Transfer({Key? key}) : super(key: key);

  @override
  State<Transfer> createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  String? selVal;
  double? newAmount;
  List<CardDetails> data = [];
  List<CardDetails> availableData = [];
  User? userData;
  CardDetails? finalData;
  double? price = 0;
  int? index = 0;
  void calculate(value) {
    setState(() {
      price = price! * 10 + value;
    });
  }

  void doublezero() {
    setState(() {
      price = price! * 100;
    });
  }

  void singlezero() {
    setState(() {
      price = price! * 10;
    });
  }

  void close() {
    setState(() {
      price = 0;
    });
  }

  void dropdownCallBack(String? val) {
    for (int i = 0; i < availableData.length; i++) {
      setState(() {
        if (availableData[i].id == val!) {
          index = i;
        }
      });
    }
    setState(() {
      selVal = val;
    });
    finalData = availableData[index!];
  }

  @override
  Widget build(BuildContext context) {
    data = Provider.of<Data>(context, listen: false).data;
    userData = ModalRoute.of(context)!.settings.arguments as User;
    availableData = data.where((card) {
      return userData!.cardId.any((element) => element == card.id);
    }).toList();
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          alignment: const Alignment(-0.82, -0.8),
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Image.asset(
                'assets/images/arrow-circle-left.png',
                height: 40,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.088,
                  right: MediaQuery.of(context).size.width * 0.088,
                  top: 123),
              child: Column(
                children: [
                  price == 0
                      ? const Text(
                          '',
                          style: TextStyle(fontSize: 36),
                        )
                      : Text(
                          "\$  ${price!.ceil()}",
                          style: const TextStyle(
                            fontSize: 36,
                            color: Color.fromRGBO(47, 17, 85, 1),
                          ),
                        ),
                  Padding(
                      padding: const EdgeInsets.only(top: 44.0),
                      child: DropdownButton(
                        alignment: Alignment.topCenter,
                        hint: const Text("Select your card"),
                        items: [
                          for (int i = 0; i < availableData.length; i++)
                            DropdownMenuItem<String>(
                              value: availableData[i].id,
                              child: Text(availableData[i].bank),
                            ),
                        ],
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_forward_ios_outlined),
                        onChanged: dropdownCallBack,
                        value: selVal,
                      )

                      // Container(
                      //   padding: const EdgeInsets.only(left: 41, right: 30),
                      //   width: MediaQuery.of(context).size.width * 0.82667,
                      //   height: MediaQuery.of(context).size.width * 0.176,
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(20),
                      //       color: Colors.black12),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //         data!.bank,
                      //         style: const TextStyle(fontSize: 16),
                      //       ),
                      //       IconButton(
                      //         onPressed: () {},
                      //         icon: const Icon(Icons.arrow_forward_ios_rounded),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      ),
                  Padding(
                    padding: const EdgeInsets.only(top: 42),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (int i = 1; i < 4; i++)
                                Button(i, () {
                                  calculate(i);
                                })
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (int i = 4; i < 7; i++)
                                Button(i, () {
                                  calculate(i);
                                })
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (int i = 7; i < 10; i++)
                                Button(i, () {
                                  calculate(i);
                                })
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () {
                                  doublezero();
                                },
                                child: const Text(
                                  '00',
                                  style: TextStyle(
                                    color: Color.fromRGBO(54, 56, 83, 100),
                                    fontSize: 40,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  singlezero();
                                },
                                child: const Text(
                                  '0',
                                  style: TextStyle(
                                    color: Color.fromRGBO(54, 56, 83, 100),
                                    fontSize: 40,
                                  ),
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    close();
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 40,
                                    color: Color.fromRGBO(54, 56, 83, 100),
                                  )),
                            ],
                          ),
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 68.0),
                    child: SizedBox(
                      width: 201,
                      height: 65,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (price != 0 &&
                              finalData!.balance >= price! &&
                              selVal != null) {
                            Navigator.of(context).popAndPushNamed(
                                TransferMore.routeName,
                                arguments: {
                                  'id': finalData!.id,
                                  'price': price!.ceil(),
                                  'userID': userData!.id,
                                });
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => const SimpleDialog(
                                titlePadding: EdgeInsets.all(24),
                                title: Text('Something went wrong, Try again',
                                    textAlign: TextAlign.center),
                              ),
                            );
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              const Color.fromRGBO(91, 37, 159, 1),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ))),
                        child: const Text(
                          "Transfer",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  int? val;
  VoidCallback handler;
  Button(this.val, this.handler, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: TextButton(
        onPressed: handler,
        child: Text(
          '$val',
          style: const TextStyle(
            color: Color.fromRGBO(54, 56, 83, 100),
            fontSize: 40,
          ),
        ),
      ),
    );
  }
}
