
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_indicator/flutter_slider_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:neom_commons/core/ui/widgets/read_more_container.dart';
import 'package:neom_commons/neom_commons.dart';

import 'directory_controller.dart';

// ignore: must_be_immutable
class DirectoryFacility extends StatefulWidget {

  bool liked;
  final AppProfile facilityProfile;
  int _currentIndex = 0;
  String distanceBetween;

  DirectoryFacility(this.facilityProfile, {this.liked = false, this.distanceBetween = "", Key? key}) : super(key: key);

  @override
  DirectoryFacilityState createState() => DirectoryFacilityState();
}

class DirectoryFacilityState extends State<DirectoryFacility> {

  AppProfile facilityProfile = AppProfile();
  @override
  Widget build(BuildContext context) {
    facilityProfile = widget.facilityProfile;

    return  GetBuilder<DirectoryController>(
      id: AppPageIdConstants.directory,
      builder: (_) => Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(style: BorderStyle.solid, color: Colors.grey, width: 0.5)
        ),
        child: Card(
          color: AppColor.getContextCardColor(context),
          elevation: 10,
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                if(_.needsPosts) Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  height: AppTheme.fullHeight(context)/4,
                  child: Stack(
                    children: <Widget>[
                      buildImageSlider(context, PageController(), widget._currentIndex, facilityProfile),
                      buildWidgetImageIndicator(context,facilityProfile,widget._currentIndex),
                      //TODO buildHeartWidget(context),
                    ],
                  ),
                ),
                if(_.needsPosts) const Divider(thickness: 1),
                facilityAvatarSection(context, _.userController.profile, facilityProfile,
                    isAdminCenter: _.isAdminCenter),
                AppTheme.heightSpace10,
                if(facilityProfile.aboutMe.isNotEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ReadMoreContainer(text: facilityProfile.aboutMe.capitalizeFirst, fontSize: 14,)
                  ),
              ],
            ),
          ),
        ),
      )
    );
  }

  PageView buildImageSlider(BuildContext context, PageController p, int index, AppProfile facility) {
    return PageView.builder(
        controller: p..addListener(() {
          setState(() {
            index=p.page!.round();
            widget._currentIndex=p.page!.round  ();
          });
        }),
        itemCount: facility.facilities!.values.first.galleryImgUrls.length,
        itemBuilder: (context,index) {
          return GestureDetector(
            onTap: () => Get.toNamed(AppRouteConstants.mateDetails, arguments: facility.id),
            child: ClipRRect(
              child: CachedNetworkImage(
                imageUrl: facility.facilities!.values.first.galleryImgUrls.elementAt(index),
                fit: BoxFit.fitWidth
              )
          ),);
        }
    );
  }

  Widget facilityAvatarSection(BuildContext context, AppProfile profile, AppProfile facilityProfile,
      {bool showDots = true, bool isAdminCenter = false}) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  if(facilityProfile.photoUrl.isNotEmpty)
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.toNamed(AppRouteConstants.mateDetails, arguments: facilityProfile.id),
                          child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage: CachedNetworkImageProvider(
                                facilityProfile.photoUrl.isNotEmpty ? facilityProfile.photoUrl
                                    : AppFlavour.getNoImageUrl(),),
                              radius: 20),
                        ),
                        AppTheme.widthSpace10,
                      ],
                    ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => profile.id == facilityProfile.id
                                    ? Get.toNamed(AppRouteConstants.profile)
                                    : Get.toNamed(AppRouteConstants.mateDetails, arguments: facilityProfile.id),
                                child: Text(facilityProfile.name.length < AppConstants.maxProfileNameLength
                                    ? facilityProfile.name.capitalize
                                    : "${facilityProfile.name.substring(0, AppConstants.maxProfileNameLength)}...",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    )
                                ),
                              ),
                              AppTheme.widthSpace10,
                            ]
                        ),
                        if(facilityProfile.address.isNotEmpty)
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.white, size: 12,),
                              AppTheme.widthSpace5,
                              Text(facilityProfile.address.length <= AppConstants.maxLocationNameLength
                                  ? facilityProfile.address.capitalize: "${facilityProfile.address.substring(0,AppConstants.maxLocationNameLength).capitalize}...",
                                  style: const TextStyle(fontSize: 12, color: Colors.white)
                              ),
                            ],
                          ),
                        Row(
                          children: [
                            const Icon(Icons.room_service, color: Colors.white, size: 12,),
                            AppTheme.widthSpace5,
                            Text(facilityProfile.mainFeature.tr.capitalizeFirst,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white
                                )
                            )
                          ]
                        ),
                        Row(
                          children: [
                            const Icon(FontAwesomeIcons.road, color: Colors.white, size: 12,),
                            AppTheme.widthSpace5,
                            Text(int.parse(widget.distanceBetween) <= 2 ? AppTranslationConstants.aroundYou.tr : '${widget.distanceBetween} KM',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white
                                )
                            )
                          ]
                        ),
                      ]
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColor.bondiBlue
                ),
                child: InkWell(
                  child: Text(AppTranslationConstants.toContact.tr,
                    style: const TextStyle(color: Colors.white),),
                  onTap: () {
                    String message = '';
                    if(isAdminCenter) {
                      message = '${AppTranslationConstants.dirWhatsappAdminMsgA.tr} ${profile.name.tr} ${AppTranslationConstants.dirWhatsappAdminMsgB.tr} "${facilityProfile.type.name.tr}". ${AppTranslationConstants.dirWhatsappAdminMsgC.tr}';
                    } else {
                      message = '${AppTranslationConstants.dirWhatsappMsgA.tr} ${facilityProfile.mainFeature.tr} "${facilityProfile.name}" ${AppTranslationConstants.dirWhatsappMsgB.tr} @${profile.name}';
                    }

                    CoreUtilities.launchWhatsappURL(widget.facilityProfile.phoneNumber, message);
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Align buildWidgetImageIndicator(BuildContext context, AppProfile appProfile, int currentindex) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SliderIndicator(
            length: appProfile.facilities!.values.first.galleryImgUrls.length,
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
            child: Icon(!widget.liked?Icons.favorite_border:Icons.favorite,
              color: !widget.liked ? Colors.black: AppColor.ceriseRed,
              size: 25,),
          ),
          onTap: (){
            setState(() {
              widget.liked=!widget.liked;
            });
          },
        )
    );
  }



}
