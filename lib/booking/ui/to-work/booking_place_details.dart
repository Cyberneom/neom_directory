import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neom_commons/core/domain/model/place.dart';
import 'package:neom_commons/core/domain/model/place_commodity.dart';
import 'package:neom_commons/core/utils/app_color.dart';
import 'package:neom_commons/core/utils/constants/app_page_id_constants.dart';
import 'package:neom_commons/core/utils/constants/app_translation_constants.dart';

import '../directory/directory_controller.dart';
import '../widgets/booking_comments_widget.dart';
import '../widgets/booking_widgets.dart';
import 'booking_payment_page.dart';

class BookingPlaceDetails extends StatefulWidget {
  final Place place;

  const BookingPlaceDetails(this.place, {Key? key}) : super(key: key);

  @override
  BookingPlaceDetailsState createState() => BookingPlaceDetailsState();
}

class BookingPlaceDetailsState extends State<BookingPlaceDetails> {

  final _pageController = PageController();
  final _currentIndex=0;

  // TODO Verify
  //bool _liked=false;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DirectoryController>(
        id: AppPageIdConstants.booking,
        init: DirectoryController(),
        builder: (_) => Scaffold(
      backgroundColor: AppColor.main50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  buildImageSlider(context, _pageController, widget.place.galleryImgUrls, _currentIndex),
                  buildWidgetImageIndicator(context, widget.place.galleryImgUrls, _currentIndex),
                  buildCloseWidget(context),
                  buildHeartWidget(context, _),
                  buildContainerPrice(widget.place.price!),
                ],
              ),
              buildDescreption(context),
              Padding(
                padding: const EdgeInsets.fromLTRB(13,2,25,10),
                child: Row(
                  children: <Widget>[
                    Container(
                        margin:const EdgeInsets.only(right: 5),
                        child: const Icon(Icons.star,color: AppColor.yellow, size: 18,)),
                    Container(
                      margin:const EdgeInsets.only(right: 5),
                      child: const Align(
                        alignment: Alignment.topLeft,

                        child:  Text("5,0",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),overflow: TextOverflow.ellipsis,),
                      ),
                    ) ,
                    const Align(
                      alignment: Alignment.topLeft,
                      child:  Text("(25)",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,letterSpacing: 0.2),overflow: TextOverflow.ellipsis,),
                    ) ,
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(13,2,25,10),
                child:
                Align(
                  alignment: Alignment.topLeft,
                  child:  Text("Luis Solaz, Guadalajara, México",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,letterSpacing: 0.2),overflow: TextOverflow.ellipsis,),
                ) ,
              ),
              separateurHorizontal(),
              Row(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(25,2,25,0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Solaz",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600,letterSpacing: 0.2),overflow: TextOverflow.ellipsis,),
                        Text("Host : Luis",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,letterSpacing: 0.2),overflow: TextOverflow.ellipsis,),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: Image.network("https://scontent.fgdl9-1.fna.fbcdn.net/v/t39.30808-6/221645235_10159386241273149_636331263202789404_n.jpg?_nc_cat=101&ccb=1-5&_nc_sid=09cbfe&_nc_eui2=AeHXj8wk19HWVFhZNXXCF-Dmlm0OD5gMmWeWbQ4PmAyZZ3Bp6aGVOxd1NkByp3C004Y&_nc_ohc=b3ueuUCdO9gAX884RB7&tn=Qsb94kQ_D0lw_4J0&_nc_ht=scontent.fgdl9-1.fna&oh=737bf3c17e467bda6e730502eeaf66dd&oe=613A48AF").image,
                            fit: BoxFit.cover)
                    ),
                    height: 50,
                    width: 50,
                  ),
                ],
              ),
              separateurHorizontal(),
              buildDescText(context),
              separateurHorizontal(),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25,2,25,0),
                  child: Text(AppTranslationConstants.equipment.tr.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2),
                    overflow: TextOverflow.ellipsis,),
                ),
              ),
              buildEquipment(PlaceCommodity()),
              separateurHorizontal(),
              Padding(
                padding: const EdgeInsets.fromLTRB(13,2,25,5),
                child: Row(
                  children: <Widget>[
                    Container(
                        margin:const EdgeInsets.only(right: 5),
                        child: const Icon(Icons.star,color: AppColor.yellow,size: 25,)),
                    Container(
                      margin:const EdgeInsets.only(right: 5),
                      child: const Align(
                        alignment: Alignment.topLeft,

                        child:  Text("4,38",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,),
                      ),
                    ) ,
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(13,0,25,10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child:  Text("(45 ${AppTranslationConstants.comments.tr})",style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w500,letterSpacing: 0.2),overflow: TextOverflow.ellipsis,),
                ),
              ) ,
              const SizedBox(height: 25,),
              Padding(
                padding: const EdgeInsets.fromLTRB(13,2,25,10),
                child: Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: Image.network("https://scontent.fgdl9-1.fna.fbcdn.net/v/t39.30808-6/221645235_10159386241273149_636331263202789404_n.jpg?_nc_cat=101&ccb=1-5&_nc_sid=09cbfe&_nc_eui2=AeHXj8wk19HWVFhZNXXCF-Dmlm0OD5gMmWeWbQ4PmAyZZ3Bp6aGVOxd1NkByp3C004Y&_nc_ohc=b3ueuUCdO9gAX884RB7&tn=Qsb94kQ_D0lw_4J0&_nc_ht=scontent.fgdl9-1.fna&oh=737bf3c17e467bda6e730502eeaf66dd&oe=613A48AF").image,
                              fit: BoxFit.cover)
                      ),
                      height: 45,
                      width: 45,
                    ),
                    const SizedBox(width: 15,),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Luis",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,letterSpacing: 0.2),overflow: TextOverflow.ellipsis,),
                        Text("September 2021",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,letterSpacing: 0.2),overflow: TextOverflow.ellipsis,)
                      ],
                    )
                  ],
                ),
              ),
              const BookingComments(),
            ],
          ),

        ),
      ),
      bottomNavigationBar: Material(
        color: AppColor.main50,
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
          margin: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
          child: MaterialButton(
              color:  AppColor.bondiBlue,
              onPressed: (){
                Get.to(() =>  const BookingPaymentPage());
              },
              child: Text(AppTranslationConstants.verifyAvailability.tr,
                style: const TextStyle(color: Colors.white),)
          ),
        ),
      ),
    )
    );
  }
}
