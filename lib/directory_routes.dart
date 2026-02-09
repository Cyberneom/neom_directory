import 'package:neom_core/utils/constants/app_route_constants.dart';
import 'package:sint/sint.dart';

import 'ui/directory_page.dart';

class DirectoryRoutes {

  static final List<SintPage<dynamic>> routes = [
    SintPage(
      name: AppRouteConstants.directory,
      page: () => const DirectoryPage(),
      transition: Transition.upToDown,
    ),
  ];

}
