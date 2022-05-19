// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, unnecessary_import, must_be_immutable, camel_case_types, override_on_non_overriding_member, use_key_in_widget_constructors, annotate_overrides, sized_box_for_whitespace

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class reminder extends StatefulWidget {
  @override
  String recordatorio;
  String hora;
  String id;
  String prioridad;
  reminder(this.recordatorio, this.hora, this.id, this.prioridad);
  State<reminder> createState() => _reminderState();
}

class _reminderState extends State<reminder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Color.fromARGB(255, 23, 21, 28),
      ),
      child: Row(children: <Widget>[
        //Franja Color
        Container(
          decoration: BoxDecoration(color: Colors.amber),
          width: 10,
        ),
        //Contenido
        Container(
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //De este lado iran los textos
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.recordatorio,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(widget.hora, style: TextStyle(color: Colors.white)),
                  SizedBox(
                    height: 5,
                  ),
                  Text(widget.prioridad, style: TextStyle(color: Colors.white)),
                ],
              ),
              //De este lado ira el icono
              Icon(
                Icons.book_online,
                color: Colors.white,
              )
            ],
          ),
        ),
      ]),
    );
  }
}
