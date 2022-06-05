import 'dart:convert';

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


