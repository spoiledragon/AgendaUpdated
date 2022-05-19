// ignore_for_file: camel_case_types, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors, duplicate_ignore, prefer_const_literals_to_create_immutables

import 'package:agendapp/clases/contact_class.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class contact_page extends StatefulWidget {
  final String id;
  contact_page(this.id);
  @override
  State<contact_page> createState() => _contact_pageState();
}

//PARTE DE LA CLASE QUE SE VE DENTRO DEL CANVAS PRINCIPAL,
class _contact_pageState extends State<contact_page> {
//CAMPOS Y BOTON PARA ENVIAR

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Contact_List(widget.id),
    );
  }
}

//AQUI DECLARAMOS EL WIDGET QUE DESPLIEGA LA LISTA, SOLO ES PARTE DEL CONSTRUCTOR
class Contact_List extends StatefulWidget {
  final String id;
  String id_todelete = "";
  int id_toedit = 1;
  Contact_List(this.id);
  @override
  State<Contact_List> createState() => _Contact_ListState();
}

//INICIO DE LA LISTA QUE DECLARA LA LISTA EN BLANCO ASI NO SE DESARMA SIEMPRE LA LISTA
class _Contact_ListState extends State<Contact_List> {
  final _nameEditingController = TextEditingController();
  final _emailEditingController = TextEditingController();
  final _telEditingController = TextEditingController();
  final _urlEditingController = TextEditingController();
  bool loading = true;
  List<Contact> contacts = [];
  @override
  void initState() {
    loading = true;
    _loadUser();
    super.initState();
  }

  Future<void> _loadUser() async {
    try {
      debugPrint("Entra a la func");
      var url =
          "https://thelmaxd.000webhostapp.com/Agendapp/contactos.php?userID=" +
              widget.id;
      debugPrint("Url lista");
      Response response = await get(Uri.parse(url));
      List<Contact> _contacts = [];
      var userResponse = json.decode(response.body);
      for (var Contacto in userResponse) {
        _contacts.add(Contact.fromJson(Contacto));
        debugPrint("si");
      }
      setState(() {
        debugPrint("Actualiza");
        contacts = _contacts;
        loading = false;
      });
    } catch (e) {
      //debugPrint(e);
    }

    //aqui sacamos los datos y los metemos a un array
  }

  void _delete_user(
    index,
  ) async {
    var url =
        "https://thelmaxd.000webhostapp.com/Agendapp/contact_todelete.php?ID=" +
            contacts[index].id;
    Response response = await get(Uri.parse(url));
    List<Contact> _contacts = [];
    _loadUser();
  }

  //PARA ENVIAR EL DATO NUEVO
  void addContact(id) async {
    //https://thelmaxd.000webhostapp.com/Agendapp/add_contact.php?id=1&name=pedrito&email=borraro@gmail.com&tel=1234
    var url =
        "https://thelmaxd.000webhostapp.com/Agendapp/add_contact.php?id=" +
            id +
            "&name=" +
            _nameEditingController.text +
            "&email=" +
            _emailEditingController.text +
            "&tel=" +
            _telEditingController.text;
    Response response = await get(Uri.parse(url));
    List<Contact> _contacts = [];
    //aqui sacamos los datos y los metemos a un array
    _loadUser();
  }

  //para editar el datox
  //https://thelmaxd.000webhostapp.com/Agendapp/edit_contact.php?id=36&url=https://i.pinimg.com/originals/51/f6/fb/51f6fb256629fc755b8870c801092942.png
  void editcontact(index, ruta, nombre, email, telefono) async {
    var url =
        "https://thelmaxd.000webhostapp.com/Agendapp/edit_contact.php?id=" +
            contacts[index].id +
            "&url=" +
            ruta +
            "&name=" +
            nombre +
            "&email=" +
            email +
            "&tel=" +
            telefono;
    Response response = await get(Uri.parse(url));
    print(response);
    List<Contact> _contacts = [];
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(child: CircularProgressIndicator());
    }

//LA PARTE VISUAL DE LOS BOTONES DE NOMBRE Y ETC
//User field
    final nameField = TextFormField(
      autofocus: false,
      controller: _nameEditingController,
      keyboardType: TextInputType.name,
      //validator: (){},
      onSaved: (value) {
        _nameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
//Email FIELD
    final emailField = TextFormField(
      autofocus: false,
      controller: _emailEditingController,
      keyboardType: TextInputType.emailAddress,
      //validator: (){},
      onSaved: (value) {
        _emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

//Telephone Field
    final teleField = TextFormField(
      autofocus: false,
      controller: _telEditingController,
      keyboardType: TextInputType.number,
      maxLength: 10,
      //validator: (){},
      onSaved: (value) {
        _telEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.phone),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Telephone",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
//Url Field
    final urlField = TextFormField(
      autofocus: false,
      controller: _urlEditingController,
      keyboardType: TextInputType.number,
      maxLength: 500,
      //validator: (){},
      onSaved: (value) {
        _urlEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.web),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "URL",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //boton
    final addButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.black,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          addContact(widget.id);
          _nameEditingController.clear();
          _emailEditingController.clear();
          _telEditingController.clear();
        },
        child: Text(
          "Register",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    //boton
    final editButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.black,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          editcontact(
              widget.id_toedit,
              _urlEditingController.text,
              _nameEditingController.text,
              _emailEditingController.text,
              _telEditingController.text);
          _urlEditingController.clear();
          _nameEditingController.clear();
          _telEditingController.clear();
          _emailEditingController.clear();
        },
        child: Text(
          "Register",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

//PARA DESPLEGAR MENSAJITOS BONITOS , es un toast pues
    void _showToast(BuildContext context, mensaje) {
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: Text(mensaje),
        ),
      );
    }

    void _showModalBottomSheet(BuildContext context, index) {
      setState(() {
        widget.id_toedit = index;
      });
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //aqui pondre todo lo que debe de verse

                    SizedBox(height: 10,),
                CircleAvatar(
                    backgroundImage: NetworkImage(contacts[index].photoUrl),radius: 50,),
                    SizedBox(height: 10,),
                Text(contacts[index].name,style: TextStyle(fontSize: 20,letterSpacing: 2,fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                Text(contacts[index].email),
                    SizedBox(height: 10,),
                Text(contacts[index].tel),
                //--------------------------------
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _emailEditingController.text = contacts[index].email;
                      _nameEditingController.text = contacts[index].name;
                      _telEditingController.text = contacts[index].tel;
                      _urlEditingController.text = contacts[index].photoUrl;
                    });
                    //SE QUITA UN MODAL Y ENTRA EL SIGUIENTE
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(400, 0, 400, 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                nameField,
                                SizedBox(
                                  height: 10,
                                ),
                                emailField,
                                SizedBox(
                                  height: 10,
                                ),
                                teleField,
                                SizedBox(
                                  height: 10,
                                ),
                                urlField,
                                SizedBox(
                                  height: 10,
                                ),
                                editButton,
                              ],
                            ),
                          );
                        });

                    //Navigator.pop(context);
                    //_showEditModal();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Delete'),
                  onTap: () {
                    _delete_user(index);
                  },
                ),
              ],
            );
          });
    }

//MODAL DESPLEGABLE CUANDO SE PRESIONA EL ENVIAR
    void _showModalAdd(BuildContext context) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(400, 0, 400, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  nameField,
                  SizedBox(
                    height: 20,
                  ),
                  emailField,
                  SizedBox(
                    height: 20,
                  ),
                  teleField,
                  SizedBox(
                    height: 20,
                  ),
                  addButton,
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          });
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showModalAdd(context),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        // ignore: prefer_const_constructors
        title: Center(child: Text("Contactos")),
        actions: [
          IconButton(
              onPressed: _loadUser,
              // ignore: prefer_const_constructors
              icon: Icon(
                Icons.person_add,
                color: Colors.white,
              ))
        ],
      ),
      body: ListView.builder(
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => {_showModalBottomSheet(context, index)},
              child: ListTile(
                title: Text(contacts[index].name),
                subtitle: Text(contacts[index].email),
                leading: CircleAvatar(
                    backgroundImage: NetworkImage(contacts[index].photoUrl)),
                trailing: Text(contacts[index].tel),
              ),
            );
          },
          itemCount: contacts.length),
    );
  }
}
