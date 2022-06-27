import 'package:flutter/material.dart';
// import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';

import 'screens/splashscreen.dart';
import 'providers/auth.dart';
import 'screens/authScreen.dart';
import 'screens/setting_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/transfer_more.dart';
import 'providers/card.dart';
import 'providers/notification.dart';
import 'providers/transactions.dart';
import 'screens/home.dart';
import 'screens/transfer_screen.dart';
import 'providers/user.dart';
import 'screens/new_card_screen.dart';
import 'screens/beginner.dart';

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
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Data>(
          create: (context) => Data(),
          update: (context, auth, previousCard) => previousCard!
            ..updateAuth(
                auth.token, previousCard == null ? [] : previousCard.data),
        ),
        ChangeNotifierProxyProvider<Auth, TransactionData>(
            create: ((context) => TransactionData()),
            update: (context, auth, previousTrans) {
              if (auth.token != null) {
                return previousTrans!
                  ..update(auth.token!,
                      previousTrans == null ? [] : previousTrans.data);
              }
              return previousTrans!;
            }),
        ChangeNotifierProxyProvider<Auth, UserData>(
            create: (context) => UserData(),
            update: (context, auth, previousUser) {
              if (auth.userID != null) {
                return previousUser!
                  ..updateAuth(auth.token, auth.userID,
                      previousUser == null ? [] : previousUser.data);
              }
              return previousUser!;
            }),
        ChangeNotifierProxyProvider<Auth, NotificationData>(
            create: (context) => NotificationData(),
            update: (context, auth, previousNots) {
              if (auth.token != null) {
                return previousNots!
                  ..update(auth.token!,
                      previousNots == null ? [] : previousNots.data);
              }
              return previousNots!;
            })
      ],
      child: Consumer<Auth>(
          builder: ((context, value, child) => MaterialApp(
                theme: ThemeData(
                    fontFamily: 'QuickSand',
                    primaryColor: const Color.fromRGBO(132, 56, 255, 1)),
                home: value.isAuth
                    ? (Consumer<UserData>(builder: (context, user, child) {
                        user.fetchAndSetData();
                        for (int i = 0; i < user.data.length; i++) {
                          if (user.data[i].creatorId == value.userID) {
                            return Home(user.data[i].id);
                          }
                        }
                        return const BeginnerScreen();
                      }))
                    : FutureBuilder(
                        future: value.tryAutoLogin(),
                        builder: ((context, snapshot) =>
                            snapshot.connectionState == ConnectionState.waiting
                                ? const SplashScreen()
                                : AuthScreen())),
                routes: {
                  Transfer.routeName: (context) {
                    return Transfer();
                  },
                  TransferMore.routeName: (context) {
                    var args = ModalRoute.of(context)?.settings.arguments;
                    return TransferMore(args);
                  },
                  NotificationScreen.routeName: (context) =>
                      const NotificationScreen(),
                  SettingScreen.routeName: (context) => const SettingScreen(),
                  Home.routeName: (context) {
                    final id =
                        ModalRoute.of(context)!.settings.arguments as String;
                    return Home(id);
                  },
                  NewCardScreeen.routeName: (context) {
                    final id =
                        ModalRoute.of(context)!.settings.arguments as String;
                    return NewCardScreeen(id);
                  },
                },
              ))),
    );
  }
}
