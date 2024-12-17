
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subcript/config/enviroment/enviroment.dart';
import 'package:subcript/data/register/repository/provider/register_provider.dart';
import 'package:subcript/ui/features/common/widgets/customAlertDialogInfo.dart';

class RegisterController extends GetxController {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController cifnifController = TextEditingController();
  TextEditingController nameUserController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController townController = TextEditingController();
  TextEditingController provinceController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController re_passwordController = TextEditingController();
  TextEditingController surnamesController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController usernameController = TextEditingController();


  register(BuildContext context,String nameCompany,String cifnifCompany,String emailCompany,String townCompany,String provinceCompany,String countryCompany) async {
    String email=emailCompany;
    String password=passwordController.text.trim();
    String companyName=nameCompany;
    String cifnif=cifnifCompany;
    String nameUser=nameUserController.text.trim();
    String telephone=telephoneController.text.trim();
    String town=townCompany;
    String province=provinceCompany;
    String country=countryCompany;
    String re_password=re_passwordController.text.trim();
    String surnames=surnamesController.text.trim();
    String pinCode=pinCodeController.text.trim();
    String code=codeController.text.trim();
    String username=usernameController.text.trim();


    Response responseApi= await RegisterProvider().register(email, password,companyName,cifnif,nameUser,telephone,town,province,country,re_password,surnames,pinCode,code,username);

    if(responseApi.body['data']!=null){

      showDialog(
        context: context,
        builder: (context) => CustomAlertDialogInfo(
          activeCancel: false,
          title: "Info",
          message:
          "Su petición de registro ha sido enviada con exito. Su cuenta sera creada en un plazo de 24-48 horas",
          onConfirm: () {
            Get.offNamedUntil('/', (route) => false);
          },
        ),
      );
      nameUserController.text="";
      passwordController.text="";
      telephoneController.text="";
      re_passwordController.text="";
      surnamesController.text="";
      pinCodeController.text="";
      codeController.text="";



      Get.toNamed('/dashboard');
    } else {
      Get.snackbar(' Error', 'Error al registrarse' ,
          backgroundColor: const Color(0xFFe5133d), colorText: Colors.white);
    }
  }




}
