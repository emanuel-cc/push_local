//Ayuda a expandir la aplicacion con alguna funcionalidad (el archivo provider)
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'dart:io';

class PushNotificationProvider{
  //Inicializar las notificaciones
  //pedirle permiso al usuario que va a recibir las notificaciones y 
  //obtener el identificador unico o token de este dispositivo
  // y ese token se va a guardar en la base de datos

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  //Escuchar cuando la notificacion caiga
  final _mensajeStreamController = StreamController<String>.broadcast();
  //Emitir mensaje
  Stream<String> get mensajes => _mensajeStreamController.stream;

  initNotifications(){
    //Pedir permiso para utilizar esas notificaciones
    _firebaseMessaging.requestNotificationPermissions();
    //Obtener el token de dispositivo
    _firebaseMessaging.getToken().then((token){
      //Ese token que me toca almacenar en la base de datos
      print('======== FCM token=========');
      print(token);
    }); //Regresa un Future, que es el token

    //Configuracion
    //Metodos a llamar con los diferentes pasos de las etapas para recibir una push
    _firebaseMessaging.configure(
      //Se va a disparar cuando la aplicacion esta abierta
      onMessage: (info){
        print('====== On Message =======');
        print(info);

        String argumento = 'no-data';
        //Determinar cuando estas en Android o en IOS
        if(Platform.isAndroid){
          argumento=info['data']['comida'] ?? 'no-data';
        }else{
          argumento = info['comida'] ?? 'no-data-ios';
        }
        _mensajeStreamController.sink.add(argumento);
      },
      
      //Cuando la aplicacion ya está terminada
      onLaunch: (info){
        print('====== On Launch =======');
        print(info);
        
      },
      //Recibir las notificaciones en segundo plano
      //Cuando la aplicacion está en segundo plano
      onResume: (info){
        print('====== On Resume =======');
        print(info);

        String argumento = 'no-data';
        //Determinar cuando estas en Android o en IOS
        if(Platform.isAndroid){
          argumento=info['data']['comida'] ?? 'no-data';
        }else{
          argumento = info['comida'] ?? 'no-data-ios';
        }
        final noti = info['data']['comida'];
        //Escucha y agrega la informacion de la notificacion que trae el argumento
        //Por lo cual va a navegar a la pantalla y mostrar la información recibida
        _mensajeStreamController.sink.add(noti);
      },
    );
  }

  //Metodo dispose
  dispose(){
    _mensajeStreamController?.close();
  }
}