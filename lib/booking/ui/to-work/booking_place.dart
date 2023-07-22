import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_indicator/flutter_slider_indicator.dart';
import 'package:get/get.dart';
import 'package:neom_commons/core/domain/model/place.dart';
import 'package:neom_commons/core/utils/app_color.dart';
import 'package:neom_commons/core/utils/app_theme.dart';
import 'package:neom_commons/core/utils/constants/app_translation_constants.dart';

import 'booking_payment_page.dart';
import 'booking_place_details.dart';


// ignore: must_be_immutable
class BookingPlace extends StatefulWidget {

  bool _liked;
  final Place place;
  int _currentIndex=0;

  BookingPlace(this._liked, this.place, {Key? key}) : super(key: key);

  @override
  BookingPlaceState createState() => BookingPlaceState();
}

class BookingPlaceState extends State<BookingPlace> {

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: AppTheme.appBoxDecoration,
      padding: const EdgeInsets.only(bottom: 5),
      child:   InkWell(
        onTap: (){
          Get.to(() => BookingPlaceDetails(widget.place));
        },
        child:Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(0,0,0,15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
              ),
              height: 200,
              child: Stack(
                children: <Widget>[
                  buildImageSlider(context, PageController(), widget._currentIndex,widget.place),
                  buildWidgetImageIndicator(context,widget.place,widget._currentIndex),
                  buildHeartWidget(context),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB( 35,0,35, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(widget.place.name,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.place.type.name.
                        replaceRange(0, 1, widget.place.type.name.substring(0,1).toLowerCase()).tr,
                          style: const TextStyle(fontWeight: FontWeight.w400),),
                        Text(widget.place.address!.getAddressSimple(),
                          overflow: TextOverflow.ellipsis,),
                        //TODO Implement when having bookings
                        // Row(
                        //   children: <Widget>[
                        //     const Icon(Icons.star,
                        //       color: AppColor.yellow,
                        //       size: 12,),
                        //     Align(
                        //       alignment: Alignment.topLeft,
                        //       child:  Text("${widget.place.reviewStars}",
                        //         overflow: TextOverflow.ellipsis,),
                        //     ) ,
                        //     Align(
                        //       alignment: Alignment.topLeft,
                        //       child: Text("(${widget.place.reviews.length})",
                        //           overflow: TextOverflow.ellipsis
                        //       ),
                        //     ) ,
                        //   ],
                        // ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColor.bondiBlue
                          ),
                          child: InkWell(
                            child: Text(AppTranslationConstants.toContact.tr,
                              style: const TextStyle(color: Colors.white),),
                            onTap: (){
                              Get.to(() =>  const BookingPaymentPage());
                            },
                          ),
                        ),
                        Text("${widget.place.price!.amount.truncate()} ${widget.place.price!.currency.name.toUpperCase()}/${AppTranslationConstants.hour.tr}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    )
                  ],
                ),
              ],)
            ),
          ],
        ),
      ),
    );
  }

  PageView buildImageSlider(BuildContext context, PageController p, int index, Place place) {
    return PageView.builder(
        controller: p..addListener(() {
          setState(() {
            index=p.page!.round();
            widget._currentIndex=p.page!.round  ();
          });
        }),
        itemCount: place.galleryImgUrls.length,
        itemBuilder: (
            context,index){
          return ClipRRect(
              child: CachedNetworkImage(
                imageUrl: place.galleryImgUrls[index],
                fit: BoxFit.cover
              )
          );
        }
    );
  }

  Align buildWidgetImageIndicator(BuildContext context, Place place, int currentindex) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SliderIndicator(
            length: place.galleryImgUrls.length,
            activeIndex: currentindex,
            indicator:const Padding( padding:EdgeInsets.all(3),child:Icon(Icons.fiber_manual_record,color: Colors.white70,size: 10,)),
            activeIndicator: const Padding(padding:EdgeInsets.all(3),child:Icon(Icons.fiber_manual_record,color: Colors.white,size: 14,),)
        ),
      ),
    );
  }

  Container buildHeartWidget(BuildContext context) {

    return Container(
        margin: const EdgeInsets.all(10),
        alignment: Alignment.topRight,
        child:GestureDetector(
          child:Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              //  borderRadius: BorderRadius.circular(25)
            ),
            child: Icon(!widget._liked?Icons.favorite_border:Icons.favorite,
              color: !widget._liked ? Colors.black: AppColor.ceriseRed,
              size: 25,),
          ),
          onTap: (){
            setState(() {
              widget._liked=!widget._liked;
            });
          },
        )
    );
  }



}
