//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:gigmeout/add/ui/add_gig_place/add_gig_place.dart';
// import 'package:gigmeout/booking/ui/host-profile/InfoPersonnel.dart';
// import 'package:gigmeout/core/utils/constants/gig-translation-constants.dart';
// import 'package:gigmeout/core/utils/gig-app-color.dart';
// import 'package:gigmeout/core/utils/gig-app-theme.dart';
// import 'package:get/get.dart';
//
//
// void main()=>runApp(
//     MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home : GigHostProfile(),
//     )
// );
//
//   class GigHostProfile extends StatefulWidget {
//
//   @override
//   _GigHostProfileState createState() => _GigHostProfileState();
//   }
//
//   class _GigHostProfileState extends State<GigHostProfile> {
//
//     @override
//     Widget build(BuildContext context) {
//       return Scaffold(
//         backgroundColor: GigAppColor.gigBlue50,
//         body: ListView(
//           children: <Widget>[
//         Container(
//           decoration: GigAppTheme.gigBoxDecoration,
//           child: Padding(
//           padding: EdgeInsets.all(25),
//           child: Row(
//             children: <Widget>[
//               Container(
//                 width: 60.0,
//                 height: 60.0,
//                 decoration: BoxDecoration(
//                     image: DecorationImage(
//                         image: Image.network("https://scontent.fgdl9-1.fna.fbcdn.net/v/t39.30808-6/221645235_10159386241273149_636331263202789404_n.jpg?_nc_cat=101&ccb=1-5&_nc_sid=09cbfe&_nc_eui2=AeHXj8wk19HWVFhZNXXCF-Dmlm0OD5gMmWeWbQ4PmAyZZ3Bp6aGVOxd1NkByp3C004Y&_nc_ohc=b3ueuUCdO9gAX884RB7&tn=Qsb94kQ_D0lw_4J0&_nc_ht=scontent.fgdl9-1.fna&oh=737bf3c17e467bda6e730502eeaf66dd&oe=613A48AF").image,
//                         fit: BoxFit.cover
//                     ),
//                     borderRadius: BorderRadius.circular(20)
//                 ),
//               ),
//               SizedBox(width: 15,),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text("Robert Redone",style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 24,
//                   ),),
//                 ],
//               )
//             ],
//           ),
//          ),
//         ),
//         ClipRRect(
//           child: Container(
//             margin: EdgeInsets.only(bottom: 5.0),
//             decoration: BoxDecoration(
//               color: Colors.black12,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black87,
//                   offset: Offset(0.0, 1.0), //(x,y)
//                   blurRadius: 5.0,
//                 ),
//               ],
//             ),
//             width: 50,
//             height: 1,
//           ),
//         ),
//             Padding(
//               padding:  EdgeInsets.all(15),
//               child: Text("Host Account Settings".toUpperCase(),style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
//             ),
//             TextButton(
//                     onPressed: (){
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => PersonalInformation()),
//                       );
//                     },
//                     child: Padding(
//                       padding:  EdgeInsets.all(15),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: <Widget>[
//                          Expanded(
//                            child: Text("Personal Information",
//                             style: TextStyle(fontSize: 17,fontWeight: FontWeight.w300),
//                               overflow: TextOverflow.ellipsis,),
//                          ),
//                           Icon(
//                             Icons.person_outline,
//                           ),
//           ],
//                       ),
//                     ),
//                 ),
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 30),
//               decoration: BoxDecoration(
//                 color: Colors.black12,
//               ),
//               width: 50,
//               height: 1,
//             ),
//             TextButton(
//               onPressed: (){},
//               child: Padding(
//                 padding:  EdgeInsets.all(15),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                     Expanded(
//                       child: Text(GigTranslationConstants.notifications.tr,
//                         style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300),
//                         overflow: TextOverflow.ellipsis,),
//                     ),
//                     Icon(
//                       Icons.notifications_none,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 30),
//               decoration: BoxDecoration(
//                 color: Colors.black12,
//               ),
//               width: 50,
//               height: 1,
//             ),
//             TextButton(
//               onPressed: (){
//                 Get.to(AddGigPlace());
//               },
//               child: Padding(
//                 padding:  EdgeInsets.all(15),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                     Expanded(
//                       child: Text("Add Gig Place",
//                         style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300),
//                         overflow: TextOverflow.ellipsis,),
//                     ),
//                     Icon(
//                       Icons.add_circle_outline,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 30),
//               decoration: BoxDecoration(
//                 color: Colors.black12,
//               ),
//               width: 50,
//               height: 1,
//             ),
//           ],
//         ),
//       );
//     }
//   }
