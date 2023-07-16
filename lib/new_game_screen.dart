import 'package:flutter/material.dart';
import 'game2.dart';
import 'words.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'final_screen.dart';
import 'learning_screen.dart';
class NewGame extends StatefulWidget {

  int currentGameLevel;
  int score;
  bool isPassed = true;
  int isEducation;
  List<String> knownWords = ([]);
  int counterOfColors;
  double bank = 0;
  int challenge = 0;
  bool isTutorial;
  bool isLearned;
  int helpCount;
  List<List<List<Cell>>> currentMatrix;
  NewGame(double bank,List<String> knownWords, int this.isEducation, int this.counterOfColors,
      int this.currentGameLevel,  int this.score,bool this.isTutorial,
      List<List<List<Cell>>> this.currentMatrix, bool this.isLearned, int this.helpCount, {Key? key}) : super(key: key){}

  @override
  State<NewGame> createState() => _NewGameState();
}

class _NewGameState extends State<NewGame> {
  @override
  void initState(){
    super.initState();
    savedVariables();
  }


  Widget build(BuildContext context) {

    List<int> numOfAllLevels = List.of([allLevels[0].length,
      allLevels[1].length,
      allLevels[2].length,
      allLevels[3].length]);

    if (widget.isEducation != 3){
      widget.bank = widget.currentGameLevel.toDouble() * (42 / allLevels.length);
    }
    if(widget.currentGameLevel < allLevels.length){
      widget.currentGameLevel++;
      widget.score++;
      widget.isLearned = false;
      savedVariables();
    }


    return Container(
        child: Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/fonred.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[

                        // ElevatedButton(onPressed:(){
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(builder: (context) => MyApp()),
                        //   );
                        // },
                        //     child: Text("Доре")),
                        Padding(
                          padding: const EdgeInsets.all(25),
                          child: FittedBox(
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
                        ),
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
                        Text("Ӟечок", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold,
                            color: lighttextColor,
                            shadows: [
                              Shadow(color: Colors.black, blurRadius: 8,
                                  offset: Offset(-3, 3))])),

                        Column(
                          children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: ElevatedButton(onPressed: changeScreen,

                                    style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.0),
                                            side: BorderSide(color: lighttextColor)
                                        )
                                    ),
                                      backgroundColor: MaterialStateProperty.all<Color>(lighttextColor),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 28, right: 28, top: 5, bottom: 5),
                                      child: Text("Продолжить",
                                        style: TextStyle(fontSize: 12, color: backColor),),
                                    )),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: ElevatedButton(onPressed:(){
                                Navigator.pop(context);
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
                                    child: Text("Показать поле",
                                      style: TextStyle(fontSize: 12, color: backColor),),
                                  )),
                            ),
                          ],
                        )

                      ]
                  )

              ),
            )
        )
    );
  }

  void savedVariables() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("learn", widget.isLearned);
      prefs.setInt("mode", widget.isEducation);
      prefs.setInt("currentGameLevel", widget.currentGameLevel);
      prefs.setInt("score", widget.score);
  }
  void changeScreen(){

    widget.isPassed = false;
    if(widget.currentGameLevel >= allLevels.length || widget.isEducation == 3){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>
        FinalScreen(widget.score, widget.bank, widget.currentGameLevel, widget.isEducation, widget.challenge)),
            (Route<dynamic> route) => false,
      );
    }
    else if (widget.isEducation == 1){

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>
            LearningScreen(widget.bank, widget.knownWords,widget.isEducation, widget.counterOfColors,
              widget.currentGameLevel, widget.score,widget.isTutorial,
                widget.currentMatrix, widget.challenge, widget.isLearned, widget.isPassed, widget.helpCount)),
            (Route<dynamic> route) => false,
      );
    }

    else if(widget.isEducation == 2){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>
            GameScreen2(widget.bank,widget.knownWords, widget.isEducation,widget.counterOfColors,
                widget.currentGameLevel, widget.score, widget.isTutorial,
                widget.currentMatrix, widget.challenge, widget.isLearned, widget.isPassed, widget.helpCount)),
            (Route<dynamic> route) => false,
      );
    }


  }
}
