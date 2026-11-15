import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/models/product.dart';
import 'package:flutter_application_1/widgets/product_card.dart';

void main(){
  testWidgets('product card shows product details and responds to taps', (
    tester,
  ) async{
    final product=Product(
      id: 1,
      title: 'Sample product',
      description: 'A short product description.',
      price: 12.5,
      category: 'Sample category',
      rating: 4.5,
      stock: 10,
      thumbnail: 'https://example.com/image.jpg',
      images: const [],
    );
    var wasTapped=false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 360,
            height: 320,
            child: ProductCard(product: product, onTap: ()=>wasTapped=true),
          ),
        ),
      ),
    );

    expect(find.text(product.title), findsOneWidget);
    expect(find.text(product.category), findsOneWidget);
    expect(find.text(product.description), findsOneWidget);
    expect(find.text('\$${product.price}'), findsOneWidget);

    await tester.tap(find.text(product.title));
    expect(wasTapped, isTrue);
  });
}
