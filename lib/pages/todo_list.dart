import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/todo_card.dart';
import 'package:flutter_application_1/services/todo_service.dart';
import 'package:flutter_application_1/pages/add_todo.dart';
import 'package:flutter_application_1/utilities/snackbar_helper.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo List'),
        centerTitle: true,
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetchData,

          // ListTile
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text('No items'),
            ),
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                // final id = item['_id'] as String;
                return TodoCart(
                  index: index,
                  item: item,
                  navigateEdit: toEditPage,
                  deleteById: deleteById,
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toAddToDo,
        child: Center(
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  // Add items page
  Future<void> toAddToDo() async {
    final route = MaterialPageRoute(
      builder: (context) => addToDoList(
        todo: null,
      ),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchData();
  }

  void toEditPage(Map item) {
    final route =
        MaterialPageRoute(builder: (context) => addToDoList(todo: item));
    Navigator.push(context, route);
  }

  // Delete
  Future<void> deleteById(String id) async {
    final success = await TodoService.deleteById(id);

    if (success) {
      print('Success');
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
        showSuccessMessage(context, msg: 'Success to remove');
      });
    } else {
      print('Failed to delete');
      showSuccessMessage(context, msg: 'Failed to remove');
    }
  }

  // Read
  Future<void> fetchData() async {
    final response = await TodoService.fetchData();

    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showSuccessMessage(context, msg: 'Something wrong i can feel it');
    }

    setState(() {
      isLoading = false;
    });
  }
}
