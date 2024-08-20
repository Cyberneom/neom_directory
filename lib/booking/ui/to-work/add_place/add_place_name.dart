import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neom_commons/core/utils/app_color.dart';
import 'package:neom_commons/core/utils/app_theme.dart';
import 'package:neom_commons/core/utils/constants/app_translation_constants.dart';

import 'add_place.dart';

class AddPlaceName extends StatefulWidget {
  const AddPlaceName({super.key});

  @override
  AddPlaceNameState createState() => AddPlaceNameState();
}

class AddPlaceNameState extends State<AddPlaceName> {
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
                const Text("Give a name to your place",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500),),
                const SizedBox(height: 20,),
                const Text("Attract musicians with a place title that highlights what makes your accommodation unique",
                  style: TextStyle(fontSize: 18,color:Colors.black87,fontWeight: FontWeight.w400),),
                const SizedBox(height: 30,),
                const TextField(
                  style: TextStyle(color: Colors.black87,fontSize: 18),
                  decoration: InputDecoration(
                    hintText: "Add a title",
                  ),
                ),
                const SizedBox(height: 80,),
                Align(
                  alignment: Alignment.bottomRight,
                  child: MaterialButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddPlace()),
                      );
                    },
                    elevation: 3,
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.red,
                        ),
                        child: Text(AppTranslationConstants.next.tr,
                          style: const TextStyle(color: Colors.white),
                        )
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
    // MediaQuery.of(context).viewInsets.bottom == 0.0

    );
  }
}
