import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pos_system/controller/customer_controller.dart';
import 'package:pos_system/program.dart';
import 'package:pos_system/screen/customer/Widgets/customer_fill_widget.dart';

class CustomerAddNewWidget extends StatelessWidget {
   CustomerAddNewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CustomerController>();
    return Container(
      width: 450,
      height: 500,
      color: Colors.white,
      child: Expanded(
          child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.red,
              child: Center(
                child: Text(
                  'ADD NEW CUSTOMER',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: Container(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    'User Profile',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                          image: NetworkImage(
                            'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541',
                          ),
                          fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Program.success("title", "description");
                    },
                    child: Container(
                      height: 25,
                      width: 84,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Text(
                          'Upload Image',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomerFillWidget(
                    icon: Icon(Icons.home),
                    hintText: 'full name',
                  ),
                  SizedBox(height: 10),

                  CustomerFillWidget(
                    icon: Icon(Icons.person_2_outlined),
                    hintText: 'username',
                  ),
                  SizedBox(height: 10),

                  CustomerFillWidget(
                    icon: Icon(Icons.key),
                    hintText: 'password',
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 300,
                    height: 40,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Roll',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 15,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue.shade100),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue.shade700,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: Icon(
                          Icons
                              .arrow_drop_down, // Replace with your desired icon
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 40,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade300,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                  // DropdownButton(items: items, onChanged: onChanged)
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
