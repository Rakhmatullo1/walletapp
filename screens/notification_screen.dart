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
        padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 0.088,
            left: MediaQuery.of(context).size.width * 0.088,
            top: 103
            ),
        child: Column(
          children: [
            Text("Notification",
                style: TextStyle(
                    fontSize: 24,
                    color: purpcolor,
                    fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height*0.8,
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(top: 40),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
