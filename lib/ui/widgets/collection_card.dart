import 'package:flutter/material.dart';
import 'package:emotion_detection/ui/widgets/deletion_warning.dart';

class CollectionCard extends StatelessWidget {
  final String id;
  final String name;
  final String date;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const CollectionCard({
    super.key,
    required this.id,
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
      direction: DismissDirection.horizontal,
      // Delete action (red background) when swiping left
      background: _buildSwipeBackground(
          Theme.of(context).colorScheme.tertiary,
          Icons.edit,
          Alignment.centerLeft),
      // Edit action (tertiary color background) when swiping right
      secondaryBackground: _buildSwipeBackground(
          Colors.red,
          Icons.delete,
          Alignment.centerRight),
      onDismissed: (direction) {
        print('Swipe direction: $direction'); // Debug print
        if (direction == DismissDirection.startToEnd) {
          // Swiped right (edit)
          print('Edit action triggered'); // Debug print
          onEdit();
        } else if (direction == DismissDirection.endToStart) {
          // Swiped left (delete)
          print('Delete action triggered'); // Debug print
          onDelete();
        }
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // For delete action, show confirmation dialog
          print('Showing delete confirmation for swipe'); // Debug print
          return await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Delete Collection'),
                content: Text('you want to delete "$name"?',style: TextStyle(color: Colors.red), ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  TextButton(
                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              );
            },
          ) ?? false;
        }
        return true;
      },
      child: Card(
        color: Theme.of(context).colorScheme.primary,
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          title: Text(name, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
          subtitle: Text(date, style: TextStyle(color: textColor)),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(Color color, IconData icon, Alignment alignment) {
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
