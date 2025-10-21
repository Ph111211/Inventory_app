import '../entities/task.dart';
abstract class TaskRepository {
  // get all tasks
  Stream<List<Task>> getAll();

  // get a task by id
  Future<Task> getById(String id);

  // creates a new task
  Future<void> create(Task task);

  // updates task details
  Future<void> update(Task task);

  // delete the task
  Future<void> delete(String id);
  //find tasks by status
  Stream<List<Task>> findByStatusOrCategory(bool status, String category);
}