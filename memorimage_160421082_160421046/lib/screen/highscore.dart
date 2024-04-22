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
  const TopScore({Key? key}) : super(key: key);

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
    fetchTopData();
  }

  Future<void> fetchTopData() async {
    final prefs = await SharedPreferences.getInstance();
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
            buildScoreCard(1, _topUser1, _topScore1),
            buildScoreCard(2, _topUser2, _topScore2),
            buildScoreCard(3, _topUser3, _topScore3),
          ],
        ),
      ),
    );
  }

  Widget buildScoreCard(int rank, String username, int score) {
    String rankImage = 'assets/images/rank$rank.png'; 
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 6, 
      color:Colors.pink[100],
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Image.asset(
              rankImage,
              width: 50,
              height: 50,
            ),
            SizedBox(height: 10),
            Text(
              'Top User ke-$rank: $username',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Top Point ke-$rank: $score',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
