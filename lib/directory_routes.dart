import 'package:neom_core/utils/constants/app_route_constants.dart';
import 'package:sint/sint.dart';

import 'ui/directory_page.dart';
import 'ui/skills/skills_edit_page.dart';
import 'ui/web/directory_service_detail_page.dart';

class DirectoryRoutes {

  static final List<SintPage<dynamic>> routes = [
    SintPage(
      name: AppRouteConstants.directory,
      page: () => const DirectoryPage(),
      transition: Transition.upToDown,
    ),
    SintPage(
      name: '/directory/service',
      page: () => const DirectoryServiceDetailPage(),
      transition: Transition.rightToLeftWithFade,
    ),
    SintPage(
      name: '/directory/skills',
      page: () => const SkillsEditPage(),
      transition: Transition.rightToLeftWithFade,
    ),
  ];

}
