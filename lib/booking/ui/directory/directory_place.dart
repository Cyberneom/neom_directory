// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_slider_indicator/flutter_slider_indicator.dart';
// import 'package:get/get.dart';
// import 'package:neom_commons/neom_commons.dart';
//
//
//
// // ignore: must_be_immutable
// class DirectoryPlace extends StatefulWidget {
//
//   bool liked;
//   final AppProfile facilityProfile;
//   int _currentIndex = 0;
//
//   DirectoryPlace(this.facilityProfile, {this.liked = false, super.key});
//
//   @override
//   DirectoryPlaceState createState() => DirectoryPlaceState();
// }
//
// class DirectoryPlaceState extends State<DirectoryPlace> {
//
//   @override
//   Widget build(BuildContext context) {
//     return  Container(
//       decoration: AppTheme.appBoxDecoration,
//       padding: const EdgeInsets.only(bottom: 5),
//       child:   InkWell(
//         onTap: (){
//           //Get.to(() => BookingPlaceDetails(widget.facility));
//         },
//         child:Column(
//           children: <Widget>[
//             Container(
//               margin: const EdgeInsets.fromLTRB(0,0,0,15),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(3),
//               ),
//               height: 200,
//               child: Stack(
//                 children: <Widget>[
//                   //TODO Verify implementation
//                   // buildImageSlider(context, PageController(), widget._currentIndex, widget.facilityProfile),
//                   buildWidgetImageIndicator(context,widget.facilityProfile,widget._currentIndex),
//                   buildHeartWidget(context),
//                   Positioned(
//                     bottom: 1,
//                     right: 1,
//                     child: Column(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             color: AppColor.bondiBlue
//                         ),
//                         child: InkWell(
//                           child: Text(AppTranslationConstants.toContact.tr,
//                             style: const TextStyle(color: Colors.white),),
//                           onTap: (){
//                             // Get.to(() =>  const BookingPaymentPage());
//                             CoreUtilities.launchURL(UrlConstants.whatsAppURL);
//                           },
//                         ),
//                       ),
//                       // Text("${widget.facilityProfile.price!.amount.truncate()} ${widget.facilityProfile.price!.currency.name.toUpperCase()}/${AppTranslationConstants.hour.tr}",
//                       //   style: const TextStyle(fontSize: 12),
//                       // ),
//                     ],
//                   ),),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(15,0,15, 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                 Text(widget.facilityProfile.name.capitalize,
//                     style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold),
//                     overflow: TextOverflow.ellipsis,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(widget.facilityProfile.mainFeature.
//                         replaceRange(0, 1, widget.facilityProfile.mainFeature.substring(0,1).toLowerCase()).tr.capitalizeFirst,
//                           style: const TextStyle(fontWeight: FontWeight.w400),),
//                         Text(widget.facilityProfile.aboutMe,
//                           overflow: TextOverflow.ellipsis,),
//                         // Text("widget.facilityProfile.position.getAddressSimple()",
//                         //   overflow: TextOverflow.ellipsis,),
//                         //TODO Implement when having bookings
//                         // Row(
//                         //   children: <Widget>[
//                         //     const Icon(Icons.star,
//                         //       color: AppColor.yellow,
//                         //       size: 12,),
//                         //     Align(
//                         //       alignment: Alignment.topLeft,
//                         //       child:  Text("${widget.place.reviewStars}",
//                         //         overflow: TextOverflow.ellipsis,),
//                         //     ) ,
//                         //     Align(
//                         //       alignment: Alignment.topLeft,
//                         //       child: Text("(${widget.place.reviews.length})",
//                         //           overflow: TextOverflow.ellipsis
//                         //       ),
//                         //     ) ,
//                         //   ],
//                         // ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],)
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   PageView buildImageSlider(BuildContext context, PageController p, int index, AppProfile facility) {
//     return PageView.builder(
//         controller: p..addListener(() {
//           setState(() {
//             index=p.page!.round();
//             widget._currentIndex=p.page!.round  ();
//           });
//         }),
//         itemCount: facility.facilities!.values.first.galleryImgUrls.length,
//         itemBuilder: (context,index) {
//           return ClipRRect(
//               child: CachedNetworkImage(
//                 imageUrl: facility.facilities!.values.first.galleryImgUrls.elementAt(index),
//                 fit: BoxFit.scaleDown
//               )
//           );
//         }
//     );
//   }
//
//   Align buildWidgetImageIndicator(BuildContext context, AppProfile appProfile, int currentIndex) {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: SliderIndicator(
//             length: appProfile.facilities!.values.first.galleryImgUrls.length,
//             activeIndex: currentIndex,
//             indicator:const Padding( padding:EdgeInsets.all(3),child:Icon(Icons.fiber_manual_record,color: Colors.white70,size: 10,)),
//             activeIndicator: const Padding(padding:EdgeInsets.all(3),child:Icon(Icons.fiber_manual_record,color: Colors.white,size: 14,),)
//         ),
//       ),
//     );
//   }
//
//   Container buildHeartWidget(BuildContext context) {
//     return Container(
//         margin: const EdgeInsets.all(10),
//         alignment: Alignment.topRight,
//         child:GestureDetector(
//           child:Container(
//             padding: const EdgeInsets.all(5),
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.circle,
//               //  borderRadius: BorderRadius.circular(25)
//             ),
//             child: Icon(!widget.liked?Icons.favorite_border:Icons.favorite,
//               color: !widget.liked ? Colors.black: AppColor.ceriseRed,
//               size: 25,),
//           ),
//           onTap: (){
//             setState(() {
//               widget.liked=!widget.liked;
//             });
//           },
//         )
//     );
//   }
//
//
//
// }
