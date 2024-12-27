import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///Here we can see that if we do not run our expensive operation inside an
///[Isolate] then the operation will consume all the resources on our main
///thread (UI) and the UI will not update. (We can clearly see this through the gif)
class IsolatesPage extends StatefulWidget {
  const IsolatesPage({super.key});

  @override
  State<IsolatesPage> createState() => _IsolatesPageState();
}

class _IsolatesPageState extends State<IsolatesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
              width: double.infinity,
            ),
            const Text('Isolates'),
            const SizedBox(
              height: 20,
            ),
            Image.asset('assets/tom.gif'),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                int total = simpleExpensiveOperation();
                debugPrint('total = $total');
              },
              child: const Text('Run in main thread'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Run in async'),
            ),
            ElevatedButton(
              onPressed: () async {
                ReceivePort receivePort = ReceivePort();
                await Isolate.spawn(
                  expensiveOperation,
                  receivePort.sendPort,
                );
                var total = await receivePort.first;
                debugPrint('total = $total');
              },
              child: const Text('Run in isolate'),
            ),
          ],
        ),
      ),
    );
  }
}

simpleExpensiveOperation() {
  var total = 0;
  for (var i = 0; i < 1000000000; i++) {
    total += i;
  }
  return total;
}

expensiveOperation(SendPort sendPort) {
  var total = 0;
  for (var i = 0; i < 1000000000; i++) {
    total += i;
  }
  sendPort.send(total);
}
