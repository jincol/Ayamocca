import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:ayamocca/screens/register3_screen.dart';
import 'register1_screen.dart';

class RegisterScreen2 extends StatefulWidget {
  final Map<String, dynamic> userData;

  RegisterScreen2({required this.userData});

  @override
  _RegisterScreen2State createState() => _RegisterScreen2State();
}

class _RegisterScreen2State extends State<RegisterScreen2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedCareer;
  String? _selectedCycle;
  String? _selectedDegree;

  bool isFormValid = false;

  Map<String, List<String>> areasConSecciones = {
    "Contabilidad": [
      "Contabilidad General",
      "Cuentas por Pagar",
      "Cuentas por Cobrar",
      "Auditoría Interna",
    ],
    "Marketing": [
      "Investigación de Mercados",
      "Publicidad",
      "Relaciones Públicas",
      "Gestión de Productos",
      "Marketing Digital",
    ],
    "Administración": [
      "Administración General",
      "Servicios Generales",
      "Gestión Documental",
    ],
    "Recursos Humanos": [
      "Reclutamiento y Selección",
      "Capacitación y Desarrollo",
      "Gestión de Nómina",
      "Relaciones Laborales",
    ],
    "Ventas": [
      "Ventas Directas",
      "Ventas Online",
      "Atención al Cliente",
      "Post-Venta",
    ],
    "Producción": [
      "Planificación de la Producción",
      "Control de Calidad",
      "Mantenimiento",
      "Gestión de Inventarios",
    ],
    "Logística": [
      "Almacenes",
      "Distribución",
      "Gestión de Transporte",
      "Gestión de Inventarios",
    ],
    "Compras": [
      "Proveedores",
      "Adquisiciones",
      "Contrataciones",
      "Gestión de Contratos",
    ],
    "Finanzas": [
      "Planeación Financiera",
      "Tesorería",
      "Gestión de Riesgos",
      "Inversiones",
    ],
    "Investigación y Desarrollo": [
      "Desarrollo de Nuevos Productos",
      "Investigación de Mercado",
      "Innovación",
      "Pruebas y Validación",
    ],
    "Servicio al Cliente": [
      "Soporte Técnico",
      "Gestión de Reclamos",
      "Atención Telefónica",
      "Atención en Línea",
    ],
    "Tecnología de la Información": [
      "Desarrollo de Software",
      "Infraestructura",
      "Soporte Técnico",
      "Seguridad Informática",
    ],
    "Calidad": [
      "Control de Calidad",
      "Mejora Continua",
      "Certificaciones",
      "Gestión de Procesos",
    ],
    "Legal": [
      "Asesoría Legal",
      "Gestión de Contratos",
      "Cumplimiento Normativo",
      "Litigios",
    ],
    "Relaciones Públicas": [
      "Comunicación Corporativa",
      "Responsabilidad Social",
      "Eventos",
      "Medios de Comunicación",
    ],
    "Planificación Estratégica": [
      "Análisis de Mercado",
      "Gestión de Proyectos",
      "Estrategia Corporativa",
      "Inteligencia Competitiva",
    ],
    "Desarrollo de Negocios": [
      "Alianzas Estratégicas",
      "Expansión de Mercado",
      "Evaluación de Oportunidades",
      "Negociaciones",
    ],
    "Seguridad": [
      "Seguridad Física",
      "Seguridad Electrónica",
      "Planes de Emergencia",
      "Auditorías de Seguridad",
    ],
    "Medio Ambiente": [
      "Gestión de Residuos",
      "Energías Renovables",
      "Cumplimiento Ambiental",
      "Proyectos de Sostenibilidad",
    ],
    "Salud y Seguridad Ocupacional": [
      "Prevención de Riesgos",
      "Ergonomía",
      "Salud Ocupacional",
      "Planes de Evacuación",
    ],
  };


  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> dropdownItems = areasConSecciones.keys.map((String key) {
      return DropdownMenuItem<String>(
        value: key,
        child: Text(key),
      );
    }).toList();


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
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text("Registro",
                    style: TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Theme.of(context).colorScheme.primary)
                ),
                SizedBox(height: 10),
                EasyStepper(
                  activeStep: 1,
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
                SizedBox(height: 16.0),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedCareer,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCareer = newValue;
                            _selectedCycle = null;
                            checkFormValidity();
                          });
                        },
                        items: dropdownItems,
                        decoration: InputDecoration(
                          labelText: 'Áreas',
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, selecciona un área de la empresa';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      DropdownButtonFormField<String>(
                        value: _selectedCycle,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCycle = newValue;
                            checkFormValidity();
                          });
                        },
                        items: _selectedCareer != null
                            ? areasConSecciones[_selectedCareer]!.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList() : [],
                        decoration: InputDecoration(
                          labelText: 'Sección',
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, selecciona una sección';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      DropdownButtonFormField<String>(
                        value: _selectedDegree,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedDegree = newValue;
                            checkFormValidity();
                          });
                        },
                        items: <String>[
                          '1ro',
                          '2do',
                          '3ro',
                          '4to',
                          '5to',
                          '6to',
                          '7mo',
                          '8vo',
                          '9no',
                          '10mo'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'N° Orden',
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, selecciona un número de orden';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      SizedBox(
                        width: 350,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: isFormValid ? () => _submitForm() : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
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
                      SizedBox(height: 16.0),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen1(),
                              ),
                            );
                          },
                          child: Text(
                            'Volver',
                            style: TextStyle(fontSize: 14.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void checkFormValidity() {
    setState(() {
      isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      widget.userData['career'] = _selectedCareer;
      widget.userData['cycle'] = _selectedCycle;
      widget.userData['degree'] = _selectedDegree;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterScreen3(userData: widget.userData),
        ),
      );
    }
  }
}
