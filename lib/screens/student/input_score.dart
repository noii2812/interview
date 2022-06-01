import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soknoy_interview/model/student_model.dart';
import 'package:soknoy_interview/model/subject_model.dart';
import 'package:soknoy_interview/utils/crud.dart';

import 'package:soknoy_interview/widget/customer_textField.dart';

class InputScore extends StatefulWidget {
  final StudentModel? studentModel;
  const InputScore({Key? key, this.studentModel}) : super(key: key);

  @override
  State<InputScore> createState() => _InputScoreState();
}

class _InputScoreState extends State<InputScore> {
  TextEditingController studentName = TextEditingController();
  TextEditingController className = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController score = TextEditingController();

  String? selectedGender;
  String? selectedStudentId;
  String? selectedSubjectId;

  List<SubjectModel> subjects = <SubjectModel>[];
  List<TextEditingController> _subjectControllers = <TextEditingController>[];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.studentModel != null) {
      setState(() {
        selectedStudentId = widget.studentModel!.documentReference.id;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildInputScoreAppBar(context),
      body: widget.studentModel == null
          ? Container()
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: size.width * 0.3,
                  child: Form(
                    key: _formKey,
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context)
                          .copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 50,
                              ),
                              buildStudentNameTextField(),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Subjects",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              StreamBuilder<QuerySnapshot>(
                                  stream: CRUD.streamData("subject"),
                                  builder: ((context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container();
                                    }
                                    subjects = List.from(snapshot.data!.docs
                                        .map((e) => SubjectModel.from(e)));
                                    return Column(
                                      children: [
                                        buildScoreTextInputGridView(),
                                        buildSubmitButton(size, context)
                                      ],
                                    );
                                  })),
                              const SizedBox(
                                height: 20,
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  AppBar buildInputScoreAppBar(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Input Score",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context)));
  }

  GridView buildScoreTextInputGridView() {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 2.5, crossAxisSpacing: 10),
        shrinkWrap: true,
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          int inputedScoreSubject = widget.studentModel!.subjects.length > 0
              ? widget.studentModel!.subjects
                  .where((element) =>
                      element.subjectId == subjects[index].documentReference.id)
                  .length
              : 0;
          _subjectControllers.add(new TextEditingController(
              text: inputedScoreSubject > 0
                  ? widget.studentModel!.subjects
                      .firstWhere((element) =>
                          element.subjectId ==
                          subjects[index].documentReference.id)
                      .score
                      .toString()
                  : ""));

          return buildScoreTextInputTIle(index);
        });
  }

  buildScoreTextInputTIle(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 5,
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          validator: (String? value) {
            if ((value!.isNotEmpty) && num.parse(value) < 0 ||
                num.parse(value) > subjects[index].score) {
              return "invalid score";
            }
            return null;
          },
          controller: _subjectControllers[index],
          decoration: InputDecoration(
              suffixIcon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("/" + subjects[index].score.toString(),
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              labelText: subjects[index].name,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(4))),
          onChanged: (val) {},
        ),
        const SizedBox(
          height: 10,
        )
      ],
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

  buildStudentDropdown() {
    return StreamBuilder<QuerySnapshot>(
        stream: CRUD.streamData("student"),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return DropdownButtonFormField<String>(
              value: selectedStudentId,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              hint: const Text("Choose Student"),
              items: List.generate(
                  snapshot.data!.docs.length,
                  (index) => DropdownMenuItem<String>(
                        child: Text(snapshot.data!.docs[index]['name']),
                        value: snapshot.data!.docs[index].id,
                      )),
              onChanged: (val) {
                setState(() {
                  selectedStudentId = val;
                });
              });
        });
  }

  buildStudentNameTextField() {
    if (widget.studentModel != null) {
      studentName.text = widget.studentModel!.studentName;
      selectedStudentId = widget.studentModel!.documentReference.id;
    }
    return CustomTextField(
      readOnly: true,
      controller: studentName,
      hintText: "StudentName",
    );
  }

  buildSubjectDropdown() {
    return StreamBuilder<QuerySnapshot>(
        stream: CRUD.streamData("subject"),
        builder: (context, snapshot) {
          print(snapshot.data?.docs.length);
          if (!snapshot.hasData) {
            return Container();
          }
          return DropdownButtonFormField<String>(
              value: selectedStudentId,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              hint: const Text("Choose Subject"),
              items: List.generate(
                  snapshot.data!.docs.length,
                  (index) => DropdownMenuItem<String>(
                        child: Text(snapshot.data!.docs[index]['name']),
                        value: snapshot.data!.docs[index].id,
                      )),
              onChanged: (val) {
                setState(() {
                  selectedStudentId = val;
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
          height: 55,
          child: IconButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                List lst = [];
                for (int i = 0; i < subjects.length; i++) {
                  if (_subjectControllers[i].text.isNotEmpty) {
                    lst.add(
                      {
                        "subjectId": subjects[i].documentReference.id,
                        "score": num.parse(_subjectControllers[i].text)
                      },
                    );
                  }
                }
                var body = {"subjects": lst};
                CRUD.updateDoc("student", selectedStudentId, body);
                Navigator.pop(context);
              }
            },
            icon: Text(
              "Submit",
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
            return null;
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
