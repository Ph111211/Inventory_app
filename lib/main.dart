/// main.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:inventory_app/app.dart';
import 'package:inventory_app/tasks/core/repositories/task_repository.dart';
import 'package:inventory_app/tasks/core/use_cases/create_task.dart';
import 'package:inventory_app/tasks/core/use_cases/delete_task.dart';
import 'package:inventory_app/tasks/core/use_cases/getAllTask.dart';

import 'package:inventory_app/tasks/core/use_cases/update_Task.dart';
import 'package:inventory_app/tasks/data/repositories/task_repository_impl.dart';
import 'package:inventory_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize Firebase based on generated firebase_options file
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // initialize dependencies/instances
  loadDependencies();

  runApp(const MyApp());
}

/// main.dart
GetIt locator = GetIt.instance;

void loadDependencies() {
  //
  final firestore = FirebaseFirestore.instance;

  locator.registerLazySingleton<TaskRepository>(
      () => TaskRepositoryImpl(firestore));
  locator.registerLazySingleton<GetAllTaskUseCase>(
      () => GetAllTaskUseCase(locator<TaskRepository>()));
  locator.registerLazySingleton<CreateTaskUseCase>(
      () => CreateTaskUseCase(locator<TaskRepository>()));
  locator.registerLazySingleton<updateTaskUseCase>(
      () => updateTaskUseCase(locator<TaskRepository>()));
  locator.registerLazySingleton<DeleteTaskUseCase>(
      () => DeleteTaskUseCase(locator<TaskRepository>()));
}
