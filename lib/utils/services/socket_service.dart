import 'dart:developer';

import 'package:boilerplate/config/app_config.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketService {
  late Socket socket;
  void connect() {
    try {
      //when socket initializing
      socket = io(
        AppConfig.socketURL,
        OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .build(),
      );

      //when socket connected
      socket.connect();
      socket.onConnect((_) {
        socket.emit('init');
        log("Socket handshake successfull!");
      });

      //when the event hit from server
      socket.on(
        'eventName',
        (received) async {
          log("Received notification by server!..");
          log(received.toString());
        },
      );

      //when socket disconnected
      socket.onDisconnect((_) {
        log('Socket disconnected with server!');
      });
    } catch (e) {
      log(e.toString());
    }
  }
}
