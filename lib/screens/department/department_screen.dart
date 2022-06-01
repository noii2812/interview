import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:soknoy_interview/model/department_model.dart';
import 'package:soknoy_interview/screens/department/add_department.dart';
import 'package:soknoy_interview/utils/crud.dart';

class DepartmentScreen extends StatefulWidget {
  const DepartmentScreen({Key? key}) : super(key: key);

  @override
  State<DepartmentScreen> createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  List<String> tableHeaders = <String>["No", "Department Name", "Options"];

  List<DataColumn> dataColumns = [];
  DepartmentModel? selectedDepartment;

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
          child: AddDepartment(department: selectedDepartment)),
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
                  stream: CRUD.streamData("department"),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text("No Data"),
                      );
                    }
                    List<DepartmentModel> students = List<DepartmentModel>.from(
                        snapshot.data!.docs
                            .map((e) => DepartmentModel.from(e))).toList()
                      ..sort((a, b) => a.name.compareTo(b.name));
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
                                    (i) => i == 2
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

  buildAddNewDepartmentButton(size) {
    return ScreeTitleWidget(scaffoldKey: _scaffoldKey);
  }

  DataCell buildOptionsButtons(DepartmentModel student) {
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
      rowIndex, headerIndex, List<DepartmentModel> department) {
    switch (headerIndex) {
      case 0:
        return "${rowIndex + 1}";
      case 1:
        return department[rowIndex].name;
      default:
        return "";
    }
  }
}

class ScreeTitleWidget extends StatelessWidget {
  const ScreeTitleWidget({
    Key? key,
    required GlobalKey<ScaffoldState> scaffoldKey,
  })  : _scaffoldKey = scaffoldKey,
        super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      // color: Colors.red,
      width: size.width * 0.7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                "Department",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
            ],
          ),
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
                "Add New Department",
                style: TextStyle(color: Colors.white),
              ),
              // style: ButtonStyle(backgroundColor: ButtonState.all(Colors.blue)),
            ),
          )
        ],
      ),
    );
  }
}
