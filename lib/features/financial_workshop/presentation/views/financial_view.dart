import 'package:al_hassan_warsha/core/utils/functions/service_locator.dart';
import 'package:al_hassan_warsha/core/utils/style/app_colors.dart';
import 'package:al_hassan_warsha/core/utils/widgets/custom_snack_bar.dart';
import 'package:al_hassan_warsha/features/financial_workshop/data/models/side_bar_model.dart';
import 'package:al_hassan_warsha/features/financial_workshop/data/repos/financial_repo_impl.dart';
import 'package:al_hassan_warsha/features/financial_workshop/presentation/manager/bloc/finanical_bloc.dart';
import 'package:al_hassan_warsha/features/financial_workshop/presentation/views/widgets/analysis_view.dart';
import 'package:al_hassan_warsha/features/financial_workshop/presentation/views/widgets/custom_side_bar_item.dart';
import 'package:al_hassan_warsha/features/financial_workshop/presentation/views/widgets/financial_body.dart';
import 'package:al_hassan_warsha/features/financial_workshop/presentation/views/widgets/salary_widget/add_edit_salary.dart';
import 'package:al_hassan_warsha/features/financial_workshop/presentation/views/widgets/transaction_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FinancialView extends StatelessWidget {
  const FinancialView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FinanicalBloc(financialRepoImpl: getIt.get<FinancialRepoImpl>())
            ..add(FetchAllOrderWithThierBillEvent()),
      child: BlocConsumer<FinanicalBloc, FinanicalState>(
          listener: (context, state) {
        if (state is SuccessUpdateCounterOrderState) {
          showCustomSnackBar(context, "تم تنزيل دفعة بنجاح ");
        } else if (state is SuccessAddTransactionState) {
          showCustomSnackBar(context, "تم ادراج التحويل بنجاح ");
        } else if (state is SuccessPayAllSalariesWorkersState) {
          showCustomSnackBar(context, "تم دفع المرتبات بنجاح ");
        } else if (state is FailureFetchOrderState) {
          showCustomSnackBar(context, "${state.errMessage}",
              backgroundColor: AppColors.red);
        } else if (state is FailureUpdateCounterOrderState) {
          showCustomSnackBar(context, "${state.errMessage}",
              backgroundColor: AppColors.red);
        } else if (state is SuccessAddTransactionState) {
          showCustomSnackBar(context, "تم اضافة التحويل بنجاح ");
        } else if (state is FailureEditWorkersData) {
          showCustomSnackBar(context, state.errMessage ?? "",
              backgroundColor: AppColors.orange);
        } else if (state is FailurePayAllSalariesWorkersState) {
          showCustomSnackBar(context, state.errMessage ?? "",
              backgroundColor: AppColors.orange);
        }
      }, builder: (context, state) {
        var bloc = context.read<FinanicalBloc>();
        return Expanded(
          child: Row(children: [
            Expanded(
                flex: 1,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration:
                      const BoxDecoration(color: AppColors.veryLightGray2),
                  child: CustomScrollView(
                    slivers: [
                      SliverList.separated(
                          itemCount: financialSideBarList.length,
                          itemBuilder: (context, index) {
                            return CustomFinancialSideBarItem(
                              model: financialSideBarList[index],
                              onTap: () {
                                bloc.add(ChangeCurrentIndexEvent(index: index));
                              },
                              picked: bloc.currIndex == index,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 24,
                            );
                          })
                    ],
                  ),
                )),
            bloc.isLoading
                ? const Expanded(
                    flex: 5,
                    child: SizedBox(
                        child: Center(child: CircularProgressIndicator())))
                : Expanded(
                    flex: 5,
                    child: [
                      FinancialBody(
                        bloc: bloc,
                      ),
                      TranscationView(
                        bloc: bloc,
                      ),
                      AddEditSalaryView(
                        bloc: bloc,
                      ),
                      const AnalysisView(),
                    ][bloc.currIndex],
                  )
          ]),
        );
      }),
    );
  }
}
