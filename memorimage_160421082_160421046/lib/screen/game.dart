import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:memorimage_160421082_160421046/class/question.dart';
import 'package:memorimage_160421082_160421046/class/result.dart';
import 'package:memorimage_160421082_160421046/screen/result.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  bool _showOptions = false;
  bool click = false;
  Color correct1 = Colors.transparent;
  Color correct2 = Colors.transparent;
  Color correct3 = Colors.transparent;
  Color correct4 = Colors.transparent;
  int _maxtime = 5;
  int _hitung = 0;
  late Timer _timer;

  List<QuestionObj> _questions = [];
  int _question_no = 0;
  int _point = 0;

  void checkAnswer(String answer) {
    setState(() {
      click = true;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (answer == _questions[_question_no].answer) {
          _point += 1;
        }
        _question_no++;
        _timer.cancel();
        correct1 = Colors.transparent;
        correct2 = Colors.transparent;
        correct3 = Colors.transparent;
        correct4 = Colors.transparent;
        click = false;

        if (_question_no > _questions.length - 1) {
          checkTopScores().then((List<int> topScores) {
            changeTopScores(topScores, _point); // Memperbarui 3 poin tertinggi
          });
          finishQuiz();
        }
      });
    });
  }

  bool cekJawaban(String answer) {
    if (answer == _questions[_question_no].answer) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<int>> checkTopScores() async {
    final prefs = await SharedPreferences.getInstance();
    int topPoint1 = prefs.getInt("top_point1") ?? 0;
    int topPoint2 = prefs.getInt("top_point2") ?? 0;
    int topPoint3 = prefs.getInt("top_point3") ?? 0;

    // Mengurutkan skor dari yang terbesar ke yang terkecil
    List<int> topScores = [topPoint1, topPoint2, topPoint3];
    topScores.sort((a, b) => b.compareTo(a));

    return topScores;
  }

  startTimerPlay() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_question_no >= _questions.length - 1) {
          _showOptions = true;
          _question_no = 0;
          _timer.cancel();
        } else {
          _timer.cancel();
          startTimerDelay();
        }
      });
    });
  }

  startTimerDelay() {
    _timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
      setState(() {
        _timer.cancel();
        _question_no++;
        startTimerPlay();
      });
    });
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
                ElevatedButton(
                    onPressed: () {
                      checkTopScores().then((List<int> topScores) {
                        // Panggil changeTopScores untuk memperbarui poin tertinggi dengan skor saat ini
                        changeTopScores(topScores, _point);
                        // Pindah ke halaman hasil
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => result(_point)));
                      });
                    },
                    child: Text("View Your Result")),
              ],
            ));
  }

  void startTimer() {
    _hitung = _maxtime;
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        _hitung--;
        if (_hitung == 0) {
          checkTopScores().then((List<int> topScores) {
            changeTopScores(topScores, _point); // Memperbarui 3 poin tertinggi
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
    startTimerPlay();

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

    _showOptions = false;
    _hitung = _maxtime;
    _point = 0;

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _showOptions = false;
      });
      // _showQuestionPopup();
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

  // void changeTopScore(point) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String user_id = prefs.getString("user_id") ?? '';
  //   prefs.setInt("top_point", point);
  //   prefs.setString("top_user", user_id);
  // }
  void changeTopScores(List<int> topScores, int point) async {
    topScores.sort((a, b) =>
        b.compareTo(a)); // Urutkan poin dari yang tertinggi ke terendah
    if (point > topScores.last) {
      topScores.removeLast(); // Hapus poin terendah
      topScores.add(point); // Tambahkan skor baru
      topScores.sort((a, b) => b.compareTo(a)); // Urutkan kembali poin
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt("top_point1", topScores[0]);
      prefs.setInt("top_point2", topScores[1]);
      prefs.setInt("top_point3", topScores[2]);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showOptions == true) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz'),
          backgroundColor: Colors.lightBlue,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Align(
                    // alignment: Alignment.topRight,
                    // child: Padding(
                    //   padding: EdgeInsets.all(16.0),
                    //   child: CircularPercentIndicator(
                    //     radius: 60.0,
                    //     lineWidth: 20.0,
                    //     percent: 1 - (_hitung / _maxtime),
                    //     center: Text(formatTime(_hitung)),
                    //     progressColor: Colors.red,
                    //   ),
                    // ),
                    ),
                if (_showOptions)
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    children: [
                      GestureDetector(
                        child: Container(
                            margin: EdgeInsets.all(10),
                            child:
                                Image.asset(_questions[_question_no].option_a),
                            color: correct1),
                        onTap: () {
                          if (click == true) {
                            return null;
                          } else {
                            checkAnswer(
                                _questions[_question_no].option_a); // top score
                            setState(() {
                              if (cekJawaban(
                                  _questions[_question_no].option_a)) {
                                correct1 = Colors.green;
                              } else {
                                correct1 = Colors.red;
                              } //buat ubah button pny warna
                            });
                          }
                        },
                      ),
                      GestureDetector(
                        child: Container(
                            margin: EdgeInsets.all(10),
                            child:
                                Image.asset(_questions[_question_no].option_b),
                            color: correct2),
                        onTap: () {
                          if (click == true) {
                            return null;
                          } else {
                            checkAnswer(
                                _questions[_question_no].option_b); // top score
                            setState(() {
                              if (cekJawaban(
                                  _questions[_question_no].option_b)) {
                                correct2 = Colors.green;
                              } else {
                                correct2 = Colors.red;
                              }
                              click = true; //buat ubah button pny warna
                            });
                          }
                        },
                      ),
                      GestureDetector(
                        child: Container(
                            margin: EdgeInsets.all(10),
                            child:
                                Image.asset(_questions[_question_no].option_c),
                            color: correct3),
                        onTap: () {
                          if (click == true) {
                            return null;
                          } else {
                            checkAnswer(
                                _questions[_question_no].option_c); // top score
                            setState(() {
                              if (cekJawaban(
                                  _questions[_question_no].option_c)) {
                                correct3 = Colors.green;
                              } else {
                                correct3 = Colors.red;
                              } //buat ubah button pny warna
                            });
                          }
                        },
                      ),
                      GestureDetector(
                        child: Container(
                            margin: EdgeInsets.all(10),
                            child:
                                Image.asset(_questions[_question_no].option_d),
                            color: correct4),
                        onTap: () {
                          if (click == true) {
                            return null;
                          } else {
                            checkAnswer(
                                _questions[_question_no].option_d); // top scor
                            setState(() {
                              if (cekJawaban(
                                  _questions[_question_no].option_d)) {
                                correct4 = Colors.green;
                              } else {
                                correct4 = Colors.red;
                              } //buat ubah button pny warna
                            });
                          }
                        },
                      )
                    ],
                  ),
                Divider(height: 50),
                Text("Score = " + _point.toString()),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text('Quiz'),
            backgroundColor: Colors.lightBlue,
          ),
          body: Center(
            child: Image.asset(_questions[_question_no].answer),
          ));
    }
  }
}
