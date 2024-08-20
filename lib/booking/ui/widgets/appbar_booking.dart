import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neom_commons/neom_commons.dart';



// ignore: must_be_immutable
class AppBarBooking extends StatelessWidget implements PreferredSizeWidget {

  final String title;
  Color? color;

  AppBarBooking({this.title = "", this.color, super.key});

  @override
  Size get preferredSize => AppTheme.appBarHeight;

  @override
  Widget build(BuildContext context) {

    color ??= AppColor.appBar;

    return AppBar(
      title: Text(title.capitalizeFirst, style: TextStyle(color: Colors.white.withOpacity(0.8),
          fontWeight: FontWeight.bold),
      ),
      actions: [
        Container(
          padding: const EdgeInsets.all(5),
          width: AppTheme.fullWidth(context),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Get.toNamed(AppRouteConstants.bookingSearch);
            },
            hoverColor: AppColor.bondiBlue,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color:Colors.grey[300]!),),
              child: Padding(
                padding:  const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    const Icon(Icons.search),
                    Text(AppTranslationConstants.bookingSearchHint.tr,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )

      ],
      backgroundColor: color,
      elevation: 0.0,
    );
  }

}
