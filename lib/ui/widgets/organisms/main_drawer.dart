import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:native_app/store/state/app/logout/notifier.dart';
import 'package:native_app/store/state/domain/division/divisions/selectors.dart';
import 'package:native_app/store/state/ui/division_id/selectors.dart';
import 'package:native_app/ui/constants.dart';
import 'package:native_app/ui/screens/division/divisions/list.dart';
import 'package:package_info/package_info.dart';

class MainDrawer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final divisionId = ref.watch(divisionIdSelector);
    final divisions = ref.watch(divisionsSelector);
    final division = divisionId != null
        ? divisions.firstWhereOrNull((element) => element.id == divisionId)
        : null;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(ImagePaths.logo)),
            ),
            child: null,
          ),
          ListTile(
            leading: const Icon(Icons.apartment),
            title: Text(division?.name ?? 'Divisions'),
            onTap: () async {
              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                  builder: (context) => DivisionListScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(AppLocalizations.of(context)!.logout),
            onTap: () {
              final notifier = ref.read(logoutStateProvider.notifier);
              notifier.logout();
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(MaterialLocalizations.of(context).licensesPageTitle),
            onTap: () async {
              final packageInfo = await PackageInfo.fromPlatform();
              showLicensePage(
                context: context,
                useRootNavigator: true,
                applicationName: packageInfo.appName,
                applicationVersion: packageInfo.version,
              );
            },
          ),
        ],
      ),
    );
  }
}
