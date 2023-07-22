import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neom_commons/core/utils/app_color.dart';
import 'package:neom_commons/core/utils/app_theme.dart';
import 'package:neom_commons/core/utils/app_utilities.dart';
import 'package:neom_commons/core/utils/constants/app_translation_constants.dart';

class BookingPaymentPage extends StatefulWidget {
  const BookingPaymentPage({Key? key}) : super(key: key);

  @override
  BookingPaymentPageState createState() => BookingPaymentPageState();
}

class BookingPaymentPageState extends State<BookingPaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SingleChildScrollView(
        child: Container(
          decoration: AppTheme.appBoxDecoration,
          padding: const EdgeInsets.symmetric(vertical:25,horizontal: 15),
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[
           Row(
             mainAxisSize: MainAxisSize.min,
             children: <Widget>[
               IconButton(
                 icon: const Icon(Icons.arrow_back, size: 23,),
                 onPressed: (){
                   Get.back();
                 },
               ),
               Text(AppTranslationConstants.confirmAndPay.tr,
                 style: const TextStyle(fontSize: 18),),
             ],
            ),
             AppTheme.heightSpace20,
             Container(
               decoration: AppTheme.appBoxDecorationBlueGrey,
               child: Row(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: <Widget>[
                   Container(
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(15),
                     ),
                   height: 160,width: 120,
                       child: ClipRRect(
                         borderRadius: BorderRadius.circular(15) ,
                           child: Image.network("https://firebasestorage.googleapis.com/v0/b/gig-me-out.appspot.com/o/RehearsalRooms%2FMexico%2FSolaz%2Frecepcion.jpg?alt=media&token=144ec983-8f5c-4db7-afb3-74ae16c3e48e",fit: BoxFit.fill,)
                       )
                   ),
                   const SizedBox(width: 15),
                   Flexible(
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: <Widget>[
                         const Text("Reserva en Solaz Salas de Ensayo",style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,maxLines: 1,),
                         AppTheme.heightSpace10,
                         const Text("Sala de ensayo",style: TextStyle(fontSize: 16),overflow: TextOverflow.ellipsis,maxLines: 1,),
                         AppTheme.heightSpace10,
                         const Text("Sala Agua",style: TextStyle(fontSize: 16),overflow: TextOverflow.ellipsis,maxLines: 1,),
                         AppTheme.heightSpace10,
                         Row(
                           children: <Widget>[
                             Container(
                                 margin:const EdgeInsets.only(right: 5),
                                 child: const Icon(Icons.star,color: Colors.yellow, size: 18)),
                             Container(
                               margin:const EdgeInsets.only(right: 5),
                               child: const Align(
                                 alignment: Alignment.topLeft,
                                 child:  Text("5,0",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis),
                               ),
                             ) ,
                             const Align(
                               alignment: Alignment.topLeft,
                               child:  Text("(12)",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,letterSpacing: 0.2),overflow: TextOverflow.ellipsis),
                             ) ,
                           ],
                         ),
                       ],
                     ),
                   ),
                 ],
               ),
             ),
             const SizedBox(height: 25,),
             Container(
               height: 10,
               color: Colors.black12,
               width: MediaQuery.of(context).size.width,
             ),
             Text(AppTranslationConstants.yourGig.tr,
               style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
             const SizedBox(height: 15,),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: <Widget>[
                 Text(AppTranslationConstants
                     .date.tr,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                 InkWell(
                     onTap: (){

                     },
                     child: Text(AppTranslationConstants.modify.tr,
                       style: const TextStyle(
                           fontWeight: FontWeight.w400,
                           fontSize: 17,
                           decoration: TextDecoration.underline),
                     )
                 ),
               ],
             ),
             AppTheme.heightSpace10,
             const Text("25-10-2021 - 06:00 PM",style: TextStyle(color: Colors.grey,fontSize: 16),),
             const SizedBox(height: 15,),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: <Widget>[
                 Text(AppTranslationConstants.musicians.tr,
                   style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                 InkWell(
                   onTap: (){

                   },
                     child: Text(AppTranslationConstants.modify.tr,
                       style: const TextStyle(
                           fontWeight: FontWeight.w400,
                           fontSize: 17,
                           decoration: TextDecoration.underline)
                     )
                 ),
               ],
             ),
             const SizedBox(height: 10,),
             Text("5 ${AppTranslationConstants.musicians.tr}",
               style: const TextStyle(color: Colors.grey,fontSize: 16),),
             const SizedBox(height: 10,),
             Text(AppTranslationConstants.priceDetails.tr,
               style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
             const SizedBox(height: 10,),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: <Widget>[
                 Text("\$500 x 2 ${AppTranslationConstants.hour.tr}",
                   style: const TextStyle(
                       color: Colors.grey,
                       fontSize: 16)
                 ),
                 const Text("\$500.00 ${"MXN"}",
                   style: TextStyle(
                       color: Colors.grey,
                       fontSize: 16)
                 ),
               ],
             ),
             const Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: <Widget>[
                 Text("Impuestos",
                     style: TextStyle(
                         color: Colors.grey,
                         fontSize: 16)
                 ),
                 Text("\$80.00 ${"MXN"}",
                     style: TextStyle(
                         color: Colors.grey,
                         fontSize: 16)
                 ),
               ],
             ),
             Divider(color: AppColor.white80),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: <Widget>[
                 Text("Total",
                     style: TextStyle(
                         color: AppColor.white80,
                         fontSize: 16, fontWeight: FontWeight.w600)
                 ),
                 Text("\$580.00 ${"MXN"}",
                     style: TextStyle(
                         color: AppColor.white80,
                         fontSize: 16)
                 ),
               ],
             ),
             const SizedBox(height: 50),
             Center(
               child: MaterialButton(onPressed: ()=> AppUtilities.logger.e(""),
                 child: Container(
                   width: MediaQuery.of(context).size.width,
                     padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(15),
                       color: AppColor.bondiBlue,
                     ),
                     child: Text(AppTranslationConstants.confirmAndPay.tr,
                       style: const TextStyle(color: Colors.white),
                       textAlign: TextAlign.center)
                 ),
               ),
             )
           ]
          ),
        ),
      ),
    );
  }
}
