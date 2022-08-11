// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:better_player/better_player.dart';
// import 'package:imhotep/constants.dart';
// import 'package:imhotep/screens/comments.dart';
// import 'package:imhotep/widgets/comment_container.dart';
// import 'package:readmore/readmore.dart';
// import 'package:share/share.dart';
// import 'package:clipboard/clipboard.dart';

// class VideoDetailScreen extends StatefulWidget {
//   const VideoDetailScreen({Key? key}) : super(key: key);

//   @override
//   _VideoDetailScreenState createState() => _VideoDetailScreenState();
// }

// class _VideoDetailScreenState extends State<VideoDetailScreen> {
//   BetterPlayerController? _betterPlayerController;

//   // List<BetterPlayerDataSource> createDataSet() {
//   //   List<BetterPlayerDataSource> dataSourceList = [];
//   //   dataSourceList.add(
//   //     BetterPlayerDataSource(
//   //       BetterPlayerDataSourceType.network,
//   //       "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
//   //     ),
//   //   );
//   //   dataSourceList.add(
//   //     BetterPlayerDataSource(BetterPlayerDataSourceType.network,
//   //         "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"),
//   //   );
//   //   dataSourceList.add(
//   //     BetterPlayerDataSource(BetterPlayerDataSourceType.network,
//   //         "http://sample.vodobox.com/skate_phantom_flex_4k/skate_phantom_flex_4k.m3u8"),
//   //   );
//   //   return dataSourceList;
//   // }

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
//   //       BetterPlayerDataSourceType.network,
//   //       "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4");
//   //   _betterPlayerController = BetterPlayerController(
//   //       BetterPlayerConfiguration(),
//   //       betterPlayerDataSource: betterPlayerDataSource);
//   // }
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//       backgroundColor: Colors.white.withOpacity(0.0),
//       body: Stack(
//         // alignment: Alignment.bottomLeft,
//         children: [
//           //video
//           // SizedBox(height: Get.height*.1,),
//           Padding(
//             padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*.1),
//             child: BetterPlayer.network(
//               VideoLinks.bugBuckBunnyVideoUrl,
//               // 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
//               // 'https://filesamples.com/samples/video/mp4/sample_640x360.mp4',
//               //"https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_640_3MG.mp4",
//               betterPlayerConfiguration: BetterPlayerConfiguration(
//                 autoDetectFullscreenAspectRatio: true,
//                 autoDetectFullscreenDeviceOrientation: true,

//                 autoPlay: true,
//                 // showPlaceholderUntilPlay: true,
//                 fit: BoxFit.fill,
//                 // placeholder: Text(VideoLinks.placeholderUrl,style: TextStyle(color:Colors.red,fontSize: 20),),
//                 controlsConfiguration: BetterPlayerControlsConfiguration(
//                   progressBarBackgroundColor: Colors.white,
//                   // progressBarBufferedColor: Colors.red,
//                   progressBarHandleColor: Colors.red,
//                   progressBarPlayedColor: Colors.black,
//                   enableOverflowMenu:false,
//                   //showControls:false,
//                   // enableProgressText: true,
//                   // enableProgressBarDrag: false,
//                   // enableProgressBar: false
//                 ),
//                 looping: true,
//                 // allowedScreenSleep: false,
//                 aspectRatio: 9 / 16,
//                 fullScreenByDefault: false,
//               ),
//             ),
//           ),
//           //appBar
//           Padding(
//             padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*.0),
//             child: Container(
//               width: Get.width,
//               height: Get.height * .08,
//               decoration: BoxDecoration(
//                   color: Colors.black,
//                   borderRadius: BorderRadius.only(
//                     bottomRight: Radius.circular(15),
//                     bottomLeft: Radius.circular(15),
//                   )),
//               child: Padding(
//                 padding: EdgeInsets.only(left: 12, right: 12),
//                 child: Row(
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Icon(
//                         Icons.arrow_back,
//                         color: Colors.white,
//                         size: 25,
//                       ),
//                     ),
//                     Spacer(),
//                     InkWell(
//                       onTap: () {
//                         showModalBottomSheet(
//                             backgroundColor: Colors.black,
//                             context: context,
//                             builder: (context) {
//                               return Wrap(
//                                 children: [
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Container(
//                                         width: Get.width * .3,
//                                         height: Get.width * .02,
//                                         decoration: BoxDecoration(
//                                             color: Color(0xff5972FF),
//                                             borderRadius:
//                                                 BorderRadius.circular(10)),
//                                       ),
//                                     ],
//                                   ),
//                                   InkWell(
//                                       onTap: () {
//                                         Navigator.pop(context);
//                                         FlutterClipboard.copy(
//                                                 'hello flutter friends')
//                                             .then((value) => Get.snackbar(
//                                                 "Copy", "Link Copied",
//                                                 colorText: Colors.white,
//                                                 backgroundColor: Colors.black));
//                                       },
//                                       child: ListTile(
//                                         title: Text(
//                                           'Copy Link',
//                                           style: TextStyle(color: Colors.white),
//                                         ),
//                                       )),
//                                   Divider(
//                                     height: 1,
//                                     thickness: 0.6,
//                                     color: Color(0xffE6E2E2),
//                                   ),
//                                   InkWell(
//                                     onTap: () {
//                                       Share.share("This is demo code");
//                                     },
//                                     child: ListTile(
//                                       title: Text(
//                                         'Share To..',
//                                         style: TextStyle(color: Colors.white),
//                                       ),
//                                     ),
//                                   ),
//                                   Divider(
//                                     height: 1,
//                                     thickness: 0.6,
//                                     color: Color(0xffE6E2E2),
//                                   ),
//                                   InkWell(
//                                       onTap: () {
//                                         Navigator.pop(context);
//                                         Get.snackbar("Save", "Video Saved",
//                                             colorText: Colors.white,
//                                             backgroundColor: Colors.black);
//                                       },
//                                       child: ListTile(
//                                         title: Text(
//                                           'Save',
//                                           style: TextStyle(color: Colors.white),
//                                         ),
//                                       )),
//                                 ],
//                               );
//                             });
//                       },
//                       child: Icon(
//                         Icons.more_vert_outlined,
//                         color: Colors.white,
//                         size: 25,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           //title detail
//           Positioned(
//             bottom: 0,
//             child: Container(
//               margin: EdgeInsets.only(bottom: Get.height * .12),
//               width: Get.width * .8,
//               height: Get.height * .12,
//               color: Colors.transparent,
//               child: ListTile(
//                 title: Text(
//                   "Title",
//                   style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Source Sans Pro',
//                       color: Colors.white),
//                 ),
//                 subtitle: Padding(
//                   padding: const EdgeInsets.all(2.0),
//                   child: ReadMoreText(
//                     'Lorem Ipsum is simply dummy text of the printing Lorem Ipsum is simply dummy printing Lorem Ipsum is simply dummy',
//                     trimLines: 2,
//                     colorClickableText: Colors.white,
//                     trimMode: TrimMode.Line,
//                     trimCollapsedText: '...Show more',
//                     trimExpandedText: ' show less',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.normal,
//                         fontFamily: 'Source Sans Pro',
//                       color: Colors.white),
//                   ),
//                 ),
//                 // Text(
//                 //   "Lorem Ipsum is simply dummy text of the printing Lorem Ipsum is simply dummy printing Lorem Ipsum is simply dummy",
//                 //   style: TextStyle(
//                 //       fontSize: 12,
//                 //       fontWeight: FontWeight.normal,
//                 //       color: Colors.white),
//                 // ),
//               ),
//             ),
//           ),
//           //side like bar
//           Positioned(
//             bottom: Get.height * .05,
//             right: 0,
//             child: Container(
//                 margin: EdgeInsets.only(bottom: Get.height * .07),
//                 width: Get.width * .2,
//                 height: Get.height * .32,
//                 color: Colors.transparent,
//                 child: Column(
//                   children: [
//                     Column(
//                       children: [
//                         SvgPicture.asset('assets/svg/blue like button.svg'),
//                         SizedBox(
//                           height: 3,
//                         ),
//                         Text(
//                           "7K",
//                           style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold ),
//                         )
//                       ],
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     InkWell(
//                         onTap: () {
//                           Navigator.of(context)
//                               .push(MaterialPageRoute(builder: (_) {
//                             return const Comments();
//                           }));
//                           // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CommentContainer(Image.asset("name"), "", "", "", true,"", true, "")));
//                         },
//                         child: Column(
//                           children: [
//                             SvgPicture.asset('assets/svg/Background.svg'),
//                             SizedBox(
//                               height: 3,
//                             ),
//                             Text(
//                               "7K",
//                               style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
//                             )
//                           ],
//                         )),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Column(
//                       children: [
//                         SvgPicture.asset('assets/svg/fvrt i.svg'),
//                         SizedBox(
//                           height: 3,
//                         ),
//                         Text(
//                           "7K",
//                           style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
//                         )
//                       ],
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Column(
//                       children: [
//                         InkWell(
//                             onTap: () {
//                               Share.share("This is demo code");
//                             },
//                             child: SvgPicture.asset('assets/svg/share lines.svg'),
//                         ),
//                         SizedBox(
//                           height: 3,
//                         ),
//                         Text(
//                           "7K",
//                           style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
//                         )
//                       ],
//                     ),
//                    /* SizedBox(
//                       height: 10,
//                     ),*/
//                   ],
//                 )),
//           ),
//         ],
//       ),
//     ));
//   }
// }
