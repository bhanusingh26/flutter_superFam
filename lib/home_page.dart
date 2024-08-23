import 'package:flutter/material.dart';
import 'package:test_app/services/database_sevice.dart';

import 'models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService.instance;

  String? _valueAdded;
  String? _keyAdded;

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        shadowColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 10.0,
        title: const Text('SuperFam Test App'),
      ),
      floatingActionButton: _addTaskButton(),
      body: _cardsList(),
    );
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      backgroundColor: const Color.fromARGB(228, 242, 17, 17),
      onPressed: () {
        showModalBottomSheet<void>(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25.0),
            ),
          ),
          elevation: 10.0,
          context: context,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      'Add Key Value Pair',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _keyAdded = value;
                        });
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Add Key',
                          labelText: 'Key'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _valueAdded = value;
                        });
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Add Value',
                          labelText: 'Value'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MaterialButton(
                          elevation: 10.0,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10.0),
                              bottom: Radius.circular(10.0),
                            ),
                          ),
                          color: const Color.fromARGB(229, 244, 69, 69),
                          onPressed: () {
                            setState(() {
                              _valueAdded = null;
                            });
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        MaterialButton(
                          elevation: 10.0,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10.0),
                              bottom: Radius.circular(10.0),
                            ),
                          ),
                          color: const Color.fromARGB(229, 244, 69, 69),
                          onPressed: () {
                            if (_valueAdded == null ||
                                _valueAdded?.isEmpty == true ||
                                _keyAdded == null ||
                                _keyAdded?.isEmpty == true) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Invalid Fields"),
                                    actions: [
                                      TextButton(
                                        child: const Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              _databaseService.addTask(
                                  value: _valueAdded!, key: _keyAdded!);
                              setState(() {
                                _valueAdded = null;
                              });
                              Navigator.pop(
                                context,
                              );
                            }
                          },
                          child: const Text(
                            "Save",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
      child: const Icon(
        Icons.add,
      ),
    );
  }

  Widget _cardsList() {
    return Center(
      child: FutureBuilder(
        future: _databaseService.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.hasError == true) {
            return const Text('Unable to reach Database');
          }
          int itemCount = snapshot.data?.length ?? 0;
          if (snapshot.hasData == true && itemCount == 0) {
            return const Text('Welcome to SuperFam.');
          }
          return ListView.builder(
            itemCount: itemCount,
            itemBuilder: (context, index) {
              Task task = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                child: Card(
                  shadowColor: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10.0),
                    leading: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: 'Key'),
                        readOnly: true,
                        initialValue: task.key,
                      ),
                    ),
                    trailing: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: 'Value'),
                        readOnly: true,
                        initialValue: task.value,
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
