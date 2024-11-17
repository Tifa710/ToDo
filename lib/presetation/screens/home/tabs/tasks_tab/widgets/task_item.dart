import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/core/utils/app_styles.dart';
import 'package:todo/core/utils/colors_manager.dart';
import 'package:todo/core/utils/date_utils.dart';
import 'package:todo/core/utils/routes_manager.dart';
import 'package:todo/database/todo_dm.dart';
import 'package:todo/database/user_DM.dart';

class TaskItem extends StatelessWidget {
  TaskItem(
      {super.key,
      required this.todo,
      required this.onDeletedTask,
      required this.taskTabStateKey});

  var taskTabStateKey;
  TodoDM todo;
  Function onDeletedTask;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).colorScheme.onPrimary),
      child: Slidable(
        startActionPane: ActionPane(motion: const DrawerMotion(), children: [
          SlidableAction(
            flex: 2,
            onPressed: (context) {
              deleteTodoFromFireStore();
              onDeletedTask();
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
            autoClose: true,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15), topLeft: Radius.circular(15)),
          ),
          SlidableAction(
            flex: 2,
            onPressed: (context) {
              Navigator.pushNamed(context, RoutesManager.task_edit, arguments: {
                'todoDM': todo,
                'taskTabStateKey': taskTabStateKey
              });
            },
            backgroundColor: ColorsManager.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
            autoClose: true,
          ),
        ]),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Container(
                height: 62,
                width: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: todo.isDone
                      ? const Color(0xff61E757)
                      : Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(
                width: 7,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(todo.title,
                      style: todo.isDone
                          ? AppLightStyles.tasksTitle
                              ?.copyWith(color: const Color(0xff61E757))
                          : AppLightStyles.tasksTitle),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(todo.description, style: AppLightStyles.taskDesc),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    todo.dateTime.toFormattedDate,
                    style: AppLightStyles.taskDate,
                  )
                ],
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  updateTaskIsDone();
                  taskTabStateKey.currentState?.getToDoFromFirestore();
                },
                child: todo.isDone
                    ? Text(
                        'Done!',
                        style: AppLightStyles.tasksTitle
                            ?.copyWith(color: const Color(0xff61E757)),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void deleteTodoFromFireStore() async {
    CollectionReference todoCollection = FirebaseFirestore.instance
        .collection(UserDM.collectionName)
        .doc(UserDM.currentUser!.id)
        .collection(TodoDM.collectionName);
    DocumentReference docRef = todoCollection.doc(todo.id);
    await docRef.delete();
  }

  void updateTaskIsDone() async {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection(UserDM.collectionName)
        .doc(UserDM.currentUser!.id)
        .collection(TodoDM.collectionName);
    DocumentReference todoDoc =
        collectionReference.doc(todo.id);
    await todoDoc.update({'isDone': !todo.isDone});
  }
}
