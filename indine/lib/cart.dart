import 'package:flutter/material.dart';
import 'package:indine/item_tile.dart';
import 'package:provider/provider.dart';
class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("Cart",style: TextStyle(color: Colors.black),),
      ),
      body: ListView.builder(
        itemCount: cart.items.length,
        itemBuilder: (context, index) {
          final item = cart.items[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text("\$${item.price} x ${item.quantity}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Total: \$${item.price * item.quantity}"),
                IconButton(
                  icon: Icon(Icons.remove_circle),
                  onPressed: () {
                    cart.removeItem(item.name);
                  },
                ),
              ],
            )
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Total: \$${cart.totalPrice}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
