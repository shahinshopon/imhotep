import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:imhotep/models/product_model.dart';
import 'package:imhotep/screens/view_photo_screen.dart';
import 'package:imhotep/widgets/common_widgets/hotep_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

class ViewSingleProductScreen extends StatelessWidget {
  final Product product;
  const ViewSingleProductScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: whiteColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          color: blackColor,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'View Product',
          style: TextStyle(
            color: blackColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _imgBuilder(context),
              SizedBox(
                height: 20.0,
              ),
              _nameAndPriceBuilder(),
              SizedBox(
                height: 20.0,
              ),
              HotepButton.filled(
                value: 'View on Website',
                borderRadius: 10.0,
                onPressed: () async {
                  try {
                    if (await canLaunch(product.website)) {
                      await launch(product.website);
                    }
                  } catch (e) {
                    print(e);
                    print('Error!!!: Launching website');
                  }
                },
              ),
              if (product.description.trim().isNotEmpty)
                SizedBox(
                  height: 20.0,
                ),
              if (product.description.trim().isNotEmpty) _descriptionBuilder(),
              if (product.content.trim() != '<div></div>')
                SizedBox(
                  height: 20.0,
                ),
              if (product.content.trim() != '<div></div>')
                Html(
                  data: product.content,
                ),
              if (product.photos.isNotEmpty)
                SizedBox(
                  height: 20.0,
                ),
              if (product.photos.isNotEmpty) _galleryPhotosBuilder(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imgBuilder(final BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ViewPhotoScreen(
              photoUrl: product.displayPhoto,
            ),
          ),
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.width,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: greyColorshade200,
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              product.displayPhoto,
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _nameAndPriceBuilder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: TextStyle(
            fontSize: 17,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          '\$${product.price}',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ],
    );
  }

  Widget _descriptionBuilder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(
            fontSize: 17,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Linkify(
          onOpen: (link) async {
            try {
              if (await canLaunch(link.url)) {
                await launch(link.url);
              }
            } catch (e) {
              print(e);
              print('Error!!!: Opening link');
            }
          },
          text: product.description,
        ),
      ],
    );
  }

  Widget _galleryPhotosBuilder() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
      ),
      itemCount: product.photos.length,
      itemBuilder: (context, index) {
        final _photo = product.photos[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ViewPhotoScreen(photoUrl: _photo),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: greyColorshade200,
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  _photo,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
