import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/main_controller.dart';
import 'home_drawer_menu_item_widget.dart';
import 'home_drawer_profile_widget copy.dart';
import 'home_logout_button_widget.dart';

class HomeScreenDrawerWidget extends StatelessWidget {
  const HomeScreenDrawerWidget({super.key});
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<MainController>();
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              const HomeDrawerProfileWidget(),
              Expanded(
                child: Container(
                  color: Colors.grey[200],
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        HomeDrawerMenuItemWidget(
                          icon: Icons.calendar_month,
                          text: 'Start working',
                          onPressed: () => controller.onStartWorkingDayPressed,
                        ),
                        HomeDrawerMenuItemWidget(
                          icon: Icons.schedule,
                          text: 'Start Shift',
                          onPressed: controller.onCloseSalePrssed,
                        ),
                        HomeDrawerMenuItemWidget(
                          icon: Icons.shopping_cart,
                          text: 'POS',
                          onPressed: () {},
                        ),
                        HomeDrawerMenuItemWidget(
                          icon: Icons.group,
                          text: 'Customer',
                          onPressed: () {},
                        ),
                        HomeDrawerMenuItemWidget(
                          icon: Icons.article,
                          text: 'Receipt',
                          onPressed: () {},
                        ),
                        HomeDrawerMenuItemWidget(
                          icon: Icons.insert_chart,
                          text: 'Report',
                          onPressed: () {},
                        ),
                        const SizedBox(height: 70),
                        const Divider(),
                        HomeDrawerMenuItemWidget(
                          icon: Icons.save,
                          text: 'Backup',
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // logout drawer button
              const HomeLogoutButtonWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
