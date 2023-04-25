import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neom_commons/core/utils/app_color.dart';
import 'package:neom_commons/core/utils/app_theme.dart';
import 'package:neom_commons/core/utils/constants/app_translation_constants.dart';

import 'add_place_site.dart';

class AddPlaceCategory extends StatefulWidget {
  const AddPlaceCategory({Key? key}) : super(key: key);

  @override
  AddPlaceCategoryState createState() => AddPlaceCategoryState();
}

class AddPlaceCategoryState extends State<AddPlaceCategory> {
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
               icon: const Icon(Icons.arrow_back,color: Colors.black87,size: 23,),
             onPressed: (){
               Get.back();
             },),
              const SizedBox(height: 30,),
              const Text("Tell us about your place",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500),maxLines: 2,textAlign: TextAlign.center,),
              const SizedBox(height: 30,),
              InkWell(
                onTap: (){
                  _askedToLead();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Padding(
                      padding:  EdgeInsets.fromLTRB(10,8,10,0),
                      child: Text("Start by choosing a general category",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400),),
                    ),
                    Padding(
                      padding:  EdgeInsets.fromLTRB(10,12,10,3),
                      child: Text("Select a general category",
                        style: TextStyle(
                            color:Colors.grey,
                            fontSize: 13,
                            fontWeight: FontWeight.w300),),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15,),
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  height: 1,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  sousCategorieDialog();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Padding(
                      padding:  EdgeInsets.fromLTRB(10,8,10,0),
                      child: Text("Choose a type of place now",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.fromLTRB(10,12,10,3),
                      child: Text("Select an option",
                        style: TextStyle(
                            color:Colors.grey,
                            fontSize: 13,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15,),
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  height: 1,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: MaterialButton(
        onPressed: (){
          Get.to(() =>  const AddPlaceSite());
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
  Future<void> _askedToLead() async {
    switch (await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () { Navigator.pop(context, "Appartement"); },
                child: const Text('Appartement'),
              ),
              SimpleDialogOption(
                onPressed: () { Navigator.pop(context, "Chambre"); },
                child: const Text('Chambre'),
              ),
              SimpleDialogOption(
                onPressed: () { Navigator.pop(context, "Hotel"); },
                child: const Text('Hotel'),
              ),
              SimpleDialogOption(
                onPressed: () { Navigator.pop(context, "Maison"); },
                child: const Text('Maison'),
              ),
            ],
          );
        }
    )) {
      case "Homme":
      // Let's go.
      // ...
        break;
      case "Femme":
      // ...
        break;
    }
  }

  Future<void> sousCategorieDialog() async {
    switch (await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () { Navigator.pop(context, "Endroit entier"); },
                child: const Text('Endroit entier'),
              ),
              SimpleDialogOption(
                onPressed: () { Navigator.pop(context, "Chambre partagé"); },
                child: const Text('Chambre partagé'),
              ),
            ],
          );
        }
    )) {
      case "Homme":
      // Let's go.
      // ...
        break;
      case "Femme":
      // ...
        break;
    }
  }
}
