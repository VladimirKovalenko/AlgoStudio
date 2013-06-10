<metadata>
360adae5dda5cba6711d58781a6c412466147201f69f9cf3254b6e53d7f516272e00172723019bbba7c2fa94b8dbf59af2967e17315f395e1e23bf9d7702f387c3a59db0635bc5e73d02c9f7734feb86016e2e4acfbae38fc3a64d6df284b3d6c2b0adde026b751ae886b38ec0e2447527093b0b2d0f38062418600e60011b769bfe26180c4eec999af6620e56253b07f9d6147a2d4c1578bcd9754bcef25d29e891f888c9ac7d43783188e664007f16aecd84e5a9dd99f69ae87549426d146031483444f590b08e231f86eabfdecca2deb9166322436b0c2742546ad69bedbc5b17d1e54874a08f0d61ddbc2a447f186d185637accb7411112f122e7f1ef98c780c83eb402fe69484ba25647c09d2a6c0a86609fb89f1cd8da293f2a6d3166221494e21acde3c02e8d4bfdc92fde68b700016771b759ee7201e8ecd1c73e78a3545d4b590fe2c55063a29066102deb1b1dcbccc87e639574a334876487447240d620568abc66b0e204e681cc4b7112fd0ec8ca3f7942c4383ee4d20e287b7d9e0948efdb688d7eb91f2127d58283a436c1e442d43246f0780f4d6a56658ca896d022050fd84c7b56f060265543c5c28ddfd90cf4868a49641718dbdf7c297bb6545410ca7c240348decd68745308be43440e6839dee0121a5f6dfb05f3933473c4b6a0b3240f89dbb9b93d0bcd35d2fb1c1715fd1ed0c237615ff90a0d01960186a0e67a6c180e896e25023a59b467a4420ff9e0074e48139767c1a72313f4df39641203f4b0f66127d4b251e2041730138bc924372bf8db6983f0dffcf9eae8ab2b28e99b6ea8e8fee245006636827086e86c50e7c9efb3d5c2551d1b8c9a6432d9ea0b08c96f33d451969a5e124453347284d91af7f4f81b0230dd0e02312e0cef5c5feced7e752639da1715e2346c4bc5323b2f6d6b7d3a741242917d9e5a9d9abca2c5f84f7f780b4db1b692c4895ab4c706847d0a0fe9f6013057616618ce31b69482cab95bd81a0cf3643ff8b3242334642361c2236721329c19d52224436a7c81f7581e4cfac9ce8e291aef20c5cf486543ba5f1285addbcc1a5cca9d9aba7958ed26d3da2f6cc8026647c09ee87bfd3d0b45c39d6a41a46b6d4e881bcd278242e6ab0d5ff9de491d4b3a6fa9ed757395d3993faf79431504430ea85ed9fff8c2975e7db79560f605e2bc0b414641e6b295de6d80f3325572b4e7315d5b0cbb97b1e58363152aacf780b241adce0a5d70164dbbd23461a6811745937c1a24a2fa7997a17a1d09bf71f2b4e72d7f8c6b4157057315633a8daa3c6117f8ae94124744ae5d91e318bf95633a9cfe580285a9ffa137d99fa096c1e6dc5fbc9f54c255b356004d4bd55362544c3b7e28dd9ab733cec9c2a5eb0d98ae568066310c4e4a1d247226e1ef8997705c6a78ffbacc9a8955775a8fcdeac0277ee8b65474a74063a610dcda4afc1a5c093b3b1dff091214ce08581bcb7953d71cfa61a7496f34d6d2415ba986b4bbedd335c4c20e38c7a08cef382a0e0cd8db9d1e0073384b06c55dee8af9ff5d740603e4d5024661f2e42ee8b704d5d7fd9e94765785899ee68016d094a3e0a62ccf1d9fba796ffddd2ec2b1796b9a0cc7a137f11b2d7546a6e52230c2940e9876307f29bf1927e1f84f017787a081d527e0ed4a0c8a1cda2f49ac3b0f2cc93af8ea1a2cfd2bd3d592752acc08fea764891b7940e001544eec1280f3d3dac88ba
</metadata>
//+------------------------------------------------------------------+
//|                                                        Bulls.mq4 |
//|                      Copyright _ 2005, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright _ 2005, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Silver
//---- input parameters
extern int BullsPeriod=13;
//---- buffers
double BullsBuffer[];
double TempBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- 1 additional buffer used for counting.
   IndicatorBuffers(2);
   IndicatorDigits(Digits);
//---- indicator line
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(0,BullsBuffer);
   SetIndexBuffer(1,TempBuffer);
//---- name for DataWindow and indicator subwindow label
   short_name="Bulls("+BullsPeriod+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Bulls Power                                                      |
//+------------------------------------------------------------------+
int start()
  {
   int i,counted_bars=IndicatorCounted();
//----
   if(Bars<=BullsPeriod) return(0);
//----
   int limit=Bars-counted_bars;
   if(counted_bars>0) limit++;
   for(i=0; i<limit; i++)
      TempBuffer[i]=iMA(NULL,0,BullsPeriod,0,MODE_EMA,PRICE_CLOSE,i);
//----
   i=Bars-counted_bars-1;
   while(i>=0)
     {
      BullsBuffer[i]=High[i]-TempBuffer[i];
      i--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+