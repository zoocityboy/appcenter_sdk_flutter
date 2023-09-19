import 'dart:async';
import 'dart:io';

import 'package:appcenter/appcenter.dart';
import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'key_extension.dart';

final secret = Platform.isIOS
    ? String.fromEnvironment('APP_CENTER_IOS_SECRET',
        defaultValue: 'b908f428-53a7-486a-a265-30a8df5ba12e')
    : String.fromEnvironment('APP_CENTER_ANDROID_SECRET',
        defaultValue: '0bbc01a5-32e2-4d49-ba9b-10f1729ba3a7');
late String instanceId;
final Stopwatch watch = Stopwatch()..start();
Future<void> main() async {
  print('secret: $secret');
  print('meseurament: start ${watch.elapsedMicroseconds}');
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (final details) async {
    await Crashes.trackException(
      message: details.exception.toString(),
      type: details.exception.runtimeType,
      stackTrace: details.stack,
    );
  };
  AppCenter.start(
    secret: secret,
    usePrivateTrack: false,
  ).then((value) {
    print('meseurament: end ${watch.elapsedMicroseconds}');
    Distribution.setDistributeEnable(value: true);
    AppCenter.isRunningInAppCenterTestCloud().then(
      (value) => print('isRunningInAppCenterTestCloud: $value'),
    );
    AppCenter.getInstallId().then(
      (value) => instanceId = value,
    );

    Crashes.isEnabled().then(
      (value) => print('isEnabled: $value'),
    );
    Crashes.hasCrashedInLastSession().then(
      (value) => print('hasCrashedInLastSession: $value'),
    );
    Analytics.isEnabled().then(
      (value) => print('isEnabled: $value'),
    );
    Analytics.setTransmissionInterval(10).then(
      (value) => print('setTransmissionInterval: $value'),
    );
    Distribution.setDistributeDebugEnable(value: true).then(
      (value) => print('setDistributeDebugEnable: true'),
    );
  });

  runApp(const MyApp());
}

/// MyApp widget.
class MyApp extends StatelessWidget {
  /// Initializes [key].
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: Page(
        key: Key('page'),
      ),
    );
  }
}

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  late final StreamSubscription<dynamic> subscription;
  @override
  void initState() {
    print('meseurament: Page init ${watch.elapsedMicroseconds}');
    super.initState();
    getInstanceId();
    subscription = Distribution.onDistributeUpdateStream.listen((data) {
      print('onDistributeUpdateStream: $data');
      if (mounted) {
        if (data != null)
          showDialog<UpdateAction>(
            context: context,
            barrierDismissible: !data.isMandatoryUpdate,
            builder: (BuildContext context) {
              return AlertDialog(
                  icon: Icon(
                    Icons.update_rounded,
                  ),
                  iconPadding: EdgeInsets.all(16),
                  title: const Text('AppCenter'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(data.releaseNotes ??
                          'Release Notes are not available'),
                      Divider(),
                      TextButton(child: const Text('Notes'), onPressed: () {}),
                    ],
                  ),
                  actionsOverflowButtonSpacing: 8,
                  actionsAlignment: MainAxisAlignment.end,
                  actions: [
                    if (!data.isMandatoryUpdate)
                      TextButton(
                          child: const Text('Postpone'),
                          onPressed: () {
                            Navigator.of(context).pop(UpdateAction.postpone);
                          }),
                    TextButton(
                        child: const Text('Update'),
                        onPressed: () {
                          Navigator.of(context).pop(UpdateAction.update);
                        })
                  ]);
            },
            useSafeArea: true,
          ).then((value) {
            if (value == null) return;
            if (value == UpdateAction.cancel) {
            } else {
              Distribution.handleDistributeUpdateAction(
                  updateAction: value.value);
            }

            ///
          }, onError: (error) {
            ///
          });
      }
    });
  }

  bool inProgress = false;
  String instanceId = '';
  void getInstanceId() async {
    AppCenter.getInstallId().then(
      (value) => setState(() => instanceId = value),
    );
  }

  @override
  void dispose() {
    print('meseurament: Page dispose ${watch.elapsedMicroseconds}');
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            centerTitle: true,
            leading: Builder(builder: (context) {
              return Center(
                child: SizedBox.square(
                  dimension: 32,
                  child: Image.asset(
                    'assets/AppCenterLogo.webp',
                    color: AppBarTheme.of(context).foregroundColor,
                  ),
                ),
              );
            }),
            title: Text('AppCenter'),
            actions: [
              IconButton.outlined(
                icon: Icon(Icons.bug_report),
                onPressed: () {},
              )
            ],
            bottom: PreferredSize(
              child: Divider(height: 1),
              preferredSize: Size.fromHeight(1),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTileTheme.merge(
                  titleTextStyle: Theme.of(context).textTheme.labelSmall,
                  subtitleTextStyle: Theme.of(context).textTheme.labelLarge,
                  child: ListTile(
                      title: Text('INSTANCEID'),
                      subtitle: Text(
                        '${instanceId}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      trailing: StatefulBuilder(
                        builder: (context, setState) {
                          // Future<void> calculateFibonaci() async {
                          //   setState(() => inProgress = true);
                          //   await AppCenter.fibonacci(50);
                          //   setState(() => inProgress = false);
                          // }

                          return inProgress
                              ? CircularProgressIndicator()
                              : IconButton(
                                  icon: Icon(Icons.refresh_outlined),
                                  // onPressed: calculateFibonaci,
                                  onPressed: () {},
                                );
                        },
                      )),
                ),
                Divider(),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Text('Crashes',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                CardButton(
                  key: Key('trackException'),
                  onPressed: (identity) {
                    unawaited(Analytics.trackEvent(
                        name: 'trackExcpetion',
                        properties: {
                          'event': 'onPressed',
                          'instanceId': instanceId,
                          'widget': identity
                        }));
                    int.parse('not a number');
                  },
                  child: const Text('TrackException'),
                ),
                CardButton(
                  key: Key('crashButton2'),
                  onPressed: (identity) {
                    unawaited(Analytics.trackEvent(
                        name: 'generateTestCrash',
                        properties: {
                          'event': 'onPressed',
                          'instanceId': instanceId,
                          'widget': identity
                        }));
                    unawaited(Crashes.generateTestCrash());
                  },
                  child: const Text('GenerateTestCrash'),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Text('Analaytics',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                CardButton(
                  key: Key('analyticsButton1'),
                  onPressed: (identity) {
                    unawaited(
                        Analytics.trackEvent(name: 'customEvent1', properties: {
                      'animal': Faker().animal.name(),
                      'color': Faker().color.color(),
                      'name': Faker().person.name(),
                      'age': Faker().randomGenerator.numbers(98, 20).toString(),
                      'instanceId': instanceId,
                      'widget': identity
                    }));
                  },
                  child: const Text('Custom Event 1'),
                ),
                CardButton(
                  key: Key('analyticsButton2'),
                  onPressed: (identity) {
                    unawaited(
                        Analytics.trackEvent(name: 'customEvent2', properties: {
                      'animal': Faker().animal.name(),
                      'color': Faker().color.color(),
                      'name': Faker().person.name(),
                      'age': Faker().randomGenerator.numbers(98, 20).toString(),
                      'instanceId': instanceId,
                      'widget': identity
                    }));
                  },
                  child: const Text('Custom Event 2'),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Text('Distribute',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                CardButton(
                  key: Key('distributeButton1'),
                  onPressed: (identity) {
                    unawaited(Analytics.trackEvent(
                        name: 'checkUpdate',
                        properties: {
                          'instanceId': instanceId,
                          'widget': identity
                        }));
                    unawaited(Distribution.checkForUpdates());
                  },
                  child: const Text('Check Update'),
                ),
                CardButton(
                  key: Key('distributeButton2'),
                  onPressed: (identity) {
                    // unawaited(AppCenterAnalytics.trackEvent(
                    //     name: 'checkUpdate',
                    //     properties: {
                    //       'instanceId': instanceId,
                    //       'widget': identity
                    //     }));
                    unawaited(Distribution.checkForUpdates());
                  },
                  child: const Text('Check Update'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

mixin TrackableWidget on Widget, Diagnosticable {
  String get identity => toIdentityString();

  String toIdentityString() {
    final String type = objectRuntimeType(this, 'Widget');

    return key == null ? type : '$type-${key?.toStringValue()}';
  }
}

class CardButton extends StatelessWidget
    with DiagnosticableTreeMixin, TrackableWidget {
  const CardButton({super.key, required this.onPressed, required this.child});
  final void Function(String identity) onPressed;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 0.5,
        ),
      ),
      elevation: 0,
      child: Builder(builder: (context) {
        return InkWell(
          onTap: () => onPressed.call(identity),
          child: Center(child: child),
        );
      }),
    );
  }
}

final baseDarkTheme = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xffCB2E63).withOpacity(.7),
      brightness: Brightness.dark,
    ),
    useMaterial3: true);
final darkTheme = baseDarkTheme.copyWith(
  appBarTheme: AppBarTheme(
    foregroundColor: baseDarkTheme.colorScheme.primaryContainer,
  ),
);

final baseLightTheme = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xffCB2E63),
      brightness: Brightness.light,
    ),
    useMaterial3: true);
final lightTheme = baseLightTheme.copyWith(
  appBarTheme: AppBarTheme(
    foregroundColor: baseDarkTheme.colorScheme.primaryContainer,
  ),
);
