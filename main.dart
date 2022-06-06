import 'package:flutter/material.dart';
// import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';
import 'package:walletapp/providers/user.dart';

import 'screens/setting_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/transfer_more.dart';
import 'providers/card.dart';
import 'providers/notification.dart';
import 'providers/transactions.dart';
import 'screens/home.dart';
import 'screens/transfer_screen.dart';

void main() {
  runApp(const WalletApp());
}

class WalletApp extends StatelessWidget {
  const WalletApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Data(),
        ),
        ChangeNotifierProvider(
          create: ((context) => TransactionData()),
        ),
        ChangeNotifierProvider(
          create: (context) => UserData(),
        ),
        ChangeNotifierProvider(create: (context) => NotificationData())
      ],
      child: MaterialApp(
        // localizationsDelegates:

        // MonthYearPickerLocalizations.localizationsDelegates,

        theme: ThemeData(
            fontFamily: 'QuickSand',
            primaryColor: const Color.fromRGBO(132, 56, 255, 1)),
        home: const Home(),
        routes: {
          Transfer.routeName: (context) {
            return Transfer();
          },
          TransferMore.routeName: (context) {
            var args = ModalRoute.of(context)?.settings.arguments;
            return TransferMore(args);
          },
          NotificationScreen.routeName: (context) => const NotificationScreen(),
          SettingScreen.routeName: (context) => const SettingScreen(),
        },
      ),
    );
  }
}
