import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scrap/services/provider.dart';
import 'package:scrap/widget/Arrow_back.dart';
import 'package:scrap/widget/Loading.dart';

class Servicedoc extends StatefulWidget {
  final bool regis;
  Servicedoc({this.regis = false});
  @override
  _ServicedocState createState() => _ServicedocState();
}

class _ServicedocState extends State<Servicedoc> {
  bool acp,loading = false;
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Container(
              padding: EdgeInsets.only(left: a.width / 20, right: a.width / 20),
              color: Colors.black,
              width: a.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ArrowBack(),
                  Text(
                    "ข้อกำหนดการใช้บริการ",
                    style:
                        TextStyle(color: Colors.white, fontSize: a.width / 20),
                  ),
                  Text("")
                ],
              ),
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                SizedBox(
                  width: a.width,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(a.width / 40),
                        child: Text(
                          "ข้อกำหนดและเงื่อนไขการใช้งานแอปพลิเคชันการเข้าถึงหรือใช้บริการแอปพลิเคชันหรือ SCRAP. (“แอปพลิเคชัน” หรือ “SCRAP.”) ภายใต้การควบคุมดูแลของ บริษัท บัวลอยเทค จำกัด (“บริษัทฯ”) (รวมถึงบริษัทสาขา บริษัทในเครือ กิจการที่บริษัทฯ เป็นหุ้นส่วน บริษัทย่อย ตัวแทน พนักงานเจ้าหน้าที่หรือผู้ที่ได้รับมอบอำนาจ รวมเรียกว่า “บริษัทฯ” “บัวลอยเทค” หรือ “เรา”) หมายถึง ท่านยอมรับข้อกำหนดและเงื่อนไขที่ปรากฏบนเว็บไซต์หรือแอปพลิเคชันว่ามีผลผูกพันตามกฎหมาย (“เงื่อนไข”) และท่านยังยอมรับนโยบายความเป็นส่วนตัวของเว็บไซต์หรือแอปพลิเคชันและยอมรับที่จะปฏิบัติตามกฎระเบียบอื่นๆ บนเว็บไซต์หรือแอปพลิเคชัน เช่น วิธีการใช้ วิธีปฏิบัติและขั้นตอน หรือเงื่อนไขสำหรับการเข้าถึงหรือการใช้บริการของเว็บไซต์หรือแอปพลิเคชัน\nข้อ 1 คำนิยาม\nภายในข้อกำหนดนี้\n(ก) “แอปพลิเคชัน” หมายความว่า แอปพลิเคชัน ชื่อว่า SCRAP. ซึ่งดำเนินการและให้บริการในลักษณะดังต่อไปนี้ ผู้ใช้บริการสามารถใช้ฟังก์ชั่นต่างๆได้แก่\n-การอ่านข้อความจากผู้ใช้งานรายอื่น \n-การส่งข้อความให้กับผู้ใช้งานรายอื่น \n-การเขียนข้อความไว้ ณ สถานที่ต่างๆ\n(ข) “เจ้าของแอพพลิเคชั่น” หมายความว่า บริษัท บัวลอยเทค จำกัด ทะเบียนนิติบุคคลเลขที่ 0905562005788 สำนักงานตั้งอยู่ที่ 41/234 ซอยชื่นจิต ถนนนิพัทธ์สงเคราะห์1 ตำบลหาดใหญ่ จังหวัดสงขลา\n(ค) “ผู้ใช้งาน” หมายความว่า ผู้เยี่ยมชม ผู้ใช้ สมาชิก ของแอปพลิเคชั่น หรือบุคคลอื่นใดที่เข้าถึงแอปพลิเคชั่น ไม่ว่าการเยี่ยมชม การใช้ การเป็นสมาชิก หรือการเข้าถึงนั้นจะกระทำด้วยวิธีใด ลักษณะวิธีใด ผ่านอุปกรณ์ใด ผ่านช่องทางใด และไม่ว่ามีค่าใช้จ่ายหรือไม่ก็ตาม\n(ง) “ข้อมูลส่วนบุคคล” หมายความว่า ข้อมูลใดๆ ก็ตามไม่ว่าของผู้ใช้งานหรือบุคคลอื่นใดที่สามารถใช้ในการระบุตัวตนของบุคคลบุคคลนั้นได้ ไม่ว่าทางตรงหรือทางอ้อม\n(จ) “เนื้อหา” หมายความว่า ข้อความ บทความ ความคิดเห็น บทวิเคราะห์ รูปภาพ สัญลักษณ์ เครื่องหมาย รูปภาพประดิษฐ์ ภาพถ่าย ภาพเคลื่อนไหว ภาพยนต์ เสียง สิ่งบันทึกเสียง การออกแบบ คำสั่ง ชุดคำสั่ง หรือการสื่อสารไม่ว่าลักษณะใดและวิธีใดๆในแอปพลิเคชัน และไม่ว่าเนื้อหานั้นจะมีการจำกัดการเข้าถึงหรือไม่ก็ตาม\nข้อ 2 การอนุญาตให้ใช้งานแอปพลิเคขันแอปพลิเคชัน SCRAP. เป็นผู้ให้บริการแพลตฟอร์มใน การอ่านข้อความจากผู้ใช้งานรายอื่น การส่งข้อความให้กับผู้ใช้งานรายอื่น และ การเขียนข้อความไว้ ณ สถานที่ต่างๆผู้ใช้งานสามารถอ่านข้อความจากผู้ใช้งานรายอื่น ส่งข้อความให้กับผู้ใช้งานรายอื่น และเขียนข้อความไว้ ณ สถานที่ต่างๆได้ โดยสามารถดาวน์โหลดและสมัครเข้าร่วมรายการโดยไม่มีค่าใช้จ่าย นอกจากนี้บริษัทฯ ขอเรียนแจ้งให้ท่านทราบว่าบริษัทแอปเปิล (Apple Inc.) และกูเกิ้ล (Google) ไม่ได้มีส่วนเกี่ยวข้องหรือเป็นผู้สนับสนุุนแต่อย่างใด หากเกิดปัญหาใดๆ ขึ้น ดุลพินิจของบริษัทฯ ถือเป็นที่สิ้นสุด โดยที่ท่านไม่สามารถโต้แย้งหรืออุทธรณ์ได้ บริษัทฯ ขอสงวนสิทธิในการเปลี่ยนแแปลงข้อตกลงในการให้บริการนี้ได้ตลอดเวลาโดยไม่ต้องแจ้งให้ท่านทราบล่วงหน้า\n\n\n\nข้อ 3 การใช้งานแอปพลิเคชัน\nในการใช้งานแอปพลิเคชันผู้ใช้งานจำเป็นต้องใช้งานแอปพลิเคชันบน\nMobile operating systems: Android Jelly Bean, v16, 4.1.x or newer, and iOS 8 or newer. \nMobile hardware: iOS devices (iPhone 4S or newer) and ARM Android devices.\nเป็นอย่างต่ำ\nข้อ 4 การสร้างบัญชีของท่าน \n\nในการใช้บริการท่านจะต้องลงทะเบียนชื่อบัญชีและตั้งรหัสผ่าน ให้รายละเอียดต่างๆ ที่เกี่ยวข้องกับตนเองที่ถูกต้อง สมบูรณ์ และตรงต่อความเป็นจริงผ่านการลงทะเบียนบนแอปพลิเคชัน (“บัญชีผู้ใช้”) และแก้ไขบัญชีผู้ใช้ให้ถูกต้องและตรงต่อความเป็นจริงในปัจจุบันอยู่เสมอ กรณีที่บริษัทฯ ตรวจสอบและพบว่าท่านให้ข้อมูลที่เป็นเท็จ บริษัทฯ ขอสงวนสิทธิที่จะระงับหรือเพิกถอนบัญชีหรือระงับการใช้บริการของท่านได้ทันที ซึ่งท่านต้องรับผิดชอบทุกการกระทำภายใต้การใช้บัญชีและรักษารหัสผ่านของท่าน หากพบว่ามีบุคคลอื่นใช้บัญชีของท่านโดยไม่ได้รับอนุญาตท่านต้องรายงานให้บริษัทฯ ทราบทันที ทั้งนี้ บริษัทฯ ขอสงวนสิทธิในการรับผิดชอบต่อบัญชีหรือรหัสผ่านของท่านกับบุคคลอื่น ในกรณีที่บริษัทฯ ได้ใช้ความเชี่ยวชาญและความระมัดระวังตามสมควรแล้ว หากเกิดการใช้บัญชีของท่านโดยไม่ได้รับอนุญาต อันเนื่องมาจากบุคคลอื่น บริษัทฯ มีสิทธิเพิกถอนหรือระงับการใช้บัญชีของท่าน จากการที่ท่านหรือบุคคลอื่นกระทำการละเมิดเงื่อนไขของบริษัท\nข้อ 5 ข้อจำกัดในการแสดงความคิดเห็น\nท่านตกลงที่จะไม่แสดงความคิดเห็นที่มีเนื้อหาดังต่อไปนี้ \n - เนื้อหาที่ภาษาหรือข้อความมีถ้อยคำหยาบคาย หรือใส่ความบุคคลอื่นในประการที่น่าจะทำให้บุคคลนั้นเสียชื่อเสียง ถูกดูหมิ่น หรือถูกเกลียดชัง หรือขัดต่อความสงบเรียบร้อยหรือศีลธรรมอันดีของประชาชนหรือสังคม \n - วิพากษ์วิจารณ์ จาบจ้วง หรือพาดพิงสถาบันมหากษัตริย์และราชวงศ์ รวมถึงสร้างความเสียหายต่อ ศาสนา หรือคำสอนของศาสนาใดๆ เนื้อหาอันอาจเป็นเหตุให้เกิดความขัดแย้งขึ้นในระหว่างสถาบันการศึกษาหรือสังคม \n - สื่อหรือบรรยายถึงการแสดงพฤติกรรมหรืออารมณ์ที่ชัดแจ้งเกี่ยวกับเพศ ซึ่งนำไปสู่การกระตุ้นทางเพศหรือยั่วยุกามารมณ์ไม่ว่าจะเป็นความหมายโดยตรงหรือโดยนัยเกินกว่าประชาชน หรือวิญญูชนทั่วไปจะรับได้ \n - เนื้อหาที่เกี่ยวกับสิ่งผิดกฎหมายหรือมีผลกระทบต่อความสงบเรียบร้อยและศีลธรรมอันดีของประชาชน ความมั่นคงของประเทศ\nข้อ 6 คำรับรองของผู้ใช้งาน \nผู้ใช้งานจะต้องไม่ดำเนินการใดๆ ที่เป็นการละเมิดสิทธิของผู้อื่น กฎหมาย หรือสัญญาหรือหน้าที่ตามกฎหมายที่ท่านมีต่อบุคคลใดๆ ไม่ละเมิดลิขสิทธิ์หรือละเมิดทรัพย์สินทางปัญญา และสิทธิต่างๆ ของบุคคลหรือนิติบุคคล ไม่ใช้แอปพลิเคชันโดยมีวัตถุประสงค์เพื่อผลประโยชน์ทางการค้าในนามส่วนตัวหรือในนามของบุคคลอื่น หากท่านกระทำหรือดำเนินการเพื่อประโยชน์ทางการค้าผ่านเว็บไซต์หรือแอปพลิเคชัน ท่านจะต้องรับผิดชอบแต่เพียงผู้เดียวต่อคู่ค้าในเรื่องการประชาสัมพันธ์ การซื้อหรือขายสินค้า การชำระเงิน การจัดส่งสินค้าหรือบริการ การรับประกันความเสียหายในสินค้าหรือบริการ ทั้งนี้ บริษัทฯ จะไม่รับผิดชอบต่อการกระทำใดๆ ของท่านที่เกิดจากการทำการค้าดังกล่าวในนามของตนเองหรือบุคคลอื่น ไม่คัดลอกและ/หรือเก็บรวบรวมข้อมูล ชื่อ ที่อยู่ อีเมล์ ผลงาน ภาพประกอบ เพลงประกอบของบุคคลอื่นที่ปรากฏอยู่บนเว็บไซต์หรือแอปพลิเคชัน ไม่กระทำการใดๆ เพื่อให้มีขึ้นซึ่งสื่อที่มีไวรัส หรือรหัสคอมพิวเตอร์ แฟ้มข้อมูลหรือโปรแกรมอื่นใดซึ่งออกแบบมาเพื่อทำลาย แทรกแซงหรือจำกัดการใช้งานตามปกติของบริการหรือเว็บไซต์หรือแอปพลิเคชัน (หรือส่วนหนึ่งส่วนใดของบริการ) หรือซอฟต์แวร์หรือฮาร์ดแวร์คอมพิวเตอร์ กระทำการหรือดำเนินการใดๆ ที่ไม่ชอบด้วยกฎหมายหรือผิดกฎหมาย ถอดรหัสโปรแกรมแบบย้อนกลับ, ถอด, แยก หรือพยายามที่จะค้นหารหัสหรือจะเข้าถึงแหล่งที่มาของพื้นฐานหรือขั้นตอนวิธีการโครงสร้างของบริการของบริษัทฯ ไม่ว่าจะทั้งหมดหรือบางส่วน\nข้อ 7 ข้อจำกัดความรับผิดของบริษัทฯ \n - บริษัทฯ ขอสงวนสิทธิในความรับผิดในกรณีที่ท่านเผยแพร่ เนื้อหา ภาษา ภาพ ข้อความหรือองค์ประกอบใดๆ ไม่ว่าทั้งหมดหรือบางส่วนที่มีลักษณะลามก อนาจาร หมิ่นประมาทบุคคลหรือสถาบัน ฯ ละเมิดลิขสิทธิ์ของบุคคลอื่นหรือขัดต่อกฎหมาย กฎระเบียบ หรือข้อบังคับที่บังคับใช้ รวมถึงมีผลกระทบต่อความสงบเรียบร้อยและศีลธรรมอันดีของประชาชน \n - บริษัทฯ ขอสงวนสิทธิไม่รับผิดชอบในการรับผิดชอบต่อเนื้อหาใดที่ท่านแสดงความคิดเห็น แนะนำ หรือวิจารณ์ที่เกี่ยวข้องกับการละเมิดสิทธิบุคคลอื่น ทั้งนี้ บริษัทฯ ขอสงวนสิทธิในการยกเลิกบัญชีของท่านโดยไม่ต้องแจ้งล่วงหน้า กรณีที่ท่านกระทำการใดๆ ที่เป็นการละเมิดลิขสิทธิ์ในช่องทางของบริษัทฯ รวมถึง กรณีที่บริษัทฯ ได้รับการแจ้งว่าความคิดเห็น แนะนำ หรือวิจารณ์ มีเนื้อหาหรือองค์ประกอบไม่ว่าทั้งหมดหรือบางส่วนเป็นการละเมิดสิทธิในทรัพย์สินทางปัญญาของบุคคลอื่น\n - บริษัทฯ ขอสงวนสิทธิในการรับประกันว่า การใช้บริการบนแอปพลิเคชันจะตรงตามความต้องการของท่าน จะไม่ถูกรบกวน หรือมีความรวดเร็ว ปลอดภัย หรือปราศจากความผิดพลาด ข้อมูลที่ได้จากการใช้บริการทางเว็บไซต์หรือแอปพลิเคชันจะถูกต้อง เชื่อถือได้ หรือบริการของแอปพลิเคชันจะเป็นไปตามความคาดหวังของท่าน การใช้บริการถือว่าอยู่ในดุลยพินิจของท่านและท่านเป็นผู้รับผิดชอบในความเสียหายที่อาจเกิดขึ้นทั้งหมด อันเนื่องมาจากการเข้าถึงผลงานนั้นๆ ไม่ว่าท่านจะได้รับคำแนะนำหรือข้อมูลจากบริษัทฯ ด้วยวาจาหรือเป็นลายลักษณ์อักษรหรือไม่ ถือว่าไม่มีการรับประกันใดๆ จากบริษัทฯ เกิดขึ้น \n - บริษัทฯ ขอสงวนสิทธิในการรับผิดชอบที่จะจัดหา ดูแล หรือรับผิดชอบการเชื่อมสัญญาณอินเตอร์เน็ตที่มีเสถียรภาพกับอุปกรณ์ของท่าน รวมถึงการที่ท่านไม่สามารถดาวน์โหลดผลงานหรือเนื้อหา ซึ่งท่านตกลงและรับผิดชอบต่อความเสียหายที่อาจเกิดขึ้นกับระบบของอุปกรณ์หรือข้อมูลสูญหายอันเนื่องมาจากการดาวน์โหลดผลงานหรือเนื้อหานั้นๆ โดยไม่จำกัดว่าท่านได้รับคำแนะนำหรือข้อมูลจากบริษัทฯ \n - ท่านตกลงและยอมรับว่าการให้บริการบนแอปพลิเคชัน บริษัทฯ มีมาตรการการป้องกันและระบบรักษาความปลอดภัยทางอิเล็กทรอนิกส์ตามมาตรฐานในการป้องกันละเมิดลิขสิทธิ์และป้องกันความเสียหาย บริษัทฯ ขอสงวนสิทธิไม่รับผิดชอบต่อการกระทำใดๆ อันเกิดจากระบบอินเตอร์เน็ต การเชื่อมต่อ อุปกรณ์ หรือบุคคลภายนอกที่อยู่นอกเหนือการควบคุมการดำเนินการของบริษัทฯ ในการเข้าถึงระบบโดยไม่ได้รับอนุญาต การสร้างความเสียหายแก่ข้อมูลหรือโปรแกรม การก่อกวนการทำงานของระบบคอมพิวเตอร์หรือเครือข่าย การเข้าถึงระบบหรือเครือข่ายโดยไม่ได้รับอนุญาต และการจารกรรมข้อมูล \n - หากท่านไม่ปฏิบัติตามระเบียบข้อบังคับการใช้บริการแอปพลิเคชัน บริษัทมีสิทธิเพิกถอนสมาชิกภาพ งดให้บริการ ลบข้อมูล ลบบัญชี หรือกระทำ การใดๆ ต่อข้อมูลและบัญชีของท่าน เพื่อเป็นการป้องกัน แจ้งเตือน ต่อสาธารณะได้โดยไม่ต้องบอกกล่าวล่วงหน้า และบริษัทฯ ไม่ต้องรับผิดชอบ ในความเสียหายใดๆ ทั้งสิ้น บริษัทฯ ขอสงวนสิทธิในการเปลี่ยนแปลงข้อกำหนดและเงื่อนไขการใช้บริการฉบับนี้เมื่อใดก็ได้ โดยไม่ต้องแจ้งผู้ใช้งานให้ทราบล่วงหน้า\nข้อ 8 การเรียกร้องค่าเสียหาย \nท่านยินยอมที่จะตรวจสอบ ดูแล จ่ายค่าชดเชย และไม่ทำความเดือดร้อนให้บริษัทฯ ตัวแทนของ บริษัทฯ หรือบุคคลอื่น จากการถูกเรียกร้องค่าเสียหาย ความสูญเสีย ค่าใช้จ่าย อาทิ ค่าทนายซึ่งเกิดจากการที่ท่านใช้บริการหรือเข้าร่วมกิจกรรมของบริษัทฯ หรือ การที่ท่านละเมิดเงื่อนไขแห่งสัญญานี้ หรือ การกระทำใดๆ ของบัญชีท่าน (เช่น การเพิกเฉยหรือการกระทำความผิด) โดยท่านหรือบุคคลอื่นที่สามารถเข้าใช้บริการหรือเข้าถึงบัญชีในชื่อบัญชีของท่าน\n\nข้อ 9 การดำเนินการเชื่อมโยงแอปพลิเคชัน \nการบริการนี้หรือบุคคลที่เกี่ยวข้องอาจมีลิงค์เพื่อเชื่อมโยงไปยังแอปพลิเคชันอื่นหรือแหล่งข้อมูลอื่นๆทางอินเทอร์เน็ต ที่บริษัทฯ ไม่มีอำนาจในการควบคุมแอปพลิเคชันและแหล่งข้อมูลนั้นๆ ท่านรับทราบและยินยอมว่า บริษัทฯ จะไม่รับผิดชอบต่อสิ่งที่เกิดขึ้นบนแอปพลิเคชันและแหล่งข้อมูลดังกล่าว และไม่รับรอง ไม่รับผิดชอบ หรือรับผิดต่อเนื้อหา การโฆษณา สินค้า บริการ หรือเนื้อหาอื่นๆ ที่ปรากฏบนแอปพลิเคชันหรือแหล่งข้อมูลนั้นใดๆ ทั้งสิ้น นอกจากนี้ท่านรับทราบและยินยอมว่า บริษัทฯ จะไม่รับผิดชอบหรือรับผิดต่อความเสียหายหรือความสูญเสียที่เกิดหรือถูกกล่าวหา อันเกิดจากหรือเกี่ยวข้องกับการใช้บริการ หรือการใช้เนื้อหา การโฆษณา สินค้า บริการ หรือเนื้อหาที่ปรากฏหรือผ่านมาจากแอปพลิเคชันหรือแหล่งข้อมูลนั้น\nข้อ 10 ทรัพย์สินทางปัญญาของบริษัทฯ \nเนื้อหาทั้งหมดที่มีในบริการของบริษัทฯ เช่น เนื้อหา ข้อความ กราฟิก โลโก้ ปุ่มไอคอน รูปภาพ และอื่นๆ โดยรวม อีกทั้งซอฟต์แวร์ที่ใช้ในแอปพลิเคชันล้วนเป็นทรัพย์สินของบริษัทฯ ซึ่งได้รับความคุ้มครองภายใต้กฎหมายไทยและกฎหมายสากลอย่างไม่จำกัดว่าด้วยลิขสิทธิ์และกฎหมายอื่นๆ ที่คุ้มครองทรัพย์สินทางปัญญาและสิทธิของบริษัทฯ ท่านตกลงที่จะไม่ละเมิดลิขสิทธิ์และปฏิบัติตามกฎหมายอื่นๆ ข้อมูลและข้อจำกัดที่มีอยู่ในเนื้อหาใดๆ ที่เข้าถึงได้ผ่านทางเว็บไซต์หรือแอปพลิเคชัน ท่านยินยอมที่จะคอยติดตามและปฏิบัติตามกฎหมายลิขสิทธิ์และกฎหมายอื่นๆ รวมถึงคำบรรยายหรือข้อบังคับอื่นๆ\nข้อ 11 การละเมิดลิขสิทธิ์ \nท่านรับรองว่าการแสดงความคิดเห็นของท่านมิได้ละเมิดลิขสิทธิ์ สิทธิตามกฎหมาย (รวมทั้งสิทธิความเป็นส่วนบุคคลและการเปิดเผยต่อสาธารณะ) ของบุคคลอื่น หรือระเบียบสังคมหรือกฎหมายต่างๆ ไม่ว่าทั้งหมดหรือบางส่วน หากปรากฏในภายหลังว่า เนื้อหาของการแสดงความคิดเห็นของท่านมีการละเมิดสิทธิดังกล่าว ไม่ว่าทั้งหมดหรือบางส่วน และมีการเรียกร้องค่าเสียหาย ท่านจะดำเนินการทั้งปวง เพื่อให้การกล่าวอ้างหรือการเรียกร้องดังกล่าวระงับสิ้นไปโดยเร็ว ท่านตกลงที่จะรับผิดและชดใช้ค่าเสียหายค่าใช้จ่ายต่างๆ รวมทั้งค่าฤชาธรรมเนียม และค่าทนายความให้แก่บริษัทฯ ทั้งหมด อันเนื่องจากผลแห่งการละเมิดลิขสิทธิ์หรือสิทธิอื่นใดดังกล่าว\nข้อ 12 สิทธิของบริษัทฯ \nบริษัทฯ ขอสงวนสิทธิยกเลิก ระงับ ลบเนื้อหาการแสดงความคิดเห็นหรือบัญชีของท่าน (“ยกเลิกบริการ”) โดยไม่ต้องแจ้งล่วงหน้าหากบริษัทฯ พบว่าท่านได้ละเมิดหรือการกระทำใดๆ ที่ขัดกับเงื่อนไขแห่งสัญญานี้ ในกรณีที่มีการยกเลิกบริการดังกล่าว บริษัทฯ อาจเพิกถอนการเข้าถึงบริการของท่านโดยไม่ต้องแจ้งให้ทราบ รวมถึงการแก้ไขหรือเปลี่ยนแปลงเงื่อนไขการใช้บริการของบริษัทฯ โดยไม่ต้องแจ้งล่วงหน้าให้ทราบทั้งนโยบายส่วนบุคคล กฎหมายที่ใช้บังคับ ข้อกำหนดตามกฎระเบียบหรือการรักษาความปลอดภัย การเปลี่ยนแปลงทางเทคนิคในบริการของบริษัทฯ บริษัทฯ สงวนสิทธิในการแจ้งการเปลี่ยนแปลงทั้งหมดและถือว่ามีผลบังคับใช้ทันที ดังนั้น โปรดตรวจสอบเงื่อนไขทุกครั้งที่ใช้บริการของบริษัทฯ กรณีท่านไม่ยอมรับเงื่อนไขที่เปลี่ยนแปลง ท่านจะไม่สามารถเข้าสู่ระบบการใช้บริการได้\nข้อ 13 ข้อมูลความเป็นส่วนตัว \nข้อมูลทั้งหมดที่ให้ไว้โดยท่านหรือที่เก็บรวบรวมโดยบริษัทฯ ในการเชื่อมต่อกับบริการจะเป็นไปตามนโยบายความเป็นส่วนตัวของบริษัทฯ บริษัทฯ อาจใช้ข้อมูลที่ได้รับหรือเก็บรวบรวมเกี่ยวกับการใช้งาน ระยะเวลาการใช้งาน ประเภทของผลงานภายใต้เงื่อนไขนโยบายความเป็นส่วนตัว โดยบริษัทฯ ใช้ข้อมูลดังกล่าวเพื่อวัตถุประสงค์ทางการตลาดหรือโฆษณาเหตุการณ์หรือบริการอื่นๆ ที่อาจเป็นที่สนใจของท่าน นอกจากนี้ข้อมูลที่ส่งหรือที่ท่านให้แก่บริษัทฯ ที่ประชาชนทั่วไปอาจสามารถเข้าถึงข้อมูลนั้นได้ ท่านควรรักษาข้อมูลเป็นอย่างดีเพื่อรักษาข้อมูลส่วนตัวหรือข้อมูลที่มีความสำคัญกับท่าน บริษัทฯ จะไม่รับผิดชอบรักษาข้อมูลใดๆ ดังกล่าวและจะไม่รับผิดชอบในการรักษาข้อมูลความเป็นส่วนตัวของจดหมายอิเล็กทรอนิกส์หรือข้อมูลอื่นๆ ที่ผ่านทางอินเตอร์เน็ตหรือเครือข่ายอื่นๆ ที่ท่านอาจจะใช้ บริษัทฯ ขอสงวนสิทธิในการควบคุมและรับผิดชอบต่อการกระทำของท่าน\nข้อ 14 เงื่อนไขอื่นๆ \n - การที่ท่านเข้าใช้หรือเข้าถึงเว็บไซต์ของบริษัทฯ ถือเป็นการยอมรับว่าจะปฏิบัติตามระเบียบข้อบังคับการใช้บริการเว็บไซด์ตามเงื่อนไขข้างต้นทุกประการ และจะมีผลผูกพันตามเงื่อนไขของบริษัทฯ ในความรับผิดต่อความเสียหายจากการใช้หรือเข้าถึงเว็บไซต์หรือแอปพลิเคชัน \n - ในกรณีที่ข้อความหรือส่วนใด ๆ ของเงื่อนไขนี้ไม่สมบูรณ์ ผิดกฎหมายหรือไม่อาจใช้บังคับได้ ให้ถือว่าข้อความส่วนนั้นๆ แยกออกจากส่วนที่เหลือของสัญญาฉบับนี้ โดยข้อความหรือส่วนนั้นๆ จะไม่มีผลกระทบต่อความสมบูรณ์ ความถูกต้องตามกฎหมาย หรือการใช้บังคับของส่วนที่เหลือของเงื่อนไขฉบับนี้\n - หากพบปัญหาต่างๆภายในระบบแอปพลิเคชันผู้ใช้งานสามารถติดต่อกับบริษัทได้ผ่านทางอีเมล SCRAPdev@bualoitech.com",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: a.width / 20),
                        ),
                      ),
                      widget.regis
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: Colors.black,
                                  ),
                                  child: Checkbox(
                                      value: acp ?? false,
                                      onChanged: (val) {
                                        setState(() {
                                          acp = val;
                                        });
                                      }),
                                ),
                                Text(
                                  'ฉันยอมรับตามข้อกำหนดการใช้บริการทั้งหมด',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: a.width / 20),
                                ),
                                SizedBox(
                                  width: a.width / 32,
                                )
                              ],
                            )
                          : SizedBox(),
                      widget.regis
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                  child: Container(
                                    margin: EdgeInsets.only(right: 32, bottom: 32),
                                    padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
                                    color: acp ?? false
                                        ? Colors.blue[200]
                                        : Colors.grey[350],
                                    child: Text(
                                      'เสร็จสิ้น',
                                      style: TextStyle(fontSize: a.width / 20),
                                    ),
                                  ),
                                  onTap: acp ?? false
                                      ? ()async {
                                         await accept();
                                        }
                                      : null))
                          : SizedBox()
                    ],
                  ),
                )
              ],
            ),
            loading ? Loading():SizedBox()
          ],
        ),
      ),
    );
  }

  accept() async {
    final uid = await Provider.of(context).auth.currentUser();
    setState(() {
      loading = true;
    });
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .updateData({'accept': true});
        setState(() {
          loading = false;
        });
  }
}