class ProductValidator{

  String validateImage(List images){


    if (images.isEmpty) return "Adicione imagens!";

    return null;

  }


  String validateTitle(String txt){

    if(txt.isEmpty) return "Preencha o titulo do produto ";

    return null;


  }

  String validateDescription(String txt){

    if(txt.isEmpty) return "Preencha a descrição do produto ";

    return null;


  }

  String validatePrice(String txt){

    double price = double.tryParse(txt);

    if (price ==  null ) return "Preço invalido!";


    if(!txt.contains(".") || txt.split(".")[1].length != 2) return "Utilize duas casas decimais";


    return null;


  }








}