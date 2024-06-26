import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pune_india_app/Network/network.dart';
import 'package:pune_india_app/auth/log_in.dart';
import 'package:pune_india_app/elevated_button.dart';
import 'package:pune_india_app/home/home.dart';
import 'package:pune_india_app/utilities/snackbar.dart';

import '../providers/text_field_providers.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _obscureText = true;
  bool _isLoading  = false;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var detailsProvider = Provider.of<SignInDetailsProvider>(context, listen: false);
    return Form(
      key: _key,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: const Text('e-Shop'),
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
                  controller: _fullName,
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
                    hintText: 'Name',
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
                  text: 'SIgn Up',
                  onPressed: (){
                    if(_key.currentState!.validate()){
                      setState(() {
                        _isLoading = true;
                        detailsProvider.email = _email.text;
                        detailsProvider.password = _password.text;
                      });
                      Network().signUpUsers(_fullName.text,
                          _email.text,
                          _password.text,
                          context).then((v){
                        setState(() {
                          _isLoading = false;
                        });
                            if(v == 'Account created successfully'){
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
                    text: 'Already have an account? ',
                    style: const TextStyle(
                        height: 1.5,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 13
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Login',
                          style: const TextStyle(
                            color: Color(0xff2455be),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return const LogInPage();
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
