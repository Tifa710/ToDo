import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo/core/utils/app_styles.dart';
import 'package:todo/core/utils/colors_manager.dart';
import 'package:todo/core/utils/date_utils.dart';
import 'package:todo/database/todo_dm.dart';
import 'package:todo/database/user_DM.dart';

class TaskEdit extends StatefulWidget {
  TaskEdit({super.key});

  @override
  State<TaskEdit> createState() => _TaskEditState();
}
class _TaskEditState extends State<TaskEdit> {
  DateTime selectedDate = DateTime.now();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  GlobalKey<FormState> formEditKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    TodoDM todoDM = args['todoDM'] as TodoDM;
    var taskTabStateKey = args['taskTabStateKey'];
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      titleController.text = todoDM.title;
      descriptionController.text = todoDM.description;
      selectedDate = todoDM.dateTime;
    }
    return Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: const Text('ToDo List'),
        ),
        body: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  color: ColorsManager.blue,
                ),
                Container(
                  margin: REdgeInsets.only(top: 50),
                  padding: EdgeInsets.all(20),
                  height: 500.h,
                  width: 350.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Form(
                    key: formEditKey,
                    child: Column(
                      children: [
                        Text(
                          'Edit Task',
                          textAlign: TextAlign.center,
                          style: AppLightStyles.bottomSheetTitle,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        TextFormField(
                          validator: (input) {
                            if (input == null || input.trim().isEmpty) {
                              return 'Plz, enter task title';
                            }
                            return null;
                          },
                          controller: titleController,
                          decoration: InputDecoration(
                            hintText: 'This is title',
                            hintStyle: AppLightStyles.hintStyle,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        TextFormField(
                          validator: (input) {
                            if (input == null || input.trim().isEmpty) {
                              return 'Plz, enter task description';
                            }
                            return null;
                          },
                          controller: descriptionController,
                          decoration: InputDecoration(
                              hintText: 'Task details',
                              hintStyle: AppLightStyles.hintStyle),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Text(
                          'Select date',
                          style: AppLightStyles.dateLabel,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        InkWell(
                            onTap: () {
                              showTaskDatePicker();
                            },
                            child: Text(
                              selectedDate.toFormattedDate,
                              textAlign: TextAlign.center,
                              style: AppLightStyles.dateStyle,
                            )),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            todoDM.title = titleController.text;
                            todoDM.description = descriptionController.text;
                            todoDM.dateTime = selectedDate;
                            updateTaskToFireStore(todoDM);
                            taskTabStateKey.currentState
                                ?.getToDoFromFirestore();
                          },
                          child: const Text('Save Changes'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
  void showTaskDatePicker() async {
    selectedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        ) ??
        selectedDate;
  }
  void updateTaskToFireStore(TodoDM todoDM) async {
    if (!formEditKey.currentState!.validate()) return;
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection(UserDM.collectionName)
        .doc(UserDM.currentUser!.id)
        .collection(TodoDM.collectionName);
    DocumentReference todoDoc =
        collectionReference.doc(todoDM.id);
    await todoDoc.update(todoDM.toFireStore()).then((value) {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }
}
