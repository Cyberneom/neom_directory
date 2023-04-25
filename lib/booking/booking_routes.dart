import 'package:get/get.dart';
import 'package:neom_commons/core/utils/constants/app_route_constants.dart';

import 'ui/booking_home_page.dart';
import 'ui/directory/directory_page.dart';
import 'ui/search/booking_search_page.dart';

class BookingRoutes {

  static final List<GetPage<dynamic>> routes = [
    GetPage(
      name: AppRouteConstants.booking,
      page: () => const BookingHomePage(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: AppRouteConstants.directory,
      page: () => const DirectoryPage(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: AppRouteConstants.bookingSearch,
      page: () => const BookingSearchPage(),
      transition: Transition.upToDown,
    ),
  ];

}
