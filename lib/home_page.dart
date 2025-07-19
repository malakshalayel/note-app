import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/add_new_task.dart';
import 'package:frontend/utils.dart';
import 'package:frontend/widgets/date_selector.dart';
import 'package:frontend/widgets/task_card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddNewTask(),
                ),
              );
            },
            icon: const Icon(
              CupertinoIcons.add,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const DateSelector(),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("tasks")
                    .where("creator",
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: Text('Error fetching tasks'));
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: ValueKey(index),
                          onDismissed: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              await FirebaseFirestore.instance
                                  .collection("tasks")
                                  .doc(snapshot.data!.docs[index].id)
                                  .delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Task deleted'),
                                ),
                              );
                            } else {
                              // Handle other dismiss directions if needed
                            }
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: TaskCard(
                                  color: hexToColor(
                                      snapshot.data!.docs[index]
                                          .data()['color'],
                                      toString),
                                  headerText: snapshot.data!.docs[index]
                                      .data()['title'],
                                  descriptionText: snapshot.data!.docs[index]
                                      .data()['description'],
                                  scheduledDate: snapshot.data!.docs[index]
                                      .data()['date']
                                      .toString(),
                                ),
                              ),
                              Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: hexToColor(
                                      snapshot.data!.docs[index]
                                          .data()['color'],
                                      toString),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  '10:00AM',
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}



/*  
StreamBuilder<QuerySnapshot>(
                                stream:  FirebaseFirestore.instance
            .collection("user information")
            .where("creator", 
            isEqualTo: user?.uid)
            .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text("Error: ${snapshot.error}"),
                                    );
                                  }
                                  if (!snapshot.hasData ) {
                                    return Center(child: Text("No Data"));
                                  }
                                  final data =
                                      snapshot.data!.data()
                                          as Map<String, dynamic>;
                                  return Center(
                                    child: Text(
                                      data["gender"] ??
                                          "null"
                                              // snapshot.data![
                                              //   index == 0
                                              //   ? "Gender"
                                              //   : index == 1
                                              //      ? "weight"
                                              //      : index == 2
                                              //        ? "status"
                                              //   : index == 3
                                              //   ? "height"
                                              //   : null,
                                              // ]
                                              .toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                              ),
*/