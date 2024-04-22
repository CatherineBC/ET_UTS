
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:memorimage_160421082_160421046/main.dart';
import 'package:memorimage_160421082_160421046/screen/game.dart';
import 'package:memorimage_160421082_160421046/screen/highscore.dart';

class result extends StatelessWidget {
  final int score;
  result(this.score);
  String hasil = "";

  List<String> Title =["Sfortunato Indovinatore (Unlucky Guesser)", "Neofita dell'Indovinello (Riddle Novice)"," Principiante dell'Indovinello (Riddle Beginner)","Abile Indovinatore (Skillful Guesser)"
  ,"Esperto dell'Indovinello (Expert of Riddles)","Maestro dell'Indovinello (Master of Riddles)"];


  String coba(int score){
    for(int i = 0; i< Title.length; i++){
      if(score == i ){
        hasil = Title[i];
      }
    }
    
    return hasil;
  }
  

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Your Score: $score"),
            Text(coba(score)),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Game(),
                  ),
                );
              },
              child: Text('Play Again'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HighScore(),
                  ),
                );
              },
              child: Text('Go to High Score'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyApp(),
                  ),
                );
              },
              child: Text('Go to Main Menu'),
            ),
          ],
        ),
      ),
    );
  }
}