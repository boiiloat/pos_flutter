import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/program.dart';
import 'package:pos_system/screen/pos/table_plan/widgets/guest_cover_popup_input_widget.dart';
import 'package:pos_system/screen/pos/table_plan/widgets/input_number_widget.dart';

import '../screen/pos/sale/widgets/sale_discount_widget.dart';
import '../screen/pos/sale/widgets/sale_payment_widget.dart';

class SaleController extends GetxController {
  // Example method to handle menu item selection
  var selectedOption = ''.obs;
  void handleMenuSelection(String value) {
    switch (value) {
      case 're_order':
        Get.dialog(
          Dialog(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(7)), // Adjust the border radius if needed
            ),
            child: Container(
              width: 50, // Set the desired width
              height: 400, // Set the desired height
              padding: const EdgeInsets.all(
                  16.0), // Optional: Add padding to the content
              child: GuestCoverPopupInputWidget(
                label: 'Re-Order',
                onPressed: () {
                  Get.back();
                  Get.back();
                },
              ),
            ),
          ),
        );
        break;
      case 'qty':
        Get.dialog(
          Dialog(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(7)), // Adjust the border radius if needed
            ),
            child: Container(
              width: 50, // Set the desired width
              height: 450, // Set the desired height
              padding: const EdgeInsets.all(
                  16.0), // Optional: Add padding to the content
              child: InputNumberWidget(
                label: 'Qty',
                onPressed: () {
                  Get.back();
                  Get.back();
                },
              ),
            ),
          ),
        );
        break;
      case 'price':
        Get.dialog(
          Dialog(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(7)), // Adjust the border radius if needed
            ),
            child: Container(
              width: 50, // Set the desired width
              height: 450, // Set the desired height
              padding: const EdgeInsets.all(
                  16.0), // Optional: Add padding to the content
              child: InputNumberWidget(
                label: 'Price',
                onPressed: () {
                  Get.back();
                  Get.back();
                },
              ),
            ),
          ),
        );
        break;
      case 'discount':
        Get.dialog(
          Dialog(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(7)), // Adjust the border radius if needed
            ),
            child: Container(
                width: 350, // Set desired width
                height: 300,
                color: Colors.white, // Set desired height
                child: SaleDiscountWidget()),
          ),
        );
        break;
      case 'remove_item':
        Program.success("Remove Item", "Item removed");
        break;
      default:
        Program.success("title", "description");
    }
  }

  void onPaymentPressed() {
    Get.dialog(
      Dialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(7)), // Adjust the border radius if needed
        ),
        child: Container(
          width: 450, // Set desired width
          height: 600,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: const SalaPaymentWidget(), // Set desired height
        ),
      ),
    );
  }

  // The selected payment type ID
  var selectedPaymentType = ''.obs;

  // Update the selected payment type
  void selectPaymentType(String paymentType) {
    selectedPaymentType.value = paymentType;
  }
}
