import 'dart:convert';

import 'package:digital_marketing/models/cource.dart';

import 'base_api.dart';
import 'package:http/http.dart' as http;

class CourceRepository extends BaseApi {
  @override
  Future<List<CourceData>?> getAllCources() async {
    try {
      final responce =
          await http.get(Uri.parse(baseUrl + '/courses-category'), headers: {
        "Accept": "application/json",
        "Content-Type": "Application/x-www-form-urlencoded",
        "X-API-KEY": '12'
      });

      if (responce.statusCode == 200) {
        Map<String, dynamic> output = jsonDecode(responce.body);
        var data = output['data'];
        if (output['data'] != null) {
          data = <CourceData>[];
          output['data'].forEach((v) {
            data!.add(CourceData.fromJson(v));
          });
          return data;
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }

// https://idigitalpreneur.com/apisecure/courses-category/

  @override
  Future<List<CourceData>?> trandingCources() async {
    try {
      final responce = await http
          .get(Uri.parse(baseUrl + '/trend-courses-category'), headers: {
        "Accept": "application/json",
        "Content-Type": "Application/x-www-form-urlencoded",
        "X-API-KEY": '1p'
      });

      if (responce.statusCode == 200) {
        Map<String, dynamic> output = jsonDecode(responce.body);
        var data = output['data'];
        if (output['data'] != null) {
          data = <CourceData>[];
          output['data'].forEach((v) {
            data!.add(CourceData.fromJson(v));
          });
          return data;
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  @override
  Future<List<CourceData>?> userPurchasedCourses(String userId) async {
    //$userId
    try {
      final responce = await http
          .get(Uri.parse(baseUrl + '/user-open-courses/$userId'), headers: {
        "Accept": "application/json",
        "Content-Type": "Application/x-www-form-urlencoded",
        "X-API-KEY": '123i'
      });

      if (responce.statusCode == 200) {
        Map<String, dynamic> output = jsonDecode(responce.body);

        var data = output['data'];
        if (output['data'] != null) {
          data = <CourceData>[];
          output['data']['open_course'].forEach((v) {
            data!.add(CourceData.fromJson(v));
          });
          return data;
        }
      }
    } catch (e) {
      return [];
    }
    return [];
  }
}
