import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/todo_service.dart';
import 'package:flutter_application_1/utilities/snackbar_helper.dart';

class addToDoList extends StatefulWidget {
  final Map? todo;
  const addToDoList({
    super.key,
    required this.todo,
  });

  @override
  State<addToDoList> createState() => _addToDoListState();
}

class _addToDoListState extends State<addToDoList> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit todo' : 'Add ToDo List',
        ),
        centerTitle: true,
        toolbarHeight: 100,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Title',
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: 'Description',
              ),
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 8,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Text(isEdit ? 'Update' : 'Submit'),
            ),
          ],
        ),
      ),
    );
  }

  // Update
  Future<void> updateData() async {
    final todo = widget.todo;

    if (todo == null) {
      showSuccessMessage(context, msg: 'Failed to update');
      return;
    }

    final id = todo['_id'];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_complete": false,
    };

    final isSuccess = await TodoService.updateToDo(id, body);

    if (isSuccess) {
      showSuccessMessage(context, msg: 'success');
    } else {
      showSuccessMessage(context, msg: 'Failed');
    }
  }

  // Read
  Future<void> submitData() async {
    // Get data from user
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_complete": false,
    };

    final isSuccess = await TodoService.addToDo(body);

    if (isSuccess) {
      showSuccessMessage(context, msg: 'Success');
    } else {
      showSuccessMessage(context, msg: 'Failed');
    }
  }
}
