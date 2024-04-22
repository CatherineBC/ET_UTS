
import 'package:flutter/material.dart';

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
        child:Column(children: [Text("Your Score : " + score.toString()), 
        Text(coba(score))])
      ),
    );
  }
}
