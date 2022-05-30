import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:soknoy_interview/model/department_model.dart';
import 'package:soknoy_interview/model/subject_model.dart';
import 'package:soknoy_interview/screens/department/add_department.dart';
import 'package:soknoy_interview/screens/subjects/add_new_subject.dart';
import 'package:soknoy_interview/utils/crud.dart';

class SubjectScreen extends StatefulWidget {
  const SubjectScreen({Key? key}) : super(key: key);

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  List<String> tableHeaders = <String>[
    "No",
    "Subject",
    "Score",
  ];

  List<DataColumn> dataColumns = [];
  SubjectModel? selectedSubject;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
      endDrawer: Container(
          width: size.width * 0.4,
          child: AddewSubject(subject: selectedSubject)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 90,
            ),
            buildAddNewDepartmentButton(size),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: size.width * 0.7,
              child: StreamBuilder<QuerySnapshot>(
                  stream: CRUD.streamData("subject"),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text("No Data"),
                      );
                    }
                    List<SubjectModel> subjects = List<SubjectModel>.from(
                        snapshot.data!.docs
                            .map((e) => SubjectModel.from(e))).toList();
                    return DataTable(
                        headingTextStyle:
                            const TextStyle(fontWeight: FontWeight.bold),
                        border: TableBorder.all(color: Colors.grey),
                        columns: [...dataColumns],
                        rows: List.generate(
                            subjects.length,
                            (index) => DataRow(
                                cells: List.generate(
                                    tableHeaders.length,
                                    (i) => DataCell(Center(
                                          child: Text(getTableDataByHeader(
                                              index, i, subjects)),
                                        ))))));
                  }),
            ),
          ],
        ),
      ),
    );
  }

  buildAddNewDepartmentButton(size) {
    return Container(
      // color: Colors.red,
      width: size.width * 0.7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
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
              onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
              child: const Text(
                "Add New Subject",
                style: TextStyle(color: Colors.white),
              ),
              // style: ButtonStyle(backgroundColor: ButtonState.all(Colors.blue)),
            ),
          )
        ],
      ),
    );
  }

  DataCell buildOptionsButtons(SubjectModel subjectModel) {
    return DataCell(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
            onPressed: () {},
            child: Icon(
              Icons.delete,
              color: Colors.red.withOpacity(.8),
            )),
        TextButton(onPressed: () {}, child: const Icon(Icons.edit)),
      ],
    ));
  }

  String getTableDataByHeader(
      rowIndex, headerIndex, List<SubjectModel> subjects) {
    switch (headerIndex) {
      case 0:
        return "${rowIndex + 1}";
      case 1:
        return subjects[rowIndex].name;
      case 2:
        return subjects[rowIndex].score.toString();
      default:
        return "";
    }
  }
}
