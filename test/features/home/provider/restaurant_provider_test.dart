import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_model.dart';
import 'package:restaurant_app/features/home/provider/restaurant_provider.dart';
import 'package:restaurant_app/utils/result_state.dart';

import 'restaurant_provider_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  group('Pengujian RestaurantProvider', () {
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
    });

    final tRestaurant = Restaurant(
      id: 'rqdv5juczeskfw1e867',
      name: 'Melting Pot',
      description: 'Description for Melting Pot',
      pictureId: '14',
      city: 'Medan',
      rating: 4.2,
    );
    final tRestaurantList = <Restaurant>[tRestaurant];

    test(
      'State awal harus didefinisikan sebagai Loading saat provider dibuat',
      () {
        when(
          mockApiService.fetchRestaurants(),
        ).thenAnswer((_) async => tRestaurantList);

        final provider = RestaurantProvider(apiService: mockApiService);

        expect(provider.state, ResultState.loading);
      },
    );

    test(
      'Harus mengubah state menjadi HasData dan mengembalikan daftar restoran ketika API berhasil',
      () async {
        when(
          mockApiService.fetchRestaurants(),
        ).thenAnswer((_) async => tRestaurantList);

        final provider = RestaurantProvider(apiService: mockApiService);

        await untilCalled(mockApiService.fetchRestaurants());

        expect(provider.state, ResultState.hasData);
        expect(provider.restaurants, tRestaurantList);
        verify(mockApiService.fetchRestaurants());
      },
    );

    test(
      'Harus mengubah state menjadi Error ketika pengambilan data API gagal',
      () async {
        when(
          mockApiService.fetchRestaurants(),
        ).thenThrow(Exception('Gagal mengambil data dari API'));

        final provider = RestaurantProvider(apiService: mockApiService);
        await untilCalled(mockApiService.fetchRestaurants());

        expect(provider.state, ResultState.error);
        expect(provider.message, contains('Error -->'));
        verify(mockApiService.fetchRestaurants());
      },
    );
  });
}
