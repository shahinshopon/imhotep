import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imhotep/enums/state_type.dart';
import 'package:imhotep/models/feed_extra_data_model.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:peaman/peaman.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../enums/feed_subscription_type.dart';

class CreatePostVm extends BaseVm {
  final BuildContext context;
  CreatePostVm(this.context);

  TextEditingController _captionController = TextEditingController();
  List<File> _files = [];
  List<File> _videoThumbnails = [];
  PeamanFeedType _selectedFeedType = PeamanFeedType.image;
  FeedSubscriptionType _selectedFeedSubscriptionType =
      FeedSubscriptionType.free;
  BoxFit _selectedVideoFitness = BoxFit.cover;
  int _adPosition = -1;

  TextEditingController get captionController => _captionController;
  List<File> get files => _files;
  List<File> get vidThumbnails => _videoThumbnails;
  List<PeamanFeedType> get feedTypes => [
        PeamanFeedType.image,
        PeamanFeedType.video,
      ];
  List<FeedSubscriptionType> get feedSubscriptionTypes => [
        FeedSubscriptionType.free,
        FeedSubscriptionType.paid,
      ];
  List<String> get feedTypeStrings => [
        'Image',
        'Video',
      ];
  List<String> get feedSubscriptionTypeStrings => [
        'Free',
        'Premium',
      ];
  PeamanFeedType get selectedFeedType => _selectedFeedType;
  FeedSubscriptionType get selectedFeedSubscriptionType =>
      _selectedFeedSubscriptionType;
  BoxFit get selectedVideoFitness => _selectedVideoFitness;
  int get adPosition => _adPosition;

  // init function
  void onInit({final PeamanFeed? feedToUpdate}) {
    if (feedToUpdate != null) {
      _initializeValues(feedToUpdate);
    }
  }

  // initialize values
  void _initializeValues(final PeamanFeed feedToUpdate) {
    _captionController.text = '${feedToUpdate.caption}';
    _selectedVideoFitness = BoxFit.values[feedToUpdate.extraData['fit'] ?? 2];
    _selectedFeedType = feedToUpdate.type;
    _selectedFeedSubscriptionType = FeedExtraData.fromJson(
      feedToUpdate.extraData,
    ).subscriptionType;
    _adPosition = FeedExtraData.fromJson(
      feedToUpdate.extraData,
    ).adPosition;

    _files = (_selectedFeedType == PeamanFeedType.image
            ? feedToUpdate.photos
            : feedToUpdate.videos)
        .map((e) => File('$e\_firebase_img123'))
        .toList();
    _videoThumbnails = feedToUpdate.photos
        .map(
          (e) => File('$e\_firebase_img123'),
        )
        .toList();
    updateStateType(StateType.idle);
  }

  // create post
  void createPost(final PeamanUser appUser) async {
    final _currentDate = DateTime.now();
    FocusScope.of(context).unfocus();
    if (_captionController.text.trim() == '')
      return showToast('Please enter a caption!');
    if (_files.isEmpty)
      return showToast('Please select atleast 1 image or video!');

    final _uploadPath =
        '${_selectedFeedType == PeamanFeedType.image ? 'posts_imgs' : 'posts_vids'}/${appUser.uid}/${_currentDate.millisecondsSinceEpoch}';

    updateStateType(StateType.busy);

    final _urls = await PStorageProvider.uploadFiles(
      _uploadPath,
      _files,
    );

    if (_urls == null || _urls.isEmpty) {
      updateStateType(StateType.idle);
      return showToast(
        'An unexpected error occured while uploading images or videos!',
      );
    }

    late PeamanFeed _feed;

    if (_selectedFeedType == PeamanFeedType.image) {
      _feed = PeamanFeed(
        ownerId: appUser.uid,
        caption: _captionController.text.trim(),
        photos: _urls,
        searchKeys: _getSearchKeys(),
        type: PeamanFeedType.image,
        extraData: {
          'subscription_type': _selectedFeedSubscriptionType.index,
          'ad_position': _adPosition,
        },
      );
    } else {
      final _thumbnailUrl = await PStorageProvider.uploadFiles(
        'posts_imgs/${appUser.uid}/${_currentDate.millisecondsSinceEpoch}',
        _videoThumbnails,
      );

      _feed = PeamanFeed(
        ownerId: appUser.uid,
        caption: _captionController.text.trim(),
        photos: _thumbnailUrl ?? [],
        videos: _urls,
        searchKeys: _getSearchKeys(),
        type: PeamanFeedType.video,
        extraData: {
          'fit': _selectedVideoFitness.index,
          'subscription_type': _selectedFeedSubscriptionType.index,
          'ad_position': _adPosition,
        },
      );
    }

    await PFeedProvider.createFeed(
      feed: _feed,
      onSuccess: (post) async {
        showToast('Post created successfully!');
        _captionController.clear();
        _files = [];
        _videoThumbnails = [];
        updateStateType(StateType.idle);
      },
      onError: (e) {
        showToast('An unexpected error occured while creating post!');
      },
    );
  }

  // edit post
  void editPost(
    final PeamanUser appUser,
    final PeamanFeed feedToUpdate,
  ) async {
    final _currentDate = DateTime.now();
    FocusScope.of(context).unfocus();
    if (_captionController.text.trim() == '')
      return showToast('Please enter a caption!');
    if (_files.isEmpty)
      return showToast(
        'Please select atleast 1 image or video!',
      );

    final _uploadPath =
        '${_selectedFeedType == PeamanFeedType.image ? 'posts_imgs' : 'posts_vids'}/${appUser.uid}/${_currentDate.millisecondsSinceEpoch}';

    final _firebaseFiles = _files
        .where((element) => element.path.contains('_firebase_img123'))
        .map((e) => e.path.replaceAll('_firebase_img123', ''))
        .toList();

    final _localFiles = _files
        .where((element) => !element.path.contains('_firebase_img123'))
        .toList();

    updateStateType(StateType.busy);

    var _urls = await PStorageProvider.uploadFiles(
      _uploadPath,
      _localFiles,
    );

    late PeamanFeed _feed;

    if (_selectedFeedType == PeamanFeedType.image) {
      _feed = PeamanFeed(
        caption: _captionController.text.trim(),
        photos: [...(_urls ?? []), ..._firebaseFiles],
        searchKeys: _getSearchKeys(),
        type: PeamanFeedType.image,
        extraData: {
          'subscription_type': _selectedFeedSubscriptionType.index,
          'ad_position': _adPosition,
        },
      );
    } else {
      final _firebaseThumbnails = _videoThumbnails
          .where((element) => element.path.contains('_firebase_img123'))
          .map((e) => e.path.replaceAll('_firebase_img123', ''))
          .toList();
      final _localThumbnails = _videoThumbnails
          .where((element) => !element.path.contains('_firebase_img123'))
          .toList();

      var _thumbnailUrls = await PStorageProvider.uploadFiles(
        'posts_imgs/${appUser.uid}/${_currentDate.millisecondsSinceEpoch}',
        _localThumbnails,
      );

      _feed = PeamanFeed(
        caption: _captionController.text.trim(),
        photos: [...(_thumbnailUrls ?? []), ..._firebaseThumbnails],
        videos: [...(_urls ?? []), ..._firebaseFiles],
        searchKeys: _getSearchKeys(),
        type: PeamanFeedType.video,
        extraData: {
          'fit': _selectedVideoFitness.index,
          'subscription_type': _selectedFeedSubscriptionType.index,
          'ad_position': _adPosition,
        },
      );
    }

    await PFeedProvider.updateFeed(
      feedId: feedToUpdate.id!,
      data: _feed.toJson(),
      onSuccess: (_) {
        showToast('Post updated successfully!');
        _captionController.clear();
        _files = [];
        updateStateType(StateType.idle);
      },
      onError: (e) {
        showToast('An unexpected error occured while updating post!');
      },
    );
  }

  // edit photos
  void editImage(final File img, final int index) async {
    final _pickedImg = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (_pickedImg != null) {
      final _newImg = File(_pickedImg.path);
      if (_selectedFeedType == PeamanFeedType.image) {
        if (_files.length > index) {
          _files[index] = _newImg;
        }
      } else {
        if (_videoThumbnails.length > index) {
          _videoThumbnails[index] = _newImg;
        }
      }
      notifyListeners();
    }
  }

  // get search keys from caption
  List<String> _getSearchKeys() {
    var _searchKeys = <String>[];
    final _longCaption = _captionController.text.trim();
    final _longCaptions = _longCaption.split(' ');

    final _caption = _longCaption.length > 300
        ? _longCaption.substring(0, 300)
        : _longCaption;
    final _captions = _caption.split(' ');

    // get hashtags
    for (int i = 0; i < _longCaptions.length; i++) {
      final _word = _longCaptions[i];
      final _words = _word.split('\n');

      for (int j = 0; j < _words.length; j++) {
        var _newWord = _words[j];

        if (_newWord.contains('#')) {
          _newWord = _newWord.replaceAll('#', '');

          for (int k = 0; k < _newWord.length; k++) {
            final _letter = _newWord.substring(0, k + 1);
            if (!_searchKeys.contains(_letter.toUpperCase())) {
              _searchKeys.add(_letter.toUpperCase());
            }
          }
        }
      }
    }
    //

    // split letters of caption
    for (int i = 0; i < _caption.length; i++) {
      final _letter = _caption.substring(0, i + 1);
      if (!_searchKeys.contains(_letter.toUpperCase())) {
        _searchKeys.add(_letter.toUpperCase());
      }
    }
    //

    // split letters of captions
    for (int i = 0; i < _captions.length; i++) {
      for (int j = 0; j < _captions[i].length; j++) {
        final _letter = _captions[i].substring(0, j + 1);
        if (!_searchKeys.contains(_letter.toUpperCase())) {
          _searchKeys.add(_letter.toUpperCase());
        }
      }
    }
    //

    return _searchKeys
        .where((element) =>
            element.trim() != '' &&
            element.trim() != ',' &&
            element.trim() != '.')
        .toList();
  }

  // upload additional files
  void uploadAdditionalFiles() async {
    final _pickedFiles = _selectedFeedType == PeamanFeedType.image
        ? await ImagePicker().pickMultiImage()
        : [await ImagePicker().pickVideo(source: ImageSource.gallery)];
    if (_pickedFiles != null &&
        _pickedFiles.isNotEmpty &&
        _pickedFiles.first != null) {
      final _newImgs = _pickedFiles.map((e) => File(e!.path)).toList();

      // for video we need thumbnails too
      if (_selectedFeedType == PeamanFeedType.video) {
        final _thumbnail = await VideoThumbnail.thumbnailFile(
          video: File(_pickedFiles.first!.path).uri.path,
          imageFormat: ImageFormat.WEBP,
        );

        if (_thumbnail != null) {
          final _newThumbnail = File(_thumbnail);
          updateVideoThumbnails([_newThumbnail, ..._videoThumbnails]);
        }
      }
      //

      updateFiles([..._newImgs, ..._files]);
    }
  }

  // compress file
  Future<File?> compressFile(File file) async {
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 60,
    );
    return result;
  }

  // remove file
  void removeFile(final File removeImg) {
    final _newFiles = _files;

    if (_selectedFeedType == PeamanFeedType.image) {
      _newFiles.remove(removeImg);
    } else {
      _videoThumbnails.remove(removeImg);
    }

    updateFiles(_newFiles);
  }

  // update value of files
  void updateFiles(final List<File> newVal) {
    _files = newVal;
    notifyListeners();
  }

  // update value of videoThumbnails
  void updateVideoThumbnails(final List<File> newVal) {
    _videoThumbnails = newVal;
    notifyListeners();
  }

  // update value of selectedFeedType
  void updateSelectedFeedType(final PeamanFeedType newVal) {
    _selectedFeedType = newVal;
    _files = [];
    notifyListeners();
  }

  // update value of selectedVideoFitness
  void updateSelectedVideoFitness(final BoxFit newVal) {
    _selectedVideoFitness = newVal;
    notifyListeners();
  }

  // update value of selectedFeedSubscriptionType
  void updateSelectedFeedSubscriptionType(final FeedSubscriptionType newVal) {
    _selectedFeedSubscriptionType = newVal;
    notifyListeners();
  }

  // update value of adPosition
  void updateAdPosition(final int newVal) {
    _adPosition = newVal;
    notifyListeners();
  }
}
