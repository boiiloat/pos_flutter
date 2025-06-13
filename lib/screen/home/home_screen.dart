import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos_system/controller/main_controller.dart';
import '../../controller/login_controller.dart';
import 'widgets/home_button_widget.dart';
import 'widgets/home_drawer_profile_widget.dart';
import 'widgets/home_profile_action_menu_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final loginController = Get.find<LoginController>();
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
    var controller = Get.put(MainController());
    final user = GetStorage().read('user');

    return Obx(
      () => SafeArea(
        child: Container(
          color: Colors.grey.shade300,
          child: Scaffold(
            appBar: AppBar(
              title: const Row(
                children: [
                  Text(
                    "SNACK & RELAX CAFE",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              leading: Builder(
                builder: (context) => IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                ),
              ),
              actions: const [
                HomeProfileActionMenuWidget(),
              ],
            ),
            backgroundColor: Colors.transparent,
            drawer: const Drawer(
              child: HomeScreenDrawerWidget(),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 220,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/bg_image.jpg"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 30),
                          Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              image: const DecorationImage(
                                image:
                                    AssetImage("assets/images/logo_image.jpg"),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "SNACK & RELAX CAFE",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Text(
                            "POS Profile : ${_getRoleName(loginController.roleId)}   /  Address: Siem Reap, Cambodia",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 360,
                              child: Obx(
                                () => Wrap(
                                  children: [
                                    HomeButtonWidget(
                                      title: controller.isSaleStarted.value
                                          ? "Close Sale".tr
                                          : "Start Sale".tr,
                                      iconData: controller.isSaleStarted.value
                                          ? Icons.stop_circle
                                          : Icons.play_circle_fill,
                                      background: controller.isSaleStarted.value
                                          ? Colors.red
                                          : Colors.blue,
                                      foreground: Colors.white,
                                      foregroundIconColor: Colors.white,
                                      onPressed: controller.toggleSale,
                                    ),
                                    // HomeButtonWidget(
                                    //   // hidden: !cont\roller.isSaleStarted.value,
                                    //   title: "Close Working Day",
                                    //   iconData: Icons.calendar_today,
                                    //   background: Colors.red,
                                    //   foreground: Colors.white,
                                    //   foregroundIconColor: Colors.white,
                                    //   onPressed: () => controller
                                    //       .onCloseWorkingDayPressed(context),
                                    // ),

                                    HomeButtonWidget(
                                      title: "POS".tr,
                                      iconData: Icons.shopping_cart_outlined,
                                      onPressed: controller.onPOSPressed,
                                      background: controller.isSaleStarted.value
                                          ? Colors.green
                                          : Colors.grey,
                                      foreground: Colors.white,
                                      foregroundIconColor: Colors.white,
                                    ),
                                    HomeButtonWidget(
                                        title: "Receipt".tr,
                                        iconData: Icons.receipt_outlined,
                                        onPressed: controller.onReceiptPressed),
                                    HomeButtonWidget(
                                      title: "Report".tr,
                                      iconData: Icons.assessment_outlined,
                                      onPressed: controller.onReportPressed,
                                    ),
                                    HomeButtonWidget(
                                      title: "Product".tr,
                                      iconData: Icons.list,
                                      onPressed: controller.onProductPressed,
                                    ),
                                    HomeButtonWidget(
                                      title: "Users".tr,
                                      iconData: Icons.group,
                                      onPressed: controller.onUserPressed,
                                    ),

                                    HomeButtonWidget(
                                      title: "Expense".tr,
                                      iconData: Icons.post_add,
                                      onPressed: controller.onExpensePressed,
                                    ),

                                    HomeButtonWidget(
                                      title: "Reset Sale".tr,
                                      iconData: Icons.refresh,
                                      onPressed: controller.onResetSalePressed,
                                    ),

                                    // HomeButtonWidget(
                                    //   title: "Back Up".tr,
                                    //   background: Colors.yellow.shade800,
                                    //   foreground: Colors.white,
                                    //   iconData: Icons.backup_sharp,
                                    //   onPressed: controller.onBackupPressed,
                                    //   foregroundIconColor: Colors.white,
                                    // ),

                                    HomeButtonWidget(
                                      title: "Logout".tr,
                                      background: Colors.red,
                                      foreground: Colors.white,
                                      iconData: Icons.logout_outlined,
                                      onPressed: controller.onLogoutPressed,
                                      foregroundIconColor: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
