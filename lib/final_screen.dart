import 'package:flutter/material.dart';
import 'package:wordskonf/home.dart';
import 'main.dart';
import 'words.dart';
import 'package:shared_preferences/shared_preferences.dart';
class FinalScreen extends StatefulWidget {
  int score;
  double bank;
  int level;
  int isEducation;
  int challenge = 0;
  String text = "";
  String challengeText = "";
  bool isRecord = false;
  FinalScreen( int this.score, double this.bank,
      int this.level, int this.isEducation, int this.challenge, {Key? key}) : super(key: key){
    void savedVariables() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("record", challenge);
    }
    if (challenge < level){
      challenge = level;
      isRecord = true;
      savedVariables();
    }
    if (level % 10 == 1){
      text = "уровень";
    }
    else if(level % 10 == 2 || level % 10 == 3 || level % 10 == 4){
      text = "уровня";
    }
    else{
      text = "уровней";
    }
    if (challenge % 10 == 1){
      challengeText = "уровень";
    }
    else if(challenge % 10 == 2 || challenge % 10 == 3 || challenge % 10 == 4){
      challengeText = "уровня";
    }
    else{
      challengeText = "уровней";
    }
  }

  @override
  State<FinalScreen> createState() => _FinalScreenState();
}

class _FinalScreenState extends State<FinalScreen> {
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(child: Scaffold(

          body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/fonred.png"),
                  fit: BoxFit.cover,
                )
            ),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      if(widget.isEducation != 3)
                        FittedBox(
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                color: lighttextColor,
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(microseconds: 1),
                              style: const TextStyle(),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                                child: Text("${widget.score}",
                                  style: TextStyle(fontSize: 20, color: backColor),),
                              ),
                            ),

                          ),
                        ),
                      if (widget.isEducation != 3)
                        SizedBox(
                        width: 250,
                        height: 250,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(150),
                            image: DecorationImage(
                                image: AssetImage(banks[widget.bank.toInt()])
                            ),
                          ),
                        ),
                      ),
                      if (widget.isEducation == 3)
                        SizedBox(
                          width: 250,
                          height: 250,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(150),
                              image: DecorationImage(
                                  image: AssetImage("assets/bank41-25.png")
                              ),
                            ),
                          ),
                        ),
                      Text("Ӟечок!", style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold,
                          color: lighttextColor,
                          shadows: [
                            Shadow(color: Colors.black, blurRadius: 8,
                                offset: Offset(-3, 3))]),),

                      Column(
                        children: [
                          if (widget.isRecord && widget.isEducation == 3)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("НОВЫЙ РЕКОРД!",
                                  style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,
                                      color: lighttextColor,
                                      shadows: [
                                        Shadow(color: Colors.black, blurRadius: 8,
                                            offset: Offset(-3, 3))])),
                            ),
                          if (widget.isEducation == 3)
                            Text("Пройдено ${widget.level} " + widget.text,
                                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,
                                    color: lighttextColor,
                                    shadows: [
                                      Shadow(color: Colors.black, blurRadius: 8,
                                          offset: Offset(-3, 3))])),
                          if (widget.isEducation == 3)
                            Text("Рекорд ${widget.challenge} " + widget.challengeText,
                                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,
                                    color: lighttextColor,
                                    shadows: [
                                      Shadow(color: Colors.black, blurRadius: 8,
                                          offset: Offset(-3, 3))])),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton(onPressed:(){
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                                (Route<dynamic> route) => false,
                          );
                          },
                            style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    side: BorderSide(color: lighttextColor)
                                )
                            ),
                              backgroundColor: MaterialStateProperty.all<Color>(lighttextColor),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                              child: Text("Главное меню",
                                style: TextStyle(fontSize: 12, color: backColor),),
                            )),
                        ),
                    ]
                )

            ),
          )
      )),
    );
  }

}
