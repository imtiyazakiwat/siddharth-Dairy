import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Milk Amount Calculation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculationPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculationPage extends StatefulWidget {
  @override
  _CalculationPageState createState() => _CalculationPageState();
}

class _CalculationPageState extends State<CalculationPage> {
  List<Map<String, dynamic>> dataList = [];
  final TextEditingController farmerController = TextEditingController();
  final TextEditingController litresController = TextEditingController();
  final TextEditingController rateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Milk Amount Calculation'),
      ),
      body: Column(
        children: [
          _buildTable(),
          _buildAddRowButton(),
          _buildTotalsRow(),
        ],
      ),
    );
  }

  Widget _buildTable() {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Farmer Name')),
            DataColumn(label: Text('Litres')),
            DataColumn(label: Text('Milk Rate')),
            DataColumn(label: Text('Total Amount')),
          ],
          rows: dataList.asMap().entries.map((entry) {
            final int index = entry.key;
            final Map<String, dynamic> data = entry.value;
            return DataRow(cells: [
              DataCell(
                Text(data['farmer']),
                onTap: () => _editRow(index),
              ),
              DataCell(
                Text(data['litres'].toString()),
                onTap: () => _editRow(index),
              ),
              DataCell(
                Text(data['rate'].toString()),
                onTap: () => _editRow(index),
              ),
              DataCell(
                Text((data['litres'] * data['rate']).toString()),
                onTap: () => _editRow(index),
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAddRowButton() {
    return ElevatedButton(
      onPressed: _displayAddDialog,
      child: Icon(Icons.add),
    );
  }

  Widget _buildTotalsRow() {
    double totalLitres = dataList.fold(0, (sum, data) => sum + data['litres']);
    double totalAmount = dataList.fold(0, (sum, data) => sum + (data['litres'] * data['rate']));

    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total: '),
          Text(totalLitres.toString()),
          SizedBox(width: 50),
          Text(totalAmount.toString()),
        ],
      ),
    );
  }

  void _displayAddDialog() {
    farmerController.clear();
    litresController.clear();
    rateController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Row'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: farmerController,
                decoration: InputDecoration(labelText: 'Farmer Name'),
              ),
              TextField(
                controller: litresController,
                decoration: InputDecoration(labelText: 'Litres'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: rateController,
                decoration: InputDecoration(labelText: 'Milk Rate'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _addRow();
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editRow(int index) {
    final Map<String, dynamic> data = dataList[index];
    farmerController.text = data['farmer'];
    litresController.text = data['litres'].toString();
    rateController.text = data['rate'].toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Row'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: farmerController,
                decoration: InputDecoration(labelText: 'Farmer Name'),
              ),
              TextField(
                controller: litresController,
                decoration: InputDecoration(labelText: 'Litres'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: rateController,
                decoration: InputDecoration(labelText: 'Milk Rate'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _updateRow(index);
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _addRow() {
    setState(() {
      String farmer = farmerController.text;
      double litres = double.tryParse(litresController.text) ?? 0;
      double rate = double.tryParse(rateController.text) ?? 0;

      if (farmer.isNotEmpty && litres > 0 && rate > 0) {
        dataList.add({
          'farmer': farmer,
          'litres': litres,
          'rate': rate,
        });
      }

      farmerController.clear();
      litresController.clear();
      rateController.clear();
    });
  }

  void _updateRow(int index) {
    setState(() {
      String farmer = farmerController.text;
      double litres = double.tryParse(litresController.text) ?? 0;
      double rate = double.tryParse(rateController.text) ?? 0;

      if (farmer.isNotEmpty && litres > 0 && rate > 0) {
        dataList[index] = {
          'farmer': farmer,
          'litres': litres,
          'rate': rate,
        };
      }

      farmerController.clear();
      litresController.clear();
      rateController.clear();
    });
  }

  @override
  void dispose() {
    farmerController.dispose();
    litresController.dispose();
    rateController.dispose();
    super.dispose();
  }
}
