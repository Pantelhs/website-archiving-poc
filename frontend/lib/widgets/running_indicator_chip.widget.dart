import 'package:flutter/material.dart';

class RunningIndicatorChip extends StatelessWidget {
  bool isRunning;
  Function refreshFunction;
  String activeText;
  String stoppedText;
  RunningIndicatorChip(
      {Key? key,
      required this.isRunning,
      required this.refreshFunction,
      this.activeText = 'Running',
      this.stoppedText = 'Finished'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData mode = Theme.of(context);
    bool isDarkMode = mode.brightness == Brightness.dark;

    return Chip(
      avatar: CircleAvatar(
        backgroundColor: isRunning
            ? isDarkMode
                ? Colors.green[800]
                : Colors.green
            : Colors.grey,
      ),
      label: Text(isRunning ? activeText : stoppedText),
      deleteIcon: isDarkMode
          ? const Icon(Icons.refresh, color: Colors.black45)
          : const Icon(Icons.refresh, color: Colors.black45),
      deleteButtonTooltipMessage: 'Refresh status',
      onDeleted: () {
        refreshFunction();
      },
      backgroundColor: isRunning
          ? isDarkMode
              ? Colors.green[400]
              : Colors.green[100]
          : isDarkMode
              ? Colors.grey[600]
              : Colors.grey[350],
    );
  }
}
