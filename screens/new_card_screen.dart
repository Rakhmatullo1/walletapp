import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:walletapp/screens/home.dart';

import '../providers/card.dart';
import '../providers/user.dart';

class NewCardScreeen extends StatefulWidget {
  String id;
  static const routeName = '/new-card';
  NewCardScreeen(this.id, {Key? key}) : super(key: key);

  @override
  State<NewCardScreeen> createState() => _NewCardScreeenState();
}

class _NewCardScreeenState extends State<NewCardScreeen> {
  final _key = GlobalKey<FormState>();
  final cardText = TextEditingController();
  final cardNode = FocusNode();
  final title = TextEditingController();
  final dateofExpiry = TextEditingController();
  final dateNode = FocusNode();
  final titleNode = FocusNode();
  DateTime date = DateTime.now();
  User? userData;
  CardDetails? cardData;
  List<String> cards = [];
  var init = false;

  @override
  void initState() {
    userData = Provider.of<UserData>(context, listen: false)
        .data
        .firstWhere((element) => element.id == widget.id);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    cardData = CardDetails(
        creatorId: '',
        balance: 0,
        id: '',
        transID: [''],
        dateOfExpiry: date,
        bank: title.text,
        cardNumber: cardText.text);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    cardText.dispose();
    cardNode.dispose();
    titleNode.dispose();
    title.dispose();
    dateofExpiry.dispose();
    dateNode.dispose();
    super.dispose();
  }

  void datePicker() {
    showDialog(
        context: context,
        barrierColor: Colors.white70,
        builder: (context) {
          return CupertinoDatePicker(
            onDateTimeChanged: (val) {
              setState(() {
                date = val;
              });
            },
            mode: CupertinoDatePickerMode.date,
          );
        });
  }

  Future<void> saveForm() async {
    setState(() {
      init = true;
    });
    // Provider.of<UserData>(context, listen: false).addCard(userData!.id, DateTime.now().toString());
    if (!_key.currentState!.validate()) {
      return;
    }
    try {
      await Provider.of<Data>(context, listen: false)
          .addcard(cardData!, userData!.creatorId);
    } finally {
      try {
        await Provider.of<Data>(context, listen: false).fetchAndSetData();
      } catch (_) {
      } finally {
        final justcards = Provider.of<Data>(context, listen: false).data;
        for (int i = 0; i < justcards.length; i++) {
          if (justcards[i].creatorId == userData!.creatorId) {
            cards.add(justcards[i].id!);
          }
        }

        userData = User(
            creatorId: userData!.id,
            notId: [''],
            title: userData!.title,
            id: userData!.id,
            cardId: cards,
            profilePic: userData!.profilePic,
            ownerName: userData!.ownerName);
        Provider.of<UserData>(context, listen: false)
            .addCardId(widget.id, userData!);
        setState(() {
          init = false;
        });
        Navigator.of(context)
            .popAndPushNamed(Home.routeName, arguments: widget.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: init
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.088,
                left: MediaQuery.of(context).size.width * 0.088,
                top: 103,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text("Add new Card ",
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(19, 1, 56, 1))),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Form(
                        key: _key,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please fill form';
                                }
                                if (value.length != 16) {
                                  return 'Please enter valid cardNumber';
                                }
                                return null;
                              },
                              focusNode: cardNode,
                              controller: cardText,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  label: Text('Enter card Number')),
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(dateNode);
                              },
                              onSaved: (value) {
                                cardData = CardDetails(
                                    creatorId: cardData!.creatorId,
                                    transID: [''],
                                    id: cardData!.id,
                                    balance: cardData!.balance,
                                    dateOfExpiry: cardData!.dateOfExpiry,
                                    bank: cardData!.bank,
                                    cardNumber: value!);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  // border: const Border(
                                  //   bottom: BorderSide(width: 1, style: BorderStyle.solid),
                                  // ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        date == null
                                            ? const Text("mm/yyyy")
                                            : Text(
                                                DateFormat.yM().format(date)),
                                        TextButton(
                                          focusNode: dateNode,
                                          child: const Text("Pick a date",
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      91, 37, 159, 1))),
                                          onPressed: () {
                                            datePicker();
                                          },
                                        )
                                      ]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                      color: Colors.black45,
                      // color : Colors.blue,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextFormField(
                        validator: ((value) {
                          if (value!.isEmpty) {
                            return 'Please fill form';
                          }
                          return null;
                        }),
                        controller: title,
                        decoration: const InputDecoration(
                            label: Text(" Enter title"),
                            focusColor: Colors.black45),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.45),
                      child: SizedBox(
                        height: 65,
                        width: 301,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromRGBO(91, 37, 159, 1)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)))),
                            onPressed: () {
                              saveForm();
                            },
                            child: const Text(
                              "Save Data",
                              style: TextStyle(fontSize: 20),
                            )),
                      ),
                    ),
                  ],
                ),
              )),
    );
  }
}
