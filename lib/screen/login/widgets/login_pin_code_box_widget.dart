import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPinCodeBoxWidget extends StatelessWidget {
  final String pinCode;
  final VoidCallback? onBackspacePressed;
  final bool disabled;
  const LoginPinCodeBoxWidget({
    super.key,
    required this.pinCode,
    required this.onBackspacePressed,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: pinCode.isEmpty
                        ? Text(
                            "PIN Code".tr,
                            style: TextStyle(
                              fontSize: 16,
                              color: pinCode.isEmpty || disabled
                                  ? Colors.grey[400]
                                  : Colors.orange,
                            ),
                          )
                        : SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ...pinCode.split('').map(
                                      (e) => Icon(
                                        Icons.fiber_manual_record,
                                        size: 14,
                                        color: disabled
                                            ? Colors.grey[400]
                                            : Colors.orange,
                                      ),
                                    )
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
              child: VerticalDivider(
                thickness: 1.0,
                color: Colors.grey,
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border(
                    left: BorderSide(
                      width: 0.25,
                      color: Colors.grey[400]!,
                    ),
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
                // child: IconButton(
                //   onPressed: disabled
                //       ? null
                //       : (pinCode.isEmpty ? null : onBackspacePressed),
                //   icon: const Icon(
                //     Icons.backspace,
                //     color: Colors.red,
                //   ),
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
