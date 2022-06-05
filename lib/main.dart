import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

import 'joke.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  Widget newJoke() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: FutureBuilder<String>(
          future: fetchJoke(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return decoratedBoxForJokes(snapshot.data as String);
            } else {
              return decoratedBoxForJokes(
                  "Chucknorris is thinking about a new joke");
            }
          },
        ),
      ),
    );
  }

  Widget decoratedBoxForJokes(String jokeText) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.75),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 6), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(30),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height-190,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  jokeText,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> jokes = [];
  @override
  Widget build(BuildContext context) {
    if (jokes.length < 3) {
      for (int i = 0; i < 3; i++) {
        jokes.add(newJoke());
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Not funny chucknorris",
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'shago'),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                jokes.add(newJoke());
                return jokes[index];
              },
              viewportFraction: 0.8,
              scale: 0.5,
              itemCount: 100000,
              control: ContolePanel(),
              loop: false,
              duration: 500,
            ),
          ),
        ),
      ),
    );
  }
}

class ContolePanel extends SwiperPlugin {
  ///iconData fopr next
  final IconData likeButton;
  IconData autoPlay = Icons.play_circle;
  bool enabled = false;

  ///icon size
  final double size;

  final EdgeInsetsGeometry padding;

  ContolePanel({
    this.likeButton = Icons.thumb_up,
    this.size = 35.0,
    this.padding = const EdgeInsets.all(5.0),
  });

  Widget buildLikeButton({
    required padding,
    required size,
    required config,
    required color,
    required iconDaga,
  }){
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        config!.controller.next(animation: true);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: SizedBox(
          width: 130.0,
          height: 60.0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              border: Border.all(
                color: Colors.deepPurple,
                width: 4,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: padding,
              child: RotatedBox(
                quarterTurns: 0,
                child: Icon(
                  iconDaga,
                  size: size,
                  color: color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAutoPlayButton({
    required SwiperController? config,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (enabled == false) {
          config!.startAutoplay();
          autoPlay = Icons.pause_circle;
          enabled = true;
        } else {
          config!.stopAutoplay();
          autoPlay = Icons.play_circle;
          enabled = false;
        }
        config.next(animation: true);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: SizedBox(
          width: 130.0,
          height: 60.0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              border: Border.all(
                color: Colors.deepPurple,
                width: 4,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: padding,
              child: RotatedBox(
                quarterTurns: 0,
                child: Icon(
                  autoPlay,
                  size: size + 10,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    const color = Colors.white;
    Widget child;
    child = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: buildLikeButton(
                  padding: padding,
                  size: size,
                  config: config,
                  color: color,
                  iconDaga: likeButton),
            ),
            buildAutoPlayButton(
              config: config.controller,
            ),
          ],
        ),
      ],
    );
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: child,
    );
  }
}
