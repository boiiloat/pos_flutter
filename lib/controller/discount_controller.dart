import 'package:get/get.dart';

class DiscountController extends GetxController {
  var isPercentageSelected = true.obs;

  // Method to toggle the discount type
  void selectPercentage() {
    isPercentageSelected.value = true;
  }

  void selectAmount() {
    isPercentageSelected.value = false;
  }
}
