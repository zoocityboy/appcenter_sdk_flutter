import 'package:appcenter/appcenter.dart';
import 'package:appcenter/src/distribute.g.dart';
import 'package:appcenter/src/distribution/appcenter_distribution_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'app_center_distribute_test.mocks.dart';

@GenerateMocks([DistributeApi])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const releaseMap = <String, dynamic>{
    'id': 1,
    'version': 1,
    'size': 100,
    'shortVersion': '1.0.0',
    'releaseDetails': 'First release',
    'releaseNotesUrl': 'url',
    'minApiLevel': 16,
    'downloadUrl': 'url',
    'isMandatoryUpdate': false,
    'releaseHash': 'hash',
    'distributionGroupId': 'group_id',
  };
  group('Distribute', () {
    late DistributeApi api;
    setUp(
      () {
        api = MockDistributeApi();
        Distribution.instance = AppCenterDistributionMethodChannel.internal(
          api: api,
        );
      },
    );
    test('Check for updates', () async {
      when(api.checkForUpdates()).thenAnswer((_) {
        return Future<void>.value();
      });
      // AppCenterDistribution.instance =
      //     AppCenterDistributionMethodChannel.internal(api: mockApi);

      await Distribution.checkForUpdates();
      verify(api.checkForUpdates()).called(1);
    });

    test('Test setDistributeEnable calls setDistributeEnabled in api',
        () async {
      await Distribution.setDistributeEnable(value: true);
      verify(api.setDistributeEnabled(true)).called(1);
    });
  });
}
