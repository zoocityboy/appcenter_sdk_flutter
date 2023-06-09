import 'dart:async';

import 'package:appcenter/appcenter.dart';
import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'key_extension.dart';

final secret = String.fromEnvironment('APP_CENTER_SECRET',
    defaultValue: '0bbc01a5-32e2-4d49-ba9b-10f1729ba3a7');
late String instanceId;
final Stopwatch watch = Stopwatch()..start();
Future<void> main() async {
  void listener(dynamic value) {
    print(value);
  }

  print('secret: $secret');
  print('meseurament: start ${watch.elapsedMicroseconds}');
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (final details) async {
    await AppCenterCrashes.trackException(
      message: details.exception.toString(),
      type: details.exception.runtimeType,
      stackTrace: details.stack,
    );
  };
  await AppCenter.start(
    secret: secret,
    usePrivateTrack: false,
  );

  AppCenter.isRunningInAppCenterTestCloud().then(
    (value) => print('isRunningInAppCenterTestCloud: $value'),
  );

  AppCenterCrashes.isEnabled().then(
    (value) => print('isEnabled: $value'),
  );
  AppCenterCrashes.hasCrashedInLastSession().then(
    (value) => print('hasCrashedInLastSession: $value'),
  );
  AppCenterAnalytics.isEnabled().then(
    (value) => print('isEnabled: $value'),
  );
  AppCenterAnalytics.setTransmissionInterval(10).then(
    (value) => print('setTransmissionInterval: $value'),
  );
  AppCenterDistribution.setDistributeDebugEnable(value: true).then(
    (value) => print('setDistributeDebugEnable: true'),
  );
  AppCenterDistribution.onDistributeUpdateStream.listen(listener);
  runApp(const MyApp());
}

/// MyApp widget.
class MyApp extends StatefulWidget {
  /// Initializes [key].
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // unawaited(AppCenter.start(
    //   secret: secret,
    //   usePrivateTrack: false,
    // ).then(
    //   (value) {
    //     print('meseurament: AppCenter initialzed ${watch.elapsedMicroseconds}');
    //     AppCenter.getInstallId()
    //         .then((value) => instanceId = value)
    //         .catchError((e, s) => instanceId = '');
    //     AppCenter.isRunningInAppCenterTestCloud().then(
    //       (value) => print('isRunningInAppCenterTestCloud: $value'),
    //     );

    //     AppCenterCrashes.isEnabled().then(
    //       (value) => print('isEnabled: $value'),
    //     );
    //     AppCenterCrashes.hasCrashedInLastSession().then(
    //       (value) => print('hasCrashedInLastSession: $value'),
    //     );
    //     AppCenterAnalytics.isEnabled().then(
    //       (value) => print('isEnabled: $value'),
    //     );
    //     AppCenterAnalytics.setTransmissionInterval(10).then(
    //       (value) => print('setTransmissionInterval: $value'),
    //     );
    //     AppCenterDistribution.setDistributeDebugEnable(value: true).then(
    //       (value) => print('setDistributeDebugEnable: true'),
    //     );
    //     AppCenterDistribution.onDistributeUpdateStream.listen(listener);
    //   },
    // ));
    // AppCenter.getInstallId()
    //     .then((value) => instanceId = value)
    //     .catchError((e, s) => instanceId = '');
  }

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
  @override
  void initState() {
    print('meseurament: Page init ${watch.elapsedMicroseconds}');
    super.initState();
  }

  bool inProgress = false;

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
                      subtitle: FutureBuilder<String>(
                        key: Key('installId'),
                        future: AppCenter.getInstallId(),
                        builder: (final context, final snapshot) => Text(
                          '${snapshot.data ?? ''}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      trailing: StatefulBuilder(
                        builder: (context, setState) {
                          Future<void> calculateFibonaci() async {
                            setState(() => inProgress = true);
                            await AppCenter.fibonacci(50);
                            setState(() => inProgress = false);
                          }

                          return inProgress
                              ? CircularProgressIndicator()
                              : IconButton(
                                  icon: Icon(Icons.refresh_outlined),
                                  onPressed: calculateFibonaci,
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
                    unawaited(AppCenterAnalytics.trackEvent(
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
                    unawaited(AppCenterAnalytics.trackEvent(
                        name: 'generateTestCrash',
                        properties: {
                          'event': 'onPressed',
                          'instanceId': instanceId,
                          'widget': identity
                        }));
                    unawaited(AppCenterCrashes.generateTestCrash());
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
                    unawaited(AppCenterAnalytics.trackEvent(
                        name: 'customEvent1',
                        properties: {
                          'animal': Faker().animal.name(),
                          'color': Faker().color.color(),
                          'name': Faker().person.name(),
                          'age': Faker()
                              .randomGenerator
                              .numbers(98, 20)
                              .toString(),
                          'instanceId': instanceId,
                          'widget': identity
                        }));
                  },
                  child: const Text('Custom Event 1'),
                ),
                CardButton(
                  key: Key('analyticsButton2'),
                  onPressed: (identity) {
                    unawaited(AppCenterAnalytics.trackEvent(
                        name: 'customEvent2',
                        properties: {
                          'animal': Faker().animal.name(),
                          'color': Faker().color.color(),
                          'name': Faker().person.name(),
                          'age': Faker()
                              .randomGenerator
                              .numbers(98, 20)
                              .toString(),
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
                    unawaited(AppCenterAnalytics.trackEvent(
                        name: 'checkUpdate',
                        properties: {
                          'instanceId': instanceId,
                          'widget': identity
                        }));
                    unawaited(AppCenterDistribution.checkForUpdates());
                  },
                  child: const Text('Check Update'),
                ),
                CardButton(
                  key: Key('distributeButton2'),
                  onPressed: (identity) {
                    unawaited(AppCenterAnalytics.trackEvent(
                        name: 'checkUpdate',
                        properties: {
                          'instanceId': instanceId,
                          'widget': identity
                        }));
                    unawaited(AppCenterDistribution.checkForUpdates());
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
