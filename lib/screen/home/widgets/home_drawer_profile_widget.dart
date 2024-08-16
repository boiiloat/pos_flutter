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
                            onPressed: () =>
                                controller.onStartWorkingDayPressed),
                        HomeDrawerMenuItemWidget(
                          icon: Icons.schedule,
                          text: 'Start Shift',
                          onPressed: () {},
                        ),
                        HomeDrawerMenuItemWidget(
                          icon: Icons.shopping_cart,
                          text: 'POS',
                          onPressed: () {},
                        ),
                        // Report ExpansionTile
                        ExpansionTile(
                          leading: Icon(Icons.article),
                          title: Text('Report'),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0), // Indent submenu items
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () => controller.onReportPressed(),
                                    child: ListTile(
                                      title: Text(
                                        'Report Screen',
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () =>
                                        controller.onStockReportPressed(),
                                    child: ListTile(
                                      title: Text(
                                        'Stock Report',
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () =>
                                        controller.onWorkingDayReportPressed(),
                                    child: ListTile(
                                      title: Text('Working Day Report',
                                          style: TextStyle(fontSize: 13)),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => controller.onExpensePressed(),
                                    child: ListTile(
                                      title: Text('Expense',
                                          style: TextStyle(fontSize: 13)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Other Menu Items
                        HomeDrawerMenuItemWidget(
                          icon: Icons.group,
                          text: 'Customer',
                          onPressed: () {},
                        ),
                        HomeDrawerMenuItemWidget(
                          icon: Icons.list,
                          text: 'Product',
                          onPressed: () {},
                        ),
                        const SizedBox(height: 30),
                        // Only show the divider if ExpansionTile is not expanded
                        Divider(),
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
              const HomeLogoutButtonWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
