import 'package:flutter/material.dart';
import 'package:inventory_app/tasks/core/entities/task.dart';
import 'package:inventory_app/tasks/core/use_cases/getAllTask.dart';
import 'package:inventory_app/tasks/core/use_cases/delete_task.dart';
import 'package:inventory_app/tasks/core/use_cases/find_task.dart';
import '../../../main.dart';
import 'package:inventory_app/tasks/presentation/widgets/add_task.dart';
import 'package:inventory_app/tasks/presentation/widgets/edit_task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  final GetAllTaskUseCase getAllTaskUseCase = locator<GetAllTaskUseCase>();
  final DeleteTaskUseCase _deleteTaskUseCase = locator<DeleteTaskUseCase>();
  final FindTaskByCategoryOrStatusUseCase _findUseCase =
      locator<FindTaskByCategoryOrStatusUseCase>();

  // search UI state
  final TextEditingController _categoryController = TextEditingController();
  String _statusSelection = 'All'; // options: All / Completed / Pending
  Stream<List<Task>>? _searchStream;

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  void addTask() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('ADD TASK'),
          content: AddTask(),
        );
      },
    );
  }

  void editTask(Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('UPDATE TASK'),
          content: EditTask(task: task),
        );
      },
    );
  }

  Future<void> deleteTask(Task task) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('DELETE TASK'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('DELETE'),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await _deleteTaskUseCase.call(task.userId.toString());
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Task deleted')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Delete failed: $e')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _executeSearch() {
    final category = _categoryController.text.trim();
    bool status;
    if (_statusSelection == 'Completed') {
      status = true;
    } else if (_statusSelection == 'Pending') {
      status = false;
    } else {
      // 'All' selected
      status = true; // default value, won't be used in search
    }

    setState(() {
      if (_statusSelection == 'All' && category.isEmpty) {
        _searchStream = null; // show all tasks
      } else if (_statusSelection == 'All') {
        // search by category only
        _searchStream =
            _findUseCase.call(true, category); // status is dummy here
      }
      else if (category.isEmpty) {
        // search by status only
        _searchStream =
            _findUseCase.call(status, ''); // category is dummy here
      } else {
        // search by both status and category
        _searchStream = _findUseCase.call(status, category);
      }
    });
    
  }

  void _clearSearch() {
    _categoryController.clear();
    setState(() {
      _statusSelection = 'All';
      _searchStream = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final streamToShow = _searchStream ?? getAllTaskUseCase.call();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _statusSelection,
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All')),
                    DropdownMenuItem(value: 'Completed', child: Text('Completed')),
                    DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                  ],
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => _statusSelection = v);
                  },
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _executeSearch,
                  child: const Text('Search'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _clearSearch,
                  child: const Text('Clear'),
                ),
              ],
            ),
          ),

          // Results
          Expanded(
            child: StreamBuilder<List<Task>>(
              stream: streamToShow,
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
                      final t = tasks[index];
                      return ListTile(
                        title: Text(t.title),
                        subtitle: Text(t.description ?? ''),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => editTask(t),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => deleteTask(t),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}