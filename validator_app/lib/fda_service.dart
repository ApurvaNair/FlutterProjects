import 'dart:convert';
import 'package:http/http.dart' as http;

class FDADrugService {
  static Future<List<String>> searchDrugs(String query) async {
    final encodedQuery = Uri.encodeQueryComponent(query);
    final apiUrl =
        'https://api.fda.gov/drug/label.json?search=purpose:"$encodedQuery"';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['results'] as List)
            .map((e) => e['openfda']['brand_name'][0].toString())
            .toList();
      } else {
        throw Exception("API returned status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }
}
