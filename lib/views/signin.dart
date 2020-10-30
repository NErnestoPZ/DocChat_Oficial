import 'package:DocChat_Oficial/helper/helper.dart';
import 'package:DocChat_Oficial/services/auth.dart';
import 'package:DocChat_Oficial/services/database.dart';
import 'package:DocChat_Oficial/views/chatrooms.dart';
import 'package:DocChat_Oficial/views/forgot_password.dart';
import 'package:DocChat_Oficial/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn(this.toggleView);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  AuthService authService = new AuthService();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  signIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authService
          .signInWithEmailAndPassword(
              emailEditingController.text, passwordEditingController.text)
          .then((result) async {
        if (result != null) {
          QuerySnapshot userInfoSnapshot =
              await DatabaseMethods().getUserInfo(emailEditingController.text);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              userInfoSnapshot.documents[0].data["userName"]);
          HelperFunctions.saveUserEmailSharedPreference(
              userInfoSnapshot.documents[0].data["userEmail"]);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        } else {
          setState(() {
            isLoading = false;
            //show snackbar
          });
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
              child: Center(child: CircularProgressIndicator()),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
//-----------------------------Logo y nombre de la App---------------------------------------
                  Center(
                    child: Image.asset(
                      "assets/images/logogrande.png",
                      width: MediaQuery.of(context).size.width / 2,
                      height: 200,
                    ),
                  ),
                  Text(
                    "DocChat",
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        color: Color.fromRGBO(
                          36,
                          62,
                          115,
                          1,
                        ),
                        height: 0.2,
                        fontSize: 40.0,
                        fontWeight: FontWeight.w600),
                  ),
//----------------------------------------------------------------------
                  Spacer(),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        formItemsDesign(
                          Icons.email,
                          TextFormField(
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[com]+")
                                      .hasMatch(val)
                                  ? null
                                  : "Ingrese de nuevo su correo electronico";
                            },
                            controller: emailEditingController,
                            style: simpleTextStyle(),
                            decoration: textFieldInputDecoration(
                                "Ingrese su direccion de E-mail"),
                          ),
                        ),
                        formItemsDesign(
                          Icons.remove_red_eye,
                          TextFormField(
                            obscureText: true,
                            validator: (val) {
                              return val.length > 6
                                  ? null
                                  : "Ingrese su contraseña de nuevo";
                            },
                            style: simpleTextStyle(),
                            controller: passwordEditingController,
                            decoration: textFieldInputDecoration(
                                "Ingrese su contraseña"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword()));
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              "Olvido su contraseña?",
                              style: simpleTextStyle(),
                            )),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      signIn();
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
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No tengo una cuenta? ",
                        style: simpleTextStyle(),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.toggleView();
                        },
                        child: Text(
                          "Register Ahora",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
    );
  }
}
