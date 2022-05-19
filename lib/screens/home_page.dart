// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, avoid_print, unused_local_variable, avoid_unnecessary_containers, camel_case_types

import 'dart:convert';
import 'package:agendapp/clases/event_class.dart';
import 'package:agendapp/screens/contacts_page.dart';
import 'package:agendapp/widget_done/recordatorio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../clases/reminder_class.dart';

class HomeScreen extends StatefulWidget {
  final String id;
  HomeScreen(this.id);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //VARIABLES
  List<Reminder> reminders = [];
  DateTime _SelectedDay = DateTime.now();
  DateTime _FocusedDay = DateTime.now();
  late Map<DateTime, List<Event>> selectedEvents;

  //Funciones
  Future<void> fetchReminder() async {
    reminders.clear();
    var url =
        'https://thelmaxd.000webhostapp.com/Agendapp/reminders.php?userID=' +
            widget.id;
    Response response = await get(Uri.parse(url));
    print(response.body);

    var reminderesponse = json.decode(response.body);
    for (var responsejson in reminderesponse) {
      reminders.add(Reminder.fromJson(responsejson));
    }
    print(reminders[0].id);
    setState(() {});
    int seconds = 1;
    return Future.delayed(Duration(seconds: 3));
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    selectedEvents = {};
    fetchReminder();
  }

  //LISTA DE EVENTOS
  List<Event> _getEventFromDay(DateTime date) {
    return selectedEvents[date]??[];
  }

  @override
  Widget build(BuildContext context) {
    //Esto si Funciona
    //aca es todo lo que si se ve
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 46, 46, 46),
      floatingActionButton: FloatingActionButton(
        onPressed: () => fetchReminder(),
        child: Icon(Icons.refresh),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("AGENDAPP"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => contact_page(widget.id)));
              },
              icon: Icon(Icons.person))
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //izquierda
              //aqui debera ir el refresh
              Expanded(
                  child: Container(
                child: RefreshIndicator(
                  onRefresh: fetchReminder,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: reminders.length,
                    itemBuilder: (context, index) {
                      //mando  a llamar al widget
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () => {
                              _showmodalReminder(index, context),
                              print(index),
                            },
                            child: reminder(
                                reminders[index].reminder,
                                reminders[index].date,
                                reminders[index].id,
                                reminders[index].priority),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      );
                    },
                  ),
                ),
              )),
              //center
              Expanded(
                  child: Column(
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: _SelectedDay,
                    calendarFormat: CalendarFormat.month,
                    daysOfWeekVisible: true,
                    //Eventos!
                    eventLoader: _getEventFromDay,
                    //day changed
                    onDaySelected: (DateTime _selectDay, DateTime focusDay) {
                      setState(() {
                        _SelectedDay = _selectDay;
                        _FocusedDay = focusDay;
                      });
                      print(_FocusedDay);
                    },
                    selectedDayPredicate: (DateTime date) {
                      return isSameDay(_SelectedDay, date);
                    },

                    //poco de diseño pal calendario
                    calendarStyle: CalendarStyle(
                      isTodayHighlighted: true,
                      selectedDecoration: BoxDecoration(
                        color: Colors.cyan,
                        shape: BoxShape.rectangle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Colors.purple,
                        shape: BoxShape.rectangle,
                      ),
                      defaultDecoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        
                      ),
                    ),
                  ),
                ],
              )),
              //Derecha
              //OSEA new reminder!---------------------------------------
              Expanded(
                child: Column(children: [
                  addReminder(widget.id),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

_showmodalReminder(int index, context) {
  //MODAL DESPLEGABLE CUANDO SE PRESIONA LA ACTIVIDAD
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Recuerdamelo"),
              onTap: () => {
                print("Recordar mas tarde")
                //FUNCION PARA AÑADIR AL CALENDARIO
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_forever),
              title: Text("Borrar"),
              onTap: () => {print("Recordar mas tarde")},
            ),
          ],
        );
      });
}

class addReminder extends StatefulWidget {
  @override
  final String id;
  addReminder(this.id);
  State<addReminder> createState() => _addReminderState();
}

class _addReminderState extends State<addReminder> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  var r_name;
  var r_desc;
  var r_prio;
  var r_date;

  var _CurrentSelectedDate;
  //CALL A EL DATEPICKER
  void callDatePicker() async {
    var selectedDate = await getDatePickerWidget();
    setState(() {
      _CurrentSelectedDate = selectedDate;
    });
  }

  Future<DateTime?> getDatePickerWidget() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(data: ThemeData.dark(), child: Center(child: child));
      },
    );
  }

  //CREAR WIDGET DATE PICKER
  @override
  Widget build(BuildContext context) {
    //CAMPO DE RECORDATORIO
    final recordatorioField = TextFormField(
      autofocus: false,
      controller: nombreController,
      onSaved: (value) {
        nombreController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.recommend),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Nombre",
          labelText: "Reminder Name",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.white,
                width: 2,
              ))),
    );

    //CAMPO DE DESCRIPCION
    final descriptionField = TextFormField(
      autofocus: false,
      controller: descriptionController,
      onSaved: (value) {
        descriptionController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 60, 20, 60),
          labelText: "Description",
          alignLabelWithHint: true,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.blue,
                width: 5,
              ))),
    );
    //BOTON DE AGREGAR
    final addBtn = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          if (nombreController.text != Null &&
              descriptionController.text != null) {
            setState(() {
              r_name = nombreController.text;
              r_desc = descriptionController.text;
              r_date = _CurrentSelectedDate;
            });
            _sendReminder(context, widget.id, r_name, r_desc, r_prio, r_date);
          } else {
            _showToast(context, "No puedes enviar Recordatorios vacios");
          }
          nombreController.clear();
          descriptionController.clear();
        },
        child: Text(
          "Create Reminder",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    // ignore: todo
    //LO QUE CONTIENE TODO LO QUE SE VE
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10)),
      height: MediaQuery.of(context).size.height - 100,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            Text("Añadir Nueva Recordatorio",
                style: TextStyle(color: Colors.white)),
            SizedBox(
              height: 20,
            ),
            recordatorioField,
            SizedBox(
              height: 20,
            ),
            Text(
              "Description",
              style: TextStyle(color: Colors.white),
            ),
            descriptionField,
            SizedBox(
              height: 20,
            ),
            //Para seleccionar la fecha
            TextButton(
                onPressed: callDatePicker,
                //style: ButtonStyle(backgroundColor: Colors.white),
                child: Text(
                  "Pick Date",
                  style: TextStyle(
                      color: Colors.white, fontSize: 20, letterSpacing: 1.5),
                )),
            //Text("$_CurrentSelectedDate",style: TextStyle(color: Colors.white)),
            SizedBox(
              height: 20,
            ),
            Text(
              "Prioridad",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            //AQUI HARE EL MODAL PARA SELECCIONAR LA PRIORIDAD

            Center(
              child: Container(
                height: 80,
                child: CupertinoPicker(
                    itemExtent: 37,
                    onSelectedItemChanged: (selectedIndex) {
                      print(selectedIndex);
                      if (selectedIndex == 0) {
                        setState(() {
                          r_prio = "High";
                        });
                      }
                      if (selectedIndex == 1) {
                        setState(() {
                          r_prio = "Medium";
                        });
                      }
                      if (selectedIndex == 2) {
                        setState(() {
                          r_prio = "Low";
                        });
                      }
                    },
                    children: [
                      Text(
                        "High",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Medium",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Low",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                    ]),
              ),
            ),
            //Boton para enviar datos
            addBtn,
          ]),
        ),
      ),
    );
  }
}

void _sendReminder(context, id, name, descripcion, priority, date) async {
  print("llegamos la func");
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(date);
  print(formatted);
  print(priority);
  print(descripcion);
  print(name);
  print(id);

  try {
    //https://thelmaxd.000webhostapp.com/Agendapp/add_reminder.php?id=5&name=probar&description=revisarlaBD&date=19-05-2022&prio=High
    //https://thelmaxd.000webhostapp.com/Agendapp/add_reminder.php?id=5&name=probar&description=Resar&date=19-05-2022&prio=low
    var url =
        "https://thelmaxd.000webhostapp.com/Agendapp/add_reminder.php?id=" +
            id +
            "&name=" +
            name +
            "&description=" +
            descripcion +
            "&date=" +
            formatted +
            "&prio=" +
            priority;

    //print(url);
    Response response = await get(Uri.parse(url));
    print(response.body);
    if (response.body == "1") {
      //Aqui es que si jalo
      _showToast(context, "Agregado con Exito");

      //Si se ha registrado hay que mostrar algo
    }
    if (response.body == "0") {
      _showToast(context, "Algo Fallo");
    }
  } catch (e) {
    print(e);
  }
}

void _showToast(context, String s) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(s),
    ),
  );
}
