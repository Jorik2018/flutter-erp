import 'package:flutter/material.dart';
import '../../model/furniture.dart';

class FurnitureItem extends StatelessWidget {
  const FurnitureItem({
    required this.furniture,
    Key? key,
  }) : super(key: key);
  final Furniture furniture;

  @override
  Widget build(BuildContext context) {
    return Draggable<Furniture>(
      feedback: _feedback,
      data: furniture,
      childWhenDragging: _childWhileDragging,
      onDragStarted: () {},
      onDragCompleted: () {},
      onDraggableCanceled: (velocity, offset) {},
      child: _childWhileDragging,
    );
  }

  Widget get _feedback {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: 260,
        height: 64,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(),
                child: Image.asset(
                  furniture.imageUrl!,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    furniture.name!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${furniture.price!.representablePrice}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget get _childWhileDragging {
    return Card(
      child: Stack(
        children: [
          Positioned(
            child: Image.asset(
              furniture.imageUrl!,
              height: 200,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            child: SizedBox(
              width: 120,
              height: 48,
              child: Text(
                furniture.name!,
                textAlign: TextAlign.left,
                overflow: TextOverflow.clip,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: .18,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 4,
            left: 0,
            child: Text(
              furniture.price!.representablePrice,
              textAlign: TextAlign.left,
              overflow: TextOverflow.clip,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.grey,
                fontWeight: FontWeight.w300,
              ),
            ),
          )
        ],
      ),
    );
  }
}
