import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/store/state/app/logout/notifier.dart';
import 'package:native_app/ui/constants.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            leading: const Icon(Icons.logout),
            title: Text(AppLocalizations.of(context)!.logout),
            onTap: () {
              final notifier = context.read<LogoutNotifier>();
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
