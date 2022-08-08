import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/crawler_address.model.dart';

class ResultsStep1 extends StatefulWidget {
  double width;
  double height;
  Function nextPage;
  List<CrawlerAddress> allAddresses;
  Function selectAddress;
  ResultsStep1(
      {Key? key,
      required this.width,
      required this.height,
      required this.nextPage,
      required this.allAddresses,
      required this.selectAddress})
      : super(key: key);

  @override
  State<ResultsStep1> createState() => _ResultsStep1State();
}

class _ResultsStep1State extends State<ResultsStep1> {
  int selectedPage = -1;
  @override
  Widget build(BuildContext context) {
    final ThemeData mode = Theme.of(context);
    bool isDarkMode = mode.brightness == Brightness.dark;
    List<CrawlerAddress> allAddresses = widget.allAddresses;

    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (allAddresses.isNotEmpty)
                SizedBox(
                  height: widget.height,
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: allAddresses.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          tileColor:
                              index == selectedPage ? Colors.grey[200] : null,
                          leading: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                selectedPage = index;
                              });
                            },
                            child: const Text('Select'),
                          ),
                          title: Text(allAddresses[index].address),
                          onTap: () {
                            setState(() {
                              selectedPage = index;
                            });
                          },
                          trailing: Text(
                            '${allAddresses[index].archivesSum} archives',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ElevatedButton(
                onPressed: selectedPage == -1
                    ? null
                    : () {
                        widget.selectAddress(allAddresses[selectedPage]);
                        widget.nextPage();
                      },
                child: const Text('Next'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
