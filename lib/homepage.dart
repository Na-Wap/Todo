import 'package:flutter/material.dart';
import 'package:todo/models/todo.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  //Async method for fetcing todos

  fetchTodos() async {
    try {
      final response = await http.get(
        Uri.parse("https://jsonplaceholder.typicode.com/todos"),
      );
    } catch (e) {
      print("Exception $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodos();
  }

  final GlobalKey<FormState> todoformKey = GlobalKey();
  String title = "";
  String description = "";
  List<Todo> todos = [
    Todo(id: 1, title: "title1", description: "description1"),
    Todo(
      id: 2,
      title: "title2",
      description: "description2",
      isCompleted: true,
    ),
    Todo(id: 3, title: "title3", description: "description3"),
    Todo(id: 4, title: "title4", description: "description4"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("To-Do Application")),
      //ListView : dekhaune column jstai kk data rakhni vnerw , builder : function ho josle kati patak buid garni vnerw vnxw , item builder : k dekhauni k display garni kati choti dekhauni ,ctx= context(for finding widget) index =i,
      body: ListView.builder(
        itemBuilder: (ctx, i) {
          return ListTile(
            leading: Checkbox(
              value: todos[i].isCompleted,
              onChanged: (value) {
                setState(() {
                  todos[i].isCompleted = value ?? false;
                });
              },
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  todos.remove(todos[i]);
                });
              },
              icon: Icon(Icons.delete_outline),
              color: Colors.red,
            ),
            title: Text(todos[i].title),
            subtitle: Text(todos[i].description),
          );
        },
        itemCount: todos.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Add Todo", style: TextStyle(fontSize: 24)),
                      Form(
                        key: todoformKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            spacing: 20,
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText: "Enter Title",
                                  labelText: "Title",
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter Title";
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (value) {
                                  setState(() {
                                    title = value!;
                                  });
                                },
                              ),
                              TextFormField(
                                minLines: 1,
                                maxLines: 5,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText: "Enter Description",
                                  labelText: "Description",
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter Description";
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (value) {
                                  setState(() {
                                    description = value!;
                                  });
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FilledButton.tonal(
                                    onPressed: () {
                                      if (!todoformKey.currentState!
                                          .validate()) {
                                        return;
                                      }
                                      todoformKey.currentState!.save();
                                      todos.add(
                                        Todo(
                                          id: todos.length + 1,
                                          title: title,
                                          description: description,
                                        ),
                                      );
                                      Navigator.pop(context);
                                    },
                                    child: Text("Add"),
                                  ),
                                  FilledButton.tonal(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
