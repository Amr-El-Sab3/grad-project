import 'package:flutter/material.dart';

class CollectionCard extends StatelessWidget {
  final String name;
  final String date;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const CollectionCard({
    super.key,
    required this.name,
    required this.date,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).colorScheme.tertiary;
    return Dismissible(
      key: UniqueKey(),
      // Required for Dismissible to uniquely identify the widget
      direction: DismissDirection.horizontal,
      // Allow horizontal swipes
      background:
          _buildSwipeBackground(Colors.red, Icons.delete, Alignment.centerLeft),
      secondaryBackground: _buildSwipeBackground(
          Theme.of(context).colorScheme.tertiary,
          Icons.edit,
          Alignment.centerRight),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          // Swiped right (edit)
          onEdit();
        } else if (direction == DismissDirection.endToStart) {
          // Swiped left (delete)
          onDelete();
        }
      },
      child: Card(
        color: Theme.of(context).colorScheme.primary,
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          title:
              Text(name, style: TextStyle(color: textColor ,fontWeight: FontWeight.bold)),
          subtitle: Text(date, style: TextStyle(color: textColor )),
          onTap: onTap, // Triggered when the card is tapped
        ),
      ),
    );
  }

  // Helper method to build the background for swipe actions
  Widget _buildSwipeBackground(
      Color color, IconData icon, Alignment alignment) {
    return Container(
      color: color,
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }
}
