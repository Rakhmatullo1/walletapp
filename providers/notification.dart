import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotificationDetails {
  String creatorId;
  String id;
  DateTime date;
  bool statusType;
  double amount;
  String reason;
  String reason1;
  NotificationDetails({
    required this.creatorId,
    required this.reason1,
    required this.id,
    required this.date,
    required this.amount,
    required this.reason,
    required this.statusType,
  });
}

class NotificationData with ChangeNotifier {
  String? token;
  String userId = '';
  String _id = '';
  List<NotificationDetails> _data = [
    // NotificationDetails(
    //     reason1: 'Paypal',
    //     id: 'n2',
    //     date: DateTime(2022, 1, 2, 9, 2),
    //     amount: 32,
    //     reason: 'Buy items',
    //     statusType: false),
    // NotificationDetails(
    //     reason1: 'Rakhmatullo',
    //     id: 'n1',
    //     date: DateTime(2022, 2, 28, 9, 2),
    //     amount: 300,
    //     reason: 'Pay debt',
    //     statusType: true),
    // NotificationDetails(
    //     reason1: 'Netflix',
    //     id: 'n4',
    //     date: DateTime(2022, 3, 2, 9, 2),
    //     amount: 140,
    //     reason: 'Buy items',
    //     statusType: false),
    // NotificationDetails(
    //     reason1: 'Netflix',
    //     id: 'n5',
    //     date: DateTime(2022, 4, 2, 9, 2),
    //     amount: 130,
    //     reason: 'Buy items',
    //     statusType: true),
    // NotificationDetails(
    //     reason1: 'Netflix',
    //     id: 'n6',
    //     date: DateTime(2022, 4, 2, 9, 2),
    //     amount: 130,
    //     reason: 'Buy items',
    //     statusType: true),
    // NotificationDetails(
    //     reason1: 'Netflix',
    //     id: 'n3',
    //     date: DateTime(2022, 5, 2, 9, 2),
    //     amount: 210,
    //     reason: 'Buy items',
    //     statusType: false),
  ];
  List<NotificationDetails> get data {
    return [..._data];
  }

  void update(String authToken, List<NotificationDetails> data) {
    token = authToken;
    _data = data;
  }

  String get id {
    return _id;
  }

  Future<void> fetchAndSetData() async {
    final url = Uri.parse(
        'https://walletapp-5cd2f-default-rtdb.firebaseio.com/nots.json?auth=$token');
    try {
      final response = await http.get(url);
      final Map<String, dynamic>? extractedNots =
          await json.decode(response.body);
      final List<NotificationDetails> loadedNots = [];
      if (extractedNots == null) {
        extractedNots!.forEach((key, value) {
          loadedNots.add(NotificationDetails(
              creatorId: value['creatorId'],
              reason1: value['reason1'],
              id: key,
              date: DateTime.parse(value['date']),
              amount: value['amount'],
              reason: value['reason'],
              statusType: value['statusType']));
        });
        _data = loadedNots;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> add(String reason1, DateTime date, double amount, reason,
      bool statusType, String creatorId) async {
    final url = Uri.parse(
        'https://walletapp-5cd2f-default-rtdb.firebaseio.com/nots.json?auth=$token');
    try {
      final response = await http.post(url,
          body: json.encode({
            'creatorId': creatorId,
            'statusType': statusType,
            'reason': reason,
            'amount': amount,
            'date': date.toIso8601String(),
            'reason1': reason1,
          }));
      _id = json.decode(response.body)['name'];
      NotificationDetails newData = NotificationDetails(
          creatorId: creatorId,
          reason1: reason1,
          id: _id,
          date: date,
          amount: amount,
          reason: reason,
          statusType: statusType);
      _data.add(newData);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
