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
  final List<TextEditingController> litreControllers = [];
  final List<TextEditingController> rateControllers = [];
  final List<FocusNode> litreFocusNodes = [];
  final List<FocusNode> rateFocusNodes = [];

  @override
  void initState() {
    super.initState();
    _addRow(); // Add an initial row
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Milk Amount Calculation'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: dataList.length + 1, // +1 for the total row
              itemBuilder: (context, index) {
                if (index == dataList.length) {
                  return _buildTotalRow();
                } else {
                  return _buildRow(index);
                }
              },
            ),
          ),
          _buildAddRowButton(),
        ],
      ),
    );
  }

  Widget _buildRow(int index) {
    final Map<String, dynamic> data = dataList[index];
    final litreController = litreControllers[index];
    final rateController = rateControllers[index];

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: litreController,
              focusNode: litreFocusNodes[index],
              decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Litres'),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculateTotal(index),
              onEditingComplete: () {
                _moveToNextField(index);
              },
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: rateController,
              focusNode: rateFocusNodes[index],
              decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Milk Rate'),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculateTotal(index),
              onEditingComplete: () {
                _moveToNextField(index);
              },
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Text(
              (data['litres'] * data['rate']).toString(),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTotalRow() {
    double totalLitres = dataList.fold(0, (sum, data) => sum + data['litres']);
    double totalAmount = dataList.fold(0, (sum, data) => sum + (data['litres'] * data['rate']));

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Total',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Text(
              totalLitres.toStringAsFixed(2),
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Text(
              totalAmount.toStringAsFixed(2),
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddRowButton() {
    return ElevatedButton(
      onPressed: _addRow,
      child: Icon(Icons.add),
    );
  }

  void _calculateTotal(int index) {
    final litre = double.tryParse(litreControllers[index].text) ?? 0;
    final rate = double.tryParse(rateControllers[index].text) ?? 0;
    setState(() {
      dataList[index]['litres'] = litre;
      dataList[index]['rate'] = rate;
    });
  }

  void _addRow() {
    setState(() {
      final litreController = TextEditingController();
      final rateController = TextEditingController();
      final litreFocusNode = FocusNode();
      final rateFocusNode = FocusNode();

      litreControllers.add(litreController);
      rateControllers.add(rateController);
      litreFocusNodes.add(litreFocusNode);
      rateFocusNodes.add(rateFocusNode);

      dataList.add({
        'litres': 0.0,
        'rate': 0.0,
      });

      Future.delayed(Duration.zero, () {
        FocusScope.of(context).requestFocus(litreFocusNodes.last);
      });
    });
  }

  void _moveToNextField(int index) {
    if (index == dataList.length - 1) {
      _addRow();
    } else {
      FocusScope.of(context).requestFocus(index.isEven ? litreFocusNodes[index + 1] : rateFocusNodes[index + 1]);
    }
  }
}
