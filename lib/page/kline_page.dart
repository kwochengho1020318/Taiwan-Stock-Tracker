import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../service/kline_service.dart';
import '../theme/flexiblespace.dart';
import '../service/carelist_storage_service.dart';
import '../service/locale.dart';
class KlinePage extends StatefulWidget {
  final String stockId;
  const KlinePage({super.key, required this.stockId});

  @override
  State<KlinePage> createState() => _KlinePageState();
}

class _KlinePageState extends State<KlinePage> {
  late Future<List<KlineData>> _klineData;
  KlineData? selectedData;
  String? selectedValue;
  final CarelistStorageService storage = CarelistStorageService(
    'my_stock_list',
  );
  List<String> stocks = [];

  @override
  void initState() {
    super.initState();
    _loadStocks();
    _klineData = KlineService().fetchKline(widget.stockId);
    selectedValue=widget.stockId;
  }

  Future<void> _loadStocks() async {
    final data = await storage.getAll();
    setState(() {
      stocks = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DropdownButton(
          value: selectedValue,
          
          items: stocks.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text('$value',style: TextStyle(fontSize: 20),),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue!;
              _klineData = KlineService().fetchKline(widget.stockId);
            });
          },
        ),
        actions: [
          if (selectedData != null)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                '${MyLocalizations.of(context).todaysClosing}: ${selectedData!.close}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
        ],
        flexibleSpace: MyfliexibleSpace(),
      ),
      body: FutureBuilder<List<KlineData>>(
        future: _klineData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('錯誤：${snapshot.error}'));
          } else {
            final data = snapshot.data!;
            final latest = data.last;
            selectedData??=latest;
            return Column(
              children: [
                Expanded(
                  child: SfCartesianChart(
                    primaryXAxis: DateTimeAxis(),
                    primaryYAxis: NumericAxis(),
                    zoomPanBehavior: ZoomPanBehavior(
                      enablePinching: true,
                      enablePanning: true,
                      zoomMode: ZoomMode.x,
                    ),
                    trackballBehavior: TrackballBehavior(
                      enable: true,
                      activationMode: ActivationMode.singleTap,
                      tooltipDisplayMode: TrackballDisplayMode.floatAllPoints,
                      tooltipSettings: const InteractiveTooltip(enable: true),
                      builder:
                          (BuildContext context, TrackballDetails details) {
                            final index = details.pointIndex ?? 0;
                            if (index < data.length) {
                              final KlineData k = data[index];
                              setState(() {
                                selectedData = k;
                              });
                            }
                            return const SizedBox.shrink(); // ✅ 不回傳 null，防錯
                          },
                    ),
                    series: <CandleSeries>[
                      CandleSeries<KlineData, DateTime>(
                        dataSource: data,
                        xValueMapper: (KlineData d, _) => d.date,
                        lowValueMapper: (KlineData d, _) => d.low,
                        highValueMapper: (KlineData d, _) => d.high,
                        openValueMapper: (KlineData d, _) => d.open,
                        closeValueMapper: (KlineData d, _) => d.close,
                      ),
                    ],
                  ),
                ),
                
                  Padding(
                    padding: const EdgeInsets.symmetric(),
                    child: Container(
                      color: Theme.of(context).colorScheme.surface,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '📅 ${MyLocalizations.of(context).date}：${selectedData!.date.toLocal().toString().split(' ')[0]}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildDataRow(MyLocalizations.of(context).open, selectedData!.open),
                          _buildDataRow(MyLocalizations.of(context).high, selectedData!.high),
                          _buildDataRow(MyLocalizations.of(context).low, selectedData!.low),
                          _buildDataRow(MyLocalizations.of(context).close, selectedData!.close),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}

Widget _buildDataRow(String label, double value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Text(
          value.toStringAsFixed(2),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}
