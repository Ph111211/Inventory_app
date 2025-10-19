import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetAllTaskUseCase {
  final TaskRepository _taskRepository;

  GetAllTaskUseCase(this._taskRepository);

  Stream<List<Task>> call() {
    return _taskRepository.getAll();
  }
}