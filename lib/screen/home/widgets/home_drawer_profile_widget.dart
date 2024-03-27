import 'package:flutter/material.dart';
import 'home_drawer_menu_item_widget.dart';
import 'home_drawer_profile_widget copy.dart';
import 'home_logout_button_widget.dart';

class HomeScreenDrawerWidget extends StatelessWidget {
  const HomeScreenDrawerWidget({super.key});
  @override
  Widget build(BuildContext context) {
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
                          text: 'Start Working Day',
                          onPressed: () {},
                        ),
                        HomeDrawerMenuItemWidget(
                          icon: Icons.calendar_month,
                          text: 'Close Working Day',
                          onPressed: () {},
                        ),
                        HomeDrawerMenuItemWidget(
                          icon: Icons.schedule,
                          text: 'Start Cashier Shift',
                          onPressed: () {},
                        ),
                        HomeDrawerMenuItemWidget(
                          icon: Icons.schedule,
                          text: 'Close Cashier Shift',
                          onPressed: () {},
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
                          icon: Icons.monetization_on,
                          text: 'Cash Drawer',
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
                        const Divider(),
                        HomeDrawerMenuItemWidget(
                          icon: Icons.save,
                          text: 'Backup',
                          onPressed: () {},
                        ),
                        HomeDrawerMenuItemWidget(
                          icon: Icons.settings,
                          text: 'Setting',
                          onPressed: () {},
                        ),
                        HomeDrawerMenuItemWidget(
                          icon: Icons.support_agent,
                          text: 'Help & Support',
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
