import 'package:flutter/material.dart';
import 'package:pos_system/program.dart';
import 'package:pos_system/screen/customer/Widgets/customer_fill_widget.dart';

class ProductAddNewWidget extends StatelessWidget {
  const ProductAddNewWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
                  SizedBox(height: 20),
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: NetworkImage(
                            'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
                          ),
                          fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(height: 15),
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
                    hintText: 'Product Name',
                  ),
                  SizedBox(height: 10),
                  CustomerFillWidget(
                    icon: Icon(Icons.home),
                    hintText: 'Cost',
                  ),
                  SizedBox(height: 10),

                  CustomerFillWidget(
                    icon: Icon(Icons.person_2_outlined),
                    hintText: 'Price',
                  ),
                  SizedBox(height: 10),

                  SizedBox(
                    width: 300,
                    height: 40,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Category',
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

                  SizedBox(height: 10),
                  // SizedBox(
                  //   width: 300,
                  //   height: 40,
                  //   child: Obx(
                  //     () => DropdownButtonFormField<String>(
                  //       value: controller.selectedRole.value,
                  //       decoration: InputDecoration(
                  //         contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  //         focusedBorder: OutlineInputBorder(
                  //           borderSide: BorderSide(color: Colors.blue.shade100),
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //         enabledBorder: OutlineInputBorder(
                  //           borderSide: BorderSide(
                  //             color: Colors.blue.shade700,
                  //           ),
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //       ),
                  //       items: <String>['Admin', 'Cashier'].map((String value) {
                  //         return DropdownMenuItem<String>(
                  //           value: value,
                  //           child: Text(value),
                  //         );
                  //       }).toList(),
                  //       onChanged: (newValue) {
                  //         if (newValue != null) {
                  //           controller.setSelectedRole(newValue);
                  //         }
                  //       },
                  //     ),
                  //   ),
                  // ),
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
