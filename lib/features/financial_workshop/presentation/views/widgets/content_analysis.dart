import 'package:al_hassan_warsha/core/utils/style/app_colors.dart';
import 'package:al_hassan_warsha/core/utils/style/app_fonts.dart';
import 'package:al_hassan_warsha/core/utils/widgets/custom_push_button.dart';
import 'package:al_hassan_warsha/features/financial_workshop/data/models/analysis_model.dart';
import 'package:flutter/material.dart';

class ContentOfAnalysis extends StatelessWidget {
  const ContentOfAnalysis({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36.0),
      child: Wrap(
        runSpacing:40 ,
        spacing: 46,
        children: [
          ...List.generate(analysisList.length, (index){
            return  FittedBox(
              child: CustomPushContainerButton(
                borderRadius: 12,
                padding: const EdgeInsets.symmetric(horizontal: 65,vertical: 12),
                color:analysisList[index].color,
                childInstead: Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(analysisList[index].title,style: AppFontStyles.extraBold32(context).copyWith(color: AppColors.white),),
                          IconButton(onPressed: null, icon: Icon(analysisList[index].iconData,color: AppColors.white,),)
                  
                        ],
                      ),
                      Text("100000 جنية",style: AppFontStyles.extraBold32(context).copyWith(color: AppColors.white),)
                    ],
                  ),
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
