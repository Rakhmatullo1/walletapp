import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  static const routeName = '/setting-screen';
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color purpcolor = const Color.fromRGBO(19, 1, 56, 1);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.088,
            vertical: 103),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text("Settings",
              style: TextStyle(
                fontSize: 24,
                color: purpcolor,
              )),
          Padding(
            padding: const EdgeInsets.only(top: 52.0, bottom: 30),
            child: GestureDetector(
              onTap: () {},
              child: ListTile(
                leading: Container(
                  height: 48,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 2.5),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20)),
                  child: Image.asset('assets/images/profile-1.png'),
                ),
                title: Text(
                  "Profile",
                  style: TextStyle(color: purpcolor),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: purpcolor,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: GestureDetector(
              onTap: () {},
              child: ListTile(
                leading: Container(
                    height: 48,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(0, 2.5),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20)),
                    child: Image.asset(
                      'assets/images/notification.png',
                    )),
                title: Text(
                  "Notifications",
                  style: TextStyle(color: purpcolor),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: purpcolor,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: GestureDetector(
              onTap: () {},
              child: ListTile(
                leading: Container(
                  height: 48,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 2.5),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20)),
                  child: Image.asset('assets/images/wallet-3.png',
                      color: purpcolor),
                ),
                title: Text(
                  "Your Wallet",
                  style: TextStyle(color: purpcolor),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: purpcolor,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: GestureDetector(
              onTap: () {},
              child: ListTile(
                leading: Container(
                  height: 48,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 2.5),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20)),
                  child: Image.asset(
                    'assets/images/key-square.png',
                  ),
                ),
                title: Text(
                  "Login Settings",
                  style: TextStyle(color: purpcolor),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: purpcolor,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: ListTile(
              leading: Container(
                height: 48,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 2.5),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20)),
                child: Image.asset(
                  'assets/images/call-calling.png',
                ),
              ),
              title: Text(
                "Service Center",
                style: TextStyle(color: purpcolor),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
                color: purpcolor,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
