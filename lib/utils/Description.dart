import 'package:flutter/material.dart';

Widget Description(String title, String body, Icon? icon) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon ??
                const Icon(
                  Icons.info,
                  color: Colors.white,
                ),
            SizedBox(width: 4),
            Expanded(
              child: Text(
                title != "" ? title : '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        Text(
          body != "" ? body : '',
          style: TextStyle(
            color: Colors.white,
          ),
        )
      ],
    ),
  );
}
