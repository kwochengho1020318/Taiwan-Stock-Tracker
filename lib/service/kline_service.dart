import 'dart:convert';
import 'package:http/http.dart' as http;

class KlineData {
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;
  final bool exist=false;
  KlineData({required this.date, required this.open, required this.high, required this.low, required this.close});

  factory KlineData.fromJson(Map<String, dynamic> json) {
    return KlineData(
      date: DateTime.parse(json['date']),
      open: json['open'].toDouble(),
      high: json['max'].toDouble(),
      low: json['min'].toDouble(),
      close: json['close'].toDouble(),
    );
  }
}

class KlineService {
  
  Future<List<KlineData>> fetchKline(String stockId) async {
    final url = Uri.parse(
        'https://api.finmindtrade.com/api/v4/data?dataset=TaiwanStockPrice&data_id=$stockId&start_date=2024-06-01');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List data = jsonData['data'];

      return data.map((e) => KlineData.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load K-line data');
    }
  }
  Future<bool> checkValidStockId(String stockId) async {
    final url = Uri.parse(
        'https://api.finmindtrade.com/api/v4/data?dataset=TaiwanStockPrice&data_id=$stockId&start_date=2024-06-01');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List data = jsonData['data'];
    
      if(data.isEmpty){
        return false;
      }
      return true;
    } else {
      return false;
    }
  }
}
