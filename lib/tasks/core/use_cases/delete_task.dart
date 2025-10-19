import '../entities/task.dart';
import '../repositories/task_repository.dart';
class DeleteTaskUseCase {
  final TaskRepository _taskRepository;

  DeleteTaskUseCase(this._taskRepository);

  Future<void> call(String id) async {
    await _taskRepository.delete(id);
  }
}