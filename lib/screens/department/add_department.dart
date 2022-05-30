import 'package:flutter/material.dart';
import 'package:soknoy_interview/model/department_model.dart';
import 'package:soknoy_interview/utils/crud.dart';
import 'package:soknoy_interview/widget/customer_textField.dart';

class AddDepartment extends StatefulWidget {
  final DepartmentModel? department;
  const AddDepartment({Key? key, this.department}) : super(key: key);

  @override
  State<AddDepartment> createState() => _AddDepartmentState();
}

class _AddDepartmentState extends State<AddDepartment> {
  TextEditingController departmentName = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            widget.department == null ? "Add New Student" : "Edit Student",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () => Navigator.pop(context))),
      body: Center(
        child: SizedBox(
          width: size.width * 0.3,
          child: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 80,
                  ),
                  CustomTextField(
                      controller: departmentName, hintText: "Department Name"),
                  const SizedBox(
                    height: 10,
                  ),
                  // buildTextField("DOB", controller: dob),
                  buildSubmitButton(size, context)
                ]),
          ),
        ),
      ),
    );
  }

  handleAddNewDepartment() async {
    var body = {"name": departmentName.text};
    await CRUD.addDoc("department", body).then((value) {
      if (value != null) Navigator.pop(context);
    });
  }

  handleEditNewDepartment(DepartmentModel departmentModel) async {
    var body = {"name": departmentName.text};
    await CRUD
        .updateDoc("department", departmentModel.documentReference.id, body)
        .then((value) {
      Navigator.pop(context);
    });
  }

  buildSubmitButton(Size size, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          color: Colors.black,
          width: 150,
          height: 55,
          child: IconButton(
            onPressed: () => widget.department == null
                ? handleAddNewDepartment()
                : handleEditNewDepartment(widget.department!),
            icon: Text(
              widget.department == null ? "Add  Department" : "Edit Department",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
