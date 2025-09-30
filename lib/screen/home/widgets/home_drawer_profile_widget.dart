import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/login_controller.dart';
import '../../../controller/main_controller.dart';
import 'home_drawer_menu_item_widget.dart';
import 'home_logout_button_widget.dart';

class HomeScreenDrawerWidget extends StatelessWidget {
  const HomeScreenDrawerWidget({super.key});
  // Helper method to get role name based on roleId
  String _getRoleName(int? roleId) {
    switch (roleId) {
      case 1:
        return 'Admin';
      case 2:
        return 'Cashier';
      default:
        return 'User';
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();
    final maincontroller = Get.find<MainController>();

    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 170,
                child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/bg_image.jpg"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Row(
                      children: [
                        Obx(() {
                          final profileImage = loginController.profileImage;
                          final imageProvider = (profileImage != null &&
                                  profileImage.isNotEmpty)
                              ? NetworkImage(
                                  'http://localhost:8000/storage/$profileImage')
                              : const AssetImage(
                                  "assets/images/logo_image.jpg");

                          return Padding(
                            padding: const EdgeInsets.only(left: 20, top: 60),
                            child: Row(
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: imageProvider as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        loginController.userFullName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${_getRoleName(loginController.roleId)} Role',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    )),
              ),
              Expanded(
                child: Container(
                  color: Colors.grey[200],
                  child: SingleChildScrollView(
                    child: SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          HomeDrawerMenuItemWidget(
                            icon: Icons
                                .play_circle_fill, // This will be dynamically changed
                            text:
                                'Start Sale', // This identifies it as the sale toggle
                            onPressed: () {
                              maincontroller.toggleSale();
                            },
                          ),

                          HomeDrawerMenuItemWidget(
                            icon: Icons.shopping_cart,
                            text: 'POS',
                            onPressed: () {
                              maincontroller.onPOSPressed();
                            },
                          ),
                          HomeDrawerMenuItemWidget(
                            icon: Icons.list,
                            text: 'Product',
                            onPressed: () {
                              maincontroller.onProductPressed();
                            },
                          ),
                          HomeDrawerMenuItemWidget(
                            icon: Icons.receipt_outlined,
                            text: 'Receipt',
                            onPressed: () {
                              maincontroller.onReceiptPressed();
                            },
                          ),
                          HomeDrawerMenuItemWidget(
                            icon: Icons.assessment_outlined,
                            text: 'Report',
                            onPressed: () {
                              maincontroller.onReportPressed();
                            },
                          ),
                          // Other Menu Items
                          HomeDrawerMenuItemWidget(
                            icon: Icons.group,
                            text: 'Users',
                            onPressed: maincontroller.onUserPressed,
                          ),
                          HomeDrawerMenuItemWidget(
                            icon: Icons.post_add,
                            text: 'Expense',
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                child: const HomeLogoutButtonWidget(),
                onTap: () {
                  maincontroller.onLogoutPressed();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
