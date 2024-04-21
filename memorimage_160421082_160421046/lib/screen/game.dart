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
  bool _showQuestion = true;
  bool _showOptions = false;
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

  void _showQuestionPopup() {
    if(_question_no > _questions.length-1){
      _showOptions = true;
      _showQuestion = false;

    }
    else{
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 3), () {
          setState(() {
            _question_no++;
          });
        });

        return AlertDialog(
          title: Text('Question'),
          content: Image.asset(_questions[_question_no].answer),
        );
    },
  );
  }
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
        }
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

    _showOptions = true;
    _showQuestion = false;
    _hitung = _maxtime;
    _point = 0;

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _showQuestion = true;
        _showOptions = false;
      });
      _showQuestionPopup();
    });
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              if (_showOptions)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularPercentIndicator(
                    radius: 60.0,
                    lineWidth: 20.0,
                    percent: 1 - (_hitung / _maxtime),
                    center: Text(formatTime(_hitung)),
                    progressColor: Colors.red,
                  ),
                ),
              ),
              if(_showOptions)
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
      ),
    );
  }
}
