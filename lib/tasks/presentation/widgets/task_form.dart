// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import '../../core/entities/task.dart';
// import './DateTimeStampForm.dart';
// class TaskForm extends StatefulWidget {
//   const TaskForm({
//     super.key,
//     required this.task,
//     required this.onSubmit,
//   });

//   final Task task;
//   final Function(Task task) onSubmit;

//   @override
//   State<TaskForm> createState() => _TaskFormState();
// }
// class _TaskFormState extends State<TaskForm> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _categoryController = TextEditingController();

//   final Timestamp _dueDateController = Timestamp.now();
//   bool _isCompleted = false;

//   void onSubmit() {
//     widget.onSubmit(
//       Task(
//         // retain task id
//         userId: widget.task.userId,
//         title: _titleController.text,
//         description: _descriptionController.text,
//         category: _categoryController.text,
//         dueDate: _dueDateController,
//         createdAt: widget.task.createdAt,
      
//         status: _isCompleted,
//       ),
//     );
//   }

//   @override
//   void initState() {
//     _titleController.text = widget.task.title;
//     _descriptionController.text = widget.task.description;
//     _categoryController.text = widget.task.category;
//     _dueDateController = widget.task.dueDate;

//     // _createdAtController.text = widget.task.createdAt.toDate().toString();
//     _isCompleted = widget.task.status;

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _categoryController.dispose();
//     _descriptionController.dispose();
//     _dueDateController.dispose();

//     super.dispose();
//   }
//     @override
//     Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextField(
//             controller: _titleController,
//             decoration: const InputDecoration(labelText: 'Title'),
//           ),
//           TextField(
//             controller: _descriptionController,
//             decoration: const InputDecoration(labelText: 'Description'),
//           ),
//           CheckboxListTile(
//             title: const Text('Completed'),
//             value: _isCompleted,
//             onChanged: (bool? value) {
//               setState(() {
//                 _isCompleted = value ?? false;
//               });
//             },
//           ),
//           DateTimeStampForm(
//             label: 'Due Date',
//             initialTimestamp: _dueDateController,
//             onTimestampChanged: (Timestamp newTimestamp) {
//               setState(() {
//                 _dueDateController = newTimestamp;
//               });
//             },
//           ),
//           TextField(
//             controller: _categoryController,
//             decoration: const InputDecoration(labelText: 'Category'),
//           ),
          
//           ElevatedButton(
//             onPressed: onSubmit,
//             child: const Text('Submit'),
//           ),
//         ],
//       ),
//     );
//     }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../core/entities/task.dart';
import './DateTimeStampForm.dart';

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
  final TextEditingController _categoryController = TextEditingController();

  Timestamp _dueDate = Timestamp.now(); // ✅ có thể thay đổi
  bool _isCompleted = false;

  void onSubmit() {
    widget.onSubmit(
      Task(
        userId: widget.task.userId,
        title: _titleController.text,
        description: _descriptionController.text,
        category: _categoryController.text,
        dueDate: _dueDate,
        createdAt: widget.task.createdAt,
        status: _isCompleted,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.task.title;
    _descriptionController.text = widget.task.description;
    _categoryController.text = widget.task.category;
    _dueDate = widget.task.dueDate; // ✅ gán lại được
    _isCompleted = widget.task.status;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    // ❌ KHÔNG gọi dispose() trên Timestamp
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
          TimestampField(
            label: 'Due Date',
            initialTimestamp: _dueDate,
            onTimestampChanged: (Timestamp newTs) {
              setState(() {
                _dueDate = newTs;
              });
            },
      ),

          TextField(
            controller: _categoryController,
            decoration: const InputDecoration(labelText: 'Category'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onSubmit,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
