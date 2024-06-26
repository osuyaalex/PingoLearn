import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pune_india_app/Network/network.dart';
import 'package:pune_india_app/auth/sign_up.dart';
import 'package:pune_india_app/elevated_button.dart';
import 'package:pune_india_app/home/home.dart';
import 'package:pune_india_app/providers/text_field_providers.dart';
import 'package:pune_india_app/utilities/snackbar.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _obscureText = true;
  bool _isLoading  = false;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var detailsProvider = Provider.of<SignInDetailsProvider>(context, listen: false);
    if(detailsProvider.email.isNotEmpty){
      setState(() {
        _email.text = detailsProvider.email;
        _password.text = detailsProvider.password;
      });
    }
    return Form(
      key: _key,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('e-Shop'),
          titleTextStyle: const TextStyle(
              color: Color(0xff467dce),
              fontSize: 23,
              fontWeight: FontWeight.w500
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.2,),
              SizedBox(
                height: MediaQuery.of(context).size.width*0.12,
                child: TextFormField(
                  controller: _email,
                  validator: (v){
                    if(v!.isEmpty){
                      return 'Field must not be empty';
                    }
                    return null;
                  },
                  decoration:  InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: const TextStyle(fontSize: 0.01),
                    hintStyle: const TextStyle(
                        fontSize: 12.5,
                        height: 6,
                        color: Colors.black
                    ),
                    hintText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:  const BorderSide(
                            color: Colors.transparent
                        )
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:  const BorderSide(
                            color:  Color(0xff467dce)
                        )
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:  const BorderSide(
                            color: Colors.transparent
                        )
                    ),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: Colors.grey.shade400
                        )
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                height: MediaQuery.of(context).size.width*0.12,
                child: TextFormField(
                  obscureText: _obscureText,
                  controller: _password,
                  validator: (v){
                    if(v!.isEmpty){
                      return 'Field must not be empty';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        icon: _obscureText? Icon(Icons.visibility_outlined, color: Colors.grey.shade400,):Icon(Icons.visibility_off_outlined,color: Colors.grey.shade400,)
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: const TextStyle(fontSize: 0.01),
                    hintStyle: const TextStyle(
                        fontSize: 12.5,
                        height: 6,
                        color: Colors.black
                    ),
                    hintText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:  const BorderSide(
                            color: Colors.transparent
                        )
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:  const BorderSide(
                            color:  Color(0xff467dce)
                        )
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:  const BorderSide(
                            color: Colors.transparent
                        )
                    ),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: Colors.grey.shade400
                        )
                    ),
                  ),
                ),
              ),
              Expanded(child: Container()),
              Button(
                  buttonColor: const Color(0xff467dce),
                  text: 'Log In',
                  onPressed: (){
                    if(_key.currentState!.validate()){
                      setState(() {
                        _isLoading = true;
                        detailsProvider.email = _email.text;
                        detailsProvider.password = _password.text;
                      });
                      Network().signInUsersWithEmailAndPassword(
                          _email.text,
                          _password.text).then((v){
                        if(v == 'login Successful'){
                          setState(() {
                            _isLoading = false;
                          });
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                            return const Home();
                          }));
                        }else{
                          setState(() {
                            _isLoading = false;
                          });
                          snack(context, v!);
                        }
                      });
                    }
                  },
                  textColor: Colors.white,
                  width: MediaQuery.of(context).size.width*0.6,
                  height: MediaQuery.of(context).size.width*0.12,
                  minSize: false,
                  textOrIndicator: _isLoading
              ),
              const SizedBox(height: 12,),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: 'Don\'t have an account? ',
                    style: const TextStyle(
                        height: 1.5,
                        color: Colors.black54,
                        fontWeight: FontWeight.w400,
                        fontSize: 13
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Signup',
                          style: const TextStyle(
                            color: Color(0xff467dce),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return const SignUpPage();
                              }));
                            }
                      ),
                    ]
                ),

              ),
              const SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}
