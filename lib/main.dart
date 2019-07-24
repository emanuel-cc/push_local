import 'package:flutter/material.dart';
import 'package:push_local/src/pages/mensaje_page.dart';
import 'package:push_local/src/providers/push_notifications_provider.dart';
import 'package:push_local/src/pages/home_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  //Inicializamos la clase PushNotificationProvider
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final pushProvider = PushNotificationProvider();
    //Lanzamos el pushProvider
    pushProvider.initNotifications();
    //Aquí se maneja la informacion a mostrar, un alert, entre otras cosas
    pushProvider.mensajes.listen((data){
      //Navigator.pushNamed(context, 'mensaje');
      print('Argumento del push');
      print(data);

      navigatorKey.currentState.pushNamed('mensaje',arguments: data);
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //Manejar el estado de material app
      navigatorKey: navigatorKey,
      title: 'Push Local',
      initialRoute: 'home',
      routes: {
        'home' : (BuildContext context) => HomePage(),
        'mensaje' : (BuildContext context) => MensajePage(),
      },
    );
  }
}