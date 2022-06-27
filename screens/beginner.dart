import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/user.dart';

class BeginnerScreen extends StatefulWidget {
  const BeginnerScreen({Key? key}) : super(key: key);

  @override
  State<BeginnerScreen> createState() => _BeginnerScreenState();
}

class _BeginnerScreenState extends State<BeginnerScreen> {
  final name = TextEditingController();
  final nameNode = FocusNode();
  final title = TextEditingController();
  final titleNode = FocusNode();
  final _form = GlobalKey<FormState>();
  User? userData;

  @override
  void didChangeDependencies() {
    userData = User(
        creatorId: '',
        notId: [''],
        title: title.text,
        id: '',
        cardId: [''],
        profilePic: '',
        ownerName: name.text);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    name.dispose();
    nameNode.dispose();
    title.dispose();
    titleNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {

    // print(Provider.of<UserData>(context, listen: false).fetchAndSetData());
    // for (int i = 0;
    //     i < Provider.of<UserData>(context, listen: false).data.length;
    //     i++) {
    //   print(Provider.of<UserData>(context, listen: false).data[i].id);
    // }

    if (!_form.currentState!.validate()) {
    // Provider.of<Auth>(context, listen: false).logOut();

      return;
    }

    try {
      await Provider.of<UserData>(context, listen: false).addUser(userData!);
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          content: Text('SomeThing went wrong'),
        ),
      );
    } finally {
      userData!.id = Provider.of<UserData>(context, listen: false).id;
      // Navigator.of(context)
      //     .pushReplacementNamed(Home.routeName, arguments: userData!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of<UserData>(context).fetchAndSetData;
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(
          right: MediaQuery.of(context).size.width * 0.088,
          left: MediaQuery.of(context).size.width * 0.088,
          top: 103),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text("Adding User",
                style: TextStyle(
                  fontSize: 32,
                )),
            Form(
              key: _form,
              child: Column(children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please provide information';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(label: Text("Your Name")),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: name,
                  focusNode: nameNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(titleNode);
                  },
                  onSaved: (val) {
                    userData = User(
                        creatorId: userData!.creatorId,
                        id: userData!.id,
                        cardId: [''],
                        notId: [''],
                        profilePic: userData!.profilePic,
                        ownerName: val!,
                        title: userData!.title);
                  },
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please provide information';
                    }
                    return null;
                  },
                  decoration:
                      const InputDecoration(label: Text("Wallet's Name")),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  controller: title,
                  focusNode: titleNode,
                  onSaved: (val) {
                    userData = User(
                        creatorId: userData!.creatorId,
                        id: userData!.id,
                        cardId: [''],
                        notId: [''],
                        profilePic: userData!.profilePic,
                        ownerName: userData!.ownerName,
                        title: val!);
                  },
                ),
              ]),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.85),
              child: SizedBox(
                height: 65,
                width: 301,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromRGBO(19, 1, 56, 1)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)))),
                    onPressed: () {
                      _saveForm();
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 24),
                    )),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
