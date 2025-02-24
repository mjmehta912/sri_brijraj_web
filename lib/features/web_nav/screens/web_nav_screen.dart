import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sri_brijraj_web/constants/color_constants.dart';
import 'package:sri_brijraj_web/constants/image_constants.dart';
import 'package:sri_brijraj_web/features/add_entry/screens/add_entry_screen.dart';
import 'package:sri_brijraj_web/features/history/screens/history_screen.dart';
import 'package:sri_brijraj_web/features/profile/screens/profile_screen.dart';
import 'package:sri_brijraj_web/features/web_nav/controllers/web_nav_controller.dart';
import 'package:sri_brijraj_web/styles/textstyles.dart';
import 'package:sri_brijraj_web/widgets/app_paddings.dart';
import 'package:sri_brijraj_web/widgets/app_size_extensions.dart';
import 'package:sri_brijraj_web/widgets/app_spacings.dart';

class WebNavScreen extends StatelessWidget {
  WebNavScreen({
    super.key,
  });

  final WebNavController _controller = Get.put(
    WebNavController(),
  );

  final List<Widget> pages = [
    HistoryScreen(),
    AddEntryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorwhite,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isSmallScreen = constraints.maxWidth < 600;

          return Row(
            children: [
              Container(
                width: isSmallScreen ? 0.3.screenWidth : 0.2.screenWidth,
                decoration: BoxDecoration(
                  color: kColorwhite,
                  border: Border(
                    right: BorderSide(
                      color: kColorLightGrey,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    AppSpaces.v20,
                    Padding(
                      padding:
                          isSmallScreen ? AppPaddings.p10 : AppPaddings.p20,
                      child: Column(
                        children: [
                          Image.asset(
                            kIconBrijraj,
                            height: isSmallScreen ? 60 : 100,
                            width: isSmallScreen ? 60 : 100,
                          ),
                          Text(
                            'SRI BRIJRAJ',
                            style: TextStyles.kBoldInstrumentSans(
                              fontSize: isSmallScreen
                                  ? FontSize.k16FontSize
                                  : FontSize.k20FontSize,
                              color: kColorPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: kColorLightGrey,
                    ),
                    AppSpaces.v20,
                    _buildNavItem(
                      0,
                      "History",
                      kIconHistory,
                      kIconHistoryFilled,
                      isSmallScreen,
                    ),
                    AppSpaces.v20,
                    _buildNavItem(
                      1,
                      "Add Entry",
                      kIconAdd,
                      kIconAddFilled,
                      isSmallScreen,
                    ),
                    AppSpaces.v20,
                    _buildNavItem(
                      2,
                      "Profile",
                      kIconProfile,
                      kIconProfileFilled,
                      isSmallScreen,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(
                  () => pages[_controller.selectedIndex.value],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    String title,
    String icon,
    String iconFilled,
    bool isSmallScreen,
  ) {
    return Obx(
      () => ListTile(
        leading: SvgPicture.asset(
          _controller.selectedIndex.value == index ? iconFilled : icon,
          colorFilter: ColorFilter.mode(
            _controller.selectedIndex.value == index
                ? kColorPrimary
                : kColorBlack,
            BlendMode.srcIn,
          ),
          height: isSmallScreen ? 20 : 24,
          width: isSmallScreen ? 20 : 24,
        ),
        title: Text(
          title,
          style: TextStyles.kMediumInstrumentSans(
            color: _controller.selectedIndex.value == index
                ? kColorPrimary
                : kColorBlack,
            fontSize:
                isSmallScreen ? FontSize.k14FontSize : FontSize.k16FontSize,
          ),
        ),
        selected: _controller.selectedIndex.value == index,
        onTap: () => _controller.changeIndex(index),
      ),
    );
  }
}
