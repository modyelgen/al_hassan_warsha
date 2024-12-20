import 'package:al_hassan_warsha/core/utils/functions/conver_en_to_ar.dart';
import 'package:al_hassan_warsha/core/utils/style/app_colors.dart';
import 'package:al_hassan_warsha/core/utils/style/app_fonts.dart';
import 'package:al_hassan_warsha/core/utils/widgets/rotate_extension.dart';
import 'package:al_hassan_warsha/features/management_workshop/data/models/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterOrdersWithMonthYear extends StatelessWidget {
  const FilterOrdersWithMonthYear(
      {super.key,
      this.title,
      required this.changeMonth,
      required this.changeYear,
      required this.month,
      this.dateStyle,
      this.iconSize,
      this.titleStyle,
      required this.year,
      required this.searchFor});
  final String? title;
  final void Function(int) changeMonth;
  final void Function(DateTime) changeYear;
  final void Function() searchFor;
  final int year;
  final int month;
  final TextStyle? titleStyle;
  final TextStyle? dateStyle;
  final double? iconSize;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: iconSize != null
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        const Expanded(child: SizedBox()),
        Text(
          title ?? "الطلبات الحالية ل",
          style: titleStyle ?? AppFontStyles.extraBoldNew30(context),
        ),
        const Expanded(flex: 5, child: SizedBox()),
        CustomContainerToPickHistory(
          child: Row(
            children: [
              Text(
                monthModelList[month - 1].monthName,
                style: dateStyle ?? AppFontStyles.extraBoldNew18(context),
              ),
              SizedBox(
                width: iconSize == null ? 10 : 0,
              ),
              PopupMenuButton<int>(
                constraints: const BoxConstraints(maxHeight: 350),
                icon: const Icon(Icons.arrow_back_ios_new).rotate(angle: 90),
                color: AppColors.veryLightGray,
                onSelected: changeMonth,
                itemBuilder: (BuildContext context) {
                  return [
                    ...List.generate(monthModelList.length, (index) {
                      return PopupMenuItem(
                        value: monthModelList[index].monthValue,
                        child: Center(
                          child: Text(
                            monthModelList[index].monthName,
                            style: AppFontStyles.extraBoldNew18(context),
                          ),
                        ),
                      );
                    })
                  ];
                },
              )
            ],
          ),
        ),
        const Expanded(child: SizedBox()),
        CustomContainerToPickHistory(
          child: Row(
            children: [
              Text(
                convertToArabicNumbers(year.toString()),
                style: dateStyle ?? AppFontStyles.extraBoldNew18(context),
              ),
              SizedBox(
                width: iconSize == null ? 10 : 0,
              ),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: SizedBox(
                              height: 300,
                              child: YearPicker(
                                firstDate: DateTime(DateTime.now().year - 10),
                                lastDate: DateTime(DateTime.now().year + 5),
                                selectedDate:
                                    DateTime.now().copyWith(year: year),
                                onChanged: changeYear,
                              ),
                            ),
                          );
                        });
                  },
                  icon: const Icon(CupertinoIcons.calendar))
            ],
          ),
        ),
        const Expanded(child: SizedBox()),
        IconButton(
            onPressed: searchFor,
            icon: Icon(
              Icons.search,
              size: iconSize ?? 40,
            )),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}

class CustomContainerToPickHistory extends StatelessWidget {
  const CustomContainerToPickHistory({super.key, this.child, this.fillColor});
  final Widget? child;
  final Color? fillColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      decoration: BoxDecoration(
          color: fillColor ?? AppColors.white,
          border: Border.all(color: AppColors.lightGray1, width: 2),
          borderRadius: BorderRadius.circular(12)),
      child: child,
    );
  }
}
