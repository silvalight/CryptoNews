import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptonews/Screens/homescreen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailCtrl = TextEditingController();
  var passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String errorMsg = "";

  void login() async {
    setState(() {
      isLoading = true;
    });
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailCtrl.text,
        password: passwordCtrl.text,
      );
      var id = userCredential.user!.uid;
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection("users").doc(id).get();
      var userDetails = {
        "user_id": doc["user_id"],
        "username": doc["username"],
        "Email": doc["Email"],
      };
      var route = MaterialPageRoute(
        builder: (context) => HomeScreen(user: userDetails),
      );
      Navigator.push(context, route);
    } catch (e) {
      setState(() {
        errorMsg = e.toString();
      });
    }
  }

  int count = 0;
  goBack() {
    if (count >= 2) {
      SystemNavigator.pop();
    } else {
      count++;
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async {
          goBack();
          // showSanckBar(context, "double Tap To Exit");
          return await false;
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 80, left: 30, right: 30),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        height: size.height / 3,
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(45),
                            image: const DecorationImage(
                              image: AssetImage("assets/images/crypyo.jpg"),
                              fit: BoxFit.cover,
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          label: const Text("E-mail"),
                          hintText: "Enter your E-mail Address",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(Icons.email),
                        ),
                        validator: (value) {
                          var emailValid = EmailValidator.validate(value!);
                          if (!emailValid) {
                            return "invalide E-mail Address";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: passwordCtrl,
                        decoration: InputDecoration(
                            label: const Text("password"),
                            hintText: "Enter Your Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.lock)),
                        validator: (value) {
                          if (value!.length < 6) {
                            return "Password too short";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: isLoading,
                        child: const CircularProgressIndicator(),
                      ),
                      Text(
                        errorMsg,
                        style: TextStyle(color: Colors.red),
                      ),
                      MaterialButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            login();
                          }
                        },
                        color: Colors.blue,
                        shape: const StadiumBorder(),
                        minWidth: 200,
                        height: 50,
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            " Do not Have An Account ?",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                              onTap: () {},
                              child: const Text("Registration",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ))),
                        ],
                      )
                    ],
                  )),
            ),
          ),
        ));
  }
}
