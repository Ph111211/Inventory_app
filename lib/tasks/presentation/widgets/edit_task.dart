import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../core/entities/task.dart';
import '../../core/use_cases/update_task.dart';
import './task_form.dart';
class EditTask extends StatefulWidget {
  const EditTask({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  State<EditTask> createState() => _EditTaskState();
}
class _EditTaskState extends State<EditTask> {
  final updateTaskUseCase _updateTaskUseCase =
      locator<updateTaskUseCase>();

  Future<void> _onSubmit(Task task) async {
    await _updateTaskUseCase.call(task);

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TaskForm(
        task: widget.task,
        onSubmit: (Task task) {
          _onSubmit(task);
        });
  }
}
