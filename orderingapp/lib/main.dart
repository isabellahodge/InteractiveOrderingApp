import 'package:flutter/material.dart';

//Gardening Store Interactive Ordering App Program
void main() {
  runApp(const MyApp());
}

//widget to display gardening item options
class ListItem extends StatelessWidget {
  final IconData iconData;
  final String itemName;
  final double price;
  final int quantity;
  //(!) new feature explored: used callbacks as a way to extend the 
  //scope of certain traits I needed to use in different widget classes.
  //in this case I used it for tracking the addition or removal of an item's
  //quantity to be used when calculating the total cost of a purchase.
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  const ListItem({
    super.key, 
    required this.iconData, 
    required this.itemName, 
    required this.price, 
    required this.quantity, 
    required this.onAdd, 
    required this.onRemove
    });

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

//widget to display the selection or deselection of an item
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
          icon: Icon(Icons.add)
        ),
        IconButton(
          onPressed: counter > 0 ? onRemove : null, 
          icon: Icon(Icons.remove)
        ),
      ]
    );
  }
}

//conditional UI element
//widget displaying tip amount chosen if tip toggle is on
class TipSelector extends StatefulWidget {
  //(!) new feature explored: another callback instance to track if
  //tip toggle is on and tip percentage, used when calculating total cost.
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
            widget.onTipChange(value, selectedTip);
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

//widget to display the total price based on the user's selections
class ViewTotal extends StatelessWidget {
  final double subtotal;
  final double total;
  const ViewTotal({super.key, required this.subtotal, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          //(!) new styling feature explored: a border around the widget card
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

//button widget displaying confirmation message when order submitted
class ConfirmSelection extends StatelessWidget {
  const ConfirmSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        //(!) new styling feature explored: modified button color and size
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

//widget displaying app identifiers
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Interactive Ordering App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
      ),
      home: const MyHomePage(title: 'Gardening Store'),
      
    );
  }
}

//widget to display cohesive main screen
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool tipIncluded = false;
  int tipAmount = 10;

  //list of five order items
  final List gardenItems = [
    {'icon': Icons.local_florist, 'name': 'Flowers', 'price': 9.99, 'quantity': 0},
    {'icon': Icons.grass, 'name': 'Shrubs', 'price': 19.99, 'quantity': 0},
    {'icon': Icons.forest, 'name': 'Trees', 'price': 39.99, 'quantity': 0},
    {'icon': Icons.emoji_nature, 'name': 'Fertilizer', 'price': 9.99, 'quantity': 0},
    {'icon': Icons.fence, 'name': 'Fencing', 'price': 29.99, 'quantity': 0},
  ];

  //helpers for calculating total
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
      total *= (1 + tipAmount / 100);
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
              //(!) new styling feature explored: a border around the widget card
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
                      //(!) new styling feature explored: a divider between listed items 
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
              //(!) new styling feature explored: a border around the widget card
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
