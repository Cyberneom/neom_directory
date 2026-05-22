import 'package:neom_core/ui/deferred_loader.dart';
import 'package:neom_core/utils/constants/app_route_constants.dart';
import 'package:sint/sint.dart';

import 'ui/directory_page.dart' deferred as directory;
import 'ui/skills/skills_edit_page.dart' deferred as skillsEdit;
import 'ui/web/directory_service_detail_page.dart' deferred as serviceDetail;

class DirectoryRoutes {

  static final List<SintPage<dynamic>> routes = [
    SintPage(
      name: AppRouteConstants.directory,
      page: () => DeferredLoader(directory.loadLibrary, () => directory.DirectoryPage()),
      transition: Transition.upToDown,
    ),
    SintPage(
      name: '/directory/service',
      page: () => DeferredLoader(serviceDetail.loadLibrary, () => serviceDetail.DirectoryServiceDetailPage()),
      transition: Transition.rightToLeftWithFade,
    ),
    SintPage(
      name: '/directory/skills',
      page: () => DeferredLoader(skillsEdit.loadLibrary, () => skillsEdit.SkillsEditPage()),
      transition: Transition.rightToLeftWithFade,
    ),
  ];

}
