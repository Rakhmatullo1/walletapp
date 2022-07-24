import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/http_exception.dart';
import '../providers/auth.dart';
// aaaa

enum AuthMode {
  login,
  signUp,
}

class AuthScreen extends StatefulWidget {
  AuthScreen({Key? key}) : super(key: key);


  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthMode auth = AuthMode.login;

  final _key = GlobalKey<FormState>();

  final emailCont = TextEditingController();

  final emailNode = FocusNode();

  final passWord = TextEditingController();
  final password1 = TextEditingController();
  final passwordNode = FocusNode();

  @override
  void dispose() {
    emailCont.dispose();
    emailNode.dispose();
    passWord.dispose();
    passwordNode.dispose();
    super.dispose();
  }
  void _showDialog(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Error Occured'),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Okay'))
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_key.currentState!.validate()) {
      return;
    }
    try {if (auth == AuthMode.login) {
      await Provider.of<Auth>(context, listen: false)
          .logIn(emailCont.text, passWord.text);
    } else {
      await Provider.of<Auth>(context, listen: false)
          .signUp(emailCont.text, passWord.text);
    }} on HttpException catch (error){
      var errorMessage = "Failed";
      if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = "Enter valid username";
      } else if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = "This username exists";
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'password or username is incorrect';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'This username does not exist';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'Please, enter stronger password';
      }
      _showDialog(errorMessage);
    } catch (errorMessage) {
      var errorMessage= "Authentication is failed, try again later";
      _showDialog(errorMessage);
    }
  }

  void switchAuth() {
    if (auth == AuthMode.signUp) {
      setState(() {
        auth = AuthMode.login;
      });
    } else {
      setState(() {
        auth = AuthMode.signUp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(
          top: 103,
          right: MediaQuery.of(context).size.width * 0.088,
          left: MediaQuery.of(context).size.width * 0.088),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              auth == AuthMode.login ? "Log In" : "SignUp",
              style: const TextStyle(
                  fontSize: 30, color: Color.fromRGBO(19, 1, 56, 1)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Form(
                key: _key,
                child: Column(children: [
                  TextFormField(
                    validator: (_) {
                      if (!emailCont.text.contains('@')) {
                        return 'Please enter valid email';
                      }
                    },
                    decoration: const InputDecoration(label: Text("email")),
                    controller: emailCont,
                    focusNode: emailNode,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(passwordNode);
                    },
                  ),
                  TextFormField(
                    validator: (_) {
                      if (passWord.text.length < 6) {
                        return 'Please, enter 6 more charachters in your passcode';
                      }
                    },
                    decoration: const InputDecoration(label: Text("password")),
                    controller: passWord,
                    focusNode: passwordNode,
                    textInputAction: auth == AuthMode.login
                        ? TextInputAction.done
                        : TextInputAction.next,
                    keyboardType: TextInputType.text,
                  ),
                  if (auth == AuthMode.signUp)
                    TextFormField(
                      controller: password1,
                      validator: (_) {
                        if (passWord.text != password1.text) {
                          return 'your code does not match';
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(label: Text("Password again")),
                    ),
                  TextButton(
                      onPressed: () {
                        switchAuth();
                      },
                      child: Text(
                        auth == AuthMode.login
                            ? "SignUp Instead"
                            : "Login instead",
                        style: const TextStyle(
                            color: Color.fromRGBO(19, 1, 56, 1)),
                      )),
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
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15)))),
                          onPressed: () {
                            _submit();
                          },
                          child: Text(
                            auth == AuthMode.login ? "Login" : "SignUp",
                            style: const TextStyle(fontSize: 24),
                          )),
                    ),
                  )
                ]),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
