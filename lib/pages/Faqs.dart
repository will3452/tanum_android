import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tanum/utils/TitleHeader.dart';
import 'package:tanum/utils/helpers.dart';
import 'package:http/http.dart' as api;

class Faqs extends StatefulWidget {
  const Faqs({Key? key}) : super(key: key);

  @override
  State<Faqs> createState() => _FaqsState();
}

class FaqItem {
  final String answer;
  final String question;

  FaqItem({required this.answer, required this.question});
}

Future<List<FaqItem>> _loadFaqs() async {
  List<FaqItem> items = [];

  var url = Helpers.getUrl('/api/faq');

  var response = await api.get(url);

  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);

    for (int i = 0; i < body.length; i++) {
      items.add(
          FaqItem(answer: body[i]['answer'], question: body[i]['question']));
    }
    print("Data fetched!  ");
    return items;
  } else {
    return [];
  }

  return items;
}

class _FaqsState extends State<Faqs> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        TitleHeader("FAQ"),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: FutureBuilder<List<FaqItem>>(
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 2,
                          )
                        ),
                        margin: EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.numbers_sharp),
                                  Text(
                                    snapshot.data![index].question,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Monospace",
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(snapshot.data![index].answer),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text("No Data found."),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                );
              }
            },
            future: _loadFaqs(),
          ),
        )
      ],
    );
  }
}
