import 'dart:async' as i4;

import 'package:mockito/mockito.dart' as i1;
import 'package:restaurant_app/data/api/api_service.dart' as i3;
import 'package:restaurant_app/data/model/restaurant_detail_model.dart' as i2;
import 'package:restaurant_app/data/model/restaurant_model.dart' as i5;

// ignore: camel_case_types
class _FakeRestaurantDetail_0 extends i1.SmartFake
    implements i2.RestaurantDetail {
  _FakeRestaurantDetail_0(super.parent, super.parentInvocation);
}

class MockApiService extends i1.Mock implements i3.ApiService {
  MockApiService() {
    i1.throwOnMissingStub(this);
  }

  @override
  i4.Future<List<i5.Restaurant>> fetchRestaurants() =>
      (super.noSuchMethod(
            Invocation.method(#fetchRestaurants, []),
            returnValue: i4.Future<List<i5.Restaurant>>.value(
              <i5.Restaurant>[],
            ),
          )
          as i4.Future<List<i5.Restaurant>>);

  @override
  i4.Future<i2.RestaurantDetail> fetchRestaurantDetail(String? id) =>
      (super.noSuchMethod(
            Invocation.method(#fetchRestaurantDetail, [id]),
            returnValue: i4.Future<i2.RestaurantDetail>.value(
              _FakeRestaurantDetail_0(
                this,
                Invocation.method(#fetchRestaurantDetail, [id]),
              ),
            ),
          )
          as i4.Future<i2.RestaurantDetail>);
}
