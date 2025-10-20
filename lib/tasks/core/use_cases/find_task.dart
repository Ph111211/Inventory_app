import '../entities/task.dart';
import '../repositories/task_repository.dart';

class FindTaskByCategoryAndStatusUseCase {
  final TaskRepository _taskRepository;

  FindTaskByCategoryAndStatusUseCase(this._taskRepository);

  Stream<List<Task>> call(bool status, String category) async* {
    yield* _taskRepository.findByStatusAndCategory(status, category);
  }
}
