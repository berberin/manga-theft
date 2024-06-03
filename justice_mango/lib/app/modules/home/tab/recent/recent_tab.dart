import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manga_theft/app/modules/home/tab/recent/recent_controller.dart';
import 'package:manga_theft/app/theme/color_theme.dart';

import 'widget/recent_card.dart';

class RecentTab extends GetWidget<RecentController> {
  const RecentTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: nearlyWhite,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 32,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'recentManga'.tr,
                style: Get.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  letterSpacing: 0.27,
                ),
              ),
            ),
            Obx(
              () => controller.recentArgs.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          'noRecentManga'.tr,
                          style: Get.textTheme.bodyMedium,
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
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
