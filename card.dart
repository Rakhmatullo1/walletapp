import 'package:flutter/material.dart';

class CardDetails {
  String id;
  List<String> transID;
  double balance;
  String type;
  DateTime dateOfIssue;
  DateTime dateOfExpiry;
  String bank;
  int cardNumber;
  CardDetails(
      {required this.transID,
      required this.id,
      required this.balance,
      required this.type,
      required this.dateOfIssue,
      required this.dateOfExpiry,
      required this.bank,
      required this.cardNumber});
}

class Data with ChangeNotifier {
  final isUpdated = false;
  final List<CardDetails> _data = [
    CardDetails(
        transID: ['t2'],
        id: 'c1',
        balance: 1234,
        type: 'Visa',
        dateOfIssue: DateTime(2020, 3),
        dateOfExpiry: DateTime(2023, 4),
        bank: 'MaBank',
        cardNumber: 1234567890122138),
    CardDetails(
        transID: [''],
        id: 'c2',
        balance: 1234,
        type: 'Visa',
        dateOfIssue: DateTime(2021, 5),
        dateOfExpiry: DateTime(2023, 4),
        bank: 'MMAABank',
        cardNumber: 1234567890123456),
    CardDetails(
        transID: ['t1'],
        id: 'c3',
        balance: 1234,
        type: 'Visa',
        dateOfIssue: DateTime(2021, 5),
        dateOfExpiry: DateTime(2023, 4),
        bank: 'OURBank',
        cardNumber: 1234567890123478),
  ];
  List<CardDetails> get data {
    return [..._data];
  }

  void update(String id, double newAmount, String extraTransId) {
    int index;
    index = _data.indexWhere((card) => card.id == id);
    if (extraTransId != '') {
      _data[index].transID.add(extraTransId);
    }
    _data[index] = CardDetails(
      transID: _data[index].transID,
      id: _data[index].id,
      dateOfExpiry: data[index].dateOfExpiry,
      dateOfIssue: data[index].dateOfIssue,
      balance: newAmount,
      type: data[index].type,
      bank: data[index].bank,
      cardNumber: data[index].cardNumber,
    );
    notifyListeners();
  }
}
