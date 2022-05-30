import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';

import 'package:soknoy_interview/screens/department/department_screen.dart';
import 'package:soknoy_interview/screens/report/student_score.dart';
import 'package:soknoy_interview/screens/student/student_screen.dart';
import 'package:soknoy_interview/screens/subjects/subject_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FluentApp(
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return NavigationView(
      pane: NavigationPane(
          selected: selectedPageIndex,
          onChanged: (pageIndex) {
            setState(() {
              selectedPageIndex = pageIndex;
            });
          },
          items: [
            PaneItem(
              icon: Icon(Icons.person),
              title: Text("Student"),
            ),
            PaneItem(
                icon: Icon(Icons.class_rounded), title: Text("Department")),
            PaneItem(icon: Icon(Icons.subject), title: Text("Subjects")),
            PaneItem(icon: Icon(Icons.score), title: Text("Student Score")),
          ]),
      content: NavigationBody(
          animationCurve: Curves.easeInOut,
          index: selectedPageIndex,
          children: [
            StudentScreen(),
            DepartmentScreen(),
            SubjectScreen(),
            StudentScore()
          ]),
    );
  }
}
