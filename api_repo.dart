import 'dart:convert';

import 'package:digital_marketing/api/base_api.dart';
import 'package:digital_marketing/models/cource_lession.dart';
import 'package:http/http.dart' as http;
//https://player.vimeo.com/video/741568358?h=fee867fd6b
class CourceDetailRepository extends BaseApi {
  @override
  Future<List<LessonData>?> getcourceVideo(String courceId) async {
    try {
      final responce = await http
          .get(Uri.parse(baseUrl + '/course-videos/$courceId'), headers: {
        "Accept": "application/json",
        "Content-Type": "Application/x-www-form-urlencoded",
        "X-API-KEY": ''
      });
//Todo need to fix
      if (responce.statusCode == 200) {
        Map<String, dynamic> output = jsonDecode(responce.body);
        var data = output['data'];
        print("data in cource detail: ${data.toString()}");
        if (output['data'] != null) {
          data = <LessonData>[];
          output['data'].forEach((v) {
            data!.add(LessonData.fromJson(v));
          });
          return data;
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
