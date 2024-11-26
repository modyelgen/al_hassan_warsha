import 'package:al_hassan_warsha/core/utils/widgets/custom_push_button.dart';
import 'package:al_hassan_warsha/features/management_workshop/presentation/manager/bloc/management_bloc.dart';
import 'package:al_hassan_warsha/features/management_workshop/presentation/views/widgets/add_edit_view_order/bill_details.dart';
import 'package:al_hassan_warsha/features/management_workshop/presentation/views/widgets/add_edit_view_order/customer_info.dart';
import 'package:al_hassan_warsha/features/management_workshop/presentation/views/widgets/add_edit_view_order/order_details_in_add.dart';
import 'package:flutter/material.dart';

class AddOrderBody extends StatelessWidget {
  const AddOrderBody({
    super.key,
    required this.bloc,
  });
  final ManagementBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: bloc.fromKey,
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 16),
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomPushContainerButton(
                    pushButtomText: "استيراد من المعرض",
                    iconBehind: Icons.file_upload_outlined,
                    borderRadius: 16,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: CustomerInfoInOrder(
                  formKey: bloc.fromKey,
                  model: bloc.customerModel,
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 16,
                ),
              ),
              SliverToBoxAdapter(
                child: OrderDetails(
                  kitchenTypesList: bloc.allKitchenTypes,
                  pickedMeidaList: bloc.mediaOrderList,
                  formKey: bloc.fromKey,
                  addMore: () {
                    bloc.add(AddExtraInOrder());
                  },
                  delteItem: (index) {
                    bloc.add(RemoveExtraItem(index: index));
                  },
                  extraList: bloc.extraOrdersList,
                  colorOrderModel: bloc.colorModel,
                  orderModel: bloc.orderModel,
                  changeColorValue: (value) {
                    bloc.add(ChangeColorOfOrderEvent(colorValue: value));
                  },
                  changeDate: (time) {
                    bloc.add(ChangeDateOfOrderEvent(dateTime: time));
                  },
                  changekitchenTypeValue: (type) {
                    bloc.add(ChangeKitchenTypeEvent(kitchenType: type));
                  },
                  addMoreMedia: (media) {
                    bloc.add(AddMediaInAddOrder(list: media));
                  },
                  delteMedia: (int index) {
                    bloc.add(RemoveMediItemEvent(index: index));
                  },
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 16,
                ),
              ),
              SliverToBoxAdapter(
                child: BillDetails(
                  changeStepsCounter: (increase) {
                    bloc.add(ChangeCounterOfStepsInPillEvent(increase: increase));
                  },
                  pillModel: bloc.pillModel,
                  onChangePayment: (paymentWay) {
                    bloc.add(ChangeOptionPaymentEvent(paymentWay: paymentWay));
                  },
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              ),
              SliverToBoxAdapter(
                child: Center(
                    child: CustomPushContainerButton(
                  onTap: () {
                    if (bloc.fromKey.currentState!.validate()) {
                      bloc.add(AddNewOrderEvent());
                    }
                  },
                  pushButtomText: "اضافة الطلب",
                  borderRadius: 16,
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
