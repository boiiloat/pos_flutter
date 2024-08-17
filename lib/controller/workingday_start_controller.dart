import 'package:get/get.dart';

class WorkingDayStartController extends GetxController{
   // This map will track which container is expanded.
  var expandedContainers = <int, bool>{}.obs;
  var selectedIndex = Rx<int?>(null);

  // Function to toggle a container's expanded state.
  void toggleContainer(int index) {
    if (expandedContainers[index] == true) {
      expandedContainers[index] = false;
    } else {
      // Collapse all other containers
      expandedContainers.forEach((key, value) {
        expandedContainers[key] = false;
      });
      // Expand the clicked container
      expandedContainers[index] = true;
    }
  }
  // Function to set the selected container index.
  void selectContainer(int index) {
    selectedIndex.value = selectedIndex.value == index ? null : index;
  }
  
}