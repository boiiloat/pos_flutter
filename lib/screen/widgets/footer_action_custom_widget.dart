import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constans/constan.dart';
import 'text_icon_loading_widget.dart';

class FooterActionCustomWidget extends StatelessWidget {
  final String cancelTitle;
  final String okTitle;
  final bool okProcessing;
  final VoidCallback? onCancelPressed;
  final VoidCallback? onOKPressed;
  final double wrapPadding;

  const FooterActionCustomWidget({
    super.key,
    this.cancelTitle = "Back",
    this.okTitle = "Accept",
    this.okProcessing = false,
    required this.onCancelPressed,
    required this.onOKPressed,
    this.wrapPadding = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
            color: appColor.withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      padding: EdgeInsets.only(top: wrapPadding, bottom: wrapPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            color: Colors.transparent,
            child: ElevatedButton.icon(
              onPressed: onCancelPressed,
              icon: const Icon(Icons.keyboard_return),
              label: TextIconLoadingWidget(
                isLoading: false,
                title: cancelTitle.tr,
                color: lightColor,
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    dangerColor), // Change Colors.green to your desired background color
                foregroundColor: MaterialStateProperty.all(Colors
                    .white), // Change Colors.white to your desired text color
                iconColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        5.0), // Change 10.0 to your desired border radius
                  ),
                ), // Ch // Change Colors.white to your desired icon color
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            alignment: Alignment.center,
            child: Material(
              color: Colors.transparent,
              child: ElevatedButton(
                onPressed: okProcessing ? null : onOKPressed,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      successColor.withOpacity(okProcessing
                          ? 0.4
                          : 1)), // Change Colors.green to your desired background color
                  foregroundColor: MaterialStateProperty.all(Colors
                      .white), // Change Colors.white to your desired text color
                  iconColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          5.0), // Change 10.0 to your desired border radius
                    ),
                  ), // Change Colors.white to your desired icon color
                ),
                child: TextIconLoadingWidget(
                  isLoading: okProcessing,
                  title: okTitle.tr,
                  color: lightColor,
                  icon: Icons.done,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
