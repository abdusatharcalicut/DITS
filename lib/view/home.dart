import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dits/themes/app_themes.dart';
import 'package:dits/view/add_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dits/view/invoice.dart';
import 'package:dits/view/product.dart';
import 'package:dits/view/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  // final String logId;
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  TextEditingController _searchController = TextEditingController();
  String? mobileNumber;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
    _loadLogId();
  }

  Future<void> _loadLogId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mobileNumber = prefs.getString('logId');
    });
  }

  void _search() {
    String searchText = _searchController.text;
    print('Searching for: $searchText');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Define your screens or routes here
  final List<Widget> _screens = [
    product(),
    Cashbook(),
    Invoice(),
    Customers(),
    settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // Set the selected item color
        selectedItemColor: AppThemes.primaryColorDark,
        // Set the unselected item color
        unselectedItemColor: Colors.black54,
        iconSize: 26,
        //BottomNavigation Section
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Items',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_outlined),
            label: 'Cashbook',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Invoice',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline_outlined),
            label: 'Customers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

//Section Cashbook

class Cashbook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Cashbook'),
    );
  }
}

//Section Invoice

class Invoice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: const Column(
          children: [
            invoice(),
          ],
        ),
      ),
    );
  }
}

//Section Customers

class Customers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed logic here
          print('FAB pressed!');
        },
        child: Icon(Icons.person_add_rounded),
        backgroundColor: AppThemes.primaryColorDark,
      ),
    );
  }
}
