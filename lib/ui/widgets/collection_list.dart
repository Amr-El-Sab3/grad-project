import 'package:emotion_detection/bloc/collection_bloc/collection_bloc.dart';
import 'package:emotion_detection/bloc/collection_bloc/collection_event.dart';
import 'package:emotion_detection/bloc/collection_bloc/collection_state.dart';
import 'package:emotion_detection/ui/widgets/collection_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CollectionListWidget extends StatefulWidget {
  const CollectionListWidget({super.key});

  @override
  State<CollectionListWidget> createState() => _CollectionListWidgetState();
}

class _CollectionListWidgetState extends State<CollectionListWidget> {
  @override
  void initState() {
    super.initState();
    // Fetch collections when the widget is first created
    context.read<CollectionBloc>().add(FetchCollections());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CollectionBloc, CollectionState>(
      listener: (context, state) {
        if (state is CollectionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        print('Current state: $state'); // Debug log
        if (state is CollectionLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CollectionLoaded) {
          return ListView.builder(
            itemCount: state.collections.length,
            itemBuilder: (context, index) {
              final collection = state.collections[index];
              return CollectionCard(
                id: collection.id,
                name: collection.name,
                date: collection.createdAt.toString(),
                onTap: () {},
                onDelete: () {
                  context.read<CollectionBloc>().add(DeleteCollection(collection.id));
                },
                onEdit: () {},
              );
            },
          );
        } else if (state is CollectionError) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text('No collections found'));
        }
      },
    );
  }
}