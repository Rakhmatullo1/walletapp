import 'package:flutter/material.dart';

enum TransType {
  transfer,
  payment,
}

class Transaction {
  String? id;
  TransType? transType;
  String name;
  String type;
  double price;
  String image;
  DateTime date;
  Transaction({
    required this.id,
    required this.transType,
    required this.name,
    required this.image,
    required this.type,
    required this.date,
    required this.price,
  });
}

class TransactionData with ChangeNotifier {
  final _data = [
    Transaction(
      id: 't1',
      transType: TransType.payment,
      name: "Netflix",
      image:
          'https://static.independent.co.uk/s3fs-public/thumbnails/image/2019/02/02/10/netflix-logo.jpg',
      type: 'Month subscription',
      date: DateTime.now(),
      price: 12,
    ),
    Transaction(
      id: 't2',
      transType: TransType.payment,
      name: "Paypal",
      image:
          'https://www.paypalobjects.com/marketing/web/us/en/business/smb/shared/icons/paypal-accept-payments.png',
      type: 'Tax',
      date: DateTime.now(),
      price: 10,
    ),
  ];
  List<Transaction> get data {
    return [..._data];
  }

  void addTransactions(
      {required String id,
      required TransType transType,
      required String name,
      required double price,
      required String type}) {
    Transaction newTrans = Transaction(
        id: id,
        transType: transType,
        name: name,
        image: 'assets/images/convert.png',
        type: type,
        date: DateTime.now(),
        price: price);
    _data.add(newTrans);
    notifyListeners();
  }
}
