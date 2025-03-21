import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/customer.dart';

class CustomerListScreen extends StatefulWidget {
  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final dbHelper = DatabaseHelper();
  List<Customer> customers = [];

  @override
  void initState() {
    super.initState();
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    final data = await dbHelper.getAllCustomers();
    setState(() {
      customers = data;
    });
  }

  void showAddCustomerDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController birth_dateController = TextEditingController();
    final TextEditingController balanceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Customer"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 10),
              TextField(
                controller: birth_dateController,
                decoration: InputDecoration(labelText: "Date of Birth"),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    birth_dateController.text = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                  }
                },
              ),
              SizedBox(height: 10),
              TextField(
                controller: balanceController,
                decoration: InputDecoration(labelText: "Balance"),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
          actions: [
            TextButton(child: Text("Cancel"), onPressed: () => Navigator.of(context).pop()),
            ElevatedButton(
              child: Text("Add"),
              onPressed: () async {
                await dbHelper.addCustomer(Customer(
                  name: nameController.text,
                  birth_date: birth_dateController.text,
                  balance: double.tryParse(balanceController.text) ?? 0.0,
                ));
                fetchCustomers();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showUpdateCustomerDialog(BuildContext context, Customer customer) {
    final TextEditingController nameController = TextEditingController(text: customer.name);
    final TextEditingController birthDateController = TextEditingController(text: customer.birth_date);
    final TextEditingController balanceController = TextEditingController(text: customer.balance.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update Customer"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: birthDateController,
                readOnly: true,
                decoration: InputDecoration(labelText: "Date of Birth"),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    birthDateController.text = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                  }
                },
              ),
              TextField(
                controller: balanceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Balance"),
              ),
            ],
          ),
          actions: [
            TextButton(child: Text("Cancel"), onPressed: () => Navigator.of(context).pop()),
            ElevatedButton(
              child: Text("Update"),
              onPressed: () async {
                await dbHelper.updateCustomer(Customer(
                  id: customer.id,
                  name: nameController.text,
                  birth_date: birthDateController.text,
                  balance: double.tryParse(balanceController.text) ?? 0.0,
                ));
                fetchCustomers();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void deleteCustomerDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Customer"),
          content: Text("Are you sure?"),
          actions: [
            TextButton(child: Text("Cancel"), onPressed: () => Navigator.of(context).pop()),
            TextButton(
              child: Text("Yes"),
              onPressed: () async {
                await dbHelper.deleteCustomer(id);
                fetchCustomers();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Customers")),
      body: ListView.builder(
        itemCount: customers.length,
        itemBuilder: (context, index) {
          final customer = customers[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            elevation: 5,
            child: ListTile(
              contentPadding: EdgeInsets.all(15),
              title: Text(
                customer.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Birth Date: ${customer.birth_date}", style: TextStyle(fontSize: 14)),
                  Text("Balance: ${customer.balance}", style: TextStyle(fontSize: 14)),
                ],
              ),
              onTap: () => showUpdateCustomerDialog(context, customer), // Tek tıklama
              onLongPress: () => deleteCustomerDialog(context, customer.id!), // Uzun basma
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton
        (onPressed: () => showAddCustomerDialog(context),
      child: Icon(Icons.add),),
    );

  }
}