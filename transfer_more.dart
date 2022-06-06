import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/card.dart';
import '../providers/transactions.dart';
import '../providers/user.dart';
import '../providers/notification.dart';

class TransferMore extends StatefulWidget {
  var args;
  static const routeName = '/transfer-more';
  TransferMore(this.args);
  @override
  State<TransferMore> createState() => _TransferMoreState();
}

class _TransferMoreState extends State<TransferMore> {
  String? details;
  int? index;
  double? newAmount;
  User? finalUserData;
  CardDetails? data;
  List<CardDetails> data1 = [];
  List<User> userData = [];
  List<CardDetails> availableData = [];
  String? selVal;
  final _key = GlobalKey<FormState>();
  final _cardFocusNode = FocusNode();
  final _cardNumber = TextEditingController();
  final _datefocusNode = FocusNode();
  TransType transType = TransType.transfer;
  DateTime? date;
  DateTime? dateID;
  @override
  void initState() {
    data = Provider.of<Data>(context, listen: false)
        .data
        .firstWhere((card) => card.id == widget.args['id']);
    data1 = Provider.of<Data>(context, listen: false).data;
    userData = Provider.of<UserData>(context, listen: false).data;
    finalUserData =
        userData.firstWhere((user) => user.id == widget.args['userID']);
    for (int i = 0; i < finalUserData!.cardId.length; i++) {
      for (int j = 0; j < data1.length; j++) {
        if (data1[j].id == finalUserData!.cardId[i]) {
          index = j;
          break;
        }
      }
      availableData.add(data1[index!]);
    }
    dateID = DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    _cardNumber.dispose();
    _cardFocusNode.dispose();
    _datefocusNode.dispose();
    super.dispose();
  }

  void datePicker() async {
    try {
      await showDialog(
          context: context,
          barrierColor: Colors.white70,
          builder: (context) {
            return CupertinoDatePicker(
              onDateTimeChanged: (val) {
                setState(() {
                  date = val;
                });
              },
              mode: CupertinoDatePickerMode.date,
            );
          });
    } finally {
      for (int i = 0; i < data1.length; i++) {
        if (double.parse(_cardNumber.text).ceil() == data1[i].cardNumber &&
            DateFormat.yM().format(date!) ==
                DateFormat.yM().format(data1[i].dateOfExpiry)) {
          for (int j = 0; j < userData.length; j++) {
            for (int k = 0; k < userData[j].cardId.length; k++) {
              if (userData[j].cardId[k] == data1[i].id) {
                index = j;
              }
            }
          }
          setState(() {
            details = userData[index!].ownerName;
          });
        }
      }
    }
  }

  void radioFunction(String? val) {
    setState(() {
      selVal = val;
    });
  }

  void _saveForm(BuildContext context) {
    DateTime? dateId; 
    if (selVal != null) {
      setState(() {
        date = data1.firstWhere((card) => card.id == selVal).dateOfExpiry;
        _cardNumber.text =
            data1.firstWhere((card) => card.id == selVal).cardNumber.toString();
      });
    }
    if (date != null && _cardNumber.text.isNotEmpty) {
      newAmount = data!.balance - widget.args['price']!;
      Provider.of<Data>(context, listen: false)
          .update(data!.id.toString(), newAmount!, dateID.toString());
      Provider.of<TransactionData>(context, listen: false).addTransactions(
          id: dateID.toString(),
          transType: transType,
          name: details == null ? finalUserData!.ownerName : details!,
          price: (data!.balance - newAmount!),
          type: 'Transformation');
      final newAmount1 = data1
              .firstWhere(
                  (card) => card.cardNumber.toString() == _cardNumber.text)
              .balance +
          widget.args['price'];

      Provider.of<UserData>(context, listen: false)
          .update(finalUserData!.id, dateID.toString());
      Provider.of<NotificationData>(context, listen: false).update(details!, dateID.toString(),
          dateID!, (data!.balance - newAmount!), 'Transformation', false);
      Provider.of<Data>(context, listen: false).update(
          data1
              .firstWhere(
                  (card) => card.cardNumber.toString() == _cardNumber.text)
              .id,
          newAmount1,
          '');
          if(details==finalUserData!.ownerName){
            Provider.of<UserData>(context, listen: false).update( userData.firstWhere((element) => element.ownerName== details).id , dateId.toString() );
          Provider.of<NotificationData>(context, listen: false).update(finalUserData!.ownerName, dateId.toString(), dateId!, (data!.balance - newAmount!), 'Transformation', true );
          }
      Navigator.of(context).pop();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 0.088,
            left: MediaQuery.of(context).size.width * 0.088,
            top: 120),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 30.0),
              child: Text(
                'Transformation',
                style: TextStyle(
                    color: Color.fromRGBO(91, 37, 159, 1), fontSize: 40),
              ),
            ),
            Form(
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value!.length != 16) {
                        return 'Enter your card number fully';
                      }
                      if (value.isEmpty) {
                        return 'Enter your card Number';
                      }

                      return null;
                    },
                    focusNode: _cardFocusNode,
                    controller: _cardNumber,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      label: Text("Card Number"),
                      focusColor: Color.fromRGBO(54, 56, 83, 1),
                    ),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_datefocusNode);
                      if (_key.currentState!.validate()) {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(content: Text('Processing Data')),
                        // );
                      }
                      if (selVal!.isNotEmpty) {
                        setState(() {
                          selVal = null;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: const Color.fromRGBO(91, 37, 159, 1))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        date == null
                            ? const Text("mm/yyyy")
                            : Text(DateFormat.yM().format(date!)),
                        TextButton(
                          focusNode: _datefocusNode,
                          child: const Text("Pick a date",
                              style: TextStyle(
                                  color: Color.fromRGBO(91, 37, 159, 1))),
                          onPressed: () {
                            datePicker();
                          },
                        )
                      ]),
                ),
              ),
            ),
            for (int i = 0; i < availableData.length; i++)
              if (availableData[i].id != widget.args['id'])
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    height: 30,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(
                            color: const Color.fromRGBO(91, 37, 159, 1))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(availableData[i].bank),
                          Radio<String>(
                            value: availableData[i].id,
                            groupValue: selVal,
                            onChanged: radioFunction,
                            activeColor: const Color.fromRGBO(91, 37, 159, 1),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Money:',
                    style: TextStyle(
                        fontSize: 25, color: Color.fromRGBO(91, 37, 159, 1)),
                  ),
                  Text(
                    '\$${widget.args['price']} ',
                    style: const TextStyle(
                        fontSize: 19, color: Color.fromRGBO(189, 189, 189, 1)),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: details == null
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.spaceBetween,
              children: [
                details == null
                    ? const Text('User not found',
                        style: TextStyle(fontSize: 25, color: Colors.black54))
                    : (Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("To:",
                              style: TextStyle(
                                  fontSize: 25, color: Colors.black54)),
                          Text(details!,
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.black54))
                        ],
                      )),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.75),
              child: SizedBox(
                height: 65,
                width: 301,
                child: ElevatedButton(
                  onPressed: () {
                    _saveForm(context);
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        const Color.fromRGBO(91, 37, 159, 1),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      )),
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
    ));
  }
}
