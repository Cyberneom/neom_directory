import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neom_commons/core/utils/app_color.dart';
import 'package:neom_commons/core/utils/app_theme.dart';
import 'package:neom_commons/core/utils/constants/app_translation_constants.dart';

import 'add_place_name.dart';

class AddPlacePhotos extends StatefulWidget {
  const AddPlacePhotos({super.key});

  @override
  AddPlacePhotosState createState() => AddPlacePhotosState();
}

class AddPlacePhotosState extends State<AddPlacePhotos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.main50,
        body: SingleChildScrollView(
        child: Container(
           decoration: AppTheme.appBoxDecoration,
           padding: const EdgeInsets.symmetric(vertical:25,horizontal: 25 ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              IconButton(
                icon: const Icon(Icons.arrow_back,color: Colors.black87,size: 23,),
            onPressed: (){
             Get.back();
            },),
               const SizedBox(height: 30,),
               const Text("Add photos to your Place",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500),),
               const SizedBox(height: 20,),
                const Text("Photos help travelers see themselves in your accommodation. You can start with a photo and add more after posting",
                  style: TextStyle(fontSize: 18,color:Colors.black87,fontWeight: FontWeight.w400),),
               const SizedBox(height: 30,),
                MaterialButton(
                  onPressed: (){
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ()),
                    );*/
                  },
                  elevation: 3,
                  child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.red,
                      ),
                      child: Text(AppTranslationConstants.addPictures.tr,style: const TextStyle(color: Colors.white),)),
                ),
                const SizedBox(height: 25,),
                Align(
                  alignment: Alignment.centerRight,
                  child: MaterialButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddPlaceName()),
                      );
                    },
                    elevation: 3,
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.red)

                        ),
                        child: Text(AppTranslationConstants.later.tr,style: const TextStyle(color: Colors.red),)),
                  ),
                ),
    ],
    ),
    ),
        ),
            );
  }
}
