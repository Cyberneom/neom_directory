import 'package:get/get.dart';
import 'package:neom_core/utils/constants/app_route_constants.dart';

import 'ui/directory_page.dart';

class DirectoryRoutes {

  static final List<GetPage<dynamic>> routes = [
    GetPage(
      name: AppRouteConstants.directory,
      page: () => const DirectoryPage(),
      transition: Transition.upToDown,
    ),
  ];

}
