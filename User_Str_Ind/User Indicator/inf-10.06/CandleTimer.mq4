<metadata>
1e22132c2f57771acea284a40670b8ddccbe2d5e462f600fe38db18c2c0e7746ecc24070694bd6f6f792bad454378ce394f087ee94fa6f0894a91331087d384c90f6537ea890cdefe5dac8f6b4883d50a7c86b0f32471a7610750d2da2d4117453217c0fb6df7619513f506d8cae7d4cdaf442720b298db395a906685534e08d85e0dce254176f0e95fb791d066aaecbb3e793fa402de683ff8dfcc0426dacc27819e88583e6a49a6c501763750cf989aacf7d43b3fa0668a9cdbad3c5a60160add9d6b9e694ae923a15b2c601787303c6a32a140d312f435e3f442ad9be413465040166fc991d23cc81c899703c487ce9d5a28d513dd6b74c22650289fc72133354a9cc97a9eed24a2bafdad8ac3a52620d90e2cbf5003c1d32a6c73f4ad0a4ec84a9c611635967063ae182b1de2d400c7c7918d5bbfe87b68883c08fe0cca166167c1d80ee0871bc80c5ea6b084629d5b837477716f39ddaa33e0075496e0d2d42f5985f323f5af09ee195abd8eed0d1ed476836557d12731e4924acc9254b750127541b252814bbd8b8d75424e099cfbd533acaad99f1186c3340a29c0e7caccddeae2b449deee28db9852d021c7f2b446e1efa836a18fd9493f4620ae7930e7df7c9a09c2a4eb8d940345134256a1274db98ee9c016486e791e50a63c3aca4cae6d87544566ff1dfe9d98abd547a635194a4fecf8bb96854240b6004a6c75b2f7c193b74c4a2e0a33f4dc4a1f8990d79b0d9157a9df3d6e8a19df297265ec9b991d52d4ccebad5b0a49a83b393a2250b1121cdfc1b355464497925155968af93fcd35134b5cd007084c06809097d533697a9c8f475053f5ebac9e291c4b3620d03719afe437d82be67486717f5941764a3d0e196ee812250086c0a34c2fea6c36a123e5f7b152468a9c882ec9ff8f2cc9ecef6846906f0a4dfad25442541ea8f3a48642893f21779f097dda82b4adbbcfa9f5468b09f4c29fe864d2ca7c9387495f42f412b4c5769407c394b2643e5836306c2b08aefadc373108beec5b6b28c685483f1620725432441f6844e2b066877143257f9c7045f694c9ece1745eea1feb9c290efae216cd2f78ad74e12acfc82e30d6e187384e5dfb8e386dfacecb0dcb16312b8d4a0940a24f5855033026f2915cde226544124e48286e344365336056b2e4d6f0a407e033f654ae694197cb8de6f0a2d5fb7d27f112645cbaefe8d94aa2a16c5ac543a9df9d9b01e7d5233295d513e24565b14f28299ed10796f0059374f3c5a7a186b1e7b5d2d117015671c7d2c58d1b4271a0426195f3f5ea3cf4033a3c65b79556b0a3697fb553cd4baaacff5d54e2061009ff21a7fc5f8d2f0c38f375ef49ab1d4e9c9724333115c7cc6a52a45d0bccfa088fa5e632f0dd1fceedfb385e8df8cbb4274340dffc90b3adcfe9fbfe99ad1a5740d036f1673c1fc7c5ef2c2ab89e6c6b3c4e08961059aeedcb4c6fbe7c5deef1d3fbb9bcdbe156caac740224f20006ca29f1f3d4e7cb081a3947d5ff4d47c0ac1a8186b066f5735bcd0dbbe7c4115378cd837454d383356a280d1ef3a0658772b47b1d894fa06633e00122ef3dc80e9214f6206345d4221274673075d321664fbb48afa32462049e38ce18f6d1e417f6559f586f792f38181e8acc998eb90ae70366504563ac9ba01644c7026090a79e88df6848ce5afca12611e20ccf0a2d07613a7d3f5a1fc85d9a9d9bcd4eaf2b6d6b90f7a680a1579ff9a665a2e01f6847f1ad9adbeea3841bbcb1376c0fe7f439df0adccc3bb4507c8a921536e1d7b39f495a3c0056e2a1418285a662a0514797918fb83420089e81466fc8f9fdd5332e0830a618eb08fb35134c0ae6405fe9cb8d4385dd293b7db650090e2780c1566625c96d083e2b4d898eb8eeb605c9db2cda81f7148292547197570159ddc0c6088edfa88f7833b489ca2556961048be5dabbb2d0533facc992d145280c7847350f76a799ca8cf594c7ab77042346aa962a0599fc640aa3c2e785d0bc4326fdbeed8047339eec0e77605effc3a7c29ff1aacb9efc711d7f1ae5acff91abdff28096f791f3b1d0a9dbb6880147d2b385e9324189ec7f438ba43a5f2f4101609cfec6aa1a7f0049f09e4e3a7200b4d5d0b2b4d5eb99f9c792aec9e6462b86e91672691ce589acc9af911240f5d9cb44fb4c40b1ff39bc247be9
</metadata>
//+------------------------------------------------------------------+
//|                                                  CandleTimer.mq4 |
//|                                                           raposo |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "raposo"
#property link      ""

#property indicator_chart_window

extern color color1 = Red;
extern int fontsize = 20;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init() {

   ObjectCreate("Timer",OBJ_LABEL,0,0,0);
   ObjectSet("Timer",OBJPROP_CORNER,3);
   ObjectSet("Timer",OBJPROP_COLOR,color1);
   ObjectSet("Timer",OBJPROP_FONTSIZE,fontsize);
   ObjectSet("Timer",OBJPROP_XDISTANCE,60);
   ObjectSet("Timer",OBJPROP_YDISTANCE,20);
  
   return(0);
}

int deinit() {
   ObjectDelete("Timer");

   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
  datetime opentime = iTime(NULL,0,0) + (Period() * 60);

//----
  ObjectSetText("Timer",TimeToStr(opentime - TimeCurrent(),TIME_SECONDS));   
//----
   return(0);
  }
//+------------------------------------------------------------------+