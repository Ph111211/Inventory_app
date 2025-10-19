import '../entities/task.dart';
import '../repositories/task_repository.dart';

class updateTaskUseCase {
  final TaskRepository _taskRepository;

  updateTaskUseCase(this._taskRepository);

  Future<void> call(Task task) async {
    await _taskRepository.update(task);
  }
}