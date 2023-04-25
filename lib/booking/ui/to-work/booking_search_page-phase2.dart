//
// import 'package:flutter/material.dart';
// import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
// import 'package:get/get.dart';
// import 'package:gigmeout/booking/ui/bloc/booking_filter.dart';
// import 'package:gigmeout/booking/ui/place/booking_places_page.dart';
// import 'package:gigmeout/booking/ui/widgets/event_counter.dart';
// import 'package:neom_commons/core/utils/app_color.dart';
// import 'package:neom_commons/core/utils/app_theme.dart';
// import 'package:neom_commons/core/utils/constants/app_route_constants.dart';
// import 'package:neom_commons/core/utils/constants/app_translation_constants.dart';
//
// class BookingSearchPage extends StatefulWidget {
//   const BookingSearchPage({Key? key}) : super(key: key);
//
//   @override
//   _BookingSearchPageState createState() => _BookingSearchPageState();
// }
//
// class _BookingSearchPageState extends State<BookingSearchPage> {
//
//   BookingFilter bookingFilter = BookingFilter();
//
//   var _selectedPeriod= dp.DatePeriod(DateTime.now().add(const Duration(days: 4)), DateTime.now().subtract(const Duration(days: 1)));
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.only(top: 20,left: 10),
//           child: Container(
//
//                 decoration: AppTheme.appBoxDecoration,
//                 child: Column(
//                   // mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Align(
//                       alignment: Alignment.topLeft,
//                       child: IconButton(
//                         icon: const Icon(Icons.arrow_back),
//                         onPressed: (){
//                           Get.back();
//                         },),
//                     ),
//                     AppTheme.heightSpace20,
//                     Container(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(AppTranslationConstants.location.tr.toUpperCase(),
//                               style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.all(15.0),
//                       child: Material(
//                         color: AppColor.main75,
//                         elevation: 5,
//                         borderRadius: BorderRadius.circular(20),
//                         child: TextField(
//                           decoration: InputDecoration(
//                               hintText: AppTranslationConstants.whereToGig.tr,
//                               border: InputBorder.none,
//                               prefixIcon: const Icon(Icons.room,)
//                           ),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(AppTranslationConstants.type.tr.toUpperCase(),
//                             style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.all(2),
//                       child: CheckboxListTile(
//                           activeColor: AppColor.bondiBlue,
//                           title: Text(AppTranslationConstants.rehearsalRoom.tr),
//                           value: bookingFilter.rehearsalRoom,
//                           onChanged: (value){
//                             setState(() {
//                               bookingFilter.rehearsalRoom = value ?? false;
//                             });
//                           }),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.all(2),
//                       child: CheckboxListTile(
//                           activeColor: AppColor.bondiBlue,
//                           title: Text(AppTranslationConstants.recordStudio.tr),
//                           value: bookingFilter.liveSession,
//                           onChanged: (value){
//                             setState(() {
//                               bookingFilter.liveSession = value ?? false;
//                             });
//                           }),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.all(2),
//                       child: CheckboxListTile(
//                           activeColor: AppColor.bondiBlue,
//                           title: Text(AppTranslationConstants.liveSessions.tr),
//                           value: bookingFilter.recordStudio,
//                           onChanged: (value){
//                             setState(() {
//                               bookingFilter.recordStudio = value ?? false;
//                             });
//                           }),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.all(2),
//                       child: Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(AppTranslationConstants.numberOfPlaces.tr.toUpperCase(),style: const TextStyle(color: Colors.grey,fontSize: 12,),),
//                       ),
//                     ),
//                     Container(
//                       padding:  const EdgeInsets.all(15),
//                       child: Material(
//                         borderRadius: BorderRadius.circular(20),
//                         color: AppColor.main75,
//                         elevation: 5,
//                         child: Container(
//                           //margin: EdgeInsets.symmetric(vertical: 25),
//                           padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 2),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(color: Colors.black87),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: <Widget>[
//                               Text(AppTranslationConstants.numberOfMusicians.tr,
//                                 style: const TextStyle(fontSize: 15),),
//                               EventCounter(
//                                 minValue: 0,
//                                 maxValue: 10,
//                                 decimalPlaces: 0,
//                                 initialValue: bookingFilter.numberOfMusicians,
//                                 color: AppColor.white80,
//                                 step: 1,
//                                 onChanged: (value0){
//                                   setState(() {
//                                     bookingFilter.numberOfMusicians = value0.toInt();
//                                   });
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.all(15),
//                       child: Material(
//                         borderRadius: BorderRadius.circular(20),
//                         color: AppColor.main75,
//                         elevation: 5,
//                         child: Container(
//                           //  margin: EdgeInsets.symmetric(vertical: 10),
//                           padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 2),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(color: Colors.black87),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: <Widget>[
//                               Text(AppTranslationConstants.numberOfGuests.tr,
//                                 style: const TextStyle(fontSize: 15),overflow: TextOverflow.ellipsis,),
//                               EventCounter(
//                                 minValue: 0,
//                                 maxValue: 5,
//                                 decimalPlaces: 0,
//                                 color: AppColor.white80,
//                                 initialValue: bookingFilter.numberOfGuests,
//                                 step: 1,
//                                 textStyle: const TextStyle(letterSpacing: 10),
//                                 onChanged: (value){
//                                   setState(() {
//                                     bookingFilter.numberOfGuests =value.toInt();
//                                   });
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(AppTranslationConstants.rating.tr.toUpperCase(),
//                           style: const TextStyle(color: Colors.grey,fontSize: 12,),),
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.all(15),
//                       child: Material(
//                         borderRadius: BorderRadius.circular(20),
//                         color: AppColor.main75,
//                         elevation: 5,
//                         child: Container(
//                           // margin: EdgeInsets.symmetric(vertical: 25),
//                           padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 2),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(color: Colors.black87),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: <Widget>[
//                               Text(AppTranslationConstants.score.tr, style: const TextStyle(fontSize: 15),),
//                               EventCounter(
//                                 minValue: 1,
//                                 maxValue: 5,
//                                 decimalPlaces: 1,
//                                 color: AppColor.white80,
//                                 initialValue: bookingFilter.rating,
//                                 step: 0.5,
//                                 onChanged: (value1){
//                                   setState(() {
//                                     bookingFilter.rating = value1.toDouble();
//                                   });
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     /** **/
//                     Container(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(AppTranslationConstants.rates.tr.toUpperCase(),style: const TextStyle(color: Colors.grey,fontSize: 12,),),
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.all(15),
//                       child: Material(
//                         color: AppColor.main75,
//                         elevation: 5,
//                         borderRadius: BorderRadius.circular(20),
//                         child: Container(
//                           //   margin: EdgeInsets.symmetric(vertical: 10),
//                           padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 2),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(color: Colors.black87),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: <Widget>[
//                               Text(AppTranslationConstants.price.tr,
//                                 style: const TextStyle(fontSize: 15),),
//                               RangeSlider(
//                                 min: 100,
//                                 max: 5000,
//                                 activeColor: AppColor.white80,
//                                 inactiveColor: AppColor.ceriseRed,
//                                 labels: RangeLabels("${bookingFilter.priceRange.start.toString().split(".").first} MXN",
//                                     "${bookingFilter.priceRange.end.toString().split(".").first} MXN"),
//                                 values: bookingFilter.priceRange,
//                                 divisions: 1000,
//                                 onChanged: (RangeValues range){
//                                   setState(() {
//                                     bookingFilter.priceRange = range;
//                                   });
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(AppTranslationConstants.chooseBookingDate.tr.toUpperCase(),style: const TextStyle(color: Colors.grey,fontSize: 12,),),
//                       ),
//                     ),
//                     dp.RangePicker(
//                       selectedPeriod: _selectedPeriod,
//                       onChanged: (datePeriod){
//                         setState(() {
//                           _selectedPeriod=datePeriod;
//                         });
//
//                       },
//                       selectableDayPredicate: _isSelectable,
//                       datePickerStyles: styles,
//                       firstDate: DateTime.now().subtract(const Duration(days: 1)),
//                       lastDate: DateTime.now().add(const Duration(days:  90)),
//
//                     ),
//                     Container(
//                       padding: const EdgeInsets.all(10),
//                       child: Material(
//                         color: AppColor.main75,
//                         elevation: 6,
//                         borderRadius: BorderRadius.circular(20),
//                         child: InkWell(
//                           onTap: () {
//                             Get.toNamed(AppRouteConstants.bookingSearch);
//                           },
//                           splashColor: AppColor.white80,
//                           hoverColor: AppColor.yellow,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 20,
//                                 vertical: 10
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: <Widget>[
//                                 Text(AppTranslationConstants.search.tr,
//                                   style: const TextStyle(fontSize: 18),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     AppTheme.heightSpace20
//                   ],
//                 ),
//               ),
//           ),
//         ),
//       );
//
//   }
//
//   bool _isSelectable(DateTime day) {
//     List<DateTime> eventsDates = [
//
//       DateTime(2020,09,12),
//       DateTime.now().add(const Duration(days: 4)),
//       DateTime.now().add(const Duration(days: 5)),
//       DateTime.now().add(const Duration(days: 10))
//     ];
//     return !eventsDates.any((eventDate) {
//       int diffDays = eventDate.difference(day).inDays;
//       return (diffDays == 0);
//     });
//   }
//   dp.DatePickerRangeStyles styles = dp.DatePickerRangeStyles(
//       selectedPeriodLastDecoration: const BoxDecoration(
//           color: AppColor.yellow,
//           borderRadius: BorderRadius.only(
//               topRight: Radius.circular(24.0),
//               bottomRight: Radius.circular(24.0))),
//       selectedPeriodStartDecoration: const BoxDecoration(
//         color: AppColor.yellow,
//         borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(24.0),
//             bottomLeft: Radius.circular(24.0)
//         ),
//       ),
//       selectedPeriodMiddleDecoration: const BoxDecoration(
//           color: AppColor.yellow,
//           shape: BoxShape.rectangle),
//       nextIcon: const Icon(Icons.arrow_right),
//       prevIcon: const Icon(Icons.arrow_left),
//      // dayHeaderStyleBuilder: _dayHeaderStyleBuilder
//   );
// }
