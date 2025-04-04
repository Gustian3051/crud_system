import 'package:flutter/material.dart';
import 'package:crud_system/helpers/database_helper.dart';
import 'package:crud_system/screens/home_screen.dart';
import 'package:crud_system/services/notification_service.dart';
import 'package:crud_system/services/task_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbHelper = DatabaseHelper();
  final notificationService = NotificationService();
  await notificationService.initialize();

  final taskService = TaskService(
    dbHelper: dbHelper,
    notificationService: notificationService,
  );

  // Cek deadline setiap kali app dibuka
  await taskService.checkDeadlineTasks();

  runApp(MyApp(taskService: taskService));
}

class MyApp extends StatelessWidget {
  final TaskService taskService;

  const MyApp({super.key, required this.taskService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(taskService: taskService),
    );
  }
}
