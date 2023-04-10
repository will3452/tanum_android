import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tanum/layouts/default.dart';
import 'package:tanum/pages/Diaries.dart';
import 'package:tanum/pages/Faqs.dart';
import 'package:tanum/pages/Garden.dart';
import 'package:tanum/pages/Login.dart';
import 'package:tanum/pages/NewNote.dart';
import 'package:tanum/pages/Register.dart';
import 'package:tanum/utils/constant.dart';
import 'package:tanum/utils/helpers.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> getRoutes(
      BuildContext context) {
    return {
      "/": (context) => Login(),
      "/register": (context) => Register(),
      "/garden": (context) => DefaultLayout(
            body: Garden(),
        bottom: BottomNavigationBar(
          onTap: (index) {
            if (index == 0) {
              Helpers.alert(context: context, message: "You're already in garden.");
            } else {
              // TODO: goto collection page
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.eco_sharp), label: "Garden"),
            BottomNavigationBarItem(icon: Icon(Icons.folder), label: "Collection"),
          ],
        ),
          ),
      '/faqs': (context) => DefaultLayout(
            body: Faqs(),
          ),
      '/diaries': (context) => DefaultLayout(
            body: Diaries(),
            action: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/new-note');
              },
              child: Icon(Icons.add),
            ),
          ),
      '/new-note': (context) => DefaultLayout(body: NewNote()),
    };
  }
}
