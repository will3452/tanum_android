import 'package:flutter/material.dart';
import 'package:tanum/utils/constant.dart';
import 'package:http/http.dart' as api;
import 'package:tanum/utils/helpers.dart';

class DefaultLayout extends StatefulWidget {
  final Widget body;
  final Widget? action;
  final Widget? bottom;

  DefaultLayout({required this.body, this.action, this.bottom, Key? key}) : super(key: key);

  @override
  _DefaultLayoutState createState() => _DefaultLayoutState();
}

class _DefaultLayoutState extends State<DefaultLayout> {
  final Widget? body;
  int _menu = 1;

  _DefaultLayoutState({this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        title: const Text(
          APP_NAME,
          style: TextStyle(
            fontFamily: "Noganas",
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: APP_THEME,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/user.png'),
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<String?>(
                    future: Helpers.getAuth(key: "name"),
                    builder: (BuildContext context,
                        AsyncSnapshot<String?> snapshot) {
                      String? name;
                      if (snapshot.hasData) {
                        name = snapshot.data!;
                      } else if (snapshot.hasError) {
                        name = "---";
                      } else {
                        return const Text("*******");
                      }

                      return Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Noganas",
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 5),
                  FutureBuilder<String?>(
                    future: Helpers.getAuth(key: "email"),
                    builder: (BuildContext context,
                        AsyncSnapshot<String?> snapshot) {
                      String? name;
                      if (snapshot.hasData) {
                        name = snapshot.data!;
                      } else if (snapshot.hasError) {
                        name = "---";
                      } else {
                        return const Text("*******");
                      }
                      return Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: "Noganas",
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.other_houses),
              title: const Text('Garden'),
              onTap: () {
                Navigator.pushNamed(context, '/garden');
              },
            ),
            ListTile(
              leading: const Icon(Icons.question_answer),
              title: const Text('FAQ'),
              onTap: () {
                Navigator.pushNamed(context, '/faqs');
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('My Notes'),
              onTap: () {
                Navigator.pushNamed(context, '/diaries');
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () async {
                bool isLogout = await Helpers.logout();
                if (isLogout) {
                  Helpers.alert(
                      context: context, message: "Thanks for using tanum!");
                  Navigator.pushNamed(context, "/");
                }
              },
            ),
          ],
        ),
      ),
      body: widget.body,
      floatingActionButton: widget.action,
      bottomNavigationBar: widget.bottom,
    );
  }
}
