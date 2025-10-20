import 'package:flutter/material.dart';

@immutable
class Task {
  final String? id;
  final String title;
  final String description;
  final bool isCompleted;

  const Task({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
    Map<String, dynamic> toJson() {
        return {
        'id': id,
        'title': title,
        'description': description,
        'isCompleted': isCompleted,
        };
    }
    Task copyWith({
        String? id,
        String? title,
        String? description,
        bool? isCompleted,
    }) {
        return Task(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        isCompleted: isCompleted ?? this.isCompleted,
        );
    }
    
}
