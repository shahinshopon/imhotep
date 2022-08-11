import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:imhotep/enums/feed_subscription_type.dart';
import 'package:imhotep/enums/state_type.dart';
import 'package:imhotep/models/feed_extra_data_model.dart';
import 'package:imhotep/viewmodels/base_vm.dart';
import 'package:path_provider/path_provider.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

import '../models/maat_warrior_config_model.dart';
import '../services/firebase/database/maat_warrior_provider.dart';
import '../services/firebase/dynamic_link/dynamic_link_provider.dart';

class FeedShareVm extends BaseVm {
  final BuildContext context;
  FeedShareVm(this.context);

  String? _deepLink;

  Timer? _debounce;
  bool _searchActive = false;
  final TextEditingController _searchController = TextEditingController();
  bool _downloading = false;

  List<PeamanFollower> get followers =>
      context.watch<List<PeamanFollower>?>() ?? [];
  List<PeamanFollower> get following =>
      context.watch<List<PeamanFollower>?>() ?? [];
  List<PeamanChat> get chats => context.watch<List<PeamanChat>?>() ?? [];
  String? get deepLink => _deepLink;
  bool get searchActive => _searchActive;
  TextEditingController get searchController => _searchController;
  bool get downloading => _downloading;

  // init function
  void onInit({
    required final PeamanUser appUser,
    required final PeamanFeed feed,
  }) async {
    if (stateType != StateType.busy) {
      updateStateType(StateType.busy);

      final _premium =
          FeedExtraData.fromJson(feed.extraData).subscriptionType ==
              FeedSubscriptionType.paid;
      final _link = await DynamicLinkProvider.createPostShareLink(
        uid: appUser.uid!,
        feed: feed,
        premium: _premium,
      );
      _deepLink = _link;
      updateStateType(StateType.idle);
    }
  }

  // dispose function
  void onDispose() {
    _debounce?.cancel();
  }

  // send message
  Future<void> sendMessage(
    final PeamanFeed feed,
    final PeamanUser receiver,
  ) async {
    final _appUser = context.read<PeamanUser>();

    final _chatId = PeamanChatHelper.getChatId(
      myId: _appUser.uid!,
      friendId: receiver.uid!,
    );
    final _message = PeamanMessage(
      chatId: _chatId,
      senderId: _appUser.uid!,
      receiverId: receiver.uid!,
      type: PeamanMessageType.feedShare,
      extraId: feed.id,
    );

    PChatProvider.sendMessage(
      message: _message,
      onSuccess: (_) {
        PFeedProvider.updateFeed(
          feedId: feed.id!,
          data: {'shares_count': 1},
          partial: true,
        );
      },
    );

    // update maat warrior points
    final _maatWarriorConfig = context.read<MaatWarriorConfig>();
    if (_maatWarriorConfig.sharePostInsidePoints > 0) {
      MaatWarriorProvider.updateMaatWarriorPoints(
        uid: _appUser.uid!,
        points: _maatWarriorConfig.sharePostInsidePoints,
      );
    }
    //
  }

  // download feed photo or video
  void download(final PeamanFeed feed) async {
    if (!_downloading) {
      _updateDownloading(true);
      try {
        final _type = feed.type;

        switch (_type) {
          case PeamanFeedType.image:
            for (int i = 0; i < feed.photos.length; i++) {
              showToast(
                feed.photos.length > 1
                    ? 'Saving... ${i + 1} of ${feed.photos.length}'
                    : 'Saving...',
              );
              final _photo = feed.photos[i];
              await ImageDownloader.downloadImage(
                _photo,
                outputMimeType: 'image/jpeg',
              );
            }
            break;
          case PeamanFeedType.video:
            final _tempDir = await getTemporaryDirectory();
            for (int i = 0; i < feed.videos.length; i++) {
              showToast('Saving Video... This may take a while.');
              final _video = feed.videos[i];
              final _path = '${_tempDir.path}/${feed.id}_$i.mp4';

              await Dio().download(_video, _path);
              await GallerySaver.saveVideo(_path);
            }
            break;
          case PeamanFeedType.other:
            final _feedExtraData = FeedExtraData.fromJson(feed.extraData);
            if (_feedExtraData.article != null) {
              for (int i = 0; i < _feedExtraData.article!.photos.length; i++) {
                showToast(
                  _feedExtraData.article!.photos.length > 1
                      ? 'Saving... ${i + 1} of ${_feedExtraData.article!.photos.length}'
                      : 'Saving...',
                );
                final _photo = _feedExtraData.article!.photos[i];
                await ImageDownloader.downloadImage(
                  _photo,
                  outputMimeType: 'image/jpeg',
                );
              }
            }
            break;
          default:
        }

        showToast('Saved');
      } catch (e) {
        print(e);
        showToast('An unexpected error occured!');
      }
      _updateDownloading(false);
    }
  }

  // get non repeating users list
  List<String> getNonRepeatingUsersList(
    final List<String> userIds,
  ) {
    final _users = <String>[];

    userIds.forEach((element) {
      if (!_users.contains(element)) {
        _users.add(element);
      }
    });

    return _users;
  }

  // create debounce
  void createDebounce() {
    updateStateType(StateType.busy);
    _updateSearchActive(false);
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 500), () {
      _updateSearchActive(_searchController.text.trim() != '');
      updateStateType(StateType.idle);
    });
  }

  // update value of searchActive
  void _updateSearchActive(final bool newVal) {
    _searchActive = newVal;
    notifyListeners();
  }

  // update value of download
  void _updateDownloading(final bool newVal) {
    _downloading = newVal;
    notifyListeners();
  }
}
