import 'package:get/get.dart';

class TablePlanController extends GetxController {
  var isloading = false;

    var selectedIndex = (-1).obs;

  void selectIndex(int index) {
    if (selectedIndex.value == index) {
      selectedIndex.value = -1; // Deselect if the same index is tapped again
    } else {
      selectedIndex.value = index;
    }
  }
}
