import 'package:flutter/material.dart';
import 'package:musicapp/constant/color.dart';

class ThemeProvider extends ChangeNotifier {
  Color background = const Color.fromARGB(255, 204, 204, 204);
  Color mainText = const Color.fromARGB(255, 17, 17, 17);
  Color mediumText = const Color.fromARGB(255, 59, 58, 58);
  bool isDarkMode = true;
  change() {
    if (isDarkMode) {
      background = mainDarkModeBackground;
      mainText = mainDarkModeTextColor;
      mediumText = mediumDarkModeTextColor;
    } else {
      background = const Color.fromARGB(255, 204, 204, 204);
      mainText = const Color.fromARGB(255, 17, 17, 17);
      mediumText = const Color.fromARGB(255, 59, 58, 58);
    }

    isDarkMode = !isDarkMode;

    notifyListeners();
  }
}
