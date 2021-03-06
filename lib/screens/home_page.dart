// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, avoid_print, unused_local_variable, avoid_unnecessary_containers, camel_case_types

import 'dart:convert';
import 'package:agendapp/clases/event_class.dart';
import 'package:agendapp/screens/contacts_page.dart';
import 'package:agendapp/screens/login_screen.dart';
import 'package:agendapp/widget_done/recordatorio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../clases/reminder_class.dart';
import '../features/tareas/tareas_notifier.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final String id;
  HomeScreen(this.id);
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  //VARIABLES
  //Controladores,
  final TextEditingController namReminderController = TextEditingController();
  final TextEditingController descReminderController = TextEditingController();
  List<Reminder> reminders = [];
  DateTime _SelectedDay = DateTime.now();
  DateTime _FocusedDay = DateTime.now();
  DateTime rightnow =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  final Map<DateTime, List<Event>> _selectedEvents = {};
  //LISTA DE EVENTOS

  List<Event> _getEventFromDay(DateTime date) {
    return _selectedEvents[date] ?? [];
  }

  //Funciones
  Future<void> fetchReminder() async {
    print("se hace la llamada");
    reminders.clear();
    _selectedEvents.clear();
    var url =
        'https://thelmaxd.000webhostapp.com/Agendapp/reminders.php?userID=' +
            widget.id;
    Response response = await get(Uri.parse(url));
    print(response.body);

    var reminderesponse = json.decode(response.body);
    for (var responsejson in reminderesponse) {
      reminders.add(Reminder.fromJson(responsejson));
    }
    reminders.sort((a, b) {
      DateTime fechita = DateTime.parse(a.date);
      DateTime fechita2 = DateTime.parse(b.date);
      DateTime now1 = DateTime(fechita.year, fechita.month, fechita.day);
      DateTime now2 = DateTime(fechita2.year, fechita2.month, fechita2.day);
      return now1.compareTo(now2);
    });

    for (var rem in reminders) {
      if (rem.remind == "1") {
        print("recordar");
        print(rem.name);
//AQUI DEBERIA PODER AGREGAR LA FUNCION
        DateTime fechita = DateTime.parse(rem.date);
        DateTime now = DateTime(fechita.year, fechita.month, fechita.day);
        if (_selectedEvents[fechita] == null) {
          _selectedEvents[fechita] = [];
          _selectedEvents[fechita]!.add(Event(rem.name));
        } else {
          _selectedEvents[fechita]!.add(Event(rem.name));
        }
        print(_selectedEvents);
      }
    }

    setState(() {});
    int seconds = 1;
    return Future.delayed(Duration(seconds: 3));
  }

  //MODALITO
  _showmodalReminder(
    int index,
    context,
    arr,
    Map<DateTime, List<Event>> _selectedEvents,
  ) {
    //MODAL DESPLEGABLE CUANDO SE PRESIONA LA ACTIVIDAD
    showModalBottomSheet(
        context: context,
        builder: (context) {
          print(arr[index].name);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.add),
                title: Text("Recuerdamelo"),
                onTap: () {
                  print("Recuerda esto");
                  //AQUI DEBERIA PODER AGREGAR LA FUNCIOR
                  Recordar(arr[index].id);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_forever),
                title: Text("Borrar"),
                //FUNCION PARA A??ADIR AL CALENDARIO
                onTap: () {
                  Borrar(index, arr);
                },
              ),
              ListTile(
                leading: Icon(Icons.edit_attributes),
                title: Text("Editar"),
                //FUNCION PARA A??ADIR AL CALENDARIO
                onTap: () {
                  Navigator.pop(context);
                  namReminderController.text = arr[index].name;
                  descReminderController.text = arr[index].reminder;
                  _showEditModal(index, context, arr);

                  //editar(index, arr);
                },
              ),
            ],
          );
        });
  }

  //MODAL DE EDICION

  _showEditModal(int index, BuildContext context, arr) {
    final nameField = TextFormField(
      autofocus: false,
      controller: namReminderController,
      onSaved: (value) {
        namReminderController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.abc),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Nombre",
        labelText: "Nombre",
        filled: true,
        fillColor: Colors.white,
      ),
    );
    final descriptionField = TextFormField(
      autofocus: false,
      controller: descReminderController,
      onSaved: (value) {
        descReminderController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.description),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Descripcion",
        labelText: "Descripcion",
        filled: true,
        fillColor: Colors.white,
      ),
    );

    final sendButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.black,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: 300,
        onPressed: () {
          Navigator.pop(context);
          editar(index, arr);
        },
        child: Text(
          "Send",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    //MODAL DESPLEGABLE CUANDO SE PRESIONA LA ACTIVIDAD
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              nameField,
              SizedBox(
                height: 10,
              ),
              descriptionField,
              SizedBox(
                height: 10,
              ),
              sendButton,
              SizedBox(
                height: 10,
              ),
            ],
          );
        });
  }

  Future<void> Recordar(id) async {
    print("Listo para recordar");
    var url =
        'https://thelmaxd.000webhostapp.com/Agendapp/edit_Reminder.php?id=' +
            id;
    Response response = await get(Uri.parse(url));
    fetchReminder();
  }

  Future<void> Borrar(int index, arr) async {
    print("Listo para Borrar");
    var url =
        'https://thelmaxd.000webhostapp.com/Agendapp/delete_reminder.php?id=' +
            arr[index].id;
    Response response = await get(Uri.parse(url));
    fetchReminder();
  }

  Future<void> editar(int index, arr) async {
    print("Editado");
    var url =
        'https://thelmaxd.000webhostapp.com/Agendapp/edit_reminder2.php?id=' +
            arr[index].id +
            '&name=' +
            namReminderController.text +
            '&desc=' +
            descReminderController.text;

    Response response = await get(Uri.parse(url));
    fetchReminder();
  }

  @override
  void initState() {
    super.initState();
    // ignore: todo

    _selectedEvents[rightnow] = [];
    _selectedEvents[rightnow]!.add(Event("Agregar"));
    fetchReminder();
  }

  @override
  Widget build(BuildContext context) {
//Fields

    //Esto si Funciona

    ref.listen<int>(counterProvider, (int? previousCount, int newCount) async {
      fetchReminder();
    });

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 46, 46, 46),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //aca es todo lo que si se ve
          print(_getEventFromDay(rightnow));
          print(_SelectedDay);
          print(rightnow);
          print("--------------------");
          fetchReminder();
        },
        child: Icon(Icons.refresh),
      ),
      appBar: AppBar(
        backgroundColor: Colors.grey,
        centerTitle: true,
        elevation: 0,
        title: Text("AGENDAPP"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => contact_page(widget.id)));
            },
            icon: Icon(Icons.person),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            icon: Icon(Icons.exit_to_app),
          ),
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
                            onLongPress: () {
                              _showmodalReminder(
                                index,
                                context,
                                reminders,
                                _selectedEvents,
                              );
                            },
                            onTap: () {
                              DateTime fechita =
                                  DateTime.parse(reminders[index].date);
                              DateTime select = DateTime(
                                  fechita.year, fechita.month, fechita.day);
                              setState(() {
                                _SelectedDay = select;
                              });
                            },
                            child: reminder(
                                reminders[index].name,
                                reminders[index].reminder,
                                reminders[index].date,
                                reminders[index].id,
                                reminders[index].priority),
                          ),
                          SizedBox(
                            height: 20,
                          ),
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
                    Column(
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
                          onDaySelected:
                              (DateTime _selectDay, DateTime focusDay) {
                            setState(() {
                              DateTime now = DateTime(_selectDay.year,
                                  _selectDay.month, _selectDay.day);
                              _SelectedDay = now;
                              _FocusedDay = now;
                            });
                            print(_FocusedDay);
                          },
                          selectedDayPredicate: (DateTime date) {
                            return isSameDay(_SelectedDay, date);
                          },

                          //poco de dise??o pal calendario EDITADO
                          calendarStyle: CalendarStyle(
                            isTodayHighlighted: true,
                            defaultTextStyle: TextStyle(
                                color: Color.fromARGB(
                                    255, 255, 255, 255)), //Colores Dias
                            weekendTextStyle: TextStyle(
                                color: Color.fromARGB(255, 255, 255,
                                    255)), //Colores Fines de Semana
                            outsideTextStyle: TextStyle(
                                color: Color.fromARGB(255, 255, 255,
                                    255)), //Colores fuera de mes actual
                            todayTextStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          headerStyle: HeaderStyle(
                            titleTextStyle: TextStyle(color: Colors.white),
                            formatButtonDecoration: BoxDecoration(
                              color: Color.fromARGB(255, 0, 204, 255),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            formatButtonTextStyle:
                                TextStyle(color: Colors.white),
                            formatButtonShowsNext: false,
                          ),
                          calendarBuilders: CalendarBuilders(
                            dowBuilder: (context, day) {
                              final text = DateFormat.E().format(day);
                              return Center(
                                child: Text(
                                  text,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 223, 222,
                                          222)), //Color a los dias de la semana
                                ),
                              );
                            },
                            selectedBuilder: (context, date, events) =>
                                Container(
                                    margin: const EdgeInsets.all(4.0),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: Text(
                                      date.day.toString(),
                                      style: TextStyle(color: Colors.black),
                                    )),
                            todayBuilder: (context, date, events) => Container(
                                margin: const EdgeInsets.all(4.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 0, 204, 255),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Text(
                                  date.day.toString(),
                                  style: TextStyle(color: Colors.black),
                                )),
                          ),
                        ),
                      ],
                    ),
                    ..._getEventFromDay(_SelectedDay)
                        .map((Event event) => Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Container(
                                //EDITAR
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    //shape: BoxShape.rectangle,
                                    border: Border.all(color: Colors.white)),
                                child: ListTile(
                                  title: Center(
                                    child: Text(
                                      event.title,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                  ],
                ),
              ),
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

//WIDGET DE LA DERECHA UWU
class addReminder extends ConsumerStatefulWidget {
  @override
  final String id;
  addReminder(this.id);
  ConsumerState<addReminder> createState() => _addReminderState();
}

class _addReminderState extends ConsumerState<addReminder> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  var r_name;
  var r_desc;
  var r_prio;
  var r_date;

  var _CurrentSelectedDate;
  var _CurrentSelectedDateonString;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      _CurrentSelectedDate = DateTime.now();
      _CurrentSelectedDateonString =
          DateFormat('yyyy-MM-dd').format(_CurrentSelectedDate);
    });
  }

  //CALL A EL DATEPICKER
  void callDatePicker() async {
    var selectedDate = await getDatePickerWidget();
    setState(() {
      _CurrentSelectedDate = selectedDate;
      _CurrentSelectedDateonString =
          DateFormat('yyyy-MM-dd').format(_CurrentSelectedDate);
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
          labelText: "Homework Name",
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
      borderRadius: BorderRadius.circular(10),
      color: Colors.blue,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: 100,
        onPressed: () async {
          if (nombreController.text.isNotEmpty &&
              descriptionController.text.isNotEmpty) {
            setState(() {
              r_name = nombreController.text;
              r_desc = descriptionController.text;
              r_date = _CurrentSelectedDate;
            });
          }
          if (descriptionController.text.isEmpty ||
              nombreController.text.isEmpty ||
              _CurrentSelectedDate == Null) {
            _showToast(context, "No puedes enviar CAMPOS vacios");
          }

          await _sendReminder(
              context, widget.id, r_name, r_desc, r_prio, r_date);
          nombreController.clear();
          descriptionController.clear();
          ref.read(counterProvider.notifier).increment();
        },
        child: Text(
          "Create Activity",
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
            Text("A??adir Nueva Tarea", style: TextStyle(color: Colors.white)),
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
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(5)),
              child: TextButton(
                  onPressed: callDatePicker,
                  //style: ButtonStyle(backgroundColor: Colors.white),
                  child: Text(
                    "$_CurrentSelectedDateonString",
                    style: TextStyle(
                        color: Colors.white, fontSize: 20, letterSpacing: 1.5),
                  )),
            ),
            //Text("$_CurrentSelectedDate",style: TextStyle(color: Colors.white)),
            SizedBox(
              height: 15,
            ),
            Text(
              "Prioridad",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            //AQUI HARE EL MODAL PARA SELECCIONAR LA PRIORIDAD

            Center(
              child: Container(
                height: 80,
                child: CupertinoPicker(
                    itemExtent: 40,
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
                      Center(
                        child: Text(
                          "High",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Center(
                        child: Text(
                          "Medium",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Center(
                        child: Text(
                          "Low",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ]),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            //Boton para enviar datos
            addBtn,
          ]),
        ),
      ),
    );
  }
}

Future<void> _sendReminder(
    context, id, name, descripcion, priority, date) async {
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
