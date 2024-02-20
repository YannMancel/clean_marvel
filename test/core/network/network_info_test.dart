import 'package:clean_marvel/core/_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks(
  <MockSpec>[
    MockSpec<InternetConnectionChecker>(),
  ],
)
import 'network_info_test.mocks.dart';

void main() {
  late InternetConnectionChecker connectionChecker;
  late NetworkInfo networkInfo;

  group(
    'NetworkInfo',
    () {
      setUp(
        () {
          connectionChecker = MockInternetConnectionChecker();
          networkInfo = NetworkInfoByInternetConnectionChecker(
            connectionChecker: connectionChecker,
          );
        },
      );

      test(
        'should return true when isConnected is called',
        () async {
          when(connectionChecker.hasConnection).thenAnswer((_) async => true);
          final isConnected = await networkInfo.isConnected;
          expect(isConnected, isTrue);
          verify(connectionChecker.hasConnection).called(1);
          verifyNoMoreInteractions(connectionChecker);
        },
      );

      test(
        'should return false when isConnected is called',
        () async {
          when(connectionChecker.hasConnection).thenAnswer((_) async => false);
          final isConnected = await networkInfo.isConnected;
          expect(isConnected, isFalse);
          verify(connectionChecker.hasConnection).called(1);
          verifyNoMoreInteractions(connectionChecker);
        },
      );
    },
  );
}
