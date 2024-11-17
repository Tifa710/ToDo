import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/core/utils/app_styles.dart';
import 'package:todo/core/utils/date_utils.dart';
import 'package:todo/database/todo_dm.dart';
import 'package:todo/database/user_DM.dart';

class TaskBottomSheet extends StatefulWidget {
  const TaskBottomSheet({super.key});

  @override
  State<TaskBottomSheet> createState() => _TaskBottomSheetState();

  // static Widget show() => TaskBottomSheet();
  static Future show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: const TaskBottomSheet(),
      ),
    );
  }
}

class _TaskBottomSheetState extends State<TaskBottomSheet> {
  DateTime selectedDate = DateTime.now();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  GlobalKey<FormState> formBtmKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      height: MediaQuery.of(context).size.height * 0.55,
      child: Form(
        key: formBtmKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add new task',
              textAlign: TextAlign.center,
              style: AppLightStyles.bottomSheetTitle,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            TextFormField(
              validator: (input) {
                if (input == null || input.trim().isEmpty) {
                  return 'Plz, enter task title';
                }
                return null;
              },
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Enter your task title',
                hintStyle: AppLightStyles.hintStyle,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            TextFormField(
              validator: (input) {
                if (input == null || input.trim().isEmpty) {
                  return 'Plz, enter task description';
                }
                if (input.length < 6) {
                  return 'Sorry, description should be at least 6 characters';
                }
                return null;
              },
              controller: descriptionController,
              decoration: InputDecoration(
                  hintText: 'Enter your task description',
                  hintStyle: AppLightStyles.hintStyle),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              'Select date',
              style: AppLightStyles.dateLabel,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
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
                  addTaskToFireStore();
                },
                child: const Text('Add task'))
          ],
        ),
      ),
    );
  }

  void showTaskDatePicker() async {
    selectedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        ) ??
        selectedDate;

    setState(() {});
  }

  void addTaskToFireStore() {
    if (!formBtmKey.currentState!.validate()) return;
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection(UserDM.collectionName)
        .doc(UserDM.currentUser!.id)
        .collection(TodoDM.collectionName);
    DocumentReference newDoc =
        collectionReference.doc(); // create new doc and generate it

    TodoDM todo = TodoDM(
        id: newDoc.id,
        title: titleController.text,
        description: descriptionController.text,
        dateTime: selectedDate.copyWith(
            second: 0, millisecond: 0, minute: 0, microsecond: 0, hour: 0),
        isDone: false);

    newDoc
        .set(todo.toFireStore())
        .then(
          (_) {
            if (mounted) {
              Navigator.pop(context);
            }
          },
        )
        .onError(
          (error, stackTrace) {},
        )
        .timeout(
          const Duration(milliseconds: 500),
          onTimeout: () {
            if (mounted) {
              //Navigator.pop(context);
            }
          },
        );
  }
}
// Provider
// widget life cycle
// const final
// key
