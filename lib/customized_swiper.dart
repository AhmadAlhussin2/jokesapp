import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'joke.dart';
import 'buttons.dart';

class CustomedSwiper extends StatelessWidget {
  const CustomedSwiper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          jokes.add(const CreateNewJoke());
          return jokes[index];
        },
        viewportFraction: 0.8,
        scale: 0.5,
        itemCount: 100000,
        control: ControlPanel(),
        loop: false,
        duration: 500,
      ),
    );
  }
}
