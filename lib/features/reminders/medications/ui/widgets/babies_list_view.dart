// ignore_for_file: deprecated_member_use

import 'package:care_nest/features/reminders/medications/ui/widgets/babies_list_view_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BabiesListView extends StatefulWidget {
  const BabiesListView({
    super.key,
  });

  @override
  State<BabiesListView> createState() => _BabiesListViewState();
}

class _BabiesListViewState extends State<BabiesListView> {
  var selectedSpecializationIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedSpecializationIndex = index;
              });
            },
            child: BabiesListViewItem(
              itemIndex: index,
              selectedIndex: selectedSpecializationIndex,
            ),
          );
        },
      ),
    );
  }
}
