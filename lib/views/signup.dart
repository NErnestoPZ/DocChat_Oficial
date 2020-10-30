import 'package:DocChat_Oficial/helper/helper.dart';
import 'package:DocChat_Oficial/services/auth.dart';
import 'package:DocChat_Oficial/services/database.dart';
import 'package:DocChat_Oficial/views/chatrooms.dart';
import 'package:DocChat_Oficial/widget/widget.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:DocChat_Oficial/views/forgot_password.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp(this.toggleView);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController usernameEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  singUp() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authService
          .signUpWithEmailAndPassword(
              emailEditingController.text, passwordEditingController.text)
          .then((result) {
        if (result != null) {
          Map<String, String> userDataMap = {
            "username": usernameEditingController.text,
            "password": passwordEditingController.text,
            "email": emailEditingController.text
          };

          databaseMethods.addUserInfo(userDataMap);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              usernameEditingController.text);
          HelperFunctions.saveUserEmailSharedPreference(
              emailEditingController.text);
          HelperFunctions.saveUserPasswordSharedPreference(
              passwordEditingController.text);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        }
      });
    }
  }

  formItemsDesign(icon, item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7),
      child: Card(child: ListTile(leading: Icon(icon), title: item)),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Spacer(),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        formItemsDesign(
                          Icons.person,
                          TextFormField(
                            style: simpleTextStyle(),
                            controller: usernameEditingController,
                            validator: (val) {
                              return val.isEmpty || val.length < 3
                                  ? "Ingrese un nombre de 4+ caracteres"
                                  : null;
                            },
                            decoration:
                                textFieldInputDecoration("Nombre de usuario"),
                          ),
                        ),
                        formItemsDesign(
                          Icons.email,
                          TextFormField(
                            controller: emailEditingController,
                            style: simpleTextStyle(),
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[com]+")
                                      .hasMatch(val)
                                  ? null
                                  : "Ingrese una direccion de e-mail correcta";
                            },
                            decoration: textFieldInputDecoration("E-mail"),
                          ),
                        ),
                        formItemsDesign(
                          Icons.remove_red_eye,
                          TextFormField(
                            obscureText: true,
                            style: simpleTextStyle(),
                            decoration: textFieldInputDecoration("Contraseña"),
                            controller: passwordEditingController,
                            validator: (val) {
                              return val.length < 6
                                  ? "Ingrese una contraseña de 6+ caracteres"
                                  : null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: () {
                      singUp();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF26A69A),
                              const Color(0xff2A75BC)
                            ],
                          )),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Ingresar",
                        style: biggerTextStyle(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Ya tengo una cuenta? ",
                        style: simpleTextStyle(),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.toggleView();
                        },
                        child: Text(
                          "Ingresar ahora",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 125,
                  )
                ],
              ),
            ),
    );
  }
}
