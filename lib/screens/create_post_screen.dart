import 'package:flutter/material.dart';
import 'package:imhotep/constants.dart';
import 'package:imhotep/enums/feed_subscription_type.dart';
import 'package:imhotep/enums/state_type.dart';
import 'package:imhotep/viewmodels/create_post_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';
import 'package:imhotep/widgets/common_widgets/hotep_button.dart';
import 'package:imhotep/widgets/common_widgets/hotep_text_input.dart';
import 'package:imhotep/widgets/create_post_widgets/upload_images_list.dart';
import 'package:peaman/peaman.dart';
import '../widgets/common_widgets/common_appbar.dart';
import '../widgets/common_widgets/rounded_icon_button.dart';

class CreatePostScreen extends StatelessWidget {
  final PeamanFeed? feedToUpdate;

  const CreatePostScreen({
    Key? key,
    this.feedToUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VMProvider<CreatePostVm>(
      vm: CreatePostVm(context),
      onInit: (vm) => vm.onInit(
        feedToUpdate: feedToUpdate,
      ),
      builder: (context, vm, appVm, appUser) {
        return SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60.0),
              child: CommonAppbar(
                title: Text(
                  'Create Post',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Color(0xff3D4A5A),
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    _typeSelectorBuilder(vm),
                    SizedBox(
                      height: 20.0,
                    ),
                    _subscriptionTypeSelectorBuilder(vm),
                    SizedBox(
                      height: 20.0,
                    ),
                    _imagesBuilder(vm),
                    if (vm.selectedFeedType == PeamanFeedType.video)
                      SizedBox(
                        height: 20.0,
                      ),
                    if (vm.selectedFeedType == PeamanFeedType.video)
                      _videoFitnessBuilder(vm),
                    _textInputBuilder(
                      title: 'Enter caption:',
                      hintText: 'Caption',
                      controller: vm.captionController,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    if (vm.files.isNotEmpty) _adPositionSelectorBuilder(vm),
                    if (vm.files.isNotEmpty)
                      SizedBox(
                        height: 20.0,
                      ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(10.0),
              child: HotepButton.filled(
                value: feedToUpdate != null ? 'Update Post' : 'Create Post',
                borderRadius: 15.0,
                loading: vm.stateType == StateType.busy,
                onPressed: () {
                  feedToUpdate != null
                      ? vm.editPost(appUser!, feedToUpdate!)
                      : vm.createPost(appUser!);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _typeSelectorBuilder(final CreatePostVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select post type:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff3D4A5A),
          ),
        ),
        DropdownButton<PeamanFeedType>(
          value: vm.selectedFeedType,
          isExpanded: true,
          items: vm.feedTypes.map((e) {
            return DropdownMenuItem<PeamanFeedType>(
              value: e,
              child: Text(
                vm.feedTypeStrings[e.index],
              ),
            );
          }).toList(),
          onChanged: (val) => vm.updateSelectedFeedType(val!),
        ),
      ],
    );
  }

  Widget _subscriptionTypeSelectorBuilder(final CreatePostVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select free or premium:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff3D4A5A),
          ),
        ),
        DropdownButton<FeedSubscriptionType>(
          value: vm.selectedFeedSubscriptionType,
          isExpanded: true,
          items: vm.feedSubscriptionTypes.map((e) {
            return DropdownMenuItem<FeedSubscriptionType>(
              value: e,
              child: Text(
                vm.feedSubscriptionTypeStrings[e.index],
              ),
            );
          }).toList(),
          onChanged: (val) => vm.updateSelectedFeedSubscriptionType(val!),
        ),
      ],
    );
  }

  Widget _adPositionSelectorBuilder(final CreatePostVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select ad position:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff3D4A5A),
          ),
        ),
        DropdownButton<int>(
          value: vm.adPosition,
          isExpanded: true,
          items: [
            DropdownMenuItem<int>(
              value: -1,
              child: Text(
                'None',
              ),
            ),
            for (var i = 0; i <= vm.files.length; i++)
              DropdownMenuItem<int>(
                value: i,
                child: Text(
                  i == 0
                      ? 'First'
                      : i == vm.files.length
                          ? 'Last'
                          : 'Between $i and ${i + 1}',
                ),
              ),
          ],
          onChanged: (val) => vm.updateAdPosition(val!),
        ),
      ],
    );
  }

  Widget _videoFitnessBuilder(final CreatePostVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select video fitness:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff3D4A5A),
          ),
        ),
        DropdownButton<BoxFit>(
          value: vm.selectedVideoFitness,
          isExpanded: true,
          items: [2, 1].map((e) {
            final _fitnessString = e == 2 ? 'Cover' : 'Contain';
            return DropdownMenuItem<BoxFit>(
              value: BoxFit.values[e],
              child: Text(
                _fitnessString,
              ),
            );
          }).toList(),
          onChanged: (val) => vm.updateSelectedVideoFitness(val!),
        ),
      ],
    );
  }

  Widget _imagesBuilder(final CreatePostVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              vm.selectedFeedType == PeamanFeedType.image
                  ? 'Select images:'
                  : 'Select videos:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff3D4A5A),
              ),
            ),
            RoundIconButton(
              padding: const EdgeInsets.all(8.0),
              icon: Icon(Icons.add_rounded),
              shadow: BoxShadow(
                color: blueColor.withOpacity(0.3),
                blurRadius: 20.0,
                offset: Offset(5.0, 5.0),
              ),
              onPressed: vm.uploadAdditionalFiles,
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        if ((vm.selectedFeedType == PeamanFeedType.image
                ? vm.files
                : vm.vidThumbnails)
            .isNotEmpty)
          UploadImagesList(
            imgFiles: vm.selectedFeedType == PeamanFeedType.image
                ? vm.files
                : vm.vidThumbnails,
            onDelete: vm.removeFile,
            onEdit: vm.editImage,
          ),
      ],
    );
  }

  Widget _textInputBuilder({
    required final String title,
    required final String hintText,
    required final TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.0,
        ),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff3D4A5A),
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        HotepTextInput.bordered(
          hintText: hintText,
          controller: controller,
          textInputType: TextInputType.multiline,
          requiredCapitalization: false,
          isExpanded: true,
        ),
      ],
    );
  }
}
