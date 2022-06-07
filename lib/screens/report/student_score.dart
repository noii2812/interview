import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:soknoy_interview/model/student_model.dart';
import 'package:soknoy_interview/screens/student/input_score.dart';
import 'package:soknoy_interview/utils/crud.dart';

class StudentScore extends StatefulWidget {
  const StudentScore({Key? key}) : super(key: key);

  @override
  State<StudentScore> createState() => _StudentScoreState();
}

class _StudentScoreState extends State<StudentScore> {
  List<String> tableHeaders = <String>[
    "No",
    "Student Name",
    "Department Name",
    "Average",
    "Grade",
    "Input Score"
  ];
  List<DataColumn> dataColumns = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String? selectedDepartmentId;
  StudentModel? selectedStudent;
  @override
  void initState() {
    dataColumns = List.generate(
        tableHeaders.length,
        (index) => DataColumn(
                label: Expanded(
              child: Text(
                tableHeaders[index],
                textAlign: TextAlign.center,
              ),
            )));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      onEndDrawerChanged: (isOpenned) {
        if (!isOpenned) {
          setState(() {
            selectedStudent = null;
          });
        }
      },
      endDrawer: buildEndDrawerStudentScoreScreen(size),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            Container(
              width: size.width * .7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Choose Department"),
                  SizedBox(
                    height: 10,
                  ),
                  buildDepartmentDropdown()
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: size.width * 0.7,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: selectedDepartmentId != null
                      ? CRUD.streamDataByField(
                          "student", "departmentId", selectedDepartmentId!)
                      : CRUD.streamData("student"),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text("No Data"),
                      );
                    }
                    List<StudentModel> students = List<StudentModel>.from(
                            snapshot.data!.docs
                                .map((e) => StudentModel.from(e)))
                        .where((element) => !element.isDisabled)
                        .toList();
                    return DataTable(
                        sortColumnIndex: 4,
                        sortAscending: true,
                        headingTextStyle:
                            const TextStyle(fontWeight: FontWeight.bold),
                        border: TableBorder.all(color: Colors.grey),
                        columns: [...dataColumns],
                        rows: List.generate(
                            students.length,
                            (index) => DataRow(
                                cells: List.generate(
                                    tableHeaders.length,
                                    (i) => i == 5
                                        ? buildInputScoreDataCell(
                                            students, index)
                                        : getDataCellByIndex(
                                            index, i, students)))));
                  }),
            ),
          ],
        ),
      ),
    );
  }

  DataCell buildInputScoreDataCell(List<StudentModel> students, int index) {
    return DataCell(Center(
      child: IconButton(
        icon: Icon(Icons.edit_note_sharp),
        onPressed: () {
          setState(() {
            selectedStudent = students[index];
          });
          _scaffoldKey.currentState!.openEndDrawer();
        },
      ),
    ));
  }

  Container buildEndDrawerStudentScoreScreen(Size size) {
    return Container(
        width: size.width * 0.4,
        child: InputScore(
          studentModel: selectedStudent,
        ));
  }

  buildDepartmentDropdown() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("department")
            .orderBy("name")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          return Container(
            width: 200,
            height: 55,
            child: DropdownButtonFormField<String>(
                value: selectedDepartmentId,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                hint: const Text("Department"),
                items: List.generate(
                    snapshot.data!.docs.length + 1,
                    (index) => index == 0
                        ? DropdownMenuItem<String>(
                            child: Text('ALL'),
                            value: "All",
                          )
                        : DropdownMenuItem<String>(
                            child: Text(snapshot.data!.docs[index - 1]['name']),
                            value: snapshot.data!.docs[index - 1].id,
                          )),
                onChanged: (val) {
                  if (val == "All") {
                    setState(() {
                      selectedDepartmentId = null;
                    });
                  } else {
                    setState(() {
                      selectedDepartmentId = val;
                    });
                  }
                }),
          );
        });
  }

  String getTableDataByHeader(rowIndex, headerIndex, students) {
    switch (headerIndex) {
      case 0:
        return "${rowIndex + 1}";
      case 1:
        return students[rowIndex].studentName;
      case 2:
        return students[rowIndex].departmentId;
      case 3:
        return students[rowIndex].email;
      case 4:
        return students[rowIndex].gender;
      case 5:
        return students[rowIndex].dob;
      default:
        return "";
    }
  }

  getDataCellByIndex(rowIndex, headerIndex, List<StudentModel> students) {
    switch (headerIndex) {
      case 2:
        return buildDeparmentDataCell(students, rowIndex);
      case 3:
        return buildScoreDataCell(students, rowIndex);
      case 4:
        return buildGradeDataCell(students, rowIndex);
      default:
        return DataCell(Center(
          child: Text(getTableDataByHeader(rowIndex, headerIndex, students)),
        ));
    }
  }

  DataCell buildDeparmentDataCell(List<StudentModel> students, rowIndex) {
    return DataCell(Center(
      child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("department")
              .doc(students[rowIndex].departmentId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            return Text(snapshot.data!['name']);
          }),
    ));
  }

  buildScoreDataCell(List<StudentModel> students, rowIndex) {
    return DataCell(Center(
      child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("student")
              .doc(students[rowIndex].documentReference.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            num totalStudentScore = snapshot.data!['subjects'].length > 0
                ? snapshot.data!['subjects'].fold(0, (a, b) => a + b['score'])
                : 0;
            return StreamBuilder<QuerySnapshot>(
                stream: CRUD.streamData('subject'),
                builder: (context, subjectSnapshot) {
                  if (!subjectSnapshot.hasData) return Container();
                  num totalSubjectScore = subjectSnapshot.data!.docs
                      .fold(0, (a, b) => a + b['score']);
                  num avg = (totalStudentScore / totalSubjectScore) * 100;
                  return Text(avg.toStringAsFixed(2));
                });
          }),
    ));
  }

  DataCell buildGradeDataCell(List<StudentModel> students, rowIndex) {
    return DataCell(Center(
      child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("student")
              .doc(students[rowIndex].documentReference.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            num totalScore = snapshot.data!['subjects'].length > 0
                ? snapshot.data!['subjects'].fold(0, (a, b) => a + b['score'])
                : 0;

            return StreamBuilder<QuerySnapshot>(
                stream: CRUD.streamData('subject'),
                builder: (context, subjectSnapshot) {
                  if (!subjectSnapshot.hasData) return Container();
                  num avg = totalScore / subjectSnapshot.data!.docs.length;
                  return Text(getGrade(avg));
                });
          }),
    ));
  }
}

getGrade(num totalScore) {
  if (totalScore > 95 && totalScore <= 100) {
    return "A";
  } else if (totalScore >= 90 && totalScore <= 95) {
    return "B";
  } else if (totalScore >= 80 && totalScore < 90) {
    return "C";
  } else if (totalScore >= 70 && totalScore < 80) {
    return "D";
  } else if (totalScore >= 60 && totalScore < 70) {
    return "E";
  } else {
    return "F";
  }
}
