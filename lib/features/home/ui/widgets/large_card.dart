// ignore_for_file: deprecated_member_use

import 'package:care_nest/core/theme/font_weight_helper.dart';
import 'package:care_nest/core/utils/app_images.dart';
import 'package:care_nest/features/home/ui/widgets/forward_arrow_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/colors_manager.dart';

class LargeCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final String routePath;

  const LargeCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.onPressed,
    required this.routePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).push(routePath);
      },
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: ColorsManager.homeCardsColor,
          borderRadius: BorderRadius.circular(32.r),
          boxShadow: const [
            BoxShadow(
              color: Color(0xff8E8E8E),
              offset: Offset(0, 5),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        height: 240.h,
        width: MediaQuery.of(context).size.width * 0.5 - 24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  imagePath,
                ),
                SizedBox(width: 8.w),
                Image.asset(
                  AppImages.arrowImage,
                ),
              ],
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeightHelper.semiBold,
                color: ColorsManager.homeCardsTextColor,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeightHelper.medium,
                  color: ColorsManager.homeCardsTextColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ForwardArrowButton(
              iconColor: ColorsManager.primaryPinkColor,
              onPressed: () {
                GoRouter.of(context).push(routePath);
              },
            ),
          ],
        ),
      ),
    );
  }
}
