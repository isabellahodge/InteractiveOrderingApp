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
  const TipSelector({super.key});

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
                  },
                );
              }).toList(),
            ),
      ],
    );
  }
}

class ConfirmSelection extends StatelessWidget {
  const ConfirmSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
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
  final List gardenItems = [
    {'icon': Icons.local_florist, 'name': 'Flowers', 'price': 9.99, 'quantity': 0},
    {'icon': Icons.grass, 'name': 'Shrubs', 'price': 19.99, 'quantity': 0},
    {'icon': Icons.forest, 'name': 'Trees', 'price': 39.99, 'quantity': 0},
    {'icon': Icons.fence, 'name': 'Fencing', 'price': 29.99, 'quantity': 0},
  ];

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
                    if (i < gardenItems.length -1) 
                      Divider(
                        color: Colors.lightGreen,
                        thickness: 1
                      ),
                  ]
                ],
              ),
            ),
            SizedBox(height: 15),
            Card(
              child: TipSelector()
            ),
            SizedBox(height: 15),
            ConfirmSelection(),
          ]
        )
      ),
    );
  }
}
