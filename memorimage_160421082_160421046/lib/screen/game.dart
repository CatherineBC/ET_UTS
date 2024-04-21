import 'dart:async';
import 'dart:math';
import 'package:memorimage_160421082_160421046/class/result.dart';

import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  late Timer _timer;
  List<String> images = [
    "images/c-1-1.png",
    "images/c-1-2.png",
    "images/c-1-3.png",
    "images/c-1-4.png",
    "images/c-2-1.png",
    "images/c-2-2.png",
    "images/c-2-3.png",
    "images/c-2-4.png",
    "images/c-3-1.png",
    "images/c-3-2.png",
    "images/c-3-3.png",
    "images/c-3-4.png",
    "images/c-4-1.png",
    "images/c-4-2.png",
    "images/c-4-3.png",
    "images/c-4-4.png",
    "images/c-5-1.png",
    "images/c-5-2.png",
    "images/c-5-3.png",
    "images/c-5-4.png",
    "images/c-6-1.png",
    "images/c-6-2.png",
    "images/c-6-3.png",
    "images/c-6-4.png",
    "images/c-7-1.png",
    "images/c-7-2.png",
    "images/c-7-3.png",
    "images/c-7-4.png",
    "images/c-8-1.png",
    "images/c-8-2.png",
    "images/c-8-3.png",
    "images/c-8-4.png",
    "images/c-9-1.png",
    "images/c-9-2.png",
    "images/c-9-3.png",
    "images/c-9-4.png",
    "images/c-10-1.png",
    "images/c-10-2.png",
    "images/c-10-3.png",
    "images/c-10-4.png",
    "images/c-11-1.png",
    "images/c-11-2.png",
    "images/c-11-3.png",
    "images/c-11-4.png",
    "images/c-12-1.png",
    "images/c-12-2.png",
    "images/c-12-3.png",
    "images/c-12-4.png",
    "images/c-13-1.png",
    "images/c-13-2.png",
    "images/c-13-3.png",
    "images/c-13-4.png",
    "images/c-14-1.png",
    "images/c-14-2.png",
    "images/c-14-3.png",
    "images/c-14-4.png",
    "images/c-15-1.png",
    "images/c-15-2.png",
    "images/c-15-3.png",
    "images/c-15-4.png",
    "images/c-16-1.png",
    "images/c-16-2.png",
    "images/c-16-3.png",
    "images/c-16-4.png",
    "images/c-17-1.png",
    "images/c-17-2.png",
    "images/c-17-3.png",
    "images/c-17-4.png",
    "images/c-18-1.png",
    "images/c-18-2.png",
    "images/c-18-3.png",
    "images/c-18-4.png",
    "images/c-19-1.png",
    "images/c-19-2.png",
    "images/c-19-3.png",
    "images/c-19-4.png",
    "images/c-20-1.png",
    "images/c-20-2.png",
    "images/c-20-3.png",
    "images/c-20-4.png",
  ];

  List<String> options = [];

  String correctOption = "";
  bool isShowingImages = true;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    setState(() {
      isShowingImages = true;
      options.clear();
      correctOption = "";
    });

    // Show images for 3 seconds
    Timer(Duration(seconds: 3), () {
      setState(() {
        isShowingImages = false;

        // Randomly select the correct option
        String correctImage = images[Random().nextInt(images.length)];
        correctOption = correctImage.split('-')[1];

        // Populate the options
        options.clear();
        for (String image in images) {
          String option = image.split('-')[1];
          if (option != correctOption && !options.contains(option)) {
            options.add(option);
          }
        }

        // Shuffle the options
        options.shuffle();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Game'),
      ),
      body: Center(
        child: isShowingImages
            ? GridView.count(
                crossAxisCount: 4,
                children: images.map((image) {
                  return Image.asset(image);
                }).toList(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Select the correct image:',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    children: options.map((option) {
                      return GestureDetector(
                        onTap: () {
                          if (option == correctOption) {
                            // Handle correct option selection
                            print('Correct!');
                          } else {
                            // Handle incorrect option selection
                            print('Incorrect!');
                          }
                          startGame();
                        },
                        child: Image.asset(option),
                      );
                    }).toList(),
                  ),
                ],
              ),
      ),
    );
  }
}

