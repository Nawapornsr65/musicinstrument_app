import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Instrument App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 18.0),
        ),
      ),
      home: HomePage(),
    );
  }
}

class Instrument {
  String name;
  int quantity;
  String dateTime;
  String category;

  Instrument({required this.name, required this.quantity, required this.dateTime, required this.category});
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Instrument> instruments = [];

  void _navigateToAddPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPage()),
    );
    if (result != null) {
      setState(() {
        instruments.add(result);
      });
    }
  }

  void _navigateToEditPage(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPage(instrument: instruments[index], index: index, onDelete: _deleteItem)),
    );
    if (result != null) {
      setState(() {
        instruments[index] = result;
      });
    }
  }

  void _deleteItem(int index) {
    setState(() {
      instruments.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Music Instruments', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
      body: instruments.isEmpty
          ? Center(child: Text('ยังไม่มีเครื่องดนตรี', style: TextStyle(fontSize: 20, color: Colors.grey)))
          : ListView.builder(
              itemCount: instruments.length,
              itemBuilder: (context, index) {
                final item = instruments[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(15),
                    title: Text(item.name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    subtitle: Text('จำนวน: ${item.quantity} | วันที่: ${item.dateTime} | หมวดหมู่: ${item.category}',
                        style: TextStyle(fontSize: 18)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue, size: 30),
                          onPressed: () => _navigateToEditPage(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red, size: 30),
                          onPressed: () => _deleteItem(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddPage,
        child: Icon(Icons.add, size: 30),
      ),
    );
  }
}

class AddPage extends StatefulWidget {
  final Instrument? instrument;
  final int? index;
  final Function(int)? onDelete;

  AddPage({this.instrument, this.index, this.onDelete});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  String _currentDateTime = '';
  String? _selectedCategory;

  final List<String> categories = ['เครื่องสาย', 'เครื่องเป่า', 'เครื่องตี', 'เครื่องลม'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.instrument?.name ?? '');
    _quantityController = TextEditingController(text: widget.instrument?.quantity.toString() ?? '');
    _currentDateTime = widget.instrument?.dateTime ?? DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    _selectedCategory = widget.instrument?.category ?? categories.first;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      final newInstrument = Instrument(
        name: _nameController.text,
        quantity: int.parse(_quantityController.text),
        dateTime: _currentDateTime,
        category: _selectedCategory!,
      );
      Navigator.pop(context, newInstrument);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.instrument == null ? 'เพิ่มเครื่องดนตรี' : 'แก้ไขเครื่องดนตรี',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'ชื่อเครื่องดนตรี', labelStyle: TextStyle(fontSize: 20)),
                validator: (value) => value!.isEmpty ? 'กรุณากรอกชื่อ' : null,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'จำนวน', labelStyle: TextStyle(fontSize: 20)),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'กรุณากรอกจำนวน' : null,
              ),
              ListTile(
                title: Text('วันที่และเวลา: $_currentDateTime',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(labelText: 'ประเภทเครื่องดนตรี', labelStyle: TextStyle(fontSize: 20)),
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category, style: TextStyle(fontSize: 20)),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('บันทึก', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
