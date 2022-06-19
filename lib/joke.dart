import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
part 'joke.g.dart';

@JsonSerializable()
class Joke {
  final String id;
  final String value;

  const Joke({
    required this.id,
    required this.value,
  });

  factory Joke.fromJson(Map<String, dynamic> json) => _$JokeFromJson(json);
  Map<String, dynamic> toJson() => _$JokeToJson(this);
}

Future<String> fetchJoke() async {
  final response =
      await http.get(Uri.parse("https://api.chucknorris.io/jokes/random"));
  if (response.statusCode == 200) {
    return Joke.fromJson(jsonDecode(response.body)).value;
  } else {
    throw Exception('Failed to load jokes');
  }
}

List<Widget> jokes = [];
List<String> jokesText = [];

class CreateNewJoke extends StatelessWidget {
  const CreateNewJoke({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: FutureBuilder<String>(
          future: fetchJoke(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return JokesBox(
                  jokeText: "Chucknorris is thinking about a new joke",
                  context: context);
            }
            if (snapshot.data != null) {
              jokesText.add(snapshot.data as String);
              return JokesBox(
                  jokeText: snapshot.data as String, context: context);
            } else {
              jokesText.add("Chucknorris is thinking about a new joke");
              return JokesBox(
                  jokeText: "Chucknorris is thinking about a new joke",
                  context: context);
            }
          },
        ),
      ),
    );
  }
}

class JokesBox extends StatelessWidget {
  const JokesBox({
    Key? key,
    required this.jokeText,
    required this.context,
  }) : super(key: key);

  final String jokeText;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
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
          height: MediaQuery.of(context).size.height - 190,
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
}
