import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int calorieBase=0;
  int calorieAvecActivite=0;
 double poids=-1.0;
 int radioSelectionne=4;
 bool genre=false;
 double annee= -1.0;
 double taille=100.0;
 Map mapActivite ={
   0:"Faible",
   1:"Modere",
   2:"Forte"
 };
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (()=>FocusScope.of(context).requestFocus(FocusNode())),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: (genre) ? Colors.blue : Colors.pink,
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              padding(),
              texteAvecStyle("Remplissez tous les champs pour obtenir votre besoin journalier en calorie"),
              padding(),
              Card(
                elevation: 10.0,
                child: Column(
                  children: [
                    padding(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        texteAvecStyle("Femme",color: Colors.pink),
                        Switch(
                            value: genre,
                            inactiveTrackColor: Colors.pink,
                            activeTrackColor: Colors.blue,
                            onChanged: (bool b){
                              setState(() {
                                genre=b;
                              });
                            }),
                        texteAvecStyle("Homme",color: Colors.blue)
                      ],
                    ),
                    padding(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: (genre) ? Colors.blue : Colors.pink, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: (()=>montrerPicker()),
                      child: texteAvecStyle((annee==-1.0) ? "Appuyez pour entrer votre age" :"Votre age est de ${annee.toInt()}",
                      color: Colors.white
                      ),
                    ),
                    padding(),
                    texteAvecStyle("Votre taille est ${taille.toInt()} cm."),
                    padding(),
                    Slider(
                        value: taille,
                        onChanged: (double d){
                          setState(() {
                            taille=d;
                          });
                        },
                      max: 215.0,
                      min: 100.0,
                      activeColor: (genre) ? Colors.blue : Colors.pink,
                    ),
                    padding(),
                    TextField(
                      cursorColor: (genre) ? Colors.blue : Colors.pink,
                      keyboardType: TextInputType.number,
                      onChanged: (String string){
                        poids=double.tryParse(string)!;
                      },
                      decoration: InputDecoration(
                        labelText: "Entrez votre poids en kilos.",
                        focusColor: (genre) ? Colors.blue : Colors.pink,
                      ),
                    ),
                    padding(),
                    texteAvecStyle("Quelle est votre activité sportive ?",color: (genre) ? Colors.blue : Colors.pink),
                    padding(),
                    rowRadio(),
                    padding(),
                  ],
                ),
              ),
              padding(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: (genre) ? Colors.blue : Colors.pink, // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: (()=>calculerNombreDeCalorie()),
                child: texteAvecStyle("Calculer",color: Colors.white),
                ),
              padding(),
            ],
          ),
        ),
      ),
    );

  }
  Padding padding(){
    return Padding(padding: EdgeInsets.only(top: 20.0));
  }
  Future<Null> montrerPicker() async{
    DateTime? choix= await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1990),
        lastDate: DateTime.now()
        initialDatePickerMode: DatePickerMode.year,
    );
    if(choix !=null){
      var difference = DateTime.now().difference(choix);
      var jours =difference.inDays;
      var ans = (jours /365);
      setState(() {
        annee=ans;
      });
    }
  }

  Text texteAvecStyle(String data,{color:Colors.black, fontSize:15.0}){
    return Text(
      data,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color,
        fontSize: fontSize
      ),
    );
  }
  Row rowRadio(){
    List<Widget> l =[];
    mapActivite.forEach((key, value) {
      Column colonne = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Radio<int>(
              value: key,
              groupValue: radioSelectionne,
              activeColor:(genre) ? Colors.blue : Colors.pink,
              onChanged: (i) {
                setState(() {
                  radioSelectionne = key;
                });
              }),
          texteAvecStyle(value,color: (genre) ? Colors.blue : Colors.pink),
        ],
      );
      l.add(colonne);
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: l,
    );
  }
  void calculerNombreDeCalorie(){
    if(annee!=-1.0 && poids!=-1.0 && radioSelectionne != 4){
      //calculer
        if(genre){
          calorieBase=(66.4730 + (13.7516 * poids) + (5.0033*taille)-(6.7550 * annee)).toInt();
        }else{
          calorieBase=(66.0955 + (9.5634 * poids) + (1.8496 * taille) - (4.6756 * annee)).toInt();
        }
        switch(radioSelectionne){
          case 0:
            calorieAvecActivite=(calorieBase*1.2).toInt();
            break;
          case 1:
            calorieAvecActivite=(calorieBase*1.2).toInt();
            break;
          case 2:
            calorieAvecActivite=(calorieBase*1.2).toInt();
            break;
          default:
            calorieAvecActivite=calorieBase;
            break;
        }
      setState(() {
        dialogue();
      });
    }else{
      //Alerte pas tout les champs
      alerte();

    }
  }

  Future<Null> dialogue() async{
    return showDialog(
      barrierDismissible: false,
        context: context,
        builder: (BuildContext buildecontext){
          return SimpleDialog(
            title: texteAvecStyle("Votre besoin en calories",color:(genre) ? Colors.blue : Colors.pink ),
            contentPadding: EdgeInsets.all(15.0),
            children: [
              padding(),
              texteAvecStyle("Votre besoin de base est de: $calorieBase"),
              padding(),
              texteAvecStyle("Votre besoin avec activité sportive est de: $calorieAvecActivite"),
              padding(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: (genre) ? Colors.blue : Colors.pink, // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: (){
                  Navigator.pop(buildecontext);
                },
                child: texteAvecStyle("OK",color: Colors.white),
              ),
            ],
          );
        }
    );
  }

  Future<Null> alerte() async{
    return showDialog(
        context: context,
        builder: (BuildContext buildcontext){
          return AlertDialog(
            title: texteAvecStyle("Erreur"),
            content: texteAvecStyle("Tous les champs ne sont pas remplis"),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,//(genre) ? Colors.blue : Colors.pink, // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: (){
                  Navigator.pop(buildcontext);
                },
                child: texteAvecStyle("OK",color: Colors.red),
              ),
            ],
          );
        }
    );
  }
}
