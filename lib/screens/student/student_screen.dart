import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:soknoy_interview/model/student_model.dart';
import 'package:soknoy_interview/screens/student/add_new_student.dart';
import 'package:soknoy_interview/utils/crud.dart';
import 'dart:js' as js;

class StudentScreen extends StatefulWidget {
  const StudentScreen({Key? key}) : super(key: key);

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen>
    with TickerProviderStateMixin {
  List<String> tableHeaders = <String>[
    "No",
    "Student Name",
    "Class Name",
    "Email Address",
    "Gender",
    "Date Of Birth",
    "Options"
  ];
  List<DataColumn> dataColumns = [];

  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
      onEndDrawerChanged: (isOpened) {
        if (!isOpened) {
          setState(() {
            selectedStudent = null;
          });
        }
      },
      key: _scaffoldKey,
      endDrawer: Container(
          width: size.width * 0.4,
          child: AddNewStudent(
            studentModel: selectedStudent,
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 90,
            ),
            buildAddNewStudentButton(size),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: size.width * 0.7,
              child: StreamBuilder<QuerySnapshot>(
                  stream: CRUD.streamData("student"),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text("No Data"),
                      );
                    }
                    List<StudentModel> students = List<StudentModel>.from(
                        snapshot.data!.docs
                            .map((e) => StudentModel.from(e))).toList();
                    return DataTable(
                        headingTextStyle:
                            const TextStyle(fontWeight: FontWeight.bold),
                        border: TableBorder.all(color: Colors.grey),
                        columns: [...dataColumns],
                        rows: List.generate(
                            students.length,
                            (index) => DataRow(
                                cells: List.generate(
                                    tableHeaders.length,
                                    (i) => i == 6
                                        ? buildOptionsButtons(students[index])
                                        : DataCell(Center(
                                            child: Text(getTableDataByHeader(
                                                index, i, students)),
                                          ))))));
                  }),
            ),
          ],
        ),
      ),
    );
  }

  showAddStudentButtomSheet({StudentModel? studentModel}) {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  handleDeleteStudent(StudentModel studentModel) {
    CRUD.deleteDoc("student", studentModel.documentReference.id).then((value) {
      js.context.callMethod(
          "showAlert", ["Student ${studentModel.studentName} is deleted"]);
    });
  }

  DataCell buildOptionsButtons(StudentModel student) {
    return DataCell(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
            onPressed: () => handleDeleteStudent(student),
            child: Icon(
              Icons.delete,
              color: Colors.red.withOpacity(.8),
            )),
        TextButton(
            onPressed: () {
              setState(() {});
              selectedStudent = student;
              showAddStudentButtomSheet(studentModel: student);
            },
            child: const Icon(Icons.edit)),
      ],
    ));
  }

  buildAddNewStudentButton(size) {
    return Container(
      // color: Colors.red,
      width: size.width * 0.7,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Students",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // buildButton(),
              // SizedBox(
              //   width: 20,
              // ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Color(0xff000000),
                ),
                width: 150,
                height: 50,
                child: TextButton(
                  // style: B,
                  style: ButtonStyle(),
                  onPressed: () => showAddStudentButtomSheet(),
                  child: const Text(
                    "Add New Student",
                    style: TextStyle(color: Colors.white),
                  ),
                  // style: ButtonStyle(backgroundColor: ButtonState.all(Colors.blue)),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Container buildButton(String title, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Color(0xff000000),
      ),
      width: 150,
      height: 50,
      child: TextButton(
        // style: B,
        style: ButtonStyle(),
        onPressed: () => showAddStudentButtomSheet(),
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        // style: ButtonStyle(backgroundColor: ButtonState.all(Colors.blue)),
      ),
    );
  }

  String getTableDataByHeader(rowIndex, headerIndex, students) {
    switch (headerIndex) {
      case 0:
        return "${rowIndex + 1}";
      case 1:
        return students[rowIndex].studentName;
      case 2:
        return students[rowIndex].className;
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
}
