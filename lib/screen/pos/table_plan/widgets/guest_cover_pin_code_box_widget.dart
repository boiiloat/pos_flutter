import 'package:flutter/material.dart';

class GuestCoverPincodeBoxWidget extends StatelessWidget {
  final String guestCover;
  final VoidCallback? onBackspacePressed;
  final bool disabled;
  final String label;

  const GuestCoverPincodeBoxWidget({
    super.key,
    required this.guestCover,
    required this.onBackspacePressed,
    this.disabled = false,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey.shade300),
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
                    child: guestCover.isEmpty
                        ? Text(
                            label,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade300,
                            ),
                          )
                        : SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  guestCover,
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 20),
                                ),
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
                child: IconButton(
                  onPressed: disabled ? null : onBackspacePressed,
                  icon: const Icon(
                    Icons.backspace,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
