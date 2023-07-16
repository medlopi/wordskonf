import 'package:flutter/material.dart';
import 'words.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'learning_screen.dart';
import 'game2.dart';


class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}
List<String> knownWords = List.of([]);
class _HomeState extends State<Home> {
  int currentGameLevel = 0;

  int score = 1;

  int isEducation = 0;

  int counterOfColors = 0;

  int helpCount = 5;

  double bank = 0;

  bool isToChange = false;

  int challenge = 0;

  bool isPassed = false;

  bool isVariablesGetted = false;

  bool isEducationGetted = false;

  bool isTutorial = false;

  bool isLearned = false;

  @override
  Widget build(BuildContext context) {

    if(isVariablesGetted == false){
      getVariables();

    }

    return WillPopScope(
      onWillPop: () async{
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: [
                    Text("Заречномедлинский", style: TextStyle(color: lighttextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(color: Colors.black, blurRadius: 8,
                              offset: Offset(-3, 3))]), ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text("Дом культуры", style: TextStyle(color: lighttextColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(color: Colors.black, blurRadius: 8,
                                offset: Offset(-3, 3))]), ),
                    ),
                    Text("Центр", style: TextStyle(color: lighttextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(color: Colors.black, blurRadius: 8,
                              offset: Offset(-3, 3))]),),
                    Text("удмуртской культуры", style: TextStyle(color: lighttextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(color: Colors.black, blurRadius: 8,
                              offset: Offset(-3, 3))]),),
                    Text('"Зарни Медло"', style: TextStyle(color: lighttextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(color: Colors.black, blurRadius: 8,
                              offset: Offset(-3, 3))]),),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: ElevatedButton(onPressed:(){
                              isToChange = false;
                              onPressed();

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
                                  child: Text("Выбор режима",
                                    style: TextStyle(fontSize: 15, color: backColor),),
                                )),
                          ),
                          const SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),


                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          child: Text("WORDSKOH",  style: TextStyle(color: Colors.red,
                              fontSize: 47,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(color: Colors.black, blurRadius: 8,
                                    offset: Offset(-3, 3))]),),


                        ),
                    ),



                SizedBox(
                  height: 300,
                  width: 200,
                  child: Padding(padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: (){
                        isToChange = true;
                        if (isEducation != 0){
                          changeScreen();
                        }
                        else{
                          onPressed();
                        }

                      },
                      child: Container(
                        child: Center(
                          child: Padding(
                              padding: const EdgeInsets.only(top: 75, left: 15),
                              child: Text("ИГРАТЬ", style: TextStyle(color: lighttextColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(color: Colors.black, blurRadius: 8,
                                        offset: Offset(-3, 3))]),)),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(150),
                          image: DecorationImage(
                              image: AssetImage(startbanks[bank.toInt()])
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
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
      // widget.isTutorial = prefs.getBool("tutorial")!;
      isEducation = prefs.getInt("mode")!;
    });
    knownWords = prefs.getStringList("knownWords")!;
    // print(widget.knownWords);
    score = prefs.getInt("score")!;
    currentGameLevel = prefs.getInt("currentGameLevel")!;
    isEducation = prefs.getInt("mode")!;
    score = prefs.getInt("score")!;
    bank = currentGameLevel.toDouble() * (41 / allLevels.length);
    isLearned = prefs.getBool("learn")!;
    challenge = prefs.getInt("record")!;
    isPassed = prefs.getBool("passed")!;
    helpCount = prefs.getInt("helps")!;

    print(score);
    isVariablesGetted = true;

    if(currentGameLevel >= allLevels.length){

      score = 0;
      bank = 0;
      if(currentGameLevel != 0 && !isEducationGetted){
        isEducation = 0;
      }
      setState(() {
        currentGameLevel = 0;
      });
    }



  }

  void changeScreen(){
    if(isEducation == 3){
      getVariables();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>
            GameScreen2(bank, knownWords = List.empty(), isEducation,counterOfColors = 0,
                currentGameLevel, score, isTutorial,
                challengeLevels, challenge, isLearned, isPassed, helpCount)),
            (Route<dynamic> route) => false,
      );
    }
    if (isEducation == 1 && isLearned == false){
      getVariables();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>
            LearningScreen(bank, knownWords, isEducation, counterOfColors,
                currentGameLevel, score, isTutorial,
                allLevels, challenge, isLearned, isPassed, helpCount)),
            (Route<dynamic> route) => false,
      );
    }
    if(isEducation == 2 || isLearned == true){
      getVariables();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>
            GameScreen2(bank, knownWords,isEducation,counterOfColors,
                currentGameLevel, score,
                isTutorial, allLevels, challenge, isLearned,
                isPassed, helpCount)),
            (Route<dynamic> route) => false,
      );
    }
    if(isEducation == 0){
      showGeneralDialog(
          context: context,
          barrierDismissible:true,
          barrierLabel: '',
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return Center(
              child: Container(
                height: 350,
                width: 300,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/window.png")
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          height: 110,
                          width: 30,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/attention.png")
                            ),
                          ),
                        ),
                      ),
                      Text("Сначала", style: TextStyle(fontSize: 15, color: lighttextColor
                          , decoration: TextDecoration.none),),
                      Text("выбери режим", style: TextStyle(fontSize: 15,color: lighttextColor
                          , decoration: TextDecoration.none),),
                      Text("ИГРЫ", style: TextStyle(fontSize: 15,color: lighttextColor
                          , decoration: TextDecoration.none),),
                    ],
                  ),
                ),
              ),
            );
          });
    }


  }

  void savedVariable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("mode", isEducation);
  }

  onPressed(){
    showGeneralDialog(
        context: context,
        barrierDismissible:true,
        barrierLabel: '',
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return Center(
            child: Container(
              height: 350,
              width: 300,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/window.png")
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: ElevatedButton(onPressed: (){
                        isEducationGetted = true;
                        isEducation = 2;
                        savedVariable();
                        Navigator.pop(context);
                        changeScreen();
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
                            padding: const EdgeInsets.only(left: 2, right: 2, top: 5, bottom: 5),
                            child: Text("Развлечение",
                              style: TextStyle(fontSize: 15, color: backColor),),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: ElevatedButton(onPressed: (){
                        isEducationGetted = true;
                        isEducation = 1;
                        savedVariable();
                        Navigator.pop(context);
                        if (isToChange){
                          changeScreen();
                        }
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
                            padding: const EdgeInsets.only(left: 14, right: 14, top: 5, bottom: 5),
                            child: Text("Обучение",
                              style: TextStyle(fontSize: 15, color: backColor),),
                          )),
                    ),

                    // SizedBox()
                  ],
                ),
              ),
            ),
          );
        });
  }
}
