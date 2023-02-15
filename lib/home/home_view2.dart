import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView2 extends StatefulWidget {
  final double width;
  final double height;
  final double depth;

  HomeView2(this.width, this.height, this.depth);

  @override
  _HomeView2State createState() => _HomeView2State();
}

class Box {
  final double width;
  final double height;
  final double depth;
  final Color color;

  Box(this.width, this.height, this.depth, this.color);
}

class _HomeView2State extends State<HomeView2> {
  List<Box> boxes = [];
  List<Box> boxesIn = [];

  GlobalKey keyPalete = GlobalKey();

  void orderBoxes(){
    boxes.sort((a, b) => (b.width * b.height * b.depth ).compareTo(a.width * a.height * a.depth ));
  }
  void addBox(Box box) {
    boxes.add(Box(30,15,40, Colors.grey));
    boxes.add(Box(20,25,30, Colors.green));
    boxes.add(Box(24,35,35, Colors.blue));
    orderBoxes();


    // aqui será implementado o algoritmo de otimização para encontrar o melhor lugar para empilhar a caixa
  }
void addBoxIn(Box box) {
  // ordenamos as caixas pelo tamanho, do maior para o menor
  // boxes.sort((a, b) => (b.width + b.height + b.depth ).compareTo(a.width + a.height + a.depth ));

  // percorremos a lista de caixas
  // for (Box currentBox in boxesIn) {
  //   // procuramos o primeiro lugar vago no container que se encaixe perfeitamente
  //   for (int i = 0; i < freeSpaces.length; i++) {
  //     Tuple freeSpace = freeSpaces[i];
  //     if (freeSpace.width >= currentBox.width &&
  //         freeSpace.height >= currentBox.height &&
  //         freeSpace.depth >= currentBox.depth) {
  //       // encontramos uma posição que se encaixa perfeitamente
  //       // removemos a tupla da lista de espaços livres
  //       freeSpaces.removeAt(i);
  //
  //       // adicionamos duas novas tuplas para os espaços livres ao lado da caixa
  //       freeSpaces.add(Tuple(
  //           freeSpace.x + currentBox.width, freeSpace.y, freeSpace.z,
  //           freeSpace.width - currentBox.width, freeSpace.height,
  //           freeSpace.depth));
  //       freeSpaces.add(Tuple(
  //           freeSpace.x, freeSpace.y + currentBox.height, freeSpace.z,
  //           freeSpace.width, freeSpace.height - currentBox.height,
  //           freeSpace.depth));
  //
  //       // adicionamos a caixa ao container
  //       currentBox.x = freeSpace.x;
  //       currentBox.y = freeSpace.y;
  //       currentBox.z = freeSpace.z;
  //       break;
  //     }
  //   }
  //
  //   currentBox.x = 0;
  //   currentBox.y = 0;
  //   currentBox.z = boxes.last.z + boxes.last.depth;
  // }

  RenderBox b = keyPalete.currentContext!.findRenderObject() as RenderBox;
  Offset position = b.localToGlobal(Offset.zero); //this is global position
  double y = position.dy; //this is y - I think it's what you want

    boxesIn.add(box);
    boxes.remove(box);


    // aqui será implementado o algoritmo de otimização para encontrar o melhor lugar para empilhar a caixa
  }
void removeBoxIn(Box box) {

    int tm = boxesIn.length;
    boxesIn.remove(box);
    if(tm > boxesIn.length){
      boxes.add(box);
      orderBoxes();
    }


    // aqui será implementado o algoritmo de otimização para encontrar o melhor lugar para empilhar a caixa
  }


  @override
  void initState() {
    super.initState();
   addBox(Box(1,1,1,Colors.black));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 100,
            width: Get.width,
            child: Wrap(
              children: [
                for(var b in boxes)
                  Draggable<Box>(
                    data: b,
                    child: Container(
                      width: b.width,
                      height: b.height,
                      decoration: BoxDecoration(
                        color: b.color,
                      ),
                    ),
                    feedback: Container(
                      width: b.width,
                      height: b.height,
                      decoration: BoxDecoration(
                        color: b.color.withOpacity(.5),
                      ),
                    ),
                  )
              ],
            ),
          ),
          Center(
            child: Container(
              key: keyPalete,
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: DragTarget(
                  onAccept: (Box box) {
                    setState(() {
                      addBoxIn(box);
                    });
                  },
                  onLeave: (Box? box) {
                    setState(() {
                      removeBoxIn(box!);
                    });
                  },
                  builder: (context, List<Box?> rejectedData,  acceptedData) {
                    return Wrap(
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      runSpacing: 1,
                      children: boxesIn.map((box) {
                        return Transform(
                          transform: Matrix4.translationValues(box.width, box.height, box.depth),
                          child:  Draggable<Box>(
                            data: box,
                            child: Container(
                              padding: const EdgeInsets.all(1),
                              width: box.width,
                              height: box.height,
                              decoration: BoxDecoration(
                                color: box.color,
                              ),
                            ),
                            feedback: Container(
                              width: box.width,
                              height: box.height,
                              decoration: BoxDecoration(
                                color: box.color.withOpacity(.5),
                              ),
                            ),
                          )
                        );
                      }).toList(),
                    );
                  }
              ),
            )
          ),
        ],
      ),
    );
  }
}