import 'dart:convert';

import 'package:http/http.dart' as http;

class CalendlyService {
  static const String _calendlyApiKey =
      // '2SP-_iDzaX7zfFpZwBNGQ_Pdo0mAdVhyJulHDX_3XK8';
      'WkuYV7wY8anZpnVXPNpKxgy4atpISoiAxmGbh_cZotM';
  // 'TvTVn6hBGGxdG1X9EiPuzE33GSpSULdErESsVw1cXM0'

  static Future<List<String>> fetchCalendlyEventTypes() async {
    final Uri calendlyEventTypesEndpoint =
        Uri.parse('https://api.calendly.com/event_types');
    final http.Response response = await http.get(
      calendlyEventTypesEndpoint,
      headers: {'Authorization': 'Bearer $_calendlyApiKey'},
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body)['collection'];
      List<String> eventUrls =
          List<String>.from(jsonResponse.map((event) => event['url']));
      return eventUrls;
    } else {
      throw Exception('Failed to load Calendly event types');
    }
  }
}
