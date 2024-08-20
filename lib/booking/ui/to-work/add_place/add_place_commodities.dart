import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neom_commons/core/utils/app_color.dart';
import 'package:neom_commons/core/utils/app_theme.dart';
import 'package:neom_commons/core/utils/constants/app_translation_constants.dart';

import 'add_place_photos.dart';

class AddPlaceCommodities extends StatefulWidget {
  const AddPlaceCommodities({super.key});

  @override
  AddPlaceCommoditiesState createState() => AddPlaceCommoditiesState();
}

class AddPlaceCommoditiesState extends State<AddPlaceCommodities> {

  var _chambreSelected=false;

  var _repasInclus=false;
  var _parking=false;
  var _equipe=false;
  var _serviceChambre=false;
  var _enfantAutorise=false;
  var _fumeeAutorise=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.main50,
      body: SingleChildScrollView(
        child: Container(
          decoration: AppTheme.appBoxDecoration,
          padding: const EdgeInsets.symmetric(vertical:25,horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.arrow_back, size: 23,),
                onPressed: (){
                  Navigator.pop(context);
                },),
              const SizedBox(height: 30,),
              GestureDetector(
               child: Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 15),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: <Widget>[
                     const Text("Wi-Fi",style: TextStyle(fontSize: 15),),
                     Container(
                       height: 35,
                       decoration: BoxDecoration(shape: BoxShape.circle, color: _chambreSelected? Colors.blue:Colors.black12),
                       child: _chambreSelected
                           ? const Icon(
                         Icons.check,
                         size: 30.0,
                         color: Colors.white,
                       )
                           :const Icon(
                         Icons.check,
                         size: 30.0,
                         color: Colors.white,
                       )
                     ),
                   ],
                 ),
               ),
                onTap: (){
                 setState(() {
                   _chambreSelected=!_chambreSelected;
                 });
                },
              ),
              separateurHorizontal(),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(AppTranslationConstants.acousticConditioning.tr,
                        style: const TextStyle(fontSize: 15),),
                      Container(
                          height: 35,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: _repasInclus? Colors.blue:Colors.black12),
                          child: _repasInclus
                              ? const Icon(
                            Icons.check,
                            size: 30.0,
                            color: Colors.white,
                          )
                              :const Icon(
                            Icons.check,
                            size: 30.0,
                            color: Colors.white,
                          )
                      ),
                    ],
                  ),
                ),
                onTap: (){
                  setState(() {
                    _repasInclus=!_repasInclus;
                  });
                },
              ),
              separateurHorizontal(),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(AppTranslationConstants.parking.tr,
                        style: const TextStyle(fontSize: 15),),
                      Container(
                          height: 35,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: _parking? Colors.blue:Colors.black12),
                          child: _parking
                              ? const Icon(
                            Icons.check,
                            size: 30.0,
                            color: Colors.white,
                          )
                              :const Icon(
                            Icons.check,
                            size: 30.0,
                            color: Colors.white,
                          )
                      ),
                    ],
                  ),
                ),
                onTap: (){
                  setState(() {
                    _parking=!_parking;
                  });
                },
              ),
              separateurHorizontal(),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(AppTranslationConstants.audioEquipment.tr,style: const TextStyle(fontSize: 15),),
                      Container(
                          height: 35,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: _equipe? Colors.blue:Colors.black12),
                          child: _equipe
                              ? const Icon(
                            Icons.check,
                            size: 30.0,
                            color: Colors.white,
                          )
                              :const Icon(
                            Icons.check,
                            size: 30.0,
                            color: Colors.white,
                          )
                      ),
                    ],
                  ),
                ),
                onTap: (){
                  setState(() {
                    _equipe=!_equipe;
                  });
                },
              ),
              separateurHorizontal(),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(AppTranslationConstants.musicalInstruments.tr,style: const TextStyle(fontSize: 15),),
                      Container(
                          height: 35,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: _equipe? Colors.blue:Colors.black12),
                          child: _equipe
                              ? const Icon(
                            Icons.check,
                            size: 30.0,
                            color: Colors.white,
                          )
                              :const Icon(
                            Icons.check,
                            size: 30.0,
                            color: Colors.white,
                          )
                      ),
                    ],
                  ),
                ),
                onTap: (){
                  setState(() {
                    _equipe=!_equipe;
                  });
                },
              ),
              separateurHorizontal(),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(AppTranslationConstants.roomService.tr,
                        style: const TextStyle(fontSize: 15),),
                      Container(
                          height: 35,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: _serviceChambre? Colors.blue:Colors.black12),
                          child: _serviceChambre
                              ? const Icon(
                            Icons.check,
                            size: 30.0,
                            color: Colors.white,
                          )
                              :const Icon(
                            Icons.check,
                            size: 30.0,
                            color: Colors.white,
                          )
                      ),
                    ],
                  ),
                ),
                onTap: (){
                  setState(() {
                    _serviceChambre=!_serviceChambre;
                  });
                },
              ),
              separateurHorizontal(),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text("Kids allowed",style: TextStyle(fontSize: 15),),
                      Container(
                          height: 35,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: _enfantAutorise? Colors.blue:Colors.black12),
                          child: _enfantAutorise
                              ? const Icon(
                            Icons.check,
                            size: 30.0,
                            color: Colors.white,
                          )
                              :const Icon(
                            Icons.check,
                            size: 30.0,
                            color: Colors.white,
                          )
                      ),
                    ],
                  ),
                ),
                onTap: (){
                  setState(() {
                    _enfantAutorise=!_enfantAutorise;
                  });
                },
              ),
              separateurHorizontal(),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text("Smoke allowed",style: TextStyle(fontSize: 15),),
                      Container(
                          height: 35,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: _fumeeAutorise? Colors.blue:Colors.black12),
                          child: _fumeeAutorise
                              ? const Icon(
                            Icons.check,
                            size: 30.0,
                            color: Colors.white,
                          )
                              :const Icon(
                            Icons.check,
                            size: 30.0,
                            color: Colors.white,
                          )
                      ),
                    ],
                  ),
                ),
                onTap: (){
                  setState(() {
                    _fumeeAutorise=!_fumeeAutorise;
                  });
                },
              ),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text("Smoke Detector",style: TextStyle(fontSize: 15),),
                      Container(
                          height: 35,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: _fumeeAutorise? Colors.blue:Colors.black12),
                          child: _fumeeAutorise
                              ? const Icon(
                            Icons.check,
                            size: 30.0,
                            color: Colors.white,
                          )
                              :const Icon(
                            Icons.check,
                            size: 30.0,
                            color: Colors.white,
                          )
                      ),
                    ],
                  ),
                ),
                onTap: (){
                  setState(() {
                    _fumeeAutorise=!_fumeeAutorise;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: MaterialButton(
        onPressed: (){
          Get.to(() =>  const AddPlacePhotos());
        },
        elevation: 3,
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.red,
            ),
            child: Text(AppTranslationConstants.next.tr,style: const TextStyle(color: Colors.white),)),
      ),
    );
  }

  Container separateurHorizontal() {
    return Container(
              margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
              height: 0.3,
              color: Colors.grey,
            );
  }
}
