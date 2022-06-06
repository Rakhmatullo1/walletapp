import 'package:flutter/material.dart';

class Notification {
  String id;
  DateTime date;
  bool statusType;
  double amount;
  String reason;
  String reason1;

  Notification({
    required this.reason1,
    required this.id,
    required this.date,
    required this.amount,
    required this.reason,
    required this.statusType,
  });
}

class NotificationData with ChangeNotifier {
  final _data = [
    Notification(
        reason1: 'Rakhmatullo',
        id: 'n1',
        date: DateTime(2022, 5, 29, 9, 2),
        amount: 100,
        reason: 'Pay debt',
        statusType: true),
    Notification(
        reason1: 'Paypal',
        id: 'n2',
        date: DateTime(2022, 6, 2, 9, 2),
        amount: 32,
        reason: 'Buy items',
        statusType: false),
    Notification(
        reason1: 'Netflix',
        id: 'n3',
        date: DateTime(2022, 5, 2, 9, 2),
        amount: 210,
        reason: 'Buy items',
        statusType: false),
  ];
  List<Notification> get data {
    return [..._data];
  }

  void update(String reason1, String id, DateTime date, double amount, reason,
      bool statusType) {
    Notification newData = Notification(
        reason1: reason1,
        id: id,
        date: date,
        amount: amount,
        reason: reason,
        statusType: statusType);
    _data.add(newData);
    notifyListeners();
  }
}
