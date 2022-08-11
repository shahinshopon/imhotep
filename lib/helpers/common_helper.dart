import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:imhotep/models/app_user_extra_data_model.dart';
import 'package:imhotep/models/custom_ad_model.dart';
import 'package:imhotep/models/editor_access_config_mode.dart';
import 'package:imhotep/models/maat_warrior_config_model.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

import '../enums/subscription_type.dart';
import '../models/ad_config.dart';

class CommonHelper {
  // limit text and show them
  static String limitedText(
    final String? text, {
    final int? limit,
  }) {
    final _text = text ?? '';
    if (limit != null) {
      return _text.length > limit
          ? '${_text.substring(0, limit).trim()}...'
          : _text;
    }
    return _text;
  }

  // check if app user is maat warrior or not
  static bool isMaatWarrior(
    final BuildContext context, {
    final PeamanUser? user,
  }) {
    final _appUser = user ?? context.watch<PeamanUser>();
    final _maatWarriorConfig = context.watch<MaatWarriorConfig>();

    final _appUserExtraData = AppUserExtraData.fromJson(_appUser.extraData);

    return _appUserExtraData.maatWarriorPoints >=
        _maatWarriorConfig.targetPoint;
  }

  // get user subscription status
  static SubscriptionType subscriptionType(
    final BuildContext context, {
    final PeamanUser? user,
  }) {
    final _appUser = user ?? context.watch<PeamanUser>();
    final _appUserExtraData = AppUserExtraData.fromJson(_appUser.extraData);

    return _appUserExtraData.subscriptionType;
  }

  // check if app user can create post
  static bool canCreatePost(
    final BuildContext context, {
    final PeamanUser? user,
  }) {
    final _appUser = user ?? context.watch<PeamanUser>();
    final _editorAccessConfig = context.watch<EditorAccessConfig>();

    final _admin = _appUser.admin;
    final _editor = _appUser.editor;
    final _canCreatePost = _editorAccessConfig.createPost;

    return _admin || (_editor && _canCreatePost);
  }

  // check if app user can create story
  static bool canCreateStory(
    final BuildContext context, {
    final PeamanUser? user,
  }) {
    final _appUser = user ?? context.watch<PeamanUser>();
    final _editorAccessConfig = context.watch<EditorAccessConfig>();

    final _admin = _appUser.admin;
    final _editor = _appUser.editor;
    final _appUserExtraData = AppUserExtraData.fromJson(_appUser.extraData);
    final _canCreateStory = _editorAccessConfig.createStory;

    return _admin ||
        (_editor && _canCreateStory) ||
        _appUserExtraData.subscriptionType == SubscriptionType.level2 ||
        _appUserExtraData.subscriptionType == SubscriptionType.level3;
  }

  // check if app user can create contest
  static bool canCreateContest(
    final BuildContext context, {
    final PeamanUser? user,
  }) {
    final _appUser = user ?? context.watch<PeamanUser>();
    final _editorAccessConfig = context.watch<EditorAccessConfig>();

    final _admin = _appUser.admin;
    final _editor = _appUser.editor;
    final _canCreateContest = _editorAccessConfig.createContest;

    return _admin || (_editor && _canCreateContest);
  }

  // check if app user can update articles
  static bool canUpdateArticles(
    final BuildContext context, {
    final PeamanUser? user,
  }) {
    final _appUser = user ?? context.watch<PeamanUser>();
    final _editorAccessConfig = context.watch<EditorAccessConfig>();

    final _admin = _appUser.admin;
    final _editor = _appUser.editor;
    final _canUpdateArticles = _editorAccessConfig.updateArticles;

    return _admin || (_editor && _canUpdateArticles);
  }

  // check if app user can create custom ad
  static bool canCreateCustomAd(
    final BuildContext context, {
    final PeamanUser? user,
  }) {
    final _appUser = user ?? context.watch<PeamanUser>();
    final _editorAccessConfig = context.watch<EditorAccessConfig>();

    final _admin = _appUser.admin;
    final _editor = _appUser.editor;
    final _canCreateCustomAd = _editorAccessConfig.createCustomAd;

    return _admin || (_editor && _canCreateCustomAd);
  }

  // check if app user can create custom notification
  static bool canCreateCustomNotification(
    final BuildContext context, {
    final PeamanUser? user,
  }) {
    final _appUser = user ?? context.watch<PeamanUser>();
    final _editorAccessConfig = context.watch<EditorAccessConfig>();

    final _admin = _appUser.admin;
    final _editor = _appUser.editor;
    final _canCreateCustomNotification =
        _editorAccessConfig.createCustomNotification;

    return _admin || (_editor && _canCreateCustomNotification);
  }

  // check if app user can create in app alert
  static bool canCreateInAppAlert(
    final BuildContext context, {
    final PeamanUser? user,
  }) {
    final _appUser = user ?? context.watch<PeamanUser>();
    final _editorAccessConfig = context.watch<EditorAccessConfig>();

    final _admin = _appUser.admin;
    final _editor = _appUser.editor;
    final _canCreateInAppAlert = _editorAccessConfig.createInAppAlert;

    return _admin || (_editor && _canCreateInAppAlert);
  }

  // get a random custom ad
  static CustomAd? getRandomCustomAd({
    required final BuildContext context,
  }) {
    CustomAd? _randomAd;
    final _random = Random();
    final _randDoubleForShowingAd = (_random.nextInt(99) + 1).toDouble();

    final _ads = context.read<List<CustomAd>>();
    final _adConfig = context.read<AdConfig>();

    // get the maximum value of priority from all the ads
    double _maxPriority = 1.0;
    _ads.forEach((element) {
      if (element.priority > _maxPriority) {
        _maxPriority = element.priority;
      }
    });
    //

    // select a random number between 1 and _maxPriority
    final _randDoubleForSelectingRandomAd = _maxPriority == 1.0
        ? 1.0
        : (_random.nextInt(_maxPriority.toInt()) + 1).toDouble();
    //

    // get _newAds list on the basis of priority
    final _newAds = <CustomAd>[];
    _ads.forEach((element) {
      if (element.priority >= _randDoubleForSelectingRandomAd) {
        _newAds.add(element);
      }
    });
    //

    if (_randDoubleForShowingAd <= _adConfig.chancesToShowCustomAds) {
      _newAds.shuffle();
      if (_newAds.isNotEmpty) {
        _randomAd = _newAds.first;
      }
    }

    return _randomAd;
  }
}
