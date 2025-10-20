import 'package:flutter/material.dart';
import 'package:inventory_app/tasks/core/entities/task.dart';
import 'package:inventory_app/tasks/presentation/widgets/task_form.dart';
import 'package:inventory_app/main.dart';
import 'package:inventory_app/tasks/core/use_cases/create_task.dart';
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
      task: const Task(
        title: '',
        description: '',
        isCompleted: false,
      ),
      onSubmit: (Task task) {
        onSubmit(task);
      },
    );
  }
}
