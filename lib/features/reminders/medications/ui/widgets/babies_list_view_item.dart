import 'package:care_nest/core/theme/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BabiesListViewItem extends StatelessWidget {
  const BabiesListViewItem({
    super.key,
    required this.itemIndex, required this.selectedIndex,
  });
  final int itemIndex;
  final int selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: itemIndex == 0 ? 0 : 24.w,
      ),
      child: Column(
        children: [
          itemIndex == selectedIndex
              ? Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorsManager.darkBlue,
                      width: 1.5,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                      radius: 28,
                      backgroundColor: ColorsManager.primaryBlueColor,
                      child: Image.asset("assets/images/girl.png")),
                )
              : CircleAvatar(
                  radius: 28,
                  backgroundColor: ColorsManager.primaryBlueColor,
                  child: Image.asset("assets/images/girl.png")),
          SizedBox(height: 8),
          Text(
            'Ali',
          ),
        ],
      ),
    );
  }
}
