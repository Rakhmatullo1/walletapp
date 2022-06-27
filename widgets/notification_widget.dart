import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/notification.dart';

class NotificationItem extends StatelessWidget {
  String id;
  NotificationItem(this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final finalData = Provider.of<NotificationData>(context)
        .data
        .firstWhere(((element) => element.id == id));
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.77),
            boxShadow: [
              BoxShadow(
                  blurRadius: 1,
                  color: Colors.grey.shade300,
                  spreadRadius: 1,
                  offset: const Offset(0.0, 2.5)),
            ]),
        width: double.infinity,
        height: 107,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${DateFormat.yMMMd().format(finalData.date)}, ${DateFormat.jm().format(finalData.date)}',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                  SizedBox(
                    width: 250,
                    height: 45,
                    child: AutoSizeText(
                      finalData.statusType
                          ? 'You received \$${finalData.amount.ceil()} from ${finalData.reason1} '
                          : 'You spent \$${finalData.amount.ceil()} for ${finalData.reason1} ',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Text('\'${finalData.reason}\' ')
                ],
              ),
              finalData.statusType
                  ? Image.asset('assets/images/Arrow - Top.png')
                  : Image.asset('assets/images/Arrow - Bottom.png'),
            ],
          ),
        ));
  }
}
