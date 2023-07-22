import 'package:flutter/material.dart';
import 'package:flutter_slider_indicator/flutter_slider_indicator.dart';
import 'package:get/get.dart';
import 'package:neom_commons/neom_commons.dart';

import '../to-work/booking_payment_page.dart';
import '../to-work/booking_place_details.dart';

// ignore: must_be_immutable
class PlaceImageView extends StatefulWidget {

  bool _liked;
  final Place place;
  int _currentIndex=0;


  PlaceImageView(this._liked, this.place, {Key? key}) : super(key: key);

  @override
  PlaceImageViewState createState() => PlaceImageViewState();
}

class PlaceImageViewState extends State<PlaceImageView> {

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
              child: Image.network(place.galleryImgUrls[index],fit: BoxFit.cover,));
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

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child:   InkWell(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookingPlaceDetails(widget.place))
          );
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
                  buildImageSlider(context,PageController(),widget._currentIndex,widget.place),
                  buildWidgetImageIndicator(context,PlacesMockups.places[1],widget._currentIndex),
                  buildHeartWidget(context),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB( 35,0,35, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child:  Text(widget.place.name,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child:  Text(widget.place.address!.state,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child:  Text(widget.place.name,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child:  Text("${widget.place.price!.amount.truncate()} ${'MXN'}/${AppTranslationConstants.hour.tr}",
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          const Icon(Icons.star,
                            color: AppColor.yellow,
                            size: 12,),
                          Align(
                            alignment: Alignment.topLeft,
                            child:  Text("${widget.place.reviewStars}",
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ) ,
                          // const Align(
                          //   alignment: Alignment.topLeft,
                          //   child:  Text("(12)",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400),overflow: TextOverflow.ellipsis,),
                          // ) ,
                        ],
                      ),
                    ],
                  ),
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
