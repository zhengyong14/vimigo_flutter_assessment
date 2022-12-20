import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {

  void _setIntroStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('introduction', false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: IntroductionScreen(
        scrollPhysics: const BouncingScrollPhysics(), //Default is BouncingScrollPhysics
        pages: [
          //List of PageViewModel

          PageViewModel(
              title: '',
              body: '',

              image: Center(
                  child:Image.asset("1.png", width: 2800,height: 2300,)
              ),
              //getPageDecoration, a method to customise the page style
              decoration: const PageDecoration(
                pageColor: Colors.white,
                titlePadding: EdgeInsets.only(top: 50),
                fullScreen: true,
                bodyTextStyle: TextStyle(color: Colors.black54,fontSize: 15),
              )
          ),
          PageViewModel(
              title: '',
              body: '',

              image: Center(
                  child:Image.asset("2.png", width: 2800,height: 2300,)
              ),
              //getPageDecoration, a method to customise the page style
              decoration: const PageDecoration(
                pageColor: Colors.white,
                titlePadding: EdgeInsets.only(top: 50),
                fullScreen: true,
                bodyTextStyle: TextStyle(color: Colors.black54,fontSize: 15),
              )
          ),
          PageViewModel(
              title: '',
              body: '',

              image: Center(
                  child:Image.asset("3.png", width: 2800,height: 2300,)
              ),
              //getPageDecoration, a method to customise the page style
              decoration: const PageDecoration(
                pageColor: Colors.white,
                titlePadding: EdgeInsets.only(top: 50),
                fullScreen: true,
                bodyTextStyle: TextStyle(color: Colors.black54,fontSize: 15),
              )
          ),
          PageViewModel(
              title: '',
              body: '',

              image: Center(
                  child:Image.asset("4.png", width: 2800,height: 2300,)
              ),
              //getPageDecoration, a method to customise the page style
              decoration: const PageDecoration(
                pageColor: Colors.white,
                titlePadding: EdgeInsets.only(top: 50),
                fullScreen: true,
                bodyTextStyle: TextStyle(color: Colors.black54,fontSize: 15),
              )
          ),
          PageViewModel(
              title: '',
              body: '',

              image: Center(
                  child:Image.asset("5.png", width: 2800,height: 2300,)
              ),
              //getPageDecoration, a method to customise the page style
              decoration: const PageDecoration(
                pageColor: Colors.white,
                titlePadding: EdgeInsets.only(top: 50),
                fullScreen: true,
                bodyTextStyle: TextStyle(color: Colors.black54,fontSize: 15),
              )
          ),
        ],
        rawPages: const [
          //If you don't want to use PageViewModel you can use this
        ],
        //If you provide both rawPages and pages parameter, pages will be used.
        onChange: (e){
          // When something changes
        },
        onDone: () {
          // When done button is press
          _setIntroStatus();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return MyApp();
              },
            ),
          );
        },
        onSkip: () {
          // You can also override onSkip callback
        },
        showSkipButton: true, //Is the skip button should be display
        skip: const Icon(Icons.skip_next),
        next: const Icon(Icons.forward),
        done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),

        dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: Colors.amberAccent,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
      ),
    );
  }
}