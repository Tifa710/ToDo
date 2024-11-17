import 'package:flutter/material.dart';
import 'package:todo/core/utils/colors_manager.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  String selectedTheme = 'Light';
  String selectedLang = 'English';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Theme',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            height: 48,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: ColorsManager.white,
                border: Border.all(color: ColorsManager.blue, width: 2)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedTheme,
                  style:
                      const TextStyle(fontSize: 16, color: ColorsManager.blue),
                ),
                DropdownButton<String>(
                  underline: Container(
                    color: Colors.transparent,
                  ),
                  items: <String>['Light', 'Dark'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newTheme) {
                    selectedTheme = newTheme!;
                    setState(() {});
                  },
                )
              ],
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          const Text('Language'),
          const SizedBox(
            height: 8,
          ),
          Container(
            height: 48,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: ColorsManager.white,
                border: Border.all(color: ColorsManager.blue, width: 2)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedLang,
                  style:
                      const TextStyle(fontSize: 16, color: ColorsManager.blue),
                ),
                DropdownButton<String>(
                  elevation: 0,
                  focusColor: Colors.transparent,
                  underline: Container(color: Colors.transparent),
                  iconDisabledColor: Colors.transparent,
                  isDense: false,
                  isExpanded: false,
                  borderRadius: BorderRadius.zero,
                  focusNode: FocusNode(debugLabel: 'HH'),
                  autofocus: false,
                  items: <String>['English', 'العربيه'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newLang) {
                    selectedLang = newLang!;
                    setState(() {});
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
