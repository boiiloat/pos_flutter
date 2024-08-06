import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/controller/login_controller.dart';
import 'package:pos_system/controller/main_controller.dart';
import 'widgets/home_button_widget.dart';
import 'widgets/home_drawer_profile_widget.dart';
import 'widgets/home_profile_action_menu_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(MainController());
    final loginController = Get.find<LoginController>();

    return Obx(
      () => SafeArea(
        child: Container(
          color: Colors.grey.shade300,
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "SNACK AND RELAX",
                style: TextStyle(color: Colors.white, fontSize: 18),
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
                            "SNACK AND RELAX",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Text(
                            "POS Profile : ${_getRoleName(loginController.loggedInUser.value?.roleId)}  / Address: Sieam Reap, Cambodia",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                          ),
                          // Display role based on roleId
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
                              child: Wrap(
                                children: [
                                  HomeButtonWidget(
                                    hidden: controller.isSaleStarted.value,
                                    title: "Start working",
                                    iconData: Icons.calendar_month,
                                    onPressed: () => controller
                                        .onStartWorkingDayPressed(context),
                                  ),
                                  // HomeButtonWidget(
                                  //   // hidden: !controller.isSaleStarted.value,
                                  //   title: "Close Working Day",
                                  //   iconData: Icons.calendar_today,
                                  //   background: Colors.red,
                                  //   foreground: Colors.white,
                                  //   foregroundIconColor: Colors.white,
                                  //   onPressed: () => controller
                                  //       .onCloseWorkingDayPressed(context),
                                  // ),
                                  HomeButtonWidget(
                                    // hidden: controller.isSaleStarted.value,
                                    title: "Start Shift",
                                    iconData: Icons.schedule,
                                    onPressed: () =>
                                        controller.onStartShiftPressed(),
                                    // controller.onStartSalePressed(context),
                                  ),
                                  // HomeButtonWidget(
                                  //   // hidden: !controller.isSaleStarted.value,
                                  //   title: "Close Shift",
                                  //   iconData: Icons.schedule,
                                  //   background: Colors.red,
                                  //   foreground: Colors.white,
                                  //   foregroundIconColor: Colors.white,
                                  //   onPressed: controller.onCloseShiftPressed,
                                  // ),
                                  HomeButtonWidget(
                                    title: "POS".tr,
                                    iconData: Icons.shopping_cart_outlined,
                                    onPressed: controller.onPOSPressed,
                                    background: Colors.green,
                                    foreground: Colors.white,
                                    foregroundIconColor: Colors.white,
                                  ),
                                  HomeButtonWidget(
                                    title: "Receipt".tr,
                                    iconData: Icons.receipt_outlined,
                                    onPressed: () {},
                                  ),
                                  HomeButtonWidget(
                                    title: "Report".tr,
                                    iconData: Icons.assessment_outlined,
                                    onPressed: () {},
                                  ),
                                  HomeButtonWidget(
                                    title: "Customer".tr,
                                    iconData: Icons.group,
                                    onPressed: () {},
                                  ),
                                  HomeButtonWidget(
                                    title: "Product".tr,
                                    iconData: Icons.list,
                                    onPressed: () {},
                                  ),
                                  HomeButtonWidget(
                                    title: "Backup".tr,
                                    iconData: Icons.save,
                                    onPressed: controller.onBackupPressed,
                                    background: Colors.yellow.shade600,
                                    foreground: Colors.white,
                                    foregroundIconColor: Colors.white,
                                  ),
                                  HomeButtonWidget(
                                    title: "Reset Transaction".tr,
                                    iconData: Icons.restart_alt_outlined,
                                    onPressed: () {},
                                  ),
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

  String _getRoleName(int? roleId) {
    switch (roleId) {
      case 1:
        return 'Admin';
      case 2:
        return 'Cashier';
      default:
        return 'Unknown Role';
    }
  }
}
