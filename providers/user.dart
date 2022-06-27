import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:walletapp/providers/notification.dart';
import 'package:walletapp/providers/transactions.dart';

class User {
  String id;
  String profilePic;
  String ownerName;
  String title;
  String creatorId;
  List<dynamic> cardId;
  List<dynamic> notId;
  User(
      {required this.creatorId,
      required this.notId,
      required this.title,
      required this.id,
      required this.cardId,
      required this.profilePic,
      required this.ownerName});
}

class UserData with ChangeNotifier {
  String? token;
  String? userId;
  String? _id;
  List<User> _data = [
    // User(
    //     id: 'u1',
    //     profilePic: 'assets/images/profile.jpeg',
    //     ownerName: 'Maftuna',
    //     cardId: ['c1', 'c3'],
    //     notId: [
    //       'n1',
    //       'n3',
    //     ],
    //     title: 'wallet',
    //     ),
    // User(
    //     title: 'My Card',
    //     id: 'u2',
    //     profilePic: 'assets/images/pro.HEIC',
    //     ownerName: 'Rakhmatullo 🤓',
    //     cardId: ['c2'],
    //     notId: ['n1', 'n2', 'n3', 'n4', 'n5', 'n6']),
  ];
  List<User> get data {
    return [..._data];
  }

  void updateAuth(String? authToken, String? userId, List<User> users) {
    token = authToken;
    _data = users;
    this.userId = userId;
  }

  String get id {
    return _id!;
  }

  bool get isEmpty {
    return _data.any((element) => element.id == userId);
  }

  Future<void> fetchAndSetData() async {
    final url = Uri.parse(
        'https://walletapp-5cd2f-default-rtdb.firebaseio.com/users.json?auth=$token');
    try {
      final response = await http.get(url);
      // print(response.body);
      final Map<String, dynamic>? extractedUsers =
          await json.decode(response.body);
      // print(extractedUsers);
      final List<User> users = [];
      extractedUsers!.forEach((key, value) {
        // print(cards.runtimeType);
        users.add(User(
            creatorId: value['creatorId'],
            notId: value['notId'] ?? [''],
            title: value['title'],
            id: key,
            cardId: value['cardId'] ?? [''],
            profilePic: value['profilePic'],
            ownerName: value['ownerName']));
      });
      _data = users;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addUser(User value) async {
    final url = Uri.parse(
        'https://walletapp-5cd2f-default-rtdb.firebaseio.com/users.json?auth=$token');
    try {
      final response = await http.post(url,
          body: json.encode({
            'cardId': value.cardId.map((e) => e).toList(),
            'profilePic': 'assets/images/ava.jpeg',
            'title': value.title,
            'ownerName': value.ownerName,
            'creatorId': userId,
            'notId': value.notId.map((e) => e).toList(),
          }));
      final newData = User(
          creatorId: userId!,
          notId: [''],
          title: value.title,
          id: json.decode(response.body)['name'],
          cardId: value.cardId,
          profilePic: 'assets/images/ava.jpeg',
          ownerName: value.ownerName);
      _data.add(newData);
      _id = json.decode(response.body)['name'];
    } catch (error) {
      rethrow;
    }

    notifyListeners();
  }

  Future<void> addCardId(String id, User value) async {
    final userInd = _data.indexWhere((element) => element.id == id);
    final url = Uri.parse(
        'https://walletapp-5cd2f-default-rtdb.firebaseio.com/users/$id/cardId.json?auth=$token');
    try {
      if (userInd >= 0) {
        final response = await http.get(url);
        if (response.body.isEmpty) {
          await http.delete(url);
        }
        for (int i = 0; i < value.cardId.length; i++) {
          await http.patch(url, body: json.encode({'$i': value.cardId[i]}));
        }
        _data[userInd] = value;
        notifyListeners();
      } else {}
    } catch (error) {
      // print(error);
    }
  }

  Future<void> update(
      String id, List<NotificationDetails> newData, String creatorId) async {
    final url = Uri.parse(
        'https://walletapp-5cd2f-default-rtdb.firebaseio.com/users/$id/notId.json?auth=$token');

    int? index;
    index = _data.indexWhere((user) => user.id == id);
    _data[index].notId.add(newData.last.id);
    try {
      if (index >= 0) {
        final response = await http.get(url);
        final List<dynamic>? nots = await json.decode(response.body);
        int i = nots!.length;
        {
          await http.patch(url,
              body: json.encode({'$i': newData.last.id}));
        }
        _data[index] = User(
          creatorId: _data[index].creatorId,
          cardId: _data[index].cardId,
          title: _data[index].title,
          ownerName: _data[index].ownerName,
          notId: _data[index].notId,
          profilePic: _data[index].profilePic,
          id: _data[index].id,
        );
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
