import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkingDayStartController extends GetxController {
  // Track which container is expanded. The key is the index of the container, and the value is whether it is expanded or not.
  var expandedContainers = <int, bool>{}.obs;

  // Track the selected main container index (Working Day). Initialized to -1, indicating no selection.
  var selectedIndex = (-1).obs;

  // Track the selected sub-container index (Cashier Shift). Initialized to -1, indicating no selection.
  var selectedSubContainerIndex = (-1).obs;

  // Function to toggle a container's expanded state.
  void toggleContainer(int index) {
    if (expandedContainers[index] == true) {
      // If the container is already expanded, collapse it.
      expandedContainers[index] = false;
    } else {
      // Collapse all other containers and expand the selected one.
      expandedContainers.forEach((key, value) {
        expandedContainers[key] = false;
      });
      expandedContainers[index] = true;
    }
  }

  // Method to handle the main container selection (Working Day).
  void selectContainer(int index) {
    selectedIndex.value = index;
    selectedSubContainerIndex.value =
        -1; // Reset sub-container selection when changing main container.
  }

  // Method to handle sub-container selection (Cashier Shift).
  void selectSubContainer(int index) {
    selectedSubContainerIndex.value = index;
    print(
        "Sub-container #$index selected"); // Optional: For debugging or logging purposes.
  }

  var selectedValue = 'Value 1'.obs; // Initial value

  void updateValue(String newValue) {
    selectedValue.value = newValue;
  }

  void onYesPressed() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(7)), // Adjust the border radius if needed
        ),
        child: Container(
          width: 100, // Set the desired width
          height: 400, // Set the desired height
          padding: const EdgeInsets.all(
              16.0), // Optional: Add padding to the content
        ),
      ),
    );
  }
}
