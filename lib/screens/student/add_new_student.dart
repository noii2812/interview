import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soknoy_interview/model/student_model.dart';
import 'package:soknoy_interview/utils/crud.dart';
import 'dart:js' as js;

class AddNewStudent extends StatefulWidget {
  final StudentModel? studentModel;
  const AddNewStudent({Key? key, this.studentModel}) : super(key: key);

  @override
  State<AddNewStudent> createState() => _AddNewStudentState();
}

class _AddNewStudentState extends State<AddNewStudent> {
  TextEditingController studentName = TextEditingController();
  TextEditingController className = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController dob = TextEditingController();
  String? selectedGender;
  String? selectedDepartmentId;

  final _formKey = GlobalKey<FormState>();
  handleAddNewStudent() {
    var body = {
      "name": studentName.text,
      "className": className.text,
      "gender": selectedGender,
      "email": email.text,
      "dob": dob.text,
      "departmentId": selectedDepartmentId,
      "subjects": []
    };
    if (_formKey.currentState!.validate()) {
      CRUD.addDoc("student", body).then((value) {
        if (value != null) Navigator.pop(context);
      });
    }
  }

  handleEditStudent() {
    var body = {
      "name": studentName.text,
      "className": className.text,
      "gender": selectedGender,
      "email": email.text,
      "dob": dob.text,
      "departmentId": selectedDepartmentId
    };
    if (_formKey.currentState!.validate()) {
      CRUD
          .updateDoc("student", widget.studentModel!.documentReference.id, body)
          .then((value) {
        Navigator.pop(context);
        js.context.callMethod("showAlert",
            ["Student ${widget.studentModel!.studentName} is updated"]);
      });
    }
  }

  @override
  void initState() {
    if (widget.studentModel != null) {
      setState(() {
        studentName.text = widget.studentModel!.studentName;
        className.text = widget.studentModel!.className;
        email.text = widget.studentModel!.email;
        gender.text = widget.studentModel!.gender;
        dob.text = widget.studentModel!.dob;
        selectedGender = widget.studentModel!.gender;
        selectedDepartmentId = widget.studentModel!.departmentId;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            widget.studentModel == null ? "Add New Student" : "Edit Student",
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
                  buildTextField("Student Name", controller: studentName),
                  buildTextField("Class Name", controller: className),
                  buildTextField("Email Address", controller: email),
                  buildGenderDropdown(),
                  const SizedBox(
                    height: 10,
                  ),
                  buildDepartmentDropdown(),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      TextFormField(
                        readOnly: true,
                        onTap: () => handleShowDatePicker(),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Required";
                          }
                        },
                        controller: dob,
                        decoration: InputDecoration(
                          hintText: "DOB",
                          border: const OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onChanged: (val) {},
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                  // buildTextField("DOB", controller: dob),
                  buildSubmitButton(size, context)
                ]),
          ),
        ),
      ),
    );
  }

  handleShowDatePicker() async {
    var now = DateTime.now();
    var result = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(now.year - 100),
        lastDate: now);
    if (result != null) {
      setState(() {
        dob.text = DateFormat("yyyy-MM-dd").format(result);
      });
    }
  }

  DropdownButtonFormField<String> buildGenderDropdown() {
    return DropdownButtonFormField<String>(
        value: selectedGender,
        decoration: const InputDecoration(border: OutlineInputBorder()),
        hint: const Text("Gender"),
        items: const [
          DropdownMenuItem(
            value: "Male",
            child: Text("Male"),
          ),
          DropdownMenuItem(
            value: "Female",
            child: Text("Female"),
          )
        ],
        onChanged: (val) {
          setState(() {
            selectedGender = val;
          });
        });
  }

  buildDepartmentDropdown() {
    return StreamBuilder<QuerySnapshot>(
        stream: CRUD.streamData("department"),
        builder: (context, snapshot) {
          print(snapshot.data?.docs.length);
          if (!snapshot.hasData) {
            return Container();
          }
          return DropdownButtonFormField<String>(
              value: selectedDepartmentId,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              hint: const Text("Department"),
              items: List.generate(
                  snapshot.data!.docs.length,
                  (index) => DropdownMenuItem<String>(
                        child: Text(snapshot.data!.docs[index]['name']),
                        value: snapshot.data!.docs[index].id,
                      )),
              onChanged: (val) {
                setState(() {
                  selectedDepartmentId = val;
                });
              });
        });
  }

  buildSubmitButton(Size size, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          color: Colors.black,
          width: 150,
          child: IconButton(
            onPressed: () => widget.studentModel == null
                ? handleAddNewStudent()
                : handleEditStudent(),
            icon: Text(
              widget.studentModel == null ? "Add  Student" : "Edit Student",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  buildTextField(hintText, {TextEditingController? controller}) {
    return Column(
      children: [
        TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return "Required";
            }
          },
          controller: controller,
          decoration: InputDecoration(
              hintText: hintText,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(4))),
          onChanged: (val) {},
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}
