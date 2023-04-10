import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tanum/utils/TitleHeader.dart';
import 'package:http/http.dart' as api;
import 'package:tanum/utils/helpers.dart';
import 'package:intl/intl.dart';

class Note {
  final String title;
  final String body;
  final String createdAt;
  final int id;

  Note({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });
}

class Diaries extends StatefulWidget {
  const Diaries({Key? key}) : super(key: key);

  @override
  State<Diaries> createState() => _DiariesState();
}

class _DiariesState extends State<Diaries> {
  String? _token;

  void _loadToken() async {
    String? token = await Helpers.getAuth(key: "bearerToken");
    setState(() {
      _token = token;
      // Helpers.alert(context: context, message: "$_token");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadToken();
  }

  void _removeNotes(int id) async {
    try {
      Helpers.alert(
          context: context, message: "Removing notes is under maintenance");
    } catch (e) {
      Helpers.alert(context: context, message: "Failed to remove note.");
    }
  }

  Future<List<Note>> _loadNotes() async {
    List<Note> notes = [];

    var url = Helpers.getUrl('/api/diary');

    var headers = {
      "Authorization": "Bearer $_token",
    };

    print("Headers ${headers.toString()}");

    var response = await api.get(url, headers: headers);

    print("Body >> ${response.body}");

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);

      for (int i = 0; i < body.length; i++) {
        notes.add(Note(
          id: body[i]['id'],
          title: body[i]['title'],
          body: body[i]['body'],
          createdAt: body[i]['created_at'],
        ));
      }
    }

    return notes;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        TitleHeader("My Notes"),
        FutureBuilder<List<Note>>(
          future: _loadNotes(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Expanded(
                    child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.green[200]!,
                      ),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(
                          snapshot.data![index].title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 10),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              DateFormat('MM/dd/yyyy').format(
                                DateTime.parse(snapshot.data![index].createdAt),
                              ),
                            )
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.visibility),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        scrollable: true,
                                        title:
                                            Text(snapshot.data![index].title),
                                        content:
                                            Text(snapshot.data![index].body),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Close"),
                                          )
                                        ],
                                      );
                                    });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _removeNotes(snapshot.data![index].id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ));
              } else {
                return Center(
                  child: Text("No Notes found."),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
