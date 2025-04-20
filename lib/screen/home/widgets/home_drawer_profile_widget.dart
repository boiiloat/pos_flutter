import 'package:flutter/material.dart';
import 'home_drawer_menu_item_widget.dart';
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
              SizedBox(
                height: 170,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/bg_image.jpg"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Flex(
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  maxRadius: 30,
                                  backgroundImage: AssetImage(
                                      "assets/images/logo_image.jpg"),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            decoration: const BoxDecoration(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Obx(() => Text(
                                //       loginController.loggedInUser.value?.fullname ??
                                //           'Unknown',
                                //       style: const TextStyle(
                                //         color: Colors.white,
                                //         fontWeight: FontWeight.bold,
                                //         fontSize: 16,
                                //       ),
                                //     )),
                                // Obx(() => Text(
                                //       'POS Profile: ${_getRoleName(loginController.loggedInUser.value?.roleId)}',
                                //       style: const TextStyle(
                                //           color: Colors.white, fontSize: 12),
                                //     )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
                              icon: Icons.play_circle_fill,
                              text: 'Start Sale',
                              onPressed: () {}),

                          HomeDrawerMenuItemWidget(
                            icon: Icons.shopping_cart,
                            text: 'POS',
                            onPressed: () {},
                          ),
                          HomeDrawerMenuItemWidget(
                            icon: Icons.list,
                            text: 'Product',
                            onPressed: () {},
                          ),
                          HomeDrawerMenuItemWidget(
                            icon: Icons.receipt_outlined,
                            text: 'Receipt',
                            onPressed: () {},
                          ),
                          HomeDrawerMenuItemWidget(
                            icon: Icons.assessment_outlined,
                            text: 'Report',
                            onPressed: () {},
                          ),
                          // Other Menu Items
                          HomeDrawerMenuItemWidget(
                            icon: Icons.group,
                            text: 'Users',
                            onPressed: () {},
                          ),
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
              ),
              const HomeLogoutButtonWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
