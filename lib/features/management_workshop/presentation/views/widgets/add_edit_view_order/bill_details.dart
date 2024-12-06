import 'package:al_hassan_warsha/core/utils/functions/conver_en_to_ar.dart';
import 'package:al_hassan_warsha/core/utils/style/app_fonts.dart';
import 'package:al_hassan_warsha/features/gallery/presentation/views/widgets/custom_text_form_with_text.dart';
import 'package:al_hassan_warsha/features/management_workshop/data/models/pill_model.dart';
import 'package:al_hassan_warsha/features/management_workshop/presentation/views/widgets/add_edit_view_order/selected_payment_way.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BillDetails extends StatelessWidget {
  const BillDetails(
      {super.key,
      required this.pillModel,
      this.onChangePayment,
      this.formKey,
      this.onTapToChangeRemain,
      required this.enableController,
      this.changeStepsCounter});
  final PillModel pillModel;
  final void Function(OptionPaymentWay)? onChangePayment;
  final void Function(bool)? changeStepsCounter;
  final GlobalKey<FormState>? formKey;
  final void Function()? onTapToChangeRemain;
  final bool enableController;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "الفاتورة",
          style: AppFontStyles.extraBoldNew20(context),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: CustomColumnWithTextInAddNewType(
                    text: "المبلغ الكلي",
                    textLabel: "",
                    readOnly: changeStepsCounter == null ? true : false,
                    initalText: enableController ? null : pillModel.totalMoney,
                    controller: enableController
                        ? TextEditingController(text: pillModel.totalMoney)
                        : null,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "المبلغ الكلي لا يمكن ان يكون خاليا ";
                      }
                      return null;
                    },
                    formKey: formKey,
                    textInnerStyle: AppFontStyles.extraBoldNew20(context)
                        .copyWith(letterSpacing: 3),
                    textInputType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9\u0660-\u0669\u06F0-\u06F9]'),
                      )
                    ],
                    onChanged: (value) {
                      pillModel.totalMoney = value ?? "";
                      onTapToChangeRemain != null
                          ? onTapToChangeRemain!()
                          : () {};
                    },
                    textStyle: AppFontStyles.extraBoldNew16(context),
                    enableBorder: true,
                    suffixIcon: Text(
                      "جنية",
                      style: AppFontStyles.extraBoldNew16(context),
                    ),
                  )),
              const Expanded(flex: 1, child: SizedBox()),
              Expanded(
                  flex: 2,
                  child: CustomColumnWithTextInAddNewType(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "المقدم لا يمكن ان يكون خاليا ";
                      }
                      return null;
                    },
                    text: "المقدم ",
                    textLabel: "",
                    readOnly: changeStepsCounter == null ? true : false,
                    initalText: enableController ? null : pillModel.interior,
                    controller: enableController
                        ? TextEditingController(text: pillModel.interior)
                        : null,
                    formKey: formKey,
                    textInnerStyle: AppFontStyles.extraBoldNew20(context)
                        .copyWith(letterSpacing: 3),
                    textInputType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9\u0660-\u0669\u06F0-\u06F9]'),
                      )
                    ],
                    onChanged: (value) {
                      pillModel.interior = value ?? "";
                      onTapToChangeRemain != null
                          ? onTapToChangeRemain!()
                          : () {};
                    },
                    textStyle: AppFontStyles.extraBoldNew16(context),
                    enableBorder: true,
                    suffixIcon: Text(
                      "جنية",
                      style: AppFontStyles.extraBoldNew16(context),
                    ),
                  )),
              const Expanded(flex: 1, child: SizedBox()),
              Expanded(
                  flex: 2,
                  child: CustomColumnWithTextInAddNewType(
                    text: "المتبقي ",
                    textLabel: "",
                    readOnly: true,
                    controller: TextEditingController(
                      text: convertToArabicNumbers(pillModel.remian),
                    ),
                    textInnerStyle: AppFontStyles.extraBoldNew20(context)
                        .copyWith(letterSpacing: 3),
                    textStyle: AppFontStyles.extraBoldNew16(context),
                    enableBorder: true,
                    suffixIcon: Text(
                      "جنية",
                      style: AppFontStyles.extraBoldNew16(context),
                    ),
                  )),
              const Expanded(flex: 1, child: SizedBox()),
              BigInt.parse(convertToEnglishNumbers(pillModel.remian)) == BigInt.from(0)
                  ? Center(
                      child: Text(
                        "تم استلام كل المبالغ المتبقية",
                        style: AppFontStyles.bold19(context),
                      ),
                    )
                  : Expanded(
                      flex: 6,
                      child: Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: SelectedPaymentWay(
                                onPressed: onChangePayment,
                                optionPaymentWay: pillModel.optionPaymentWay,
                              )),
                          const Expanded(child: SizedBox()),
                          switch (pillModel.optionPaymentWay) {
                            OptionPaymentWay.onSteps => Expanded(
                                flex: 2,
                                child: CustomColumnWithTextInAddNewType(
                                  textInnerStyle:
                                      AppFontStyles.extraBoldNew18(context),
                                  onChanged: (value) {
                                    if (value == null || value.isEmpty) {
                                    } else {
                                      pillModel.stepsCounter = BigInt.parse(
                                          convertToEnglishNumbers(value)).toInt();
                                    }
                                  },
                                  text: "عدد الدفعات",
                                  textAlign: TextAlign.center,
                                  readOnly:
                                      changeStepsCounter == null ? true : false,
                                  textLabel: "",
                                  controller: TextEditingController(
                                      text: convertToArabicNumbers(
                                          pillModel.stepsCounter.toString())),
                                  textInputType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(
                                          r'[\u0660-\u0669\u06F0-\u06F9]'), // Arabic numerals only
                                    ),
                                  ],
                                  textStyle: AppFontStyles.extraBoldNew16(context),
                                  enableBorder: true,
                                  suffixIcon: changeStepsCounter != null
                                      ? IconButton(
                                          onPressed: () {
                                            changeStepsCounter!(true);
                                          },
                                          icon: const Icon(
                                            Icons.add_circle_outlined,
                                            size: 30,
                                          ))
                                      : const SizedBox(),
                                  prefixIcon: changeStepsCounter != null
                                      ? IconButton(
                                          onPressed: () {
                                            changeStepsCounter!(false);
                                          },
                                          icon: const Icon(
                                            CupertinoIcons.minus_circle_fill,
                                            color: Colors.black,
                                            size: 30,
                                          ))
                                      : const SizedBox(),
                                )),
                            OptionPaymentWay.atRecieve => const SizedBox()
                          },
                        ],
                      ),
                    )
            ],
          ),
        ),
      ],
    );
  }
}
