import 'dart:async';
import 'dart:math';
import 'package:memorimage_160421082_160421046/class/question.dart';
import 'package:memorimage_160421082_160421046/class/result.dart';
import 'package:percent_indicator/percent_indicator.dart';


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  int _maxtime = 5;
  int _hitung = 0;
  late Timer _timer;

  List<QuestionObj> _questions = [];
  int _question_no = 0;
  int _point = 0;

  void checkAnswer(String answer) {
    setState(() {
      if (answer == _questions[_question_no].answer) {
        _point += 100;
      }
      _question_no++;
      if (_question_no > _questions.length - 1) {
        checkTopScore().then((int result) {
          int topScore = result;
          if (topScore < _point) {
            changeTopScore(_point);
          }
        });

        finishQuiz();
      }
      _hitung = _maxtime;
    });
  }

  Future<int> checkTopScore() async {
    final prefs = await SharedPreferences.getInstance();
    int top_point = prefs.getInt("top_point") ?? 0;
    return top_point;
  }

  finishQuiz() {
    _timer.cancel();
    _question_no = 0;
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('Quiz'),
              content: Text('Your point = $_point'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'OK');
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }

  void startTimer() {
    _hitung = _maxtime;
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        _hitung--;
        if (_hitung == 0) {
          checkTopScore().then((int result) {
            int topScore = result;
            if (topScore < _point) {
              changeTopScore(_point);
            }
          });
          finishQuiz();
          // _question_no++;
          // if(_question_no > _questions.length-1)
          // {
          //   _question_no = 0;
          // }
          // _hitung=_maxtime;
          //_timer.cancel();
          // showDialog<String>(
          //     context: context,
          //     builder: (BuildContext context) => AlertDialog(
          //           title: Text('Quiz'),
          //           content: Text('Waktu Habis'),
          //           actions: <Widget>[
          //             TextButton(
          //               onPressed: () => Navigator.pop(context, 'OK'),
          //               child: const Text('OK'),
          //             ),
          //           ],
          //         ));
        }
        // else{
        //   _hitung--;
        // }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // _hitung--;
    _hitung = _maxtime;
    startTimer();

    _questions.add(QuestionObj(
        'assets/images/c-17-1.png',
        'assets/images/c-17-2.png',
        'assets/images/c-17-3.png',
        'assets/images/c-17-4.png',
        'assets/images/c-17-2.png'));
    _questions.add(QuestionObj(
        'assets/images/c-5-1.png',
        'assets/images/c-5-2.png',
        'assets/images/c-5-3.png',
        'assets/images/c-5-4.png',
        'assets/images/c-5-3.png'));
    _questions.add(QuestionObj(
        'assets/images/c-1-1.png',
        'assets/images/c-1-2.png',
        'assets/images/c-1-3.png',
        'assets/images/c-1-4.png',
        'assets/images/c-1-1.png'));
    _questions.add(QuestionObj(
        'assets/images/c-10-1.png',
        'assets/images/c-10-2.png',
        'assets/images/c-10-3.png',
        'assets/images/c-10-4.png',
        'assets/images/c-10-2.png'));
    _questions.add(QuestionObj(
        'assets/images/c-12-1.png',
        'assets/images/c-12-2.png',
        'assets/images/c-12-3.png',
        'assets/images/c-12-4.png',
        'assets/images/c-12-1.png'));
  }

  @override
  void dispose() {
    _timer.cancel();
    _hitung = 0;
    super.dispose();
  }

  String formatTime(int hitung) {
    var hours = (hitung ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((hitung % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (hitung % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  void changeTopScore(point) async {
    final prefs = await SharedPreferences.getInstance();
    String user_id = prefs.getString("user_id") ?? '';
    prefs.setInt("top_point", point);
    prefs.setString("top_user", user_id);
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Quiz'),
      backgroundColor: Colors.lightBlue,
    ),
    body: Center(
      child: Column(
        children: <Widget>[
          CircularPercentIndicator(
            radius: 60.0,
            lineWidth: 20.0,
            percent: 1 - (_hitung / _maxtime),
            center: Text(formatTime(_hitung)),
            progressColor: Colors.red,
          ),
          Container(
            width: 300,
            height: 150,
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            children: [
              IconButton(
                icon: Image.asset(_questions[_question_no].option_a),
                onPressed: () {
                  checkAnswer(_questions[_question_no].option_a);
                },
              ),
              IconButton(
                icon: Image.asset(_questions[_question_no].option_b),
                onPressed: () {
                  checkAnswer(_questions[_question_no].option_b);
                },
              ),
              IconButton(
                icon: Image.asset(_questions[_question_no].option_c),
                onPressed: () {
                  checkAnswer(_questions[_question_no].option_c);
                },
              ),
              IconButton(
                icon: Image.asset(_questions[_question_no].option_d),
                onPressed: () {
                  checkAnswer(_questions[_question_no].option_d);
                },
              ),
            ],
          ),
          Divider(height: 50),
          Text("Score = " + _point.toString()),
        ],
      ),
    ),
  );
}
}