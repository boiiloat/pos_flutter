import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/program.dart';


class SaleController extends GetxController {
  
  void onPayPressed(){
    Program.success("title", "description");
  }

  void onSubmitPressed(){
    Program.success("title", "description");
  }
}
