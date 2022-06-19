import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';
import 'joke.dart';

class FavouritesList extends StatelessWidget {
  FavouritesList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: AllJokes(),
    );
  }
}

class AllJokes extends StatefulWidget {
  const AllJokes({Key? key}) : super(key: key);

  @override
  State<AllJokes> createState() => _AllJokesState();
}

class _AllJokesState extends State<AllJokes> {
  final Stream<QuerySnapshot> jokes =
      FirebaseFirestore.instance.collection('jokes').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: jokes,
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          if (snapshot.hasError) {
            return const Text("Error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("loading");
          }
          final data = snapshot.data;
          return ListView.builder(
            itemCount: data!.size,
            itemBuilder: (context, index) {
              return Text(data.docs[index]['Joke']);
            },
          );
        },
      ),
    );
  }
}
