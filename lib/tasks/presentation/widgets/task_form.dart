import 'package:flutter/material.dart';
import 'package:inventory_app/tasks/core/entities/task.dart';
class TaskForm extends StatefulWidget {
  const TaskForm({
    super.key,
    required this.task,
    required this.onSubmit,
  });

  final Task task;
  final Function(Task task) onSubmit;

  @override
  State<TaskForm> createState() => _TaskFormState();
}
class _TaskFormState extends State<TaskForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isCompleted = false;

  void onSubmit() {
    widget.onSubmit(
      Task(
        // retain task id
        id: widget.task.id,
        title: _titleController.text,
        description: _descriptionController.text,
        isCompleted: _isCompleted,
      ),
    );
  }

  @override
  void initState() {
    _titleController.text = widget.task.title;
    _descriptionController.text = widget.task.description;
    _isCompleted = widget.task.isCompleted;

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }
    @override
    Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          CheckboxListTile(
            title: const Text('Completed'),
            value: _isCompleted,
            onChanged: (bool? value) {
              setState(() {
                _isCompleted = value ?? false;
              });
            },
          ),
          ElevatedButton(
            onPressed: onSubmit,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
    }
}