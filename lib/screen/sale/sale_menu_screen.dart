import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_system/constans/constan.dart';
import 'package:pos_system/screen/home/home_screen.dart';
import '../../controller/sale_controller.dart';
import 'widgets/menu_item_widget.dart';
import 'widgets/sale_buttom_action_widget.dart';
import 'widgets/sale_item_note_widget.dart';
import 'widgets/sale_product_widget.dart';

class SaleMenuScreen extends StatelessWidget {
  const SaleMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SaleController());

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(onPressed: (){Get.to(HomeScreen());}, icon: Icon(Icons.home,size: 25,color: Colors.white,)),
                        Text('ePOS',style: TextStyle(color: Colors.white),),
                        SizedBox(width: 10),
                        Text('T04',style: TextStyle(color: Colors.white),),

                        

                      ],
                    ),
                    Container(
                      height: 40,
                      width: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(fontStyle: FontStyle.italic,color: Colors.grey.shade400),
                          border: InputBorder.none,
                        ),),
                      )
                    ),
                    Text('23/05/2024   10 : 11 PM',style: TextStyle(color: Colors.white),),
                
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 12 ,
            child: Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: List.generate(
                                  5,
                                  (index) => const SaleItemNoteWidget(
                                    label: 'Khmer food',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 15,
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/bg_image.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 9,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 5),
                                      Wrap(
                                        children: List.generate(
                                          100,
                                          (index) => Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: SaleProductWidget(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          Container(
                            height: 45,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                           Container(
                                        width: 100,
                                        decoration: BoxDecoration(
                                        color: Colors.white,  
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.arrow_back,size: 20,),
                                              SizedBox(width: 3),
                                              Text('Go back'),
                                            ],
                                          ),
                                        ),
                                      ),
                                      
                                      
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: 100,
                                        decoration: BoxDecoration(
                                        color: Colors.red,  
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Center(
                                          child: Text('Cancel',style: TextStyle(color: Colors.white),),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                         Container(
                                        width: 100,
                                        decoration: BoxDecoration(
                                        color: Colors.green,  
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Center(
                                          child: Text('Hold bill',style: TextStyle(color: Colors.white),),
                                        ),
                                      ),
                                      SizedBox(width: 10),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(height: 40,),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0,right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Table # :',style: TextStyle(fontWeight: FontWeight.bold),),
                              Text(' T03'),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),

                    Column(
                    children: List.generate(3 , (index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.red),
                          ),
                        ),
                      );
                    }
                    ),
                  ),
                  Container()

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
