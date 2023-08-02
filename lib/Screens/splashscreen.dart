import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptonews/Screens/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Splashsceen extends StatefulWidget {
  const Splashsceen({super.key});

  @override
  State<Splashsceen> createState() => _SplashsceenState();
}

class _SplashsceenState extends State<Splashsceen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 5), () async {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        var route = MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
        Navigator.push(context, route);
      } else {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

        var userDetails = {
          "user_id": doc["user_id"],
          "Username": doc["username"],
          "Email": doc["Email"]
        };
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        color: Colors.white10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: size.height / 2,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/cryto.jpg"),
                    fit: BoxFit.fill,
                  )),
            ),
            const Text(
              "CRYPTONEWS",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.lightBlueAccent),
            ),
            const CircularProgressIndicator(
              color: Colors.lightBlueAccent,
            )
          ],
        ),
      ),
    );
  }
}
