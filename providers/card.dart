import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'transactions.dart';

class CardDetails {
  String creatorId;
  String? id;
  List<dynamic> transID;
  double balance;
  DateTime dateOfExpiry;
  String bank;
  String cardNumber;
  CardDetails(
      {required this.creatorId,
      required this.transID,
      required this.id,
      required this.balance,
      required this.dateOfExpiry,
      required this.bank,
      required this.cardNumber});
}

class Data with ChangeNotifier {
  String? token;
  String userId = '';
  String _id = '';
  final isUpdated = false;
  List<CardDetails> _data = [
    // CardDetails(
    //     transID: ['t2'],
    //     id: 'c1',
    //     balance: 1234,
    //     type: 'Visa',
    //     dateOfIssue: DateTime(2020, 3),
    //     dateOfExpiry: DateTime(2023, 4),
    //     bank: 'MaBank',
    //     cardNumber: 1234567890122138),
    // CardDetails(
    //     transID: [''],
    //     id: 'c2',
    //     balance: 1234,
    //     type: 'Visa',
    //     dateOfIssue: DateTime(2021, 5),
    //     dateOfExpiry: DateTime(2023, 4),
    //     bank: 'MMAABank',
    //     cardNumber: 1234567890123456),
    // CardDetails(
    //     transID: ['t1'],
    //     id: 'c3',
    //     balance: 1234,
    //     type: 'Visa',
    //     dateOfIssue: DateTime(2021, 5),
    //     dateOfExpiry: DateTime(2023, 4),
    //     bank: 'OURBank',
    //     cardNumber: 1234567890123478),
  ];
  List<CardDetails> get data {
    return [..._data];
  }

  void updateAuth(String? authtoken, List<CardDetails> cards) {
    token = authtoken;
    _data = cards;
  }

  String get id {
    return _id;
  }

  Future<void> addcard(CardDetails value, String userId) async {
    final url = Uri.parse(
        'https://walletapp-5cd2f-default-rtdb.firebaseio.com/cards.json?auth=$token');
    try {
      final response = await http.post(url,
          body: json.encode({
            'transId': value.transID.map((e) => e).toList(),
            'creatorId': userId,
            'balance': 1000.0,
            'cardNumber': value.cardNumber,
            'dateOfExpiry': value.dateOfExpiry.toIso8601String(),
            'bank': value.bank,
          }));
      final newData = CardDetails(
          creatorId: userId,
          transID: [''],
          id: json.decode(response.body)['name'],
          balance: 1000,
          dateOfExpiry: value.dateOfExpiry,
          bank: value.bank,
          cardNumber: value.cardNumber);
      _id = json.decode(response.body)['name'];
      _data.add(newData);

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchAndSetData() async {
    final url = Uri.parse(
        'https://walletapp-5cd2f-default-rtdb.firebaseio.com/cards.json?auth=$token');
    try {
      final response = await http.get(url);
      final Map<String, dynamic>? extractedCards =
          await json.decode(response.body);
      final List<CardDetails> loadedCards = [];
      if (extractedCards != null) {
        extractedCards.forEach((key, value) {
          // print(value['dateOfExpiry'].runtimeType);
          loadedCards.add(CardDetails(
              creatorId: value['creatorId'],
              transID: value['transId'] ?? [''],
              id: key,
              balance: value['balance'] + 0.0,
              dateOfExpiry: DateTime.parse(value['dateOfExpiry']),
              bank: value['bank'],
              cardNumber: value['cardNumber']));
        });
      }
      // print(loadedCards);
      _data = loadedCards;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateTrans(String id, List<Transaction> value) async {
    int index;
    index = _data.indexWhere((card) => card.id == id);
    _data[index].transID.add(value.last.id);
    print(_data.length);
    final url = Uri.parse(
        'https://walletapp-5cd2f-default-rtdb.firebaseio.com/cards/$id/transId.json?auth=$token');
    try {
      final response = await http.get(url);
      if (response.body.isEmpty) {
        await http.delete(url);
      }
      final List<dynamic>? trans = await json.decode(response.body);
      int i = trans!.length;
      await http.patch(url,
          body: json.encode({
            '$i': value.last.id,
          }));
      _data[index] = CardDetails(
        creatorId: userId,
        transID: _data[index].transID,
        id: _data[index].id,
        dateOfExpiry: _data[index].dateOfExpiry,
        balance: _data[index].balance,
        bank: _data[index].bank,
        cardNumber: _data[index].cardNumber,
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> update(String id, double newAmount) async {
    final url = Uri.parse(
        'https://walletapp-5cd2f-default-rtdb.firebaseio.com/cards/$id.json?auth=$token');

    int index;
    index = _data.indexWhere((card) => card.id == id);

    try {
      await http.patch(url,
          body: json.encode({
            'creatorId': _data[index].creatorId,
            'balance': newAmount,
            'cardNumber': _data[index].cardNumber,
            'dateOfExpiry': _data[index].dateOfExpiry.toIso8601String(),
            'bank': _data[index].bank,
            'transId': _data[index].transID,
          }));
      _data[index] = CardDetails(
        creatorId: userId,
        transID: _data[index].transID,
        id: _data[index].id,
        dateOfExpiry: _data[index].dateOfExpiry,
        balance: newAmount,
        bank: _data[index].bank,
        cardNumber: _data[index].cardNumber,
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
