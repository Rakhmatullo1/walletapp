import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Transaction {
  String? id;
  String name;
  String type;
  double price;
  String image;
  DateTime date;
  Transaction({
    required this.id,
    required this.name,
    required this.image,
    required this.type,
    required this.date,
    required this.price,
  });
}

class TransactionData with ChangeNotifier {
  String? token;
  String _id = '';
  String userId = '';
  List<Transaction> _data = [
    // Transaction(
    //   id: 't1',
    //   transType: TransType.payment,
    //   name: "Netflix",
    //   image:
    //       'https://static.independent.co.uk/s3fs-public/thumbnails/image/2019/02/02/10/netflix-logo.jpg',
    //   type: 'Month subscription',
    //   date: DateTime.now(),
    //   price: 12,
    // ),
    // Transaction(
    //   id: 't2',
    //   transType: TransType.payment,
    //   name: "Paypal",
    //   image:
    //       'https://www.paypalobjects.com/marketing/web/us/en/business/smb/shared/icons/paypal-accept-payments.png',
    //   type: 'Tax',
    //   date: DateTime.now(),
    //   price: 10,
    // ),
  ];
  List<Transaction> get data {
    return [..._data];
  }

  void update(String? authToken, List<Transaction> data) {
    token = authToken;
    _data = data;
  }

  String get id {
    return _id;
  }

  Future<void> fetchAndSetData() async {
    final url = Uri.parse(
        'https://walletapp-5cd2f-default-rtdb.firebaseio.com/trans.json?auth=$token');
    try {
      final response = await http.get(url);
      final Map<String, dynamic>? extractedTrans = json.decode(response.body);
      List<Transaction> loadedTrans = [];
      if (extractedTrans != null) {
        extractedTrans.forEach((key, value) {
          loadedTrans.add(Transaction(
              id: key,
              name: value['title'],
              image: value['image'],
              type: value['type'],
              date: DateTime.parse(value['date']),
              price: value['price']));
        });
      }
      _data = loadedTrans;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addTransactions(
      {required String name,
      required double price,
      required String type}) async {
    DateTime date = DateTime.now();
    final url = Uri.parse(
        'https://walletapp-5cd2f-default-rtdb.firebaseio.com/trans.json?auth=$token');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': name,
            'price': price,
            'type': type,
            'date': date.toIso8601String(),
            'image': 'assets/images/convert.png',
          }));
      _id = json.decode(response.body)['name'];
      Transaction newTrans = Transaction(
          id: _id,
          name: name,
          image: 'assets/images/convert.png',
          type: type,
          date: date,
          price: price);
      _data.add(newTrans);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
