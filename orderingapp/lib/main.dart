import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class ListItem extends StatelessWidget {
  final IconData iconData;
  final String itemName;
  final double price;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  const ListItem({super.key, required this.iconData, required this.itemName, required this.price, required this.quantity, required this.onAdd, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        iconData,
        color: const Color.fromARGB(255, 5, 69, 7)
        ),
      title: Text(itemName),
      subtitle: Text(price.toString()),
      trailing: ActionItem(
        counter: quantity,
        onAdd: onAdd,
        onRemove: onRemove
      ),
    );
  }
}

class ActionItem extends StatelessWidget {
  final int counter;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  const ActionItem({super.key, required this.counter, required this.onAdd, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("$counter"),
        IconButton(
          onPressed: onAdd, 
          icon: Icon(Icons.add)),
        IconButton(
          onPressed: counter > 0 ? onRemove : null, 
          icon: Icon(Icons.remove)),
      ]
    );
  }
}

class TipSelector extends StatefulWidget {
  final void Function(bool addTip, int selectedTip) onTipChange;
  const TipSelector({super.key, required this.onTipChange});

  @override
  State<TipSelector> createState() => _TipSelectorState();
}

class _TipSelectorState extends State<TipSelector> {
  bool addTip = false;
  int selectedTip = 10;
  List<int> tipOptions = [10, 15, 20, 25];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: Text("Add a tip?"),
          value: addTip, 
          onChanged: (value) {
            setState(() {
              addTip = value;
            });
            widget.onTipChange(addTip, selectedTip);
          }),

          if (addTip)
            Wrap(
              spacing: 8,
              children: tipOptions.map((tip) {
                return ChoiceChip(
                  label: Text("$tip%"), 
                  selected: selectedTip == tip,
                  onSelected: (selected) {
                    setState(() {
                      selectedTip = tip;
                    });
                    widget.onTipChange(addTip, tip);
                  },
                );
              }).toList(),
            ),
      ],
    );
  }
}

class ViewTotal extends StatelessWidget {
  final double subtotal;
  final double total;
  const ViewTotal({super.key, required this.subtotal, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.lightGreen, width: 1),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text("Subtotal: ${subtotal.toStringAsFixed(2)}"),
                Text("Total after tip: ${total.toStringAsFixed(2)}"),
              ],
            )
          )
        )
      ]
    );
  }
}

class ConfirmSelection extends StatelessWidget {
  const ConfirmSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 5, 69, 7),
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: TextStyle(fontSize: 18),
        ),
        onPressed: () {
          showDialog(
            context: context, 
            builder: (context) {
              return AlertDialog(
                title: Text("Order Confirmed"),
                content: Text("Your order has been submitted, thank you for your business!"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    child: Text("Close"))
                ],
              );
            }
          );
        },
        child: Text("Confirm Order")
      )
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: .fromSeed(seedColor: Colors.lightGreen),
      ),
      home: const MyHomePage(title: 'Gardening Store'),
      
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool tipIncluded = false;
  int tipAmount = 10;
  final List gardenItems = [
    {'icon': Icons.local_florist, 'name': 'Flowers', 'price': 9.99, 'quantity': 0},
    {'icon': Icons.grass, 'name': 'Shrubs', 'price': 19.99, 'quantity': 0},
    {'icon': Icons.forest, 'name': 'Trees', 'price': 39.99, 'quantity': 0},
    {'icon': Icons.fence, 'name': 'Fencing', 'price': 29.99, 'quantity': 0},
  ];


  var subtotalPrice = (List gardenItems) {
    double subtotal = 0;
    for (var item in gardenItems) {
      subtotal += item['price'] * item['quantity']; 
    }
    return subtotal;
  };

  var totalPrice = (double subtotal, bool tipIncluded, int tipAmount) {
    double total = subtotal;
    if (tipIncluded) {
      total += 1 + (tipAmount / 100);
    }
    return total;
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        leading: Icon(
          Icons.yard,
          size: 36,
          color: const Color.fromARGB(255, 5, 69, 7)
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.lightGreen, width: 1),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < gardenItems.length; i++) ...[
                    ListItem(
                      iconData: gardenItems[i]['icon'], 
                      itemName: gardenItems[i]['name'], 
                      price: gardenItems[i]['price'],
                      quantity: gardenItems[i]['quantity'],
                      onAdd: () => setState(() => gardenItems[i]['quantity']++),
                      onRemove: () => setState(() => gardenItems[i]['quantity']--),
                    ),
                    if (i < gardenItems.length - 1) 
                      Divider(
                        color: Colors.lightGreen,
                        thickness: 1
                      ),
                  ]
                ],
              ),
            ),
            SizedBox(height: 15,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.lightGreen, width: 1),
              ),
              child: TipSelector(
                onTipChange: (addTip, selectedTip) {
                  setState(() {
                    tipIncluded = addTip;
                    tipAmount = selectedTip;
                  });
                },
              )
            ),
            SizedBox(height: 15),
            ViewTotal(
              subtotal: subtotalPrice(gardenItems),
              total: totalPrice(subtotalPrice(gardenItems), tipIncluded, tipAmount)
            ),
            SizedBox(height: 30),
            ConfirmSelection(),
          ]
        )
      ),
    );
  }
}
