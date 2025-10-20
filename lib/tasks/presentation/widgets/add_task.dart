import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../main.dart';
import '../../core/entities/task.dart';
import '../../core/use_cases/create_task.dart';
import '../widgets/task_form.dart';
class AddTask extends StatefulWidget {
  const AddTask({
    super.key,
  });

  @override
  State<AddTask> createState() => _AddTaskState();
}
class _AddTaskState extends State<AddTask> {
  final CreateTaskUseCase _createTaskUseCase =
      locator<CreateTaskUseCase>();

  Future<void> onSubmit(Task task) async {
    await _createTaskUseCase.call(task);

    if (mounted) {
      Navigator.of(context).pop();
      // .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return TaskForm(
      task: Task(
        title: '',
        description: '',
        category: '',
        status: false,
        dueDate: Timestamp.now(),
        createdAt: Timestamp.now(),

      ),
      onSubmit: (Task task) {
        onSubmit(task);
      },
    );
  }
}
