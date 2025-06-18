import 'package:flutter/material.dart';
import 'package:pos_system/screen/user/Widgets/customer_fill_widget.dart';

class CategoryAddNewWidget extends StatelessWidget {
  const CategoryAddNewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              'Add new category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            CustomerFillWidget(
              icon: Icon(Icons.person_2_outlined),
              hintText: 'Input Category',
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 70,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 70,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Center(
                    child: Text(
                      'Okay',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
