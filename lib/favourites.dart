import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavouritesList extends StatelessWidget {
  const FavouritesList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const AllJokes(),
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Funny chucknorris",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'shago',
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context, rootNavigator: true).pop(
              context,
            );
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
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
              return Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 20,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 198, 165, 255),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        data.docs[index]['Joke'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
class FavouritesButton extends StatelessWidget {
  const FavouritesButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FavouritesList()),
          );
        },
        child: const Icon(
          Icons.star_border,
        ),
      ),
    );
  }
}