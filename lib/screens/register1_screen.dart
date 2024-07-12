import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:ayamocca/screens/register2_screen.dart';

class RegisterScreen1 extends StatefulWidget {
  @override
  _RegisterScreen1State createState() => _RegisterScreen1State();
}

class _RegisterScreen1State extends State<RegisterScreen1> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  String? _selectedDay;
  String? _selectedMonth;
  String? _selectedYear;
  String? _selectedGender;

  bool isFormValid = false;

  List<String> days = List.generate(31, (index) => (index + 1).toString());
  List<String> months = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];
  List<String> years = List.generate(60, (index) => (1963 + index).toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          /*decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/fondo.jpg'),
              fit: BoxFit.cover,
            ),
          ),*/
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                Text("Registro",
                    style: TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Theme.of(context).colorScheme.primary)
                ),
                SizedBox(height: 10),
                EasyStepper(
                  activeStep: 0,
                  //lineLength: 70,
                  steps: [
                    EasyStep(
                      icon: Icon(Icons.account_circle),
                      title: 'Datos',
                    ),
                    EasyStep(
                      icon: Icon(Icons.business),
                      title: 'Área',
                    ),
                    EasyStep(
                      icon: Icon(Icons.payment),
                      title: 'Finalizar',
                    ),
                  ],
                  onStepReached: (index) {
                    setState(() {
                      //activeStep = index;
                    });
                  },
                ),
                Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // Alinea los elementos a la izquierda
                      mainAxisAlignment: MainAxisAlignment.center,
                      // Alinea los elementos al centro
                      children: [
                        TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            labelText: 'Nombres',
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, ingresa tus nombres';
                            }
                            return null;
                          },
                          textCapitalization: TextCapitalization.words,
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            labelText: 'Apellidos',
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, ingresa tus apellidos';
                            }
                            return null;
                          },
                          textCapitalization: TextCapitalization.words,
                        ),
                        SizedBox(height: 32.0),
                        Container(
                          alignment: Alignment.centerLeft,
                          // Alinea el texto a la izquierda
                          child: Text(
                            'Selecciona tu fecha de nacimiento',
                            style: TextStyle(
                                fontSize: 18.0,
                            //    color: Colors.white
                            ), // Cambia el color del texto a blanco
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          // Alinea los elementos a la izquierda
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _selectedDay,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedDay = newValue;
                                    checkFormValidity();
                                  });
                                },
                                items: days.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                decoration: InputDecoration(
                                  labelText: 'Día',
                                  filled: true,
                                  fillColor: Colors.transparent,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, selecciona el día';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              flex: 2,
                              // Aumenta el factor de expansión a 2 para ocupar más espacio
                              child: DropdownButtonFormField<String>(
                                value: _selectedMonth,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedMonth = newValue;
                                    checkFormValidity();
                                  });
                                },
                                items: months.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                decoration: InputDecoration(
                                  labelText: 'Mes',
                                  filled: true,
                                  fillColor: Colors.transparent,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, selecciona el mes';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _selectedYear,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedYear = newValue;
                                    checkFormValidity();
                                  });
                                },
                                items: years.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                decoration: InputDecoration(
                                  labelText: 'Año',
                                  filled: true,
                                  fillColor: Colors.transparent,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, selecciona el año';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        DropdownButtonFormField<String>(
                          value: _selectedGender,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedGender = newValue;
                              checkFormValidity();
                            });
                          },
                          items: <String>['Masculino', 'Femenino', 'Otros']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'Género',
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, selecciona tu género';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 32.0),
                        SizedBox(
                          width: 350,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: isFormValid
                                ? () {
                                    if (_formKey.currentState!.validate()) {
                                      Map<String, dynamic> userData = {
                                        'nombres': capitalizeFirstLetter(
                                            _firstNameController.text),
                                        'apellidos': capitalizeFirstLetter(
                                            _lastNameController.text),
                                        'fechaNacimiento': getSelectedDate(),
                                        'genero': _selectedGender!,
                                      };
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RegisterScreen2(
                                              userData: userData),
                                        ),
                                      );
                                    }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              // Cambia el color del botón
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text(
                              'Siguiente',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String capitalizeFirstLetter(String text) {
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }

  void checkFormValidity() {
    setState(() {
      isFormValid = _selectedDay != null &&
          _selectedMonth != null &&
          _selectedYear != null &&
          _selectedGender != null &&
          _firstNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty;
    });
  }

  String getSelectedDate() {
    return '$_selectedDay de $_selectedMonth de $_selectedYear';
  }
}
