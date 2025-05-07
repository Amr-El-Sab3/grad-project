import 'package:emotion_detection/bloc/collection_bloc/collection_bloc.dart';
import 'package:emotion_detection/bloc/collection_bloc/collection_state.dart';
import 'package:emotion_detection/ui/widgets/collection_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CollectionListWidget extends StatelessWidget {
  const CollectionListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionBloc, CollectionState>(
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
                name: collection.name,
                date: collection.createdAt.toString(),
                onTap: () {},
                onDelete: () {},
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