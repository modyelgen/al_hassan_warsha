import 'package:al_hassan_warsha/core/utils/functions/extentions.dart';
import 'package:al_hassan_warsha/features/gallery/data/models/kitchen_model.dart';
import 'package:al_hassan_warsha/features/gallery/presentation/views/widgets/add_kitchen_widgets/empyt_upload_media.dart';
import 'package:al_hassan_warsha/features/management_workshop/data/models/extra_model.dart';
import 'package:al_hassan_warsha/features/management_workshop/presentation/views/widgets/add_edit_view_order/add_more_extra.dart';
import 'package:al_hassan_warsha/features/management_workshop/presentation/views/widgets/mobile_layout/media_grid_in_mobile.dart';
import 'package:flutter/material.dart';

class SecondPageInOrderMobile extends StatelessWidget {
  const SecondPageInOrderMobile({
    super.key,
    required this.list,
    required this.mediaOrderList,
    this.addMoreExtras,
    this.removeItemFromExtras,
    this.addMedia,
    this.addMoreMedia,
    this.removeMedia,
  });
  final List<ExtraInOrderModel> list;
  final void Function()? addMoreExtras;
  final void Function(int)? removeItemFromExtras;
  final List<PickedMedia> mediaOrderList;
  final void Function(List<String>)? addMoreMedia;
  final void Function(List<String>)? addMedia;
  final void Function(int)? removeMedia;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AddsForOrder(
                  addWidth: context.screenWidth * 0.425,
                  list: list,
                  addMore: addMoreExtras,
                  removeItem: removeItemFromExtras,
                ),
                const SizedBox(
                  height: 12,
                ),
                mediaOrderList.isNotEmpty
                    ? CustomGridMediaInMobile(
                        addMediaMore: addMoreMedia,
                        pickedMediaList: mediaOrderList,
                        enableClear: true,
                        removeIndex: removeMedia,
                      )
                    : EmptyUploadMedia(
                        edgeInsets: const EdgeInsets.symmetric(vertical: 25),
                        fontSize: 18,
                        addMedia: addMedia,
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
