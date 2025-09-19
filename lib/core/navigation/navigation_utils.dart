import 'package:ellelife/core/navigation/route_names.dart';
import 'package:go_router/go_router.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';

abstract class NavigationUtils {
  static final icons = [
    (MingCuteIcons.mgc_home_3_line, MingCuteIcons.mgc_home_3_fill, "Home"),
    (MingCuteIcons.mgc_video_line, MingCuteIcons.mgc_video_fill, "Reels"),

    (MingCuteIcons.mgc_group_2_line, MingCuteIcons.mgc_group_2_fill, "Teams"),
    (MingCuteIcons.mgc_user_5_line, MingCuteIcons.mgc_user_5_fill, "Profile"),
  ];

  static int activeIndex(GoRouterState state) {
    return switch (state.fullPath) {
      RouteNames.home => 0,
      RouteNames.reels => 1,
      RouteNames.teams => 2,
      RouteNames.profile => 3,
      _ => 0,
    };
  }
}
