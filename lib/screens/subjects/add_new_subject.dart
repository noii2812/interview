import 'package:flutter/material.dart';
import 'package:soknoy_interview/model/subject_model.dart';
import 'package:soknoy_interview/utils/crud.dart';
import 'package:soknoy_interview/widget/customer_textField.dart';

class AddewSubject extends StatefulWidget {
  final SubjectModel? subject;
  const AddewSubject({Key? key, this.subject}) : super(key: key);

  @override
  State<AddewSubject> createState() => _AddewSubjectState();
}

class _AddewSubjectState extends State<AddewSubject> {
  final _formKey = GlobalKey<ScaffoldState>();

  TextEditingController subjectName = TextEditingController();
  TextEditingController score = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            widget.subject == null ? "Add New Subject" : "Edit Subject",
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
                      controller: subjectName, hintText: "SubjectName Name"),
                  CustomTextField(controller: score, hintText: "Score"),
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
    var body = {"name": subjectName.text, "score": double.parse(score.text)};
    await CRUD.addDoc("subject", body).then((value) {
      if (value != null) Navigator.pop(context);
    });
  }

  handleEditNewDepartment(SubjectModel subjectModel) async {
    var body = {"name": subjectName.text, "score": double.parse(score.text)};
    await CRUD
        .updateDoc("subject", subjectModel.documentReference.id, body)
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
            onPressed: () => widget.subject == null
                ? handleAddNewDepartment()
                : handleEditNewDepartment(widget.subject!),
            icon: Text(
              widget.subject == null ? "Add  Subject" : "Edit Subject",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
