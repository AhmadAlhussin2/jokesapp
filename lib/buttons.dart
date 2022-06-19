import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'joke.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class ControlPanel extends SwiperPlugin {
  final double size;
  final EdgeInsetsGeometry padding;

  ControlPanel({
    this.size = 35.0,
    this.padding = const EdgeInsets.all(5.0),
  });

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
              child: LikeButton(
                padding: padding,
                size: size,
                config: config,
                color: color,
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: AutoPlayButton(
                padding: padding,
                size: size,
                config: config.controller,
                color: color,
              ),
            ),
            FavouritesButton(
              padding: padding,
              size: size,
              config: config,
              color: color,
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

class FavouritesButton extends StatelessWidget {
  const FavouritesButton({
    Key? key,
    required this.padding,
    required this.size,
    required this.config,
    required this.color,
  }) : super(key: key);

  final IconData favourite = Icons.favorite_border;
  final EdgeInsetsGeometry padding;
  final double size;
  final SwiperPluginConfig config;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        try {
          CollectionReference jokes =
              FirebaseFirestore.instance.collection("jokes");
          int idx = config.pageController!.page!.round();
          jokes.add({'Joke': jokesText[idx]});
        } catch (e, s) {
          FirebaseCrashlytics.instance.recordError(
            e,
            s,
            reason: 'Can not find the correct joke',
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: SizedBox(
          width: 120.0,
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
                  favourite,
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
}

class AutoPlayButton extends StatelessWidget {
  const AutoPlayButton({
    Key? key,
    required this.padding,
    required this.size,
    required this.config,
    required this.color,
  }) : super(key: key);

  final EdgeInsetsGeometry padding;
  final double size;
  final SwiperController? config;
  final Color color;
  @override
  Widget build(BuildContext context) {
    IconData autoPlay = Icons.play_circle_outlined;
    bool enabled = false;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (enabled == false) {
          config!.startAutoplay();
          autoPlay = Icons.pause_circle_outline;
          enabled = true;
        } else {
          config!.stopAutoplay();
          autoPlay = Icons.play_circle_outline;
          enabled = false;
        }
        config!.next(animation: true);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: SizedBox(
          width: 120.0,
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
}

class LikeButton extends StatelessWidget {
  const LikeButton({
    Key? key,
    required this.padding,
    required this.size,
    required this.config,
    required this.color,
  }) : super(key: key);

  final EdgeInsetsGeometry padding;
  final double size;
  final SwiperPluginConfig config;
  final Color color;
  final IconData iconDaga = Icons.thumb_up_outlined;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        config.controller.next(animation: true);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: SizedBox(
          width: 120.0,
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
}
