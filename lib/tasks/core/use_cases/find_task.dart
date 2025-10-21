import '../entities/task.dart';
import '../repositories/task_repository.dart';

class FindTaskByCategoryOrStatusUseCase {
  final TaskRepository _taskRepository;

  FindTaskByCategoryOrStatusUseCase(this._taskRepository);

  Stream<List<Task>> call(bool status, String category) async* {
    yield* _taskRepository.findByStatusOrCategory(status, category);
  }
}
