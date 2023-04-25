import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neom_commons/neom_commons.dart';

import '../../booking_home_page.dart';
import 'add_place_category.dart';

class AddPlace extends StatefulWidget {
  const AddPlace({Key? key}) : super(key: key);

  @override
  AddPlaceState createState() => AddPlaceState();
}

class AddPlaceState extends State<AddPlace> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.to(() =>  const BookingHomePage());
        return true;
      },
      child: Scaffold(
          backgroundColor: AppColor.main50,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25,vertical:15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 35,),
                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddPlaceCategory()),
                      );
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: ()=>AppUtilities.logger.e(""),
                            icon:const Icon(Icons.add),
                            iconSize: 30)
                    ),
                  ),
                  const Text("2 Places",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold)),
                  const Text("In Progress",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Material(
                    color: AppColor.main75,
                    elevation: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          height:80,
                            width: MediaQuery.of(context).size.width/2,
                            child: const Center(child: Text("Rehearsal Room in Guadalajara",style: TextStyle(fontSize:15,fontWeight: FontWeight.w300),maxLines: 5,textAlign: TextAlign.center,))),
                        Container(
                          padding:const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(left: 8),
                          height: 80,
                            child: Image.network("https://firebasestorage.googleapis.com/v0/b/gig-me-out.appspot.com/o/RehearsalRooms%2FMexico%2FSolaz%2Fbateria.jpg?alt=media&token=70823527-3e00-4d98-87ba-4fce0dc3639e",
                              fit: BoxFit.fitHeight))
                      ],
                    ),
                  ),
                  AppTheme.heightSpace5,
                  Material(
                    color: AppColor.main75,
                    elevation: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                            height:80,
                            width: MediaQuery.of(context).size.width/2,
                            child: const Center(child: Text("Live Session en CDMX",style: TextStyle(fontSize:15,fontWeight: FontWeight.w300),maxLines: 5,textAlign: TextAlign.center,))),
                        Container(
                            padding:const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(left: 8),
                            height: 80,
                            child: Image.network("https://firebasestorage.googleapis.com/v0/b/gig-me-out.appspot.com/o/RehearsalRooms%2FMexico%2FWarhead%2Fcontenido.jpg?alt=media&token=38415d21-48e2-433b-8f97-5484c8fa173e",
                              fit: BoxFit.scaleDown,))
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Material(
                    color: AppColor.main75,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Icon(Icons.add,color: AppColor.ceriseRed,size: 25,),
                          const SizedBox(width: 15,),
                          InkWell(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const AddPlaceCategory()),
                              );
                            },
                              child: const Text("Add a new place",style: TextStyle(fontWeight: FontWeight.w500),))
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          )
      ),
    );
  }
}
