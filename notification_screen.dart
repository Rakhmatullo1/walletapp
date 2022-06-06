import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/notification_widget.dart';
import '../providers/notification.dart';

class NotificationScreen extends StatelessWidget {
  static const routeName = '/notification-screen';
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ids = ModalRoute.of(context)!.settings.arguments as List;
    final nots = Provider.of<NotificationData>(context).data;
    final finalData = nots.where((not) {
      return ids.any((e) => e == not.id);
    }).toList();
    Color purpcolor = const Color.fromRGBO(19, 1, 56, 1);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.088,
            vertical: 103),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text("Notification",
              style: TextStyle(
                  fontSize: 24, color: purpcolor, fontWeight: FontWeight.bold)),
          const Padding(
            padding: EdgeInsets.only(top: 57.0),
            child: Text(
              "New",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 4),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < finalData.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: NotificationItem(finalData[i].id),
                      )
                  ],
                ),
              ))
        ]),
      ),
    );
  }
}
