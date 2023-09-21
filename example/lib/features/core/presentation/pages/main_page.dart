import 'dart:async';

import 'package:appcenter_sdk/appcenter_sdk.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

import '../widget/card_button.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  static const String routeName = 'main';
  static const String routePath = '/main';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final StreamSubscription<dynamic> subscription;
  @override
  void initState() {
    super.initState();
    getInstanceId();
    subscription = Distribution.onDistributeUpdateStream.listen((data) {
      if (mounted) {
        if (data != null) {
          showDialog<UpdateActionTap>(
            context: context,
            barrierDismissible: !data.isMandatoryUpdate,
            builder: (BuildContext context) {
              return AlertDialog(
                icon: const Icon(
                  Icons.update_rounded,
                ),
                iconPadding: const EdgeInsets.all(16),
                title: const Text('New Update Available'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data.releaseNotes ?? 'Release Notes are not available',
                    ),
                    const Divider(),
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
                        Navigator.of(context).pop(UpdateActionTap.postpone);
                      },
                    ),
                  TextButton(
                    child: const Text('Update'),
                    onPressed: () {
                      Navigator.of(context).pop(UpdateActionTap.update);
                    },
                  ),
                ],
              );
            },
          ).then(
            (value) {
              if (value == null) return;
              if (value == UpdateActionTap.postpone) {
              } else {
                Distribution.handleDistributeUpdateAction(
                  updateAction: value,
                );
              }

              ///
            },
            onError: (error) {
              ///
            },
          );
        }
      }
    });
  }

  bool inProgress = false;
  String instanceId = '';
  Future<void> getInstanceId() async {
    await AppCenter.getInstallId().then(
      (value) => setState(() => instanceId = value),
    );
  }

  @override
  void dispose() {
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
            leading: Builder(
              builder: (context) {
                return Center(
                  child: SizedBox.square(
                    dimension: 32,
                    child: Image.asset(
                      'assets/AppCenterLogo.webp',
                      color: AppBarTheme.of(context).foregroundColor,
                    ),
                  ),
                );
              },
            ),
            title: const Text('AppCenter'),
            actions: [
              IconButton.outlined(
                icon: const Icon(Icons.bug_report),
                onPressed: () {},
              ),
            ],
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(height: 1),
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
                    title: const Text('INSTANCEID'),
                    subtitle: Text(
                      instanceId,
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
                            ? const CircularProgressIndicator()
                            : IconButton(
                                icon: const Icon(Icons.refresh_outlined),
                                // onPressed: calculateFibonaci,
                                onPressed: () {},
                              );
                      },
                    ),
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Crashes',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                CardButton(
                  key: const Key('trackException'),
                  onPressed: (identity) {
                    unawaited(
                      Analytics.trackEvent(
                        name: 'trackExcpetion',
                        properties: {
                          'event': 'onPressed',
                          'instanceId': instanceId,
                          'widget': identity,
                        },
                      ),
                    );
                    int.parse('not a number');
                  },
                  child: const Text('TrackException'),
                ),
                CardButton(
                  key: const Key('crashButton2'),
                  onPressed: (identity) {
                    unawaited(
                      Analytics.trackEvent(
                        name: 'generateTestCrash',
                        properties: {
                          'event': 'onPressed',
                          'instanceId': instanceId,
                          'widget': identity,
                        },
                      ),
                    );
                    try {
                      unawaited(Crashes.generateTestCrash());
                    } catch (e, stackTrace) {
                      Crashes.trackException(
                        message: e.toString(),
                        type: e.runtimeType,
                        stackTrace: stackTrace,
                        properties: {
                          'generated': 'true',
                        },
                      );
                    }
                  },
                  child: const Text('GenerateTestCrash'),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Analaytics',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                CardButton(
                  key: const Key('analyticsButton1'),
                  onPressed: (identity) {
                    unawaited(
                      Analytics.trackEvent(
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
                          'widget': identity,
                        },
                      ),
                    );
                  },
                  child: const Text('Custom Event 1'),
                ),
                CardButton(
                  key: const Key('analyticsButton2'),
                  onPressed: (identity) {
                    unawaited(
                      Analytics.trackEvent(
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
                          'widget': identity,
                        },
                      ),
                    );
                  },
                  child: const Text('Custom Event 2'),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Distribute',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                CardButton(
                  key: const Key('distributeButton1'),
                  onPressed: (identity) {
                    unawaited(
                      Analytics.trackEvent(
                        name: 'checkUpdate',
                        properties: {
                          'instanceId': instanceId,
                          'widget': identity,
                        },
                      ),
                    );
                    unawaited(Distribution.checkForUpdates());
                  },
                  child: const Text('Check Update'),
                ),
                CardButton(
                  key: const Key('distributeButton2'),
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
