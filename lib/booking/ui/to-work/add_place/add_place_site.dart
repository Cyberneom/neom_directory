import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neom_commons/core/utils/app_color.dart';
import 'package:neom_commons/core/utils/app_theme.dart';
import 'package:neom_commons/core/utils/app_utilities.dart';
import 'package:neom_commons/core/utils/constants/app_translation_constants.dart';

import 'add_place_commodities.dart';

class AddPlaceSite extends StatefulWidget {
  const AddPlaceSite({Key? key}) : super(key: key);

  @override
  AddPlaceSiteState createState() => AddPlaceSiteState();
}

class AddPlaceSiteState extends State<AddPlaceSite> {
  double defaultValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.main50,
      body: SingleChildScrollView(
        child: Container(
          decoration: AppTheme.appBoxDecoration,
          padding: const EdgeInsets.symmetric(vertical:25,horizontal: 15 ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.arrow_back, size: 23,),
              onPressed: (){
                Navigator.pop(context);
              },),
              const SizedBox(height: 30,),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text("Where is your place located?",
                  style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500),textAlign: TextAlign.left,),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text("This is the position that users see",
                  style: TextStyle(fontSize: 17,fontWeight: FontWeight.w300),textAlign: TextAlign.left,),
              ),
              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                child: MaterialButton(onPressed: ()=> AppUtilities.logger.e(""),
                  elevation: 5,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black87),
                    ),
                    child: const Text("Use current location",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              const Center(
                child: Text("Where enter your address",style: TextStyle(color: Colors.grey,fontSize: 12),),
              ),
              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(AppTranslationConstants.country.tr,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400),),
                    TextField(
                      style: const TextStyle(color: Colors.grey),
                    controller: TextEditingController(text: "México",),
                      decoration: const InputDecoration(
                      ),
                    ),
                    //separateurHorizontal(),

                  ],
                ),
              ),
              const SizedBox(height: 15,) ,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(AppTranslationConstants.state.tr,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400),
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.grey),
                      controller: TextEditingController(text: "Jalisco",),
                      decoration: const InputDecoration(
                      ),
                    ),
                    //separateurHorizontal(),

                  ],
                ),
              ),
              const SizedBox(height: 15,) ,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(AppTranslationConstants.city.tr,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400),
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.grey),
                      controller: TextEditingController(text: "Guadalajara",),
                      decoration: const InputDecoration(
                      ),
                    ),
                    //separateurHorizontal(),
                  ],
                ),
              ),
              const SizedBox(height: 15,) ,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(AppTranslationConstants.street.tr,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400),
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.grey),
                      controller: TextEditingController(text: "Av. Lopez Mateos",),
                      decoration: const InputDecoration(
                      ),
                    ),
                    //separateurHorizontal(),

                  ],
                ),
              ),
              const SizedBox(height: 15,) ,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(AppTranslationConstants.propertyNumber.tr,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400),),
                    TextField(
                      style: const TextStyle(color: Colors.grey),
                      controller: TextEditingController(text: "125",),
                      decoration: const InputDecoration(
                      ),
                    ),
                    //separateurHorizontal(),

                  ],
                ),
              ),
              const SizedBox(height: 15,) ,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(AppTranslationConstants.zipCode.tr,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400),),
                    TextField(
                      style: const TextStyle(color: Colors.grey),
                      controller: TextEditingController(text: "09037",),
                      decoration: const InputDecoration(
                      ),
                    ),
                    //separateurHorizontal(),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: MaterialButton(
        onPressed: (){
          Get.to(() =>  const AddPlaceCommodities());
        },
        elevation: 3,
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.red,
            ),
            child: Text(AppTranslationConstants.next.tr,
              style: const TextStyle(color: Colors.white),)),
      ),

    );
  }
  Container separateurHorizontal() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal:0,vertical: 8),
      height: 1,
      color: Colors.black12,
    );
  }
}
