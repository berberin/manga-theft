import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:justice_mango/app/modules/home/tab/recent/recent_controller.dart';
import 'package:justice_mango/app/theme/color_theme.dart';

import 'widget/recent_card.dart';

class RecentTab extends GetWidget<RecentController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: nearlyWhite,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'recentManga'.tr,
                style: Get.textTheme.headline5.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  letterSpacing: 0.27,
                ),
              ),
            ),
            Obx(() => controller.recentArgs.isEmpty
                ? Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'noRecentManga'.tr,
                        style: Get.textTheme.bodyText2,
                      ),
                    ),
                  )
                : Column(
                    //verticalDirection: VerticalDirection.up,
                    children: List.generate(
                      controller.recentArgs.length,
                      (index) => RecentCard(
                        recentArgs: controller.recentArgs[index],
                      ),
                    ),
                  ))
          ],
        ),
      ),
    );
  }
}
