import 'package:flutter/material.dart';
import 'package:todo/presetation/screens/home/tabs/settings_tab/settings_tab.dart';
import 'package:todo/presetation/screens/home/tabs/tasks_tab/tasks_tab.dart';
import 'package:todo/presetation/screens/home/task_bottom_sheet/task_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  GlobalKey<TasksTabState> taskTabKey = GlobalKey();
  List<Widget> tabs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabs = [
      TasksTab(
        key: taskTabKey,
      ),
      const SettingsTab(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text('ToDo List'),
      ),
      floatingActionButton: buildFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: buildBottomNavBar(),
      body: tabs[currentIndex],
    );
  }

  buildBottomNavBar() => BottomAppBar(
        notchMargin: 8,
        child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Tasks',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ]),
      );

  void onTapped(int index) {
    currentIndex = index;
    setState(() {});
  }

  Widget buildFab() => FloatingActionButton(
        onPressed: () async {
          await TaskBottomSheet.show(context);
          taskTabKey.currentState?.getToDoFromFirestore();
        },
        child: const Icon(
          Icons.add,
        ),
      );
}
