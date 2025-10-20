import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class Task {
  final String? userId;
  final String title;
  final String description;
  final String category;
  final Timestamp dueDate;
  final Timestamp createdAt;
  final bool status;


   const Task({
    this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.dueDate,
    required this.createdAt,
    required this.status,
  });
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      userId: json['userId'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      dueDate: json['dueDate'],
      createdAt: json['createdAt'],
      status: json['status'],
    );
  }
    Map<String, dynamic> toJson() {
        return {
        'userId': userId,
        'title': title,
        'description': description,
        'category': category,
        'dueDate': dueDate,
        'createdAt': createdAt,
        'status': status,
        };
    }
    Task copyWith({
        String? userId,
        String? title,
        String? description,
        String? category,
        Timestamp? dueDate,
        Timestamp? createdAt,
        bool? status,
    }) {
        return Task(
        userId: userId ?? this.userId,
        title: title ?? this.title,
        description: description ?? this.description,
        category: category ?? this.category,
        dueDate: dueDate ?? this.dueDate,
        createdAt: createdAt ?? this.createdAt,
        status: status ?? this.status,
        );
    }
    
}
