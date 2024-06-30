import 'package:flutter/material.dart';
import 'model.dart';
import 'service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Scaffold(
          appBar: AppBar(
            title: Text('Motor Search App'),
            backgroundColor: Colors.blue,
          ),
          body: MotorList(),
        ),
        '/specification': (context) => SpecificationPage(),
      },
    );
  }
}

class SpecificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Motor selectedMotor =
    ModalRoute.of(context)!.settings.arguments as Motor;

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedMotor.model),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              width: double.infinity,
              child: Hero(
                tag: 'motor_gambar_${selectedMotor.gambar}',
                child: Image.network(
                  'http://10.0.2.2/FLUTTER_API/${selectedMotor.gambar}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildInfoRow('Merek', selectedMotor.merek),
                  buildInfoRow('Model', selectedMotor.model),
                  buildInfoRow('Tahun Produksi', selectedMotor.tahunProduksi),
                  buildInfoRow('Warna', selectedMotor.warna),
                  buildInfoRow('Harga', selectedMotor.harga),
                  buildInfoRow('Stok', selectedMotor.stok),
                  // Tambahkan informasi spesifikasi lainnya sesuai kebutuhan
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(width: 16),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class MotorList extends StatefulWidget {
  @override
  _MotorListState createState() => _MotorListState();
}

class _MotorListState extends State<MotorList> {
  late Future<List<Motor>> _motorList;
  TextEditingController _searchController = TextEditingController();
  List<Motor> _filteredMotorList = [];

  @override
  void initState() {
    super.initState();
    _motorList = _loadData();
  }

  Future<List<Motor>> _loadData() async {
    try {
      ApiService apiService =
      ApiService(baseUrl: 'http://10.0.2.2/FLUTTER_API/');
      final results = await apiService.getItems();
      return results;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  void _updateFilteredMotorList(String query) async {
    if (query.isEmpty) {
      setState(() {
        _filteredMotorList = [];
      });
    } else {
      final List<Motor> fullList = await _motorList;
      final List<Motor> filteredList = fullList
          .where((motor) =>
          motor.model.toLowerCase().contains(query.toLowerCase()))
          .toList();

      setState(() {
        _filteredMotorList = filteredList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari motor...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              )
            ),
            onChanged: (query) {
              _updateFilteredMotorList(query);
            },
          ),
        ),
        Expanded(
          child: _filteredMotorList.isNotEmpty
              ? ListMotor(
            MotorList: _filteredMotorList,
            onItemTap: (motor) {
              Navigator.pushNamed(
                context,
                '/specification',
                arguments: motor,
              );
            },
          )
              : FutureBuilder<List<Motor>>(
            future: _motorList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
              } else if (snapshot.hasData) {
                return ListMotor(
                  MotorList: snapshot.data!,
                  onItemTap: (motor) {
                    Navigator.pushNamed(
                      context,
                      '/specification',
                      arguments: motor,
                    );
                  },
                );
              } else {
                return Center(child: Text('Tidak ada data yang tersedia'));
              }
            },
          ),
        ),
      ],
    );
  }
}

class ListMotor extends StatelessWidget {
  final List<Motor> MotorList;
  final Function(Motor) onItemTap;

  ListMotor({Key? key, required this.MotorList, required this.onItemTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: MotorList.length,
      itemBuilder: (_, index) {
        var data = MotorList[index];
        return InkWell(
          onTap: () {
            onItemTap(data);
          },
          child: Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ListTile(
                title: Text(
                  data.model,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  ' ${data.merek}',
                  style: TextStyle(fontSize: 14),
                ),
                leading: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        'http://10.0.2.2/FLUTTER_API/${data.gambar}',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
