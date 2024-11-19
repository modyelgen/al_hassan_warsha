import 'package:al_hassan_warsha/core/utils/functions/service_locator.dart';
import 'package:al_hassan_warsha/core/utils/style/app_colors.dart';
import 'package:al_hassan_warsha/core/utils/widgets/custom_snack_bar.dart';
import 'package:al_hassan_warsha/features/gallery/data/models/kitchen_type.dart';
import 'package:al_hassan_warsha/features/gallery/presentation/manager/bloc/gallery_bloc.dart';
import 'package:al_hassan_warsha/features/gallery/presentation/views/widgets/all_kitchen_items_body.dart';
import 'package:al_hassan_warsha/features/gallery/presentation/views/widgets/gallery_body.dart';
import 'package:al_hassan_warsha/features/gallery/presentation/views/widgets/side_bar_gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    List<KitchenTypeModel> kitchenList = [];

    return BlocProvider(
      create: (context) => GalleryBloc(galleryRepoImp: getIt.get())
        ..add(CheckExistOfGalleryDataEvent()),
      child: BlocConsumer<GalleryBloc, GalleryState>(
          listenWhen: (previous, current) => current is GalleryOutSideState,
          buildWhen: (pervious, current) => current is! GalleryOutSideState,
          listener: (context, state) {
            var galleryBloc = context.read<GalleryBloc>();
            if (state is SuccessAddedNewKitchenType) {
              kitchenList.add(KitchenTypeModel(
                  typeId: state.typeId, typeName: state.typeName));
              Navigator.pop(context);
              showCustomSnackBar(
                context,
                "تم اضافة نوع جديد",
              );
              galleryBloc.add(UpdateCatchDataEvent(kitchenList: kitchenList));
            } else if (state is FailureCreateOrGetData) {
              showCustomSnackBar(context, " ${state.errMessage} ",
                  backgroundColor: AppColors.red);
            } else if (state is FailureAddedNewKitchenType) {
              Navigator.pop(context);
              showCustomSnackBar(context, " ${state.errMessage} ",
                  backgroundColor: AppColors.red);
            } else if (state is FetchKitchenTypeAfterChangeState) {
              int index = kitchenList.indexWhere(
                  (model) => model.typeId == state.kitchenTypeModel.typeId);
              kitchenList[index] = state.kitchenTypeModel;
              galleryBloc.add(UpdateCatchDataEvent(kitchenList: kitchenList));
            }
          },
          builder: (context, state) {
            var galleryBloc = context.read<GalleryBloc>();
            switch (state.runtimeType) {
              case const (LoadingCreateOrGetData):
                return const CircularProgressIndicator();
              case const (SuccessCreateOrGetData):
                final successState = state as SuccessCreateOrGetData;
                kitchenList = successState.kitchenTypesList;
                return Expanded(
                  child: Row(
                    children: [
                      Expanded(
                          child: SideBarGallery(
                              currIndex: galleryBloc.showingIndex,
                              changeIndex: (index) {
                                if (index != galleryBloc.showingIndex) {
                                  galleryBloc.add(ShowMoreKitcenTypeEvent(
                                      currIndex: index));
                                }
                              },
                              addType: (value) {
                                galleryBloc.add(
                                    AddNewKitchenTypeEvent(typeName: value));
                              },
                              typesList: kitchenList)),
                      Expanded(
                        flex: 4,
                        child: GalleryBody(
                          kitchenList: kitchenList,
                          bloc: galleryBloc,
                        ),
                      ),
                    ],
                  ),
                );
              case const (FailureCreateOrGetData):
                final failedStated = state as FailureCreateOrGetData;
                return Text("${failedStated.errMessage}");

              case const (ShowMoreOfKitchenTypeState):
                final showingState = state as ShowMoreOfKitchenTypeState;
                return Expanded(
                  child: Row(
                    children: [
                      Expanded(
                          child: SideBarGallery(
                              currIndex: showingState.currIndex,
                              changeIndex: (index) {
                                if (index != showingState.currIndex) {
                                  galleryBloc.add(ShowMoreKitcenTypeEvent(
                                      currIndex: index));
                                }
                              },
                              addType: (value) {
                                galleryBloc.add(
                                    AddNewKitchenTypeEvent(typeName: value));
                              },
                              typesList: kitchenList)),
                      Expanded(
                        flex: 4,
                        child: ShowingAllKitchenItemsGrid(
                          typeId: kitchenList[showingState.currIndex].typeId,
                          onBack: () {
                            galleryBloc.add(
                                UpdateCatchDataEvent(kitchenList: kitchenList));
                          },
                          kitchenList:
                              kitchenList[showingState.currIndex].kitchenList,
                          bloc: galleryBloc,
                          typeName:
                              kitchenList[showingState.currIndex].typeName,
                        ),
                      ),
                    ],
                  ),
                );

              default:
                return const SizedBox();
            }
          }),
    );
  }
}
