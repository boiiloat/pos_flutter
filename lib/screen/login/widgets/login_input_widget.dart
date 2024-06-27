import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/login_controller.dart';

class LoginInputWidget extends StatelessWidget {
  const LoginInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<LoginController>();
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: Column(
        children: [
          const SizedBox(height: 100),
          Text(
            'WELCOME BACK',
            style: TextStyle(
                fontSize: 22,
                color: Colors.blue.shade700,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          SizedBox(
            child: TextFormField(
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue.shade100),
                  borderRadius: BorderRadius.circular(5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue.shade700,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.account_circle,
                  color: Colors.blue.shade700,
                  size: 25,
                ),
                filled: true,
                fillColor: Colors.white,
                labelText: "Username",
                labelStyle: TextStyle(
                  color: Colors.blue.shade700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            child: TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue.shade100),
                  borderRadius: BorderRadius.circular(5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue.shade700,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.lock_outline_sharp,
                  color: Colors.blue.shade700,
                  size: 25,
                ),
                filled: true,
                fillColor: Colors.white,
                labelText: "Password",
                labelStyle: TextStyle(
                  color: Colors.blue.shade700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Obx(
            () => Row(
              children: [
                Transform.scale(
                  scale: 0.7,
                  child: Checkbox(
                    activeColor: Colors.blue.shade900,
                    checkColor: Colors.white, //
                    value: controller.isChecked.value,
                    onChanged: (bool? value) {
                      controller.isChecked.value = value!;
                    },
                  ),
                ),
                Text(
                  'Remember Me',
                  style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: controller.onLoginPressed,
            child: Ink(
              width: 500,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Center(
                child: Text(
                  'Log In',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          // const SizedBox(height: 10),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     InkWell(
          //       onTap: controller.onLoginPressed,
          //       child: Ink(
          //         width: 80,
          //         height: 28,
          //         decoration: BoxDecoration(
          //           border: Border.all(color: Colors.blue.shade700),
          //           borderRadius: BorderRadius.circular(3),
          //         ),
          //         child: Center(
          //           child: Text(
          //             'ភាសារខ្មែរ',
          //             style: TextStyle(
          //               color: Colors.blue.shade700,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //    const  SizedBox(width: 8),
          //     InkWell(
          //       onTap: controller.onLoginPressed,
          //       child: Ink(
          //         width: 80,
          //         height: 28,
          //         decoration: BoxDecoration(
          //           border: Border.all(color: Colors.blue.shade700),
          //           borderRadius: BorderRadius.circular(3),
          //         ),
          //         child: Center(
          //           child: Text(
          //             'English',
          //             style: TextStyle(
          //               color: Colors.blue.shade700,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
