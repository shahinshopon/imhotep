import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:imhotep/models/article_model.dart';
import 'package:imhotep/screens/view_photo_screen.dart';
import 'package:imhotep/services/ads/google_ads_provider.dart';
import 'package:imhotep/viewmodels/view_single_article_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';
import 'package:imhotep/widgets/feed_widgets/feed_action_buttons.dart';
import 'package:imhotep/widgets/feed_widgets/feeds_list.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../models/feed_extra_data_model.dart';
import '../widgets/ads_widgets/banner_ad_widget.dart';
import '../widgets/common_widgets/hotep_button.dart';
import '../widgets/feed_widgets/feed_carousel_slider.dart';

class ViewSingleArticleScreen extends StatelessWidget {
  final PeamanFeed feed;
  const ViewSingleArticleScreen({
    Key? key,
    required this.feed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _article = FeedExtraData.fromJson(feed.extraData).article;
    if (_article == null) return Container();

    final _appUser = context.watch<PeamanUser>();

    return VMProvider<ViewSingleArticleVm>(
      vm: ViewSingleArticleVm(context),
      onInit: (vm) => vm.onInit(
        thisFeed: feed,
        appUser: _appUser,
      ),
      builder: (context, vm, appVm, appUser) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, vm.feed);
            return true;
          },
          child: Scaffold(
            backgroundColor: whiteColor,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: whiteColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_rounded),
                color: blackColor,
                onPressed: () => Navigator.pop(context, vm.feed),
              ),
              title: Text(
                'View Article',
                style: TextStyle(
                  color: blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FeedCarouselSlider.image(
                    images: _article.photos,
                    onPressed: (list, index) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ViewPhotoScreen(
                            photoUrl: list[index],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  FeedActionButtons(
                    feed: vm.feed,
                    onFeedUpdate: (val) {
                      vm.updateFeed(val);
                      GoogleAdsProvider.loadInterstitialAd(
                        context: context,
                      );
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        _titleBuilder(_article),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      children: [
                        Html(
                          data: _article.content,
                          onLinkTap: (link, rContext, data, element) async {
                            if (link != null) {
                              try {
                                await launch(link);
                              } catch (e) {
                                print(e);
                              }
                            }
                          },
                          onImageTap: (url, rContext, data, element) {
                            if (url == null) return;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ViewPhotoScreen(photoUrl: url),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        FeedActionButtons(
                          feed: vm.feed,
                          onFeedUpdate: vm.updateFeed,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        HotepBannerAd(),
                        SizedBox(
                          height: 20.0,
                        ),
                        HotepButton.filled(
                          value: 'View on Website',
                          borderRadius: 10.0,
                          onPressed: () async {
                            try {
                              if (await canLaunch(_article.website)) {
                                await launch(_article.website);
                              }
                            } catch (e) {
                              print(e);
                              print('Error!!!: Launching website');
                            }
                          },
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        _recommendedArticlesBuilder(vm),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _titleBuilder(final Article article) {
    return Text(
      article.title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: blueColor,
        fontSize: 22.0,
      ),
    );
  }

  Widget _recommendedArticlesBuilder(final ViewSingleArticleVm vm) {
    final _allArticles = vm.allFeeds
        .where((element) => element.type == PeamanFeedType.other)
        .toList();
    _allArticles.shuffle();

    final _filteredArticles = _allArticles.sublist(
      0,
      _allArticles.length < 6 ? _allArticles.length : 6,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'See recommended:',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        FeedsList.grid(
          feeds: _filteredArticles,
          crossAxisCount: 2,
          withText: true,
        ),
      ],
    );
  }
}
