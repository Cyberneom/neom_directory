import 'package:flutter/material.dart';
import 'package:flutter_slider_indicator/flutter_slider_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:neom_commons/core/domain/model/place_commodity.dart';
import 'package:neom_commons/core/domain/model/price.dart';
import 'package:neom_commons/core/ui/widgets/handled_cached_network_image.dart';
import 'package:neom_commons/core/utils/app_color.dart';
import 'package:neom_commons/core/utils/constants/app_constants.dart';
import 'package:neom_commons/core/utils/constants/app_route_constants.dart';
import 'package:neom_commons/core/utils/constants/app_translation_constants.dart';

import '../directory/directory_controller.dart';
import '../to-work/booking_description_details_page.dart';

GestureDetector buildScrollActivities(String imgUri, {String text = '', bool isRemote = true}) {
  return GestureDetector(
    onTap: () => Get.toNamed(AppRouteConstants.directory),
    child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      children: <Widget>[
        Container(
            color: Colors.white,
            height: 250,
            width: 350,
            child: isRemote ? HandledCachedNetworkImage(imgUri, fit: BoxFit.fitHeight,) :
            Image.asset(imgUri, fit: BoxFit.fitWidth,),
        ),
        Container(
            width: double.infinity,
            color: AppColor.bondiBlue,
            child: Text(text,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
        ),
      ],
    ),),
  );
}

SizedBox buildImageSlider(BuildContext context, PageController _, List<String> galleryImgUrls, int currentIndex) {
  return SizedBox(
      height: 250,
      child: PageView.builder(
          controller: _,
          itemCount: galleryImgUrls.length,
          itemBuilder: (
              context,index){
            return Image.network(galleryImgUrls[currentIndex],fit: BoxFit.cover);
          }
      )
  );
}

Align buildWidgetImageIndicator(BuildContext context, List<String> galleryImgUrls, int currentIndex) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Padding(
      padding: const EdgeInsets.only(top: 225),
      child: SliderIndicator(
        length: galleryImgUrls.length,
        activeIndex: currentIndex,
        indicator: const Icon(Icons.radio_button_unchecked,color: Colors.white,size: 10,),
        activeIndicator: const Icon(Icons.fiber_manual_record,color: Colors.white,size: 12,),
      ),
    ),
  );
}

Align buildCloseWidget(BuildContext context) {
  return Align(
    alignment: Alignment.topLeft,

    child: Container(
      padding: const EdgeInsets.all(0),
      height: 45,
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white
      ),
      margin: const EdgeInsets.only(left: 13,top: 40),
      child: IconButton(icon: const Icon(Icons.arrow_back,size: 18,),
        color: Colors.black,
        onPressed: (){Navigator.of(context).pop();},
      ),
    ),
  );
}

Widget buildContainerPrice(Price price) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      margin: const EdgeInsets.only(left: 10,top: 10),
      padding: const EdgeInsets.symmetric(vertical: 6,horizontal:12 ),
      decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.attach_money,size: 16,color: Colors.white,),
          Text("${price.amount}", style: const TextStyle(color: Colors.white),),
          Text("/ ${AppTranslationConstants.hour.tr}", style: const TextStyle(color: Colors.white,fontSize: 16),),
        ],
      ),
    ),
  );
}

Column buildEquipment(PlaceCommodity commodity)  {
  return Column(
      children: <Widget>[
        getSingleEquipment(AppConstants.wifi, Icons.wifi, commodity.wifi),
        getSingleEquipment(AppTranslationConstants.parking, Icons.local_parking, commodity.parking),
        getSingleEquipment(AppTranslationConstants.roomService, Icons.room_service, commodity.roomService),
        getSingleEquipment(AppTranslationConstants.audioEquipment, Icons.speaker, commodity.audioEquipment),
        getSingleEquipment(AppTranslationConstants.musicalInstruments, FontAwesomeIcons.guitar, commodity.musicalInstruments),
        getSingleEquipment(AppTranslationConstants.acousticConditioning, Icons.surround_sound, commodity.acousticConditioning),
        getSingleEquipment(AppTranslationConstants.childAllowance, Icons.child_care, commodity.childAllowance),
        getSingleEquipment(AppTranslationConstants.smokingAllowance, Icons.smoking_rooms, commodity.smokingAllowance),
        getSingleEquipment(AppTranslationConstants.smokeDetector, Icons.fire_hydrant, commodity.smokeDetector),
        getSingleEquipment(AppTranslationConstants.publicBathroom, Icons.bathroom, commodity.publicBathroom),
        getSingleEquipment(AppTranslationConstants.privateBathroom, Icons.bathtub, commodity.privateBathroom),
        getSingleEquipment(AppTranslationConstants.sharedPlace, Icons.emoji_people, commodity.sharedPlace),
      ]
  );
}

Padding getSingleEquipment(String title, IconData icon, bool isActive) {
  TextStyle bare= const TextStyle(color:Colors.grey,decoration: TextDecoration.lineThrough);
  TextStyle active= const TextStyle(color:Colors.white);
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 25),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(title.tr, style: isActive ? active : bare),
        Icon(icon, color: isActive ? AppColor.ceriseRed : Colors.grey,)
      ],
    ),
  );
}

Container separateurHorizontal() {
  return Container(
    margin: const EdgeInsets.all(15),
    width: 200,
    height: 1,
    color: Colors.white70,
  );
}

Column buildDescText(BuildContext context) {
  int maxLines1=3;
  return Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.fromLTRB(18,5,25,10),
        child:
        Align(
          alignment: Alignment.topLeft,
          child:  Text("A modern furnished apartment, in a quiet area, but very close to the busy street of sidi yahia.\n-parquet floor/ central ",
            style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w400,letterSpacing: 0.2),overflow: TextOverflow.ellipsis,maxLines: maxLines1,),
        ) ,
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(18,10,25,10),
        child: GestureDetector(
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BookingDescriptionDetailsPage()));
          },
          child: Row(
            children: <Widget>[
              Text(AppTranslationConstants.seeMoreElements.tr,
                style: const TextStyle(decoration: TextDecoration.underline,fontWeight: FontWeight.w500,fontSize: 16),),
              const Icon(Icons.arrow_right)
            ],
          ),
        ),
      )
    ],
  );
}

Container buildHeartWidget(BuildContext context, DirectoryController _) {
  return Container(
      margin: const EdgeInsets.only(right: 13,top: 40),
      alignment: Alignment.topRight,
      child:GestureDetector(
        child:Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            //  borderRadius: BorderRadius.circular(25)
          ),
          // child: Icon(!_liked?Icons.favorite_border:Icons.favorite,
          //   color:!_liked? Colors.black: GigAppColor.ceriseRed,
          //   size: 20,),
          child: const Icon(Icons.favorite)
        ),
        onTap: (){
          // setState(() {
          //   _liked=!_liked;
          // });
        },
      )
  );
}

Padding buildDescreption(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(8),
    child: Text("Quiet, carefully designed & furnished apartement",style: TextStyle(fontSize: 20),overflow: TextOverflow.ellipsis,maxLines: 2,),
  );
}
