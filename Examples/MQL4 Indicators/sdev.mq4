<metadata>
d9e5625da7df305da9c5e7c70b7d0b6e295b1d6e3e57533ce688f3ce795ba392634dfaca8aa87454f89da8c68eeddeb11672deb72f4197f098a50123f481a1d5a9cf2c01526a7e5c447b0e30f8c4422f1679771356236a063356c5e57f09ed880c7ee99a0f66f09fe987a49971532f1e416f1e2ecbe9330dba86e28ca9c855388eebbf811f6ce387016488fe2a16321d68061978b7daec899da3dae62e5af28bddadd2b74f71430ad5bb84e0244d5536cdac384c83ec3f4d794599b6dca895ec3a4a8fea241aefd31579e0814a24187ff1842849fe996b0e80be84c92b7ac488e6d2625e705fa2ce7b1ad3bd1c7b7e0b52335235bcd926182e12a9c8a3d63a4ea7cf83ec4d3f89b78acbf0856511442cfd9282f0b9855e7126474a3f03778ae2bfd011634779dae63556b7d8bcd1fb8b0f6e600ee69f7a44e5a6630c006dcaba1372244a473eecd0a689a2c1d4bb214c3c4c5233553b50290638360aa1c29cf3d0bd9bf62346c3ad3b4f9cefc8f6c9f5341bd0b32748d0bd88e5a9ccea84f286f083f7c9c2fe9ffc6f00d5a520597c0ecfa64b2cf29a5723ee9d96a811520b643b4bd3aaf785c6afa3c4d6be1f6ba2820d52674787b5e4d44979c8fd4a665e7ee0add1b4d1a50f6e5a0bb0c59cf36317f99c4437260671223a55b5d32c580572006191e317721a3a0447bbd4b2c0b3c3705e477b86a9d4b780eff383ed94daa8adc47c1b1c7493e77003dde36458e084d7b61a6e7712c28ddeb80b485f2d187d8fee36421a73fb94e58b122c0537e1d8ddf3d1e02210a08e291b0b3b162621199ea2725d385c58392a5e0a6f206f1b7dc98a9eece782b9d8b5c15b32640b7b15704e172badc8d4ac6010bafe7c1dec9886e3a59bc3f31021fcd2f9c95968547a7747c8f8daea6b5ad7ebdcf37a1f067ea2d2b0f46b0ae99dcda8605e2a16b0c0b4d58af94c3f99ee1d720b796c089ca27c40edc22454a0c1087b3e4ddea9afc0f6846307ae90f4c82847daaf5d292a5a790c3d49e6d85e1acef4227e9feff785eb8458322f4ab4d7fd890b7854089ccc82f028474e1a5a28ff9e385c6702f785794b14484919f4a080cc0f4d0d784f26bcd080e487e25b29c39f8eecc5acaec08dd189cd583d2b497603b7d06b37420b90fea7c3bed79dfef5947400d4bbdcae35460f53f2ce84ab0b643a4fccb84737cdb8502439079fa3e795bbde4b2d6603e89a3d583b55accf7a1fcbb8bf81467a63116b0ec6a06c0907751c79ff91b3d04c290a348ce13a4b711d3501605cad8267156005e98fbbdebbc9f7921b754320f095edd35864143bd8aa8feae88ee98ca2d03154f49a3556c8addcafffc1033ffb925b351e7a096098fb81e091e5f79889fb9dd2caba6e1a4029cda2c1af0d7eb898f3801772d0a0751427554726493dc1a46855587a9cc817657306b6d347657d436c50274bfa93791771140323dab48ceda7ca5a3febd6123038740a63432dc6a33c1c8dbc0f2d1c3c4320452a503c600f4e3c86bb84a64b662d1c0533c2f5cafd6254ecd5eed867563e1c4666f784295dc4bddeb22c4928156c4e3d0d1230d0f03b4c4d242d493c48cda51528002214252d0fba84e6da7857177b274ebed0f2977749e4d8f5daf49de789b1d5ee87d7b45938bbcf117e1e6cafe05727cbbf472ee58adab46a19c8f6d4e883ac3a57442bd6b2c6b32b47f396b58b6f263ecb363f8dd1a39f066c1f1b725c
</metadata>
//+------------------------------------------------------------------+
//|                                           Standard Deviation.mq4 |
//|                      Copyright _ 2005, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright _ 2005, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"

#property indicator_separate_window
#property indicator_minimum 0
#property indicator_buffers 1
#property indicator_color1 Blue
//---- input parameters
extern int ExtStdDevPeriod=20;
extern int ExtStdDevMAMethod=0;
extern int ExtStdDevAppliedPrice=0;
extern int ExtStdDevShift=0;
//---- buffers
double ExtStdDevBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string sShortName;
//---- indicator buffer mapping
   SetIndexBuffer(0,ExtStdDevBuffer);
//---- indicator line
   SetIndexStyle(0,DRAW_LINE);
//---- line shifts when drawing
   SetIndexShift(0,ExtStdDevShift);   
//---- name for DataWindow and indicator subwindow label
   sShortName="StdDev("+ExtStdDevPeriod+")";
   IndicatorShortName(sShortName);
   SetIndexLabel(0,sShortName);
//---- first values aren't drawn
   SetIndexDrawBegin(0,ExtStdDevPeriod);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Standard Deviation                                               |
//+------------------------------------------------------------------+
int start()
  {
   int    i,j,nLimit,nCountedBars;
   double dAPrice,dAmount,dMovingAverage;  
//---- insufficient data
   if(Bars<=ExtStdDevPeriod) return(0);
//---- bars count that does not changed after last indicator launch.
   nCountedBars=IndicatorCounted();
//----Standard Deviation calculation
   i=Bars-ExtStdDevPeriod-1;
   if(nCountedBars>ExtStdDevPeriod) 
      i=Bars-nCountedBars;  
   
   while(i>=0)
     {
      dAmount=0.0;
      dMovingAverage=iMA(NULL,0,ExtStdDevPeriod,0,ExtStdDevMAMethod,ExtStdDevAppliedPrice,i);
      for(j=0; j<ExtStdDevPeriod; j++)
        {
         dAPrice=GetAppliedPrice(ExtStdDevAppliedPrice,i+j);
         dAmount+=(dAPrice-dMovingAverage)*(dAPrice-dMovingAverage);
        }
      ExtStdDevBuffer[i]=MathSqrt(dAmount/ExtStdDevPeriod);
      i--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetAppliedPrice(int nAppliedPrice, int nIndex)
  {
   double dPrice;
//----
   switch(nAppliedPrice)
     {
      case 0:  dPrice=Close[nIndex];                                  break;
      case 1:  dPrice=Open[nIndex];                                   break;
      case 2:  dPrice=High[nIndex];                                   break;
      case 3:  dPrice=Low[nIndex];                                    break;
      case 4:  dPrice=(High[nIndex]+Low[nIndex])/2.0;                 break;
      case 5:  dPrice=(High[nIndex]+Low[nIndex]+Close[nIndex])/3.0;   break;
      case 6:  dPrice=(High[nIndex]+Low[nIndex]+2*Close[nIndex])/4.0; break;
      default: dPrice=0.0;
     }
//----
   return(dPrice);
  }
//+------------------------------------------------------------------+