import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HighScore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Score'),
      ),
      body: TopScore(),
    );
  }
}

class TopScore extends StatefulWidget {
  const TopScore({super.key});

  @override
  State<TopScore> createState() => _TopScoreState();
}

class _TopScoreState extends State<TopScore> {
  int _topScore1 = 0;
  int _topScore2 = 0;
  int _topScore3 = 0;

  String _topUser1 = "";
  String _topUser2 = "";
  String _topUser3 = "";


  @override
  void initState() {
    super.initState();
    fetchTopData(); // Panggil fungsi untuk mengambil data dari game.dart
  }

  // Fungsi untuk mengambil data username dan point dari game.dart
  Future<void> fetchTopData() async {
    final prefs = await SharedPreferences.getInstance();
    // Mengambil data point dan username dari game.dart
    int topPoint1 = prefs.getInt("topPoint1") ?? 0;
    int topPoint2 = prefs.getInt("topPoint2") ?? 0;
    int topPoint3 = prefs.getInt("topPoint3") ?? 0;

    String topUsers1 = prefs.getString("juara1") ?? "";
    String topUsers2 = prefs.getString("juara2") ?? "";
    String topUsers3 = prefs.getString("juara3") ?? "";


    setState(() {
      _topScore1 = topPoint1;
      _topScore2 = topPoint2;
      _topScore3 = topPoint3;

      _topUser1 = topUsers1;
      _topUser2 = topUsers2;
      _topUser3 = topUsers3;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Top User ke-1: $_topUser1"),
            Text("Top User ke-2: $_topUser2"),
            Text("Top User ke-3: $_topUser3"),

            Text("Top Point ke-1: $_topScore1"),
            Text("Top Point ke-2: $_topScore2"),
            Text("Top Point ke-3: $_topScore3"),

          ],
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class HighScore extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Top Score'),
//       ),
//       body: TopScore(),
//     );
//   }
// }


// class TopScore extends StatefulWidget {
//   const TopScore({super.key});

//   @override
//   State<TopScore> createState() => _TopScoreState();
// }

// Future<String> checkUsername() async {
//   final prefs = await SharedPreferences.getInstance();
//   String top_user = prefs.getString("username") ?? '-';
//   return top_user;
// }

// Future<int> checkTopPoint() async {
//   final prefs = await SharedPreferences.getInstance();
//   int top_point = prefs.getInt("top_point") ?? 0;
//   return top_point;
// }

// class _TopScoreState extends State<TopScore> {
//   int _top_score = 0;
//   String username = "";

//   @override
//   void initState() {
//     super.initState();
//     checkUsername().then((value) => setState(() {
//           username = value;
//         }));
//     checkTopPoint().then((value) => setState(() {
//           _top_score = value;
//         }));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//             child: Column(children: [
//           Text("Top User: " + username),
//           Text("Top Point: " + _top_score.toString()),
//         ])));
//   }
// }
