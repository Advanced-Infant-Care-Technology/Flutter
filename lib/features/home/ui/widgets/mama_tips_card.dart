// ignore_for_file: deprecated_member_use

import 'package:care_nest/core/theme/font_weight_helper.dart';
import 'package:care_nest/features/home/ui/widgets/forward_arrow_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/colors_manager.dart';

class MamaTipsCard extends StatelessWidget {
  const MamaTipsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      height: MediaQuery.of(context).size.height * 0.14,
      width: MediaQuery.of(context).size.width * 0.5 - 24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Mama Tips',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeightHelper.semiBold,
                    color: ColorsManager.homeCardsTextColor,
                  ),
                ),
                SizedBox(height: 12.h),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Parenting Tips,\nJust for You',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeightHelper.medium,
                        color: ColorsManager.homeCardsTextColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          ForwardArrowButton(
            iconColor: ColorsManager.primaryPinkColor,
            onPressed: () {
              GoRouter.of(context).push(AppRouter.kTargetSelectionScreen);
            },
          ),
        ],
      ),
    );
  }
}
