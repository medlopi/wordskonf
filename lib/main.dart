import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) {
    runApp(MyApp());
  });
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Splash2(),
      debugShowCheckedModeBanner: false,
    );
  }

}
class Splash2 extends StatefulWidget {
  @override
  State<Splash2> createState() => _Splash2State();
}

class _Splash2State extends State<Splash2> {
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((value) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>
            Home()),
            (Route<dynamic> route) => false,
      );
    });


  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(

        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Container(
              decoration: const BoxDecoration(

                color: Color(0xffffffff),
                  image: DecorationImage(
                      image: AssetImage("assets/final_splash.png"),
                  )
              ),
            ),
        ),

      ),
    );
  }

}