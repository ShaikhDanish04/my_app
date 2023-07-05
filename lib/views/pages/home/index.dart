import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_app/models/todoItem.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<TodoItem> items = [];

  SharedPreferences? prefs;

  syncData() async {
    prefs = await SharedPreferences.getInstance();

    prefs?.setString('todos', jsonEncode(items));
  }

  loadData() async {
    prefs = await SharedPreferences.getInstance();

    final jsonItems = jsonDecode(prefs?.getString('todos') ?? '');

    setState(() {

      for(var eachItem in jsonItems) {
        items.add(TodoItem.fromJson(eachItem));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    loadData();

    // items.add(TodoItem(title: 'Lets get the UI Done'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Welcome, User'),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            TodoItem item = items[index];

            return ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.title}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (item.description != null)
                    Text(
                      '${item.description}',
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return TodoForm(
                          item: item,
                          onDelete: (item) async {
                            Navigator.of(context).pop();
                            setState(() {
                              items.removeAt(index);
                            });
                            await syncData();

                          },
                          onSaved: (item) async {
                            Navigator.of(context).pop();

                            setState(() {
                              items[index] = item;
                              // items.add(item);
                            });

                            await syncData();
                          });
                    });
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            // items.add(TodoItem(title: 'This is new', description: 'This is the description.This is the descriptionThis is the descriptionThis is the descriptionThis is the description'));

            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return TodoForm(onSaved: (item) {
                    setState(() async {
                      Navigator.of(context).pop();

                      items.add(item);

                      await syncData();
                    });
                  }
                      // item: item,
                      // onDelete: (item) {
                      //   Navigator.of(context).pop();
                      //   setState(() {
                      //     items.removeAt(index);
                      //   });
                      // },
                      );
                });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TodoForm extends StatefulWidget {
  TodoItem? _item;
  Function(TodoItem item)? _onDelete;
  Function(TodoItem item)? _onSaved;

  TodoForm({
    TodoItem? item,
    Function(TodoItem item)? onDelete,
    Function(TodoItem item)? onSaved,
  }) {
    _item = item;
    _onDelete = onDelete;
    _onSaved = onSaved;
  }

  @override
  State<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    titleController.text = widget._item?.title ?? '';
    descriptionController.text = widget._item?.description ?? '';
  }

  final _formKey = GlobalKey<FormState>();

  submit() {
    if (_formKey.currentState!.validate() && widget._onSaved != null) {
      widget._onSaved!(TodoItem(title: titleController.text, description: descriptionController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  // validator: (value) {
                  //   if (value == '' || value!.isEmpty) {
                  //     return 'Title cannot be Empty';
                  //   }

                  //   return '';
                  // },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: titleController,
                  decoration: InputDecoration(hintText: 'Enter Title'),
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(hintText: 'Enter Description'),
                  minLines: 5,
                  maxLines: 5,
                ),
                // Text('${widget._item?.title}'),
                // if (widget._item?.description != null) Text('${widget._item?.description}'),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget._onDelete != null)
                  ElevatedButton(
                    onPressed: () {
                      if (widget._onDelete != null) {
                        widget._onDelete!(widget._item!);
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text('Delete'),
                  ),
                ElevatedButton(
                  onPressed: submit,
                  child: Text('Save'),
                ),
              ],
            ),
          )
        ],
      ),
    );
    ;
  }
}
