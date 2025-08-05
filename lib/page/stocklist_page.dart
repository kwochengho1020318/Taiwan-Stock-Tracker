
import 'package:demo1/service/kline_service.dart';
import 'package:flutter/material.dart';
import '../service/carelist_storage_service.dart';
import 'kline_page.dart';
import '../service/locale.dart';
import '../main.dart';
class StockListPage extends StatefulWidget {
  const StockListPage({super.key});

  @override
  State<StockListPage> createState() => _StockListPageState();
}

class _StockListPageState extends State<StockListPage> {
  final CarelistStorageService storage = CarelistStorageService(
    'my_stock_list',
  );
  List<String> stocks = [];
final Map<String, String> languages = {
    'en': 'English',
    'zh': '中文',
  };
  @override
  void initState() {
    super.initState();
    _loadStocks();
    

  }

  Future<void> _loadStocks() async {
    final data = await storage.getAll();
    setState(() {
      stocks = data;
    });
  }

  Future<void> _addStock() async {
    final controller = TextEditingController();
    String? errorText;
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context,setState){
        return AlertDialog(
        title: Text(MyLocalizations.of(context).addStock),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: MyLocalizations.of(context).enterStockID, errorText: errorText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  Text(MyLocalizations.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final stock = controller.text.trim();
              if (stock.isNotEmpty) {
                if (!await KlineService().checkValidStockId(stock)) {
                  setState((){
                    errorText=MyLocalizations.of(context).errortext;
                  });
                  return;
                }
                await storage.add(stock);
                Navigator.pop(context);
                _loadStocks();
              }
            },
            child:  Text(MyLocalizations.of(context).add),
          ),
        ],
      );
      })
    );
  }

  Widget _buildStockItem(String stock) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => KlinePage(stockId: stock)),
        );
      },
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: const Icon(
            Icons.candlestick_chart_outlined,
            color: Colors.red,
          ),
          title: Text(
            stock,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _confirmDelete(stock);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(MyLocalizations.of(context).stockList),
        backgroundColor: Theme.of(context).colorScheme.primary,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme.of(context).colorScheme.primary, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: Localizations.localeOf(context).languageCode,
                icon: const Icon(Icons.language, color: Colors.white),
                dropdownColor: Colors.blue,
                style: const TextStyle(color: Colors.white),
                onChanged: (String? newLang) {
                  if (newLang != null) {
                    setState(() {
                      MyApp.of(context)?.setLocale(Locale(newLang));
                    });
                  }
                },
                items: languages.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text(entry.value, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(width: 12),],
      ),
      body: stocks.isEmpty
          ? const Center(child: Text(''))
          : ListView.builder(
              itemCount: stocks.length,
              itemBuilder: (context, index) {
                return _buildStockItem(stocks[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addStock,

        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _confirmDelete(String stock) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(MyLocalizations.of(context).deleteStockID),
        content: Text('${MyLocalizations.of(context).areyousuredeleting}「$stock」?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child:  Text(MyLocalizations.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            
            child: Text(MyLocalizations.of(context).delete,style: TextStyle(color: Colors.red),),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await storage.remove(stock);
      _loadStocks();
    }
  }
}
