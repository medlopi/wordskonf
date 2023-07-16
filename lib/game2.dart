import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wordskonf/home.dart';
import 'main.dart';
import 'new_game_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'words.dart';
import 'dart:math';
import 'final_screen.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/gestures.dart';


class OnlyOnePointerRecognizer extends OneSequenceGestureRecognizer {
  int _p = 0;
  @override
  void addPointer(PointerDownEvent event) {
    startTrackingPointer(event.pointer);
    if (_p == 0) {
      resolve(GestureDisposition.rejected);
      _p = event.pointer;
    } else {
      resolve(GestureDisposition.accepted);
    }
  }

  @override
  String get debugDescription => 'only one pointer recognizer';

  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  void handleEvent(PointerEvent event) {
    if (!event.down && event.pointer == _p) {
      _p = 0;
    }
  }
}

class GameScreen2 extends StatefulWidget {
  int currentGameLevel;
  int score;
  int helpIndex = 0;
  int count = 60;
  Timer? timer;
  bool isDone = false;
  var number = 0;
  int challenge = 0;
  int counterOfLevels = 0;
  int counterOfColors ;
  double scoreSize = 30;
  int isEducation;
  double cellSize = 0;
  int currentWord = 0;
  double textSize = 0;
  double bank = 0;
  int helpCount;
  int duration = 0;
  int level = 0;
  int tutorialCount = 0;
  bool isPassed;
  List<String> knownWordsIds = ([]);
  List<String> tutorialText = List.of(["Находи слова",
    "Дополнительные слова",
    "Подсказки перевода"]);
  List<String> tutorialPictures = List.of(["knownWord.gif","addWord.gif","promtDialog.gif"]);
  List<String> knownWords = ([]);
  int tutorialCounter = 0;
  bool isTutorial;
  bool isLearned;
  bool isTranslate = false;
  List<int> selectCell = [0, 0];
  int randomNumber = new Random().nextInt(2);
  int challengeRandom = new Random().nextInt(2);
  AudioCache player = AudioCache();
  List<List<List<Cell>>> currentMatrix;
  GameScreen2(double bank,List<String> knownWords, int this.isEducation, int this.counterOfColors,
       int this.currentGameLevel, int this.score, bool this.isTutorial,
      List<List<List<Cell>>> this.currentMatrix, int this.challenge, bool this.isLearned,
      bool this.isPassed, int this.helpCount,
      {Key? key})
      : super(key: key) {

    if (isPassed){
      isDone = false;
    }

    if (isEducation != 3){
      level = currentGameLevel;

    }
    else{
      challengeLevels.forEach((element) {element.forEach((element)
      {element.forEach((element) {element.isKnown = false;});});});
    }
    if (score > 0){


      isTutorial = true;

    }

    cellSize = 300/(currentMatrix[level].length.toDouble());
    textSize = cellSize*0.60;
  }





  @override
  _GameScreen2State createState() => _GameScreen2State();
  List<List<String>> forTutorial = List.of([
    List.of([
    "Заполните квадрат",
    "Найдите все слова",
    "Ведите по буквам",]),
    List.of([
      "Не все слова подходят",
      "для заполнения квадрата",
      ""
    ]),
    List.of([
      "Не получается найти,",
      "Используйте подсказку",
      "Справа сверху"
    ])
  ]);
  List<Color> AllColors = ([
    Color(0xffc686ca),
    Color(0xffd87e46),
    Color(0xffe56cb6),
    Color(0xff7853a7),
    Color(0xfff1de82),
    Color(0xff8e516a),
    Color(0xfff4ae70),
    Color(0xffe79299),
    Color(0xffc64d43),
    Color(0xff8c315d),
    Color(0xffce6374),
    Color(0xffd2cb3e),
    Color(0xff9c4c91),
  ]);
  List<String> addWords = List.of([]);

  List<Color> cellColors = List.of([
    lighttextColor,
    lighttextColor,
    lighttextColor,
    lighttextColor,
    lighttextColor,
    lighttextColor,
    lighttextColor,
    lighttextColor,
    lighttextColor,
    lighttextColor,
    lighttextColor,
    lighttextColor,
    lighttextColor,
    lighttextColor,
    lighttextColor,
    lighttextColor,
  ]);

  List<String> AllLevelwords = List.of([
    "ЛУЛ", "МУЛЬЫ", "СӤЗЬ", "СЮР", "СУ", "ЮАН",
    "ЫЖ","УЖ","ДУН","ПУ","ПИ",
    "ПЫЖ","АР","ТЫПЫ",
    "ВЫЖ","КЫЙ","ДУР",
    "ТУРЫН","БАКА",
    "КИОН", "ӞИЧЫ", "ОШ", "ГОНДЫР",
    "КОРКА", "УКНО", "ӜӦК", "КУАР",
    "КУАКА", "ШУНДЫ","БЕРИЗЬ",
    "ЧОРЫГ","СЮКАСЬ","КЕШЫР",
    "СУГОН","ПУКСЁН","МАКЕС",
    "ЙЫР","БАМ","ЭМЕЗЬ","АРАКЫ",
    "АРЪЯН","ПЫШТУРЫН","НЫР",
    "КЫЛБУР","МАЙТАЛ","СКАЛ",
    "ЛЬӦМ","ИЗЬЫ","КУТ","КЫШЕТ",
    "НЮЛЭС","ӴӦЖ","ГУЖЕМ","КЫЗ",
    "ЧИБИНЬ","СӤЛЬ","ТУСЬТЫ",
    "КУЖЫМ", "ГУР", "КУАЗЬ", "ТЫПЫРТОН", "НЯНЬ",
    "ЭБЕК","ПАНЬТЭМ","ПУШМУЛЬЫ","СЯРТЧЫ",
    "ШЫД","ВУ","ПЕЛЬНЯНЬ","ВАЛ","ГУБИ","КЫМЕС",
    "ЧИНЬЫ","БОРЫ","БАДЯР","ТУЛЫС","ПАЛЭЗЬ",
    "ӞОЛЬГЫРИ","ЮСЬ","НУМЫР","ӴЫН","СӤЗЬЫЛ",
    "БУБЫЛИ","ТЫМЕТ","ЛЕМТЭЙ","АЙШЕТ","УЗЫ",
    "ТЭЛЬ","ЗОРКИБЫ","ДУРЫ","АТАС","БӦДЁНО",
    "СЮСЬТЫЛ","ВЫЖЫКЫЛ","ЛЫМЫ","ЙӦ","КУРЕГ",
    "ВИРНУНАЛ","ТАШБАКА","ГОРДКУШМАН",
    "АДЯМИ","ЭКСЭЙ","СЭРЕГ","ДУШЕС","ВАМЫШ",
    "ӜӦККЫШЕТ","УЙВӦТ","КОӴЫШ","ӦС","ЛАПАС",
    "ДЫШЕТСКОН","АРБЕРИ","ВӦЛДЭТ","ВЕНЬ",
    "БАКЧА","ГУДЫРИ","ЕМЫШ","ВОТЭС","УРОБО",
    "ӜУЙ","ЁРОС","БАТЫР","ВӦЁГУБИ","ВЕДӤН","ВОЗЬ",
    "СЮЛЭМ", "КОЙЫК", "ПУЖЫМ", "ДУРИНЧИ", "ДЭРЕМ", "УЛМО", "ПУКОН",
    "ГЕРЫ","ВУКАРНАН","ГАЖАН","ГУЖДОР","ӴУШЪЯЛ","ГОРДСЮЙ","ГУЖДОР",
    "КАР","МАЖЕС","ПИЛЕМ","УКСЁ","СЮАН","СУТЭР","ӜУК","ПЕЛЬ","ДОР",
    "ДУННЕ","ПАЛЬПОТОН","ЛЫМШОР","ШАЙВЫЛ","ӦР","СЫЛАЛ","ПУЗ",
    "КОНЬЫ","ЗАРНИ","ВӦЙ","ПУРТ","УРАМ","ШЫКЫС","КОНЬДОН","ДЫР",
    "ЧИПЕЙ","ПАРСЬ","ИН","МУШ","НЮЛЭСМУРТ","КУТКУЛОНГУБИ",
    "СЮРЕС","ШУМПОТОН","АЗИНСКОН","СЯСЬКА","КОРКАКУЗЁ",
    "ГЫРЛЫ","ИНСЬӦР","ВОЖВЫЛЪЯСЬКОН","ДАРТ","ЭШЪЯСЬКОН","ОЖГАРЧИ","ОЖ","ЭШ","СИН",
    "ӴОШАТСКОН","ТОДЬЫГУБИ","НИМ","ШУЛДЫРЪЯСЬКОН","КОӴО","ЛӤЯЛГУБИ",
    "ПЕСЯТАЙ","АТАЙ","ЛУД","ГУРЕЗЬ","ОГРЕЧ","ЛЫМЫПОГ",
    "ЯРАТОН", "ВЕРАСЬКОН", "МИНДЭР", "ЛУЛЧЕБЕРЕТ", "ВАЛЕС", "ГУРТ", "КАПКА", "ВЫЖЫ",
    "АРАМА","КЫЛ","ТУСЬ","УЙ","ВӦТ","УД","ВИР","НУНАЛ",
    "КУШМАН","ШУР","ЛЫМ","ЫМ","ТЫ","ЛЫ","ЛЫС","ТЫЛ","УР",
    "СЮСЬ","ЗОР","КИБЫ","ТЭЙ","ГУ","ГУМЫ","ГЫРЛЫ","МУГ","АРНЯ",
    "КУ","КУА","КУАК","ГОН","ЫРГОН","ПЕЛЬ","БУН","КӦТ","ПУНЬЫ",
    "ПАЛ","ТУС","СЮЛ","ПУЖ","ПУЖЫ","ПУМ","КУДЫ","КИ","СЮЙ","КУЛОН","ЛӤЯЛ","БУР",
    "ДЫЖ","ПУНЫ","СУР","УД","ТАКА","ШЫР","МУРТ","ШУ","ПУРТЫ","ПУР","ШУД","ДЭРА","ВЕРАСЬ","ВӦЛЬ",
    "НЫД","ЛЯЛЬЧИ","МУНЧО","КОРТ","БЫЖ","АНАЙ","ӞАЗЕГ","ЭШ","САЕС","МУГ","ИВОР",
    "ДӦДЬЫ","ПӦЙШУР","ТӤР","АПАЙ","КЕНЕШ","МАЛПАН","БУС","ВЫН","КАРНАН","ДӤСЬ","ГИД","ПИСПУ","ТОЛЭЗЬ","АЗБАР","АНДАН","ВИЗЬ",
    "ГУЛБЕЧ","ВАЛЭКТОН","ЙЫРСИ","ПЫӴАЛ","БУДОС","ГУР","АГАЙ","НЮК","МУЗЪЕМ","ПАСЬ","ЕТӤН","ВИЗЬСЫНАН","ТУШМОН",
    "ИНБАМ","ДАУР","ГОЗЫ","СУРЕД","ОГИН","ПУНЫ","ГИЖЫ","МИЛЬЫМ","КЫР","МУС","ЭКТОН","ДАН","ПУС","НЫЛ",""
  ]);
}

class _GameScreen2State extends State<GameScreen2> {
  GlobalKey gridKey = new GlobalKey();
  List<Cell> selectedCells = List.empty(growable: true);
  Map<int, int> wordsLengths = Map();
  String word = "";
  // void dispose(){
  //   _player?.dispose();
  //   super.dispose();
  // }
  //
  // void play() {
  //     _player?.dispose;
  //     final player = _player = AudioPlayer();
  //     player.play(AssetSource('audio/untitled - Track 240.wav'));
  // }

  void selectItem(GlobalKey<State<StatefulWidget>> gridItemKey, var details) {
    RenderBox _boxItem = gridItemKey.currentContext?.findRenderObject() as RenderBox;
    RenderBox _boxMainGrid = gridKey.currentContext?.findRenderObject() as RenderBox;
    Offset position = _boxMainGrid.localToGlobal(Offset.zero); //this is global position
    double gridLeft = position.dx;
    double gridTop = position.dy;

    double gridPosition = details.globalPosition.dy - gridTop;

    //Get item position
    int rowIndex = (gridPosition / _boxItem.size.width).floor().toInt();
    int colIndex = ((details.globalPosition.dx - gridLeft) / _boxItem.size.width).floor().toInt();
    var matrix = widget.currentMatrix[widget.level];
    var cell = matrix[rowIndex][colIndex];
    if (!selectedCells.contains(cell)) {
      if(!cell.isKnown){
        cell.selected = true;
        selectedCells.add(cell);
      }
    }

    setState(() {

    });
  }

  List<int> savedIds = ([]);
  void getVariable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      widget.helpCount = prefs.getInt("helps")!;
    });

      widget.knownWords = prefs.getStringList("knownWords")!;
      widget.knownWordsIds = prefs.getStringList("knownCells")!;
      if(widget.knownWordsIds.isNotEmpty){
        if(!widget.isDone){
          if(savedIds.isEmpty){
            if (true){
              for(var i in widget.knownWordsIds){
                savedIds.add(int.parse(i));
              }
            }
            for(int i = 0; i < widget.currentMatrix[widget.level].length; i++){
              for(int j = 0; j < widget.currentMatrix[widget.level].length; j++){
                var matrix = widget.currentMatrix[widget.level];
                var cell = matrix[i][j];
                if(savedIds.contains(cell.wordId)){
                  setState(() {
                    widget.currentMatrix[widget.level][i][j].isKnown = true;
                  });
                }
                if(cell.isKnown){
                  switch (cell.wordId){
                    case 1: widget.cellColors[cell.wordId] = widget.AllColors[cell.wordId];
                    // widget.counterOfColors++;
                    break;
                    case 2: widget.cellColors[cell.wordId] = widget.AllColors[cell.wordId];
                    // widget.counterOfColors++;
                    break;
                    case 3: widget.cellColors[cell.wordId] = widget.AllColors[cell.wordId];
                    // widget.counterOfColors++;
                    break;
                    case 4: widget.cellColors[cell.wordId] = widget.AllColors[cell.wordId];
                    // widget.counterOfColors++;
                    break;
                    case 5: widget.cellColors[cell.wordId] = widget.AllColors[cell.wordId];
                    // widget.counterOfColors++;
                    break;
                    case 6: widget.cellColors[cell.wordId] = widget.AllColors[cell.wordId];
                    // widget.counterOfColors++;
                    break;
                    case 7: widget.cellColors[cell.wordId] = widget.AllColors[cell.wordId];
                    // widget.counterOfColors++;
                    break;
                    case 8: widget.cellColors[cell.wordId] = widget.AllColors[cell.wordId];
                    // widget.counterOfColors++;
                    break;
                    case 9: widget.cellColors[cell.wordId] = widget.AllColors[cell.wordId];
                    // widget.counterOfColors++;
                    break;
                  }
                }
              }
            }
            widget.isDone = true;
            }
        }
      }
  }

  void tutorial  () {

    Future.delayed(Duration.zero,(){
      widget.isTutorial = true;
      if (widget.isEducation == 3){
        showGeneralDialog(
            context: context,
            barrierDismissible:false,
            barrierLabel: '',
            transitionDuration: const Duration(milliseconds: 0),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return Center(
                child: Container(
                  height: 350,
                  width: 300,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/window.png")
                      )
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 8),
                          child: FittedBox(
                            child: Text("Испытание",
                              style: TextStyle(color: lighttextColor, fontSize: 15
                                  , decoration: TextDecoration.none),),
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/attention.png")
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 8),
                          child: FittedBox(
                            child: Column(
                              children: [
                                Text("Проходи уровни быстрее",
                                  style: TextStyle(color: lighttextColor, fontSize: 15
                                      , decoration: TextDecoration.none),),
                                Text("пока идёт время",
                                  style: TextStyle(color: lighttextColor, fontSize: 15
                                      , decoration: TextDecoration.none),),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: ElevatedButton(onPressed: (){
                            Navigator.pop(context);
                            startTimer();
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
                                child: Text("Приступить к испытанию",
                                  style: TextStyle(fontSize: 12, color: backColor),),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      }
      else{
        showGeneralDialog(
            context: context,
            barrierDismissible:false,
            barrierLabel: '',
            transitionDuration: const Duration(milliseconds: 0),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return Center(
                child: Container(
                  height: 350,
                  width: 300,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/window.png")
                      )
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 8),
                          child: FittedBox(
                            child: Text("Начало игры",
                              style: TextStyle(color: lighttextColor, fontSize: 15
                                  , decoration: TextDecoration.none),),
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/attention.png")
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 8),
                          child: FittedBox(
                            child: Column(
                              children: [
                                Text(widget.forTutorial[widget.tutorialCount][0],
                                  style: TextStyle(color: lighttextColor, fontSize: 15
                                      , decoration: TextDecoration.none),),
                                Text(widget.forTutorial[widget.tutorialCount][1],
                                  style: TextStyle(color: lighttextColor, fontSize: 15
                                      , decoration: TextDecoration.none),),
                                Text(widget.forTutorial[widget.tutorialCount][2],
                                  style: TextStyle(color: lighttextColor, fontSize: 15
                                      , decoration: TextDecoration.none),),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: ElevatedButton(onPressed: (){
                            Navigator.pop(context);

                            setState(() {
                              widget.tutorialCount++;
                              if (widget.tutorialCount < widget.forTutorial.length){

                                tutorial();
                              }
                              else{

                                savedVariables();

                              }

                            });


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
                                child: Text("Продолжить",
                                  style: TextStyle(fontSize: 12, color: backColor),),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      }

    });
  }

  void startTimer(){
    if (widget.isEducation != 3){
      widget.count = 1;
    }
    const oneSec = Duration(seconds: 1);
    widget.timer = Timer.periodic(oneSec,
            (timer){
          if (widget.isEducation == 3){
            if(widget.count == 0){
              setState(() {
                timer.cancel();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      FinalScreen(widget.score, widget.bank, widget.level, widget.isEducation, widget.challenge)),
                      (Route<dynamic> route) => false,
                );
              });

            }
            else{
              setState(() {
                widget.count--;
              });
            }
          }
          else{
            if(widget.count == 0){
              setState(() {
                widget.isTranslate = false;
                timer.cancel();
              });
            }
            else{
              setState(() {
                widget.count--;
              });
            }
          }

        }
    );

  }
  @override
  void initState() {

    getVariable();
    savedVariables();
    super.initState();
  }

  Widget build(BuildContext context) {

    wordsLengths.clear();
    // if(!widget.isDone && widget.isEducation != 3){
    //   getVariable();
    //   savedVariables();
    // }
    if (!widget.isTutorial){
      tutorial();
    }

    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        OnlyOnePointerRecognizer: GestureRecognizerFactoryWithHandlers<OnlyOnePointerRecognizer>(
              () => OnlyOnePointerRecognizer(),
              (OnlyOnePointerRecognizer instance) {},
        ),
      },
      child: WillPopScope(
        onWillPop: () async{
          return false;
        },
        child: Container(
            child: Scaffold(
                body: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/fonred.png"),
                        fit: BoxFit.cover,
                      )
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Visibility(
                                visible: widget.isEducation != 3,
                                child
                                    : Padding(
                                  padding: const EdgeInsets.only(bottom: 30),
                                  child: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Align(
                                      child: Container(
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage("assets/pause1.png"),
                                                fit: BoxFit.cover,
                                              )
                                          ),child: GestureDetector(
                                        onTap: (){

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
                                                            padding: const EdgeInsets.all(8),
                                                            child: ElevatedButton(onPressed: (){
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
                                                                  padding: const EdgeInsets.only(left: 2, right: 2, top: 5, bottom: 5),
                                                                  child: Text("Главное меню",
                                                                    style: TextStyle(fontSize: 12, color: backColor),),
                                                                )),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.all(8),
                                                            child: ElevatedButton(onPressed: (){
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
                                                                  padding: const EdgeInsets.only(left:7, right: 7, top: 5, bottom: 5),
                                                                  child: Text("Продолжить",
                                                                    style: TextStyle(fontSize: 12, color: backColor),),
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                      )),
                                    ),
                                  ),
                                ),
                              ),
                              if (widget.isEducation != 3)
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: FittedBox(
                                    child: Container(
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                          color: lighttextColor,
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      child: AnimatedDefaultTextStyle(
                                        duration: const Duration(
                                            milliseconds: 500),
                                        style: TextStyle(
                                            fontSize: widget.scoreSize,
                                            color: Colors.black),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 20,
                                              right: 20,
                                              top: 5,
                                              bottom: 5),
                                          child: Text("${widget.score}",
                                            style: TextStyle(
                                                fontSize: 20, color: backColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (widget.isEducation == 3)
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: FittedBox(
                                    child: Container(
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                          color: lighttextColor,
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      child: AnimatedDefaultTextStyle(
                                        duration: const Duration(milliseconds: 500),
                                        style: TextStyle(fontSize: widget.scoreSize,color : Colors.black),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                                          child: Text("${widget.count}",
                                            style: TextStyle(fontSize: 20, color: backColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (widget.isEducation == 3)
                                const SizedBox(),
                              Visibility(
                                visible: widget.isEducation != 3,
                                child: Padding(
                                    padding: const EdgeInsets.only(bottom: 30),
                                    child: GestureDetector(
                                      child: SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage("assets/lamp2.png"),

                                              )
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(bottom: 15),
                                              child: Text("${widget.helpCount}",

                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                            ),
                                          ),
                                        ),
                                      ),



                                      onTap: (){
                                        if (widget.helpCount > 0 && !widget.currentMatrix[widget.level]
                                            .every((element) => element.every((c) => c.isKnown))){
                                          List<int> ids = List.of([]);
                                          for(int k = 1; k < allLevelWordsUDM[widget.currentGameLevel].length+1; k++){
                                            if (!widget.knownWordsIds.contains(k.toString())){
                                              ids.add(k-1);
                                            }
                                          }
                                          print(ids);
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
                                                          Container(
                                                            height: 120,
                                                            width: 120,
                                                            decoration: const  BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: AssetImage("assets/lamp2.png")
                                                                )
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(right: 8, left: 10, bottom: 10, top: 10),
                                                            child: Text(allLevelWordsUDM[widget.level][ids[widget.helpIndex]],
                                                              style: TextStyle(color: lighttextColor,fontSize: 15, decoration: TextDecoration.none),),

                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(right: 8, left: 10),
                                                            child: Text(allLevelWordsRUS[widget.level][ids[widget.helpIndex]],
                                                              style: TextStyle(color: lighttextColor,fontSize: 15, decoration: TextDecoration.none),),

                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                          if (widget.helpIndex >= ids.length-1){
                                            widget.helpIndex = -1;
                                          }
                                          widget.helpIndex++;
                                          setState(() {
                                            widget.helpCount--;
                                            savedVariables();
                                          });

                                        }


                                      },
                                    )


                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 90,
                          child: Visibility(
                            visible: widget.isTranslate && widget.isEducation == 1,
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
                                      child: Text(allLevelWordsRUS[widget.currentGameLevel][widget.currentWord],
                                        style: TextStyle(fontSize: 20, color: backColor),),
                                    ),
                                  ),

                                ),
                              ),
                            ),
                          ),
                        ),


                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 1)
                            ),
                            key: gridKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                for (int i = 0; i < widget.currentMatrix[widget.level].length; i++)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(widget.currentMatrix[widget.level].length, (j) {
                                      GlobalKey gridItemKey = new GlobalKey();
                                      var matrix = widget.currentMatrix[widget.level];
                                      var cell = matrix[i][j];
                                      wordsLengths.putIfAbsent(cell.wordId, () => 0);
                                      wordsLengths[cell.wordId] = wordsLengths[cell.wordId]!+1;
                                      return AbsorbPointer(
                                        absorbing: false,
                                        child: GestureDetector(
                                          onTapDown: (details) {
                                            widget.duration = 0;
                                            selectItem(gridItemKey, details);
                                          },
                                          onTapUp: (details) {
                                            if(!cell.isKnown){
                                              widget.duration = 0;
                                              unselectCell(cell);
                                            }
                                            else if(widget.isEducation != 3){
                                              promptWindow(cell);
                                            }
                                          },
                                          onPanUpdate: (details) {
                                            widget.duration = 0;
                                            selectItem(gridItemKey, details);
                                          },
                                          onPanEnd: (details) {
                                            widget.duration = 0;
                                            if(!widget.currentMatrix[widget.level]
                                                .every((element) => element.every((c) => c.isKnown))){
                                              unselectCell(cell);
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: AnimatedContainer(
                                                duration: Duration(seconds: widget.duration),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.black, width: 0.5),
                                                  color: cell.selected ? widget.AllColors[widget.counterOfColors] :
                                                  cell.isKnown ?
                                                  widget.cellColors[cell.wordId] :
                                                  lighttextColor,
                                                ),

                                                child: SizedBox(
                                                    key: gridItemKey,
                                                    width: widget.cellSize,
                                                    height: widget.cellSize,
                                                    child: Align(
                                                      alignment: Alignment.center,
                                                      child: Text(cell.letter,

                                                        style: TextStyle(fontSize: widget.textSize, color: Colors.black),

                                                      ),


                                                    ))),
                                          ),

                                        ),
                                      );

                                    }),
                                  ),

                              ],

                            ),

                          ),
                        ),

                        SizedBox(),
                        SizedBox(
                          height: 77,
                          child: Visibility(
                            visible: widget.currentMatrix[widget.level]
                                .every((element) => element.every((c) => c.isKnown)) && widget.isEducation != 3,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: ElevatedButton(onPressed: (){
                                changeScreen();
                                savedVariables();
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
                                    child: Text("Продолжить",
                                      style: TextStyle(fontSize: 12, color: backColor),),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))),
      ),
    );

  }


  void promptWindow(Cell cell){
    if(cell.isKnown){
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
                      Container(
                        height: 120,
                        width: 120,
                        decoration: const  BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/book.png")
                          )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8, left: 10, bottom: 10),
                          child: Text(allLevelWordsUDM[widget.level][cell.wordId-1],
                            style: TextStyle(color: lighttextColor,fontSize: 15, decoration: TextDecoration.none),),

                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8, left: 10),
                          child: Text(allLevelWordsRUS[widget.level][cell.wordId-1],
                            style: TextStyle(color: lighttextColor,fontSize: 15, decoration: TextDecoration.none),),

                      ),
                    ],
                  ),
                ),
              ),
            );
          });

    }

  }
  void changeScreen(){
    widget.knownWords.clear();
    widget.knownWordsIds.clear();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          NewGame(widget.bank,widget.knownWords,widget.isEducation, widget.counterOfColors,
            widget.currentGameLevel, widget.score,
              widget.isTutorial, widget.currentMatrix, widget.isLearned, widget.helpCount)),

    );
  }

  void unselectCell(Cell cell) {
    Set<int> wordIds = Set();
    for (var cell in selectedCells) {
      wordIds.add(cell.wordId);
    }

    String lastWord = word;
    word = "";
    widget.isDone = true;
    selectedCells.forEach((element) {
      word = word + element.letter;
    });
    widget.duration = 0;
    if (wordIds.length == 1 && wordsLengths[cell.wordId] == selectedCells.length
        && allLevelWordsUDM[widget.level].contains(word)) {
      // win
      setState(() {
        widget.currentWord = cell.wordId-1;
      });

      widget.cellColors[cell.wordId] = widget.AllColors[widget.counterOfColors];
      widget.counterOfColors++;
      if(widget.counterOfColors >= widget.AllColors.length){
        widget.counterOfColors = 0;
      }
      if(widget.cellColors.contains(widget.AllColors[widget.counterOfColors])){

        widget.counterOfColors = widget.randomNumber+10;
        if(widget.counterOfColors >= widget.AllColors.length){
          widget.counterOfColors = 0;
        }
      }
      if(!widget.knownWordsIds.contains(cell.wordId.toString()) && widget.isEducation != 3){
        widget.knownWordsIds.add(cell.wordId.toString());
        print(widget.knownWordsIds);
      }

      savedVariables();
      // print(word);
      if(!widget.knownWords.contains(word) && widget.isEducation != 3){
        widget.knownWords.add(word);
      }
      selectedCells.forEach((element) {
        element.isKnown = true;
        element.selected = false;
      });
      // print(widget.knownWords);
      if(widget.isEducation != 3){
        setState(() {
          widget.isTranslate = true;
        });
      }


      if (widget.isEducation != 3){
        startTimer();
      }


    }
    else {
      selectedCells.forEach((element) {
        element.isKnown = false;
        element.selected = false;
      });
    }
    if(allLevelWordsUDM[widget.level].contains(word)
    && !selectedCells.every((element) => element.isKnown)
        && widget.isEducation != 3 && !widget.knownWords.contains(word)){
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
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Container(
                        height: 140,
                        width: 70,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/question.png")
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: FittedBox(
                        child: Text("Попробуй написать", style: TextStyle(color: lighttextColor, fontSize: 15
                            , decoration: TextDecoration.none),),
                      ),
                    ),
                    Text("слово", style: TextStyle(fontSize: 15,color: lighttextColor
                        , decoration: TextDecoration.none),),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 8),
                      child: FittedBox(
                        child: Text(word, style: TextStyle(color: lighttextColor, fontSize: 15
                            , decoration: TextDecoration.none),),
                      ),
                    ),
                    Text("по-другому", style: TextStyle(fontSize: 15,color: lighttextColor
                        , decoration: TextDecoration.none),),
                    const SizedBox(height: 20,)
                  ],
                ),
              ),
            ),
          );
        });
    }
    else if ((widget.addWords.contains(word) || widget.knownWords.contains(word)) && !cell.isKnown
    && !allLevelWordsUDM[widget.level].contains(word) && widget.isEducation != 3) {
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
                          height: 120,
                          width: 50,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/attention.png")
                            ),
                          ),
                        ),
                      ),
                      Text("Слово", style: TextStyle(fontSize: 15,color: lighttextColor
                          , decoration: TextDecoration.none),),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 8),
                        child: FittedBox(
                          child: Text(word, style: TextStyle(color: lighttextColor, fontSize: 15
                              , decoration: TextDecoration.none),),
                        ),
                      ),
                      Text("уже было найдено!", style: TextStyle(fontSize: 15,color: lighttextColor
                          , decoration: TextDecoration.none),),
                    ],
                  ),
                ),
              ),
            );
          });
    }
    else if(lastWord == word && cell.isKnown == false
        && widget.AllLevelwords.contains(word) == false && widget.isEducation != 3){
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
                        padding: const EdgeInsets.only(bottom: 0),
                        child: Container(
                          height: 140,
                          width: 70,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/question.png")
                            ),
                          ),
                        ),
                      ),
                      Text("Слово", style: TextStyle(fontSize: 15,color: lighttextColor
                          , decoration: TextDecoration.none),),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 8),
                        child: FittedBox(
                          child: Text(word, style: TextStyle(color: lighttextColor, fontSize: 15
                              , decoration: TextDecoration.none),),
                        ),
                      ),
                      Text("я не знаю", style: TextStyle(fontSize: 15,color: lighttextColor
                          , decoration: TextDecoration.none),),
                    ],
                  ),
                ),
              ),
            );
          });
    }


    print(widget.knownWords);
    if (widget.AllLevelwords.contains(word) && !allLevelWordsUDM[widget.level].contains(word)
        && !widget.knownWords.contains(word) && !cell.isKnown && widget.isEducation != 3){
      widget.duration = 1;
      widget.knownWords.add(word);
      final snackBar = SnackBar(
        content: Text("Найдено слово " + word, style: TextStyle(color: backColor),),
        backgroundColor: text2Color,
        duration: const Duration(milliseconds: 1200),
        action: SnackBarAction(
          label: "Ладно",
          textColor: backColor,
          onPressed: (){

          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);


    }

    if(widget.AllLevelwords.contains(word) && cell.isKnown == false){
      widget.addWords.add(word);
    }
    if(widget.currentMatrix[widget.level]
        .every((element) => element.every((c) => c.isKnown))){
      widget.helpCount++;
      savedVariables();
      widget.player.play("sound.mp3", volume: 1000000);
      if (widget.isEducation == 3){
      if(widget.level < challengeLevels.length-1){
        setState(() {
          widget.level++;
        });
      }
      else{
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) =>
              FinalScreen(widget.score, widget.bank, widget.level, widget.isEducation, widget.challenge)),
              (Route<dynamic> route) => false,
        );
        widget.level++;
      }
      }
    }
    selectedCells.clear();
    setState(() {});
  }

  void savedVariables() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      if (widget.isEducation != 3){
        prefs.setBool("learn", widget.isLearned);
        prefs.setBool("tutorial", widget.isTutorial);

        prefs.setStringList("knownCells", widget.knownWordsIds);
        prefs.setInt("mode", widget.isEducation);
        prefs.setInt("currentGameLevel", widget.currentGameLevel);
        prefs.setInt("score", widget.score);
        prefs.setStringList("knownWords", widget.knownWords);
        prefs.setBool("passed", widget.isPassed);

        prefs.setInt("helps", widget.helpCount);


      }


  }
}