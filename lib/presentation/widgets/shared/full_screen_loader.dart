
import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> getLoadingMessage() {

    final messages = <String>[
      'Charging movies',
      'Charging popcorn',
      'Charging poplular',
      'This is taking longer than expected',
      'Ready!!',
    ];

    return Stream.periodic( const Duration( milliseconds: 1200 ), ( step ) {
      return messages[ step ];
    }).take( messages.length );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Wait please...'),
          const SizedBox( height:  10 ),
          const CircularProgressIndicator( strokeWidth: 2 ),
          const SizedBox( height:  10 ),

          StreamBuilder(
            stream: getLoadingMessage(),
            builder: (context, snapshot) {
              if ( !snapshot.hasData ) return const Text( 'Charging...' );

              return Text( snapshot.data! );
            },
          ),
        ],
      ),
    );
  }
}