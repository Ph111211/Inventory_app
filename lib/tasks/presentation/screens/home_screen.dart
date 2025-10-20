import 'package:flutter/material.dart';
import '../../../main.dart';
import '../../core/entities/task.dart';
import '../../core/use_cases/getAllTask.dart';
import '../../core/use_cases/delete_task.dart';
import '../widgets/add_task.dart';
import '../widgets/edit_task.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  final GetAllTaskUseCase getAllTaskUseCase = locator<GetAllTaskUseCase>();
  final DeleteTaskUseCase _deleteTaskUseCase = locator<DeleteTaskUseCase>();

    void addTask() {
        showDialog(
            context: context,
            builder: (context) {
            return const AlertDialog(
                title: Text('ADD TASK'),
                content: AddTask(),
            );
            });
    }
    void editTask(Task task) {
        showDialog(
            context: context,
            builder: (context) {
            return AlertDialog(
                title: const Text('UPDATE TASK'),
                content: EditTask(
                task: task,
                ),
            );
            });
    }
    Future<void> deleteTask(Task task) async {
        //
        showDialog(
        context: context,
        builder: (context) {
            return AlertDialog(
            title: const Text('DELETE TASK'),
            content: const Text('Are you sure you want to delete this task?'),
            actions: [
                TextButton(
                    onPressed: () {
                    Navigator.pop(context);
                    },
                    child: const Text('CANCEL')),
                FilledButton(
                    onPressed: () async {
                    await _deleteTaskUseCase.call(task.userId!);
                    Navigator.pop(context);
                    },
                    child: const Text('DELETE')),
            ],
            );
        },
        );
    }
    @override
    Widget build(BuildContext context) {
        return Scaffold(
        appBar: AppBar(
            title: const Text('Task Manager'),
        ),
        body: StreamBuilder<List<Task>>(
            stream: getAllTaskUseCase.call(),
            builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No tasks available.'));
            } else {
                final tasks = snapshot.data!;
                return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                    final task = tasks[index];
                    return ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.description),
                    trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => editTask(task),
                        ),
                        IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => deleteTask(task),
                        ),
                        ],
                    ),
                    );
                },
                );
            }
            },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: addTask,
            child: const Icon(Icons.add),
        ),
        );
    }


}