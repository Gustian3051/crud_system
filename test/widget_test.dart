import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:crud_system/models/task.dart';
import 'helpers/database_helper_test.mocks.dart';

void main() {
  testWidgets('Task List displays task title', (WidgetTester tester) async {
    final mockDbHelper = MockDatabaseHelper();
    final task = Task(id: 1, title: 'Mock Task', isCompleted: false);

    when(mockDbHelper.getTasks()).thenAnswer((_) async => [task]);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FutureBuilder<List<Task>>(
            future: mockDbHelper.getTasks(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final task = snapshot.data![index];
                    return ListTile(
                      title: Text(task.title),
                      trailing: Icon(
                        task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                        color: task.isCompleted ? Colors.green : Colors.grey,
                      ),
                      subtitle: task.deadline != null
                          ? Text('Deadline: ${task.deadline!.toLocal()}')
                          : null,
                    );
                  },
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Mock Task'), findsOneWidget);
  });

  testWidgets('Displays completed task with green check icon', (WidgetTester tester) async {
    final mockDbHelper = MockDatabaseHelper();
    final task = Task(id: 2, title: 'Completed Task', isCompleted: true);

    when(mockDbHelper.getTasks()).thenAnswer((_) async => [task]);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FutureBuilder<List<Task>>(
            future: mockDbHelper.getTasks(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: snapshot.data!.map((task) {
                    return ListTile(
                      title: Text(task.title),
                      trailing: Icon(
                        task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                        color: task.isCompleted ? Colors.green : Colors.grey,
                      ),
                    );
                  }).toList(),
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Completed Task'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });

  testWidgets('Displays deadline if available', (WidgetTester tester) async {
    final mockDbHelper = MockDatabaseHelper();
    final deadline = DateTime.now().add(const Duration(days: 2));
    final task = Task(id: 3, title: 'Task with Deadline', deadline: deadline);

    when(mockDbHelper.getTasks()).thenAnswer((_) async => [task]);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FutureBuilder<List<Task>>(
            future: mockDbHelper.getTasks(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: snapshot.data!.map((task) {
                    return ListTile(
                      title: Text(task.title),
                      subtitle: task.deadline != null
                          ? Text('Deadline: ${task.deadline!.toLocal()}')
                          : null,
                    );
                  }).toList(),
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Task with Deadline'), findsOneWidget);
    expect(find.textContaining('Deadline:'), findsOneWidget);
  });
}
