import 'package:darksdkapp/sectionpage.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(new QuizSecondApp());
}

class QuizSecondApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.blue, accentColor: Colors.white),
      debugShowCheckedModeBanner: false,
      home: StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds:  5), () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SectionPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Container(
            decoration: BoxDecoration(
              image: new DecorationImage(
                image: AssetImage(
                  "assets/bg.jpg"
                ),
                fit: BoxFit.fill
              )
            ),
            
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      width: 200.0,
                      height: 200.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/logo.png"),
                          fit: BoxFit.fill 
                        )
                      ),
                    ),
                    
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

