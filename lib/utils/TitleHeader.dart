import 'package:flutter/material.dart';
import 'package:tanum/utils/constant.dart';

Widget TitleHeader(String message) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      width: double.infinity,
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: "Noganas",
          color: Colors.green, // assuming you have a primary color defined in your constants file
        ),
      ),
    ),
  );
}
