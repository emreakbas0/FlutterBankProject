class Customer{
  int? id;
  String name;
  String birth_date;
  double balance;

  Customer({this.id, required this.name, required this.birth_date, required this.balance});

  Map<String, dynamic> toMap(){
    return{
      'id' : id,
      'name' : name,
      'birth_date' : birth_date,
      'balance' : balance
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map){
    return Customer(id: map['id'] ,name: map['name'], birth_date: map['birth_date'], balance: map['balance']);

  }
}