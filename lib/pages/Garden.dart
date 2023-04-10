import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tanum/utils/Description.dart';
import 'package:tanum/utils/DescriptionSpace.dart';
import 'package:tanum/utils/TitleHeader.dart';
import 'package:tanum/utils/constant.dart';
import 'package:tanum/utils/helpers.dart';
import 'package:http/http.dart' as api;

class Garden extends StatefulWidget {
  const Garden({Key? key}) : super(key: key);

  @override
  State<Garden> createState() => _GardenState();
}

Future<List<Map<dynamic, dynamic>>> _loadPlants() async {
  List<Map> plants = [];

  var url = Helpers.getUrl('/api/plants');

  var response = await api.get(url);

  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);

    for (int i = 0; i < body.length; i++) {
      plants.add(body[i]);
    }
  }

  return plants;
}

class _GardenState extends State<Garden> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleHeader("Garden"),
        FutureBuilder<List<Map<dynamic, dynamic>>>(
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GridView.builder(
                      itemCount: snapshot.data!.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 150,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          color: Colors.green,
                          child: GestureDetector(
                            onTap: () {
                              var item = snapshot.data![index];
                              // print("${snapshot.data![index]['common_name']} was clicked!");
                              showModalBottomSheet(
                                useSafeArea: true,
                                isScrollControlled: true,
                                context: context,
                                enableDrag: true,
                                builder: (BuildContext context) {
                                  return Stack(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        color: Colors.green[900],
                                        child: ListView(
                                          children: [
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              left: 0,
                                              child: ListTile(
                                                title: Text(
                                                  "${item['common_name']}",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                leading: const Icon(
                                                  Icons.info,
                                                  color: Colors.white,
                                                ),
                                                trailing: IconButton(
                                                  icon: const Icon(Icons.close,
                                                      color: Colors.white),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ),
                                            ),
                                            Image.network(
                                              "$API_ASSETS${item['image']}",
                                              fit: BoxFit.cover,
                                              width: 100,
                                              height: 200,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "${item['common_name']}",
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Description(
                                              "Scientific Name",
                                              item['scientific_name'],
                                              const Icon(
                                                Icons.science,
                                                color: Colors.white,
                                              ),
                                            ),
                                            DescriptionSpace(),
                                            Description(
                                              "Habitat",
                                              item['habitat'],
                                              const Icon(
                                                Icons.spa,
                                                color: Colors.white,
                                              ),
                                            ),
                                            DescriptionSpace(),
                                            Description(
                                              "Family",
                                              item['family'],
                                              const Icon(Icons.grass,
                                                  color: Colors.white),
                                            ),
                                            DescriptionSpace(),
                                            Description(
                                              "Description",
                                              item['description'],
                                              const Icon(
                                                Icons.info,
                                                color: Colors.white,
                                              ),
                                            ),
                                            DescriptionSpace(),
                                            Description(
                                              "Tips",
                                              item["tips"],
                                              const Icon(
                                                Icons.star,
                                                color: Colors.white,
                                              ),
                                            ),
                                            DescriptionSpace(),
                                            Description(
                                              "Temperature",
                                              item['temp'],
                                              const Icon(
                                                Icons.thermostat,
                                                color: Colors.white,
                                              ),
                                            ),
                                            DescriptionSpace(),
                                            Description(
                                              "Air",
                                              item['air'],
                                              const Icon(
                                                Icons.air,
                                                color: Colors.white,
                                              ),
                                            ),
                                            DescriptionSpace(),
                                            Description(
                                              "Light",
                                              item['light'],
                                              const Icon(
                                                Icons.sunny,
                                                color: Colors.white,
                                              ),
                                            ),
                                            DescriptionSpace(),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                      //  TODO: adding to collection
                                                        Navigator.of(context).pop();
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.lightGreenAccent,
                                                      ),
                                                      child: const Text(
                                                        'ADD TO COLLECTION',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Column(
                              children: [
                                Image.network(
                                  "${API_ASSETS}${snapshot.data![index]["image"]}",
                                  width: double.infinity,
                                  height: 120,
                                  alignment: Alignment.center,
                                  cacheHeight: 300,
                                  cacheWidth: 300,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  "${snapshot.data![index]['common_name']}"
                                      .toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              } else {
                return const Text('No data found.');
              }
            } else {
              return const CircularProgressIndicator(
                strokeWidth: 1,
              );
            }
          },
          future: _loadPlants(),
        ),
      ],
    );
  }
}
