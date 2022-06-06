import 'package:flutter/material.dart';

class User {
  String id;
  String profilePic;
  String ownerName;
  bool status;
  String title;
  List<String> cardId;
  List<String> notId;
  User(
      {required this.notId,
      required this.status,
      required this.title,
      required this.id,
      required this.cardId,
      required this.profilePic,
      required this.ownerName});
}

class UserData with ChangeNotifier {
  final _data = [
    User(
        id: 'u1',
        profilePic: 'assets/images/profile.jpeg',
        ownerName: 'Guzal',
        cardId: ['c1', 'c3'],
        notId: ['n1', 'n3'],
        title: 'wallet',
        status: true),
    User(
        title: 'My Card',
        status: true,
        id: 'u2',
        profilePic: 'assets/images/pro.HEIC',
        ownerName: 'Rakhmatullo',
        cardId: ['c2'],
        notId: ['n2']),
  ];
  List<User> get data {
    return [..._data];
  }

  void update(String id, String newData) {
    int? index;
    index = _data.indexWhere((user) => user.id == id);
    _data[index].notId.add(newData);
    _data[index] = User(
      cardId: _data[index].cardId,
      title: _data[index].title,
      status: _data[index].status,
      ownerName: _data[index].ownerName,
      notId: _data[index].notId,
      profilePic: _data[index].profilePic,
      id: _data[index].id,
    );
    notifyListeners();
  }
}
