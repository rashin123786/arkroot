import 'package:arkroot_to_do/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget emptyList() {
  return Column(
    children: [
      Lottie.asset(
        'assets/animations/emptylist.json',
        width: 200,
        height: 200,
        fit: BoxFit.fill,
      ),
      Text("You don't have any tasks yet",
          style: TextStyle(
            color: Color.fromRGBO(128, 128, 128, 1),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )),
      Text("Start adding tasks and manage your\ntime effectively.",
          textAlign: TextAlign.center,
          style:
              TextStyle(color: Color.fromRGBO(128, 128, 128, 1), fontSize: 16)),
    ],
  );
}
