import 'package:flutter/material.dart';
import 'main.dart';
import 'game2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'words.dart';
class LearningScreen extends StatefulWidget {
  int currentGameLevel;
  int score;
  int isEducation;
  int counterOfColors;
  bool isPassed;
  List<String> knownWords = ([]);
  double bank = 0;
  bool isVariablesGetted = false;
  bool isTutorial;
  int helpCount;
  int challenge;
  bool isLearned;
  List<List<List<Cell>>> currentMatrix;
  LearningScreen (double bank, List<String> knownWords, int this.isEducation,int this.counterOfColors,
    int this.currentGameLevel, int this.score, bool this.isTutorial,
      List<List<List<Cell>>> this.currentMatrix,
      int this.challenge, bool this.isLearned, bool this.isPassed, int this.helpCount, {Key? key}) : super(key: key) {}

  @override

  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {

  @override
  // void initState(){
  //   super.initState();
  //   getVariables();
  // }
  Widget build(BuildContext context) {
    if(widget.isVariablesGetted == false){
      // getVariables();
    }
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
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

              children: [
                SizedBox(
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50, bottom: 10),
                      child: FittedBox(
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              color: lighttextColor,
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: AnimatedDefaultTextStyle(
                            duration: Duration(microseconds: 1),
                            style: TextStyle(),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                              child: Text("Запомни слова",
                                style: TextStyle(fontSize: 12, color: backColor),),
                            ),
                          ),

                        ),
                      ),
                    )),
                Expanded(
                    child: ListView.builder(
                        itemCount: allLevelWordsUDM[widget.currentGameLevel].length,
                        itemBuilder: (context, index) {
                          return Padding(padding: const EdgeInsets.only(left: 50, right: 50, bottom: 10, top: 10),
                              child:
                               Container(
                                 decoration: BoxDecoration(
                                     color: lighttextColor,
                                     borderRadius: BorderRadius.circular(37)
                                 ),
                                  child: Column(

                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 5, top: 5),
                                        child: Container(
                                          child: Text(allLevelWordsUDM[widget.currentGameLevel][index],
                                            style: TextStyle(color: backColor,fontSize: 25),),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 5, top: 5),
                                        child: Container(
                                          child: Text(allLevelWordsRUS[widget.currentGameLevel][index],
                                              style: TextStyle(color: backColor,fontSize: 25)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                            );
                        }),
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50, top: 20),
                  child: ElevatedButton(onPressed:(){
                    // getVariables();
                    widget.isLearned = true;
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                      builder: (context) => GameScreen2(widget.bank,widget.knownWords,widget.isEducation, widget.counterOfColors,
                          widget.currentGameLevel, widget.score, widget.isTutorial,
                          widget.currentMatrix, widget.challenge, widget.isLearned, widget.isPassed, widget.helpCount),),
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
                        padding: const EdgeInsets.only(left: 28, right: 28, top: 5, bottom: 5),
                        child: Text("Запомнил",style: TextStyle(color: backColor,
                            fontSize: 15,)),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  void getVariables() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      widget.isEducation = prefs.getInt("mode")!;
    });
    widget.score = prefs.getInt("score")!;
    widget.currentGameLevel = prefs.getInt("currentGameLevel")!;
    if(widget.isEducation == null){
      widget.isEducation = 0;
    }
    else{
      widget.isEducation = prefs.getInt("mode")!;
    }
    if(widget.score == null){
      widget.score = 0;
    }
    else{
      widget.score = prefs.getInt("score")!;
    }
    if(widget.currentGameLevel == null){
      widget.currentGameLevel = 40;
      widget.bank = 0;
    }
    else {
      widget.currentGameLevel = prefs.getInt("currentGameLevel")!;
      widget.bank = widget.currentGameLevel.toDouble();
    }
    widget.isVariablesGetted = true;
    if(widget.currentGameLevel >= allLevels.length ){
      setState(() {
        widget.currentGameLevel = 0;
      });
      widget.score = 0;
      widget.bank = 0;
      widget.isEducation = 0;
    }

  }
}
