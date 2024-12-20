import 'package:al_hassan_warsha/core/utils/style/app_colors.dart';
import 'package:al_hassan_warsha/core/utils/style/app_fonts.dart';
import 'package:al_hassan_warsha/core/utils/widgets/custom_push_button.dart';
import 'package:al_hassan_warsha/features/gallery/data/models/kitchen_model.dart';
import 'package:al_hassan_warsha/features/gallery/presentation/manager/view_edit_add_bloc/bloc/view_edit_add_bloc.dart';
import 'package:al_hassan_warsha/features/gallery/presentation/views/widgets/add_kitchen_widgets/custom_media_list_with_pagination.dart';
import 'package:al_hassan_warsha/features/gallery/presentation/views/widgets/add_kitchen_widgets/empyt_upload_media.dart';
import 'package:al_hassan_warsha/features/gallery/presentation/views/widgets/custom_text_form_with_text.dart';
import 'package:flutter/material.dart';

class EditKitchenView extends StatefulWidget {
  const EditKitchenView(
      {super.key,
      required this.model,
      required this.pickedList,
      required this.bloc});
  final List<PickedMedia> pickedList;
  final KitchenModel model;
  final ViewEditAddBloc bloc;
  @override
  State<EditKitchenView> createState() => _EditKitchenViewState();
}

class _EditKitchenViewState extends State<EditKitchenView> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController editNameController = TextEditingController();
  final TextEditingController editDescribeController = TextEditingController();
  List<String> addedList = [];
  List<PickedMedia> removedList = [];

  @override
  void initState() {
    editNameController.text = widget.model.kitchenName ?? "";
    editDescribeController.text = widget.model.kitchenDesc ?? "";
    super.initState();
  }

  @override
  void dispose() {
    editNameController.dispose();
    editDescribeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0,vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: width * 0.5,
                child: CustomColumnWithTextInAddNewType(
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "الاسم لا يمكن ان يكون خاليا ";
                    }
                    return null;
                  },
                  controller: editNameController,
                  textStyle: AppFontStyles.extraBoldNew21(context),
                  text: "الاسم",
                  textLabel: "اضف اسم للمنتج................",
                  enableBorder: true,
                )),
            const SizedBox(
              height: 12,
            ),
            CustomColumnWithTextInAddNewType(
              controller: editDescribeController,
              textStyle: AppFontStyles.extraBoldNew21(context),
              maxLine: 2,
              text: "الوصف",
              textLabel:
                  "اضف بعض الوصف للمنتج ليساعدك في شرح المنتج للعميل...................",
              enableBorder: true,
            ),
            const SizedBox(
              height: 22,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "الوسائط",
                  style: AppFontStyles.extraBoldNew21(context),
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  "( ${widget.model.mediaCounter} )",
                  style: AppFontStyles.extraBoldNew20(context),
                ),
              ],
            ),
            const SizedBox(
              height: 22,
            ),
            widget.pickedList.isNotEmpty
                ? MediaListInEditView(
                    addMore: (media) {
                      addedList.addAll(media);
        
                      widget.bloc.add(
                          RecieveMediaToAddMoreInEditEvent(medialList: media));
                    },
                    pickedList: widget.pickedList,
                    removeIndex: (index) {
                      removedList.add(widget.pickedList[index]);
                      widget.bloc.add(RemovePickedMediaIndexEvent(index: index));
                      addedList.remove(widget.pickedList[index].mediaPath);
                    },
                    fetchMoreKitchen: () {
                      widget.model.mediaCounter >= 5
                          ? widget.bloc.add(ShowMoreHorizontalMedia(
                              kitchenId: widget.model.kitchenId,
                              offset: (widget.pickedList.length -
                                  addedList.length +
                                  removedList.length)))
                          : () {
                            
                          };
                    },
                    enableShowMore: widget.bloc.isLoadingEnabled,
                  )
                : EmptyUploadMedia(
                  isReadOnly: false,
                    addMedia: (media) {
                      addedList.addAll(media);
                      widget.bloc.add(RecieveMediaToAddEvent(medialList: media));
                    },
                  ),
            const SizedBox(
              height: 32,
            ),
            Center(
                child: CustomPushContainerButton(
              onTap: () {
                if (formKey.currentState!.validate()) {
                  widget.model.kitchenName = editNameController.text;
                  widget.model.kitchenDesc = editDescribeController.text;
                  widget.model.mediaCounter +=
                      (addedList.length - removedList.length);
                  widget.bloc.add(EditKitchenEvent(
                      addedItems: addedList,
                      model: widget.model,
                      deletedItems: removedList,
                      pickedMediaList: widget.pickedList));
                }
              },
              childInstead: widget.bloc.isLoding?const CircularProgressIndicator(color: AppColors.white,):Text("تعديل",style: AppFontStyles.extraBoldNew24(context).copyWith(color: AppColors.white,)),
              borderRadius: 15,
              padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 12),
              enableIcon: false,
            )),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}
