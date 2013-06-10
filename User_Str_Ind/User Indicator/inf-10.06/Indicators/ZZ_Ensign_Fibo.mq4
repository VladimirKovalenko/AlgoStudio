//+------------------------------------------------------------------+
//|                                                                  |
//|                 Copyright © 1999-2008, MetaQuotes Software Corp. |
//|                                         http://www.metaquotes.ru |
//+------------------------------------------------------------------+
#property copyright "nen"
#property link      "http://onix-trade.net/forum/index.php?s=&showtopic=118&view=findpost&p=69113"
//----
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Yellow
//---- indicator parameters
extern int minBars= 12;
extern int minSize=50;
//----
extern bool ExtFiboType=true;
extern bool ExtFiboDinamic=false;
extern bool ExtFiboStatic=false;
extern int ExtFiboStaticNum=2;
extern color ExtFiboS=Teal;
extern color ExtFiboD=Sienna;
// Переменные для вил Эндрюса
extern int ExtPitchfork=0;
extern color ExtLinePitchfork=MediumBlue;
//-------------------------------------
// Массивы для ZigZag 
// Массив для отрисовки ZigZag
double zz[];
// Массив минимумов ZigZag
double zzL[];
// Массив максимумов ZigZag
double zzH[];
// Матрица для поиска исчезнувших баров afr - массив значений времени пяти последних фракталов и отрисовки динамических и статических фиб
// afrl - минимумы, afrh - максимумы
int afr[]={0,0,0,0,0,0,0,0,0,0};
double afrl[]={0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0}, afrh[]={0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0};
int cPoint=0,numOb;
bool afrm;
string nameObj;
// Переменные индикатора ZigZag подобного встроенному в Ensign
double si,di,lLast=0,hLast=0;
int fs,countBar;
int ai,bi,ai0,bi0;
datetime tai,tbi,ti;
bool fh=false,fl=false,fcount0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(3);
//---- drawing settings
   // ZigZag
   SetIndexStyle(0,DRAW_SECTION);
   SetIndexBuffer(0,zz);
   SetIndexEmptyValue(0,0.0);
   SetIndexBuffer(1,zzL);
   SetIndexBuffer(2,zzH);
   if (minSize!=0) {di=minSize*Point; countBar=minBars;}
   if (ExtFiboDinamic || ExtFiboStatic)
     {
      if (Point*10==1) cPoint=1;
      else if (Point*100==1) cPoint=2;
         else if (Point*1000==1) cPoint=3;
            else if (Point*10000==1) cPoint=4;
               else if (Point*100000==1) cPoint=5;
     }
   if (ExtFiboStaticNum<2) ExtFiboStaticNum=2;
   if (ExtFiboStaticNum>9) ExtFiboStaticNum=9;
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Деинициализация. Удаление всех трендовых линий и текстовых объектов
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectDelete("fiboS1");ObjectDelete("fiboD1");ObjectDelete("pitchfork1");ObjectDelete("pmediana1");
   return(0);
  }
//********************************************************
// НАЧАЛО
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int i,n,cbi;
   cbi=Bars-IndicatorCounted()-1;
//---------------------------------
   for(i=cbi; i>=0; i--)
     {
      //-------------------------------------------------
      // Устанавливаем начальные значения минимума и максимума бара
      if (lLast==0) {lLast=Low[i];hLast=High[i];
     }
      // Определяем направление тренда до первой точки смены тренда.
      // Или до точки начала первого луча за левым краем.
      if (fs==0)
        {
         if (lLast<Low[i] && hLast<High[i]) {fs=1; hLast=High[i]; si=High[i]; ai=i; tai=Time[i];}  // тренд восходящий
         if (lLast>Low[i] && hLast>High[i]) {fs=2; lLast=Low[i]; si=Low[i]; bi=i; tbi=Time[i];}  // тренд нисходящий
        }
      if (ti!=Time[i])
        {
         // запоминаем значение направления тренда fs на предыдущем баре
         ti=Time[i];
         ai0=iBarShift(Symbol(),Period(),tai);
         bi0=iBarShift(Symbol(),Period(),tbi);
         fcount0=false;
         if ((fh || fl) && countBar>0) {countBar--; if (i==0 && countBar==0) fcount0=true;
        }
         // Остановка. Определение дальнейшего направления тренда.
         if (fs==1)
           {
            if (hLast>High[i] && !fh) fh=true;
            if (i==0)
              {
               if (Close[i+1]<lLast && fh) {fs=2; afrm=true; countBar=minBars; fh=false;}
               if (countBar==0 && si-di>Low[i+1] && High[i+1]<hLast && ai0>i+1 && fh && !fcount0) {fs=2; countBar=minBars; fh=false;
              }
               if (fs==2) // Тредн сменился с восходящего на нисходящий на предыдущем баре
                 {
                  zz[ai0]=High[ai0];
                  zzH[ai0]=High[ai0];
                  lLast=Low[i+1];
                  si=Low[i+1];
                  bi=i+1;
                  tbi=Time[i+1];
                 }
              }
            else
              {
               if (Close[i]<lLast && fh) {fs=2; afrm=true; countBar=minBars; fh=false;
               }
               if (countBar==0 && si-di>Low[i] && High[i]<hLast && fh) {fs=2; countBar=minBars; fh=false;
               }
               if (fs==2) // Тредн сменился с восходящего на нисходящий
                 {
                  zz[ai]=High[ai];
                  zzH[ai]=High[ai];
                  lLast=Low[i];
                  si=Low[i];
                  bi=i;
                  tbi=Time[i];
                 }
              }
           }
         else // fs==2
           {
            if (lLast<Low[i] && !fl) fl=true;
            if (i==0)
              {
               if (Close[i+1]>hLast && fl) {fs=1; afrm=true; countBar=minBars; fl=false;
              }
               if (countBar==0 && si+di<High[i+1] && Low[i+1]>lLast && bi0>i+1 && fl && !fcount0) {fs=1; countBar=minBars; fl=false;
              }
               if (fs==1) // Тредн сменился с нисходящего на восходящий на предыдущем баре
                 {
                  zzL[bi0]=Low[bi0];
                  zz[bi0]=Low[bi0];
                  hLast=High[i+1];
                  si=High[i+1];
                  ai=i+1;
                  tai=Time[i+1];
                 }
              }
            else
              {
               if (Close[i]>hLast && fl) {fs=1; afrm=true; countBar=minBars; fl=false;
              }
               if (countBar==0 && si+di<High[i] && Low[i]>lLast && fl) {fs=1; countBar=minBars; fl=false;
              }
               if (fs==1) // Тредн сменился с нисходящего на восходящий
                 {
                  zz[bi]=Low[bi];
                  zzL[bi]=Low[bi];
                  hLast=High[i];
                  si=High[i];
                  ai=i;
                  tai=Time[i];
                 }
              }
           }
        }
      // Продолжение тренда
      if (fs==1 && High[i]>si) {ai=i; tai=Time[i]; afrm=true; hLast=High[i]; si=High[i]; countBar=minBars; fh=false;
      }
      if (fs==2 && Low[i]<si) {bi=i; tbi=Time[i]; afrm=true; lLast=Low[i]; si=Low[i]; countBar=minBars; fl=false;
      }
      //===================================================================================================
      // Нулевой бар. Расчет первого луча ZigZag-a
      if (i==0)
        {
         ai0=iBarShift(Symbol(),Period(),tai);
         bi0=iBarShift(Symbol(),Period(),tbi);
//----
         if (fs==1) {for(n=bi0-1; n>=0; n--) {zzH[n]=0; zz[n]=0;} zz[ai0]=High[ai0]; zzH[ai0]=High[ai0]; zzL[ai0]=0;
        }
         if (fs==2) {for(n=ai0-1; n>=0; n--) {zzL[n]=0; zz[n]=0;} zz[bi0]=Low[bi0]; zzL[bi0]=Low[bi0]; zzH[bi0]=0;
        }
         //         if (fs==1) { for (n=bi0-1; n>0; n--) {zz[n]=0;} zz[ai0]=High[ai0];}         
         //         if (fs==2) {for (n=ai0-1; n>0; n--) {zz[n]=0;} zz[bi0]=Low[bi0];}
        }
      //====================================================================================================
     }
   matriza();
  }
//--------------------------------------------------------
// Формирование матрицы. Начало.
// Матрица используется для поиска исчезнувших фракталов.
// Это инструмент компенсации непредвиденных закидонов стандартного ZigZag-a.
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void matriza()
  {
   if (afrm && (ExtFiboStatic || ExtFiboDinamic || ExtPitchfork>0))
     {
      int shift,k,k1;
      double ab2,ac2,bc2;
      datetime tab2,tac2,tbc2;
      k=0;
      for(shift=0; shift<Bars && k<10; shift++)
        {
         if (zz[shift]>0)
           {
            afr[k]=Time[shift];
            if (zz[shift]==zzL[shift]) {afrl[k]=Low[shift]; afrh[k]=0.0;}
            if (zz[shift]==zzH[shift]) {afrh[k]=High[shift]; afrl[k]=0.0;}
            k++;
           }
        }
      afrm=false;
      // Вывод статических и динамических фиб.
      if (ExtFiboStatic)
        {
         ExtFiboStatic=false;
         screenFiboS();
        }
      if (ExtFiboDinamic)
        {
         screenFiboD();
        }
      if (ExtPitchfork>0)
        {
         //         nameObj="pf" + Period() + "_" + afr[3];
         nameObj="pitchfork1";
         numOb=ObjectFind(nameObj);
         if (numOb>-1) ObjectDelete(nameObj);
         if (afrl[3]>0)
           {
            ObjectCreate(nameObj,OBJ_PITCHFORK,0,afr[3],afrl[3],afr[2],afrh[2],afr[1],afrl[1]);
           }
         else
           {
            ObjectCreate(nameObj,OBJ_PITCHFORK,0,afr[3],afrh[3],afr[2],afrl[2],afr[1],afrh[1]);
           }
         ObjectSet(nameObj,OBJPROP_STYLE,STYLE_SOLID);
         ObjectSet(nameObj,OBJPROP_COLOR,ExtLinePitchfork);
//----
         if (ExtPitchfork==2)
           {
            k1=MathCeil((iBarShift(Symbol(),Period(),afr[3])+iBarShift(Symbol(),Period(),afr[2]))/2);
            tab2=Time[k1];
            k1=MathCeil((iBarShift(Symbol(),Period(),afr[2])+iBarShift(Symbol(),Period(),afr[1]))/2);
            tbc2=Time[k1];
            k1=MathCeil((iBarShift(Symbol(),Period(),afr[3])+iBarShift(Symbol(),Period(),afr[1]))/2);
            tac2=Time[k1];
            //            nameObj="pm" + Period() + "_" + afr[3];
            nameObj="pmediana1";
            numOb=ObjectFind(nameObj);
            if (numOb>-1) ObjectDelete(nameObj);
            if (afrl[3]>0)
              {
               ObjectCreate(nameObj,OBJ_TREND,0,tab2,(afrl[3]+afrh[2])/2,tbc2,(afrh[2]+afrl[1])/2);
              }
            else
              {
               ObjectCreate(nameObj,OBJ_TREND,0,tab2,(afrh[3]+afrl[2])/2,tbc2,(afrl[2]+afrh[1])/2);
              }
            ObjectSet(nameObj,OBJPROP_STYLE,STYLE_DASH);
            ObjectSet(nameObj,OBJPROP_COLOR,ExtLinePitchfork);
           }
        }
     }
   return ;
  }
//--------------------------------------------------------
// Формирование матрицы. Конец.
//--------------------------------------------------------

//--------------------------------------------------------
// Вывод фиб статических. Начало.
//--------------------------------------------------------
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void screenFiboS()
  {
   double fibo_0, fibo_100, fiboPrice, fiboPrice1;
//----
   nameObj="fiboS1";
   numOb=ObjectFind(nameObj);
   if (numOb>-1) ObjectDelete(nameObj);
   if (afrl[ExtFiboStaticNum-1]>0)
     {
      fibo_0=afrh[ExtFiboStaticNum];fibo_100=afrl[ExtFiboStaticNum-1];
      fiboPrice=afrh[ExtFiboStaticNum]-afrl[ExtFiboStaticNum-1];fiboPrice1=afrl[ExtFiboStaticNum-1];
     }
   else
     {
      fibo_0=afrl[ExtFiboStaticNum];fibo_100=afrh[ExtFiboStaticNum-1];
      fiboPrice=afrl[ExtFiboStaticNum]-afrh[ExtFiboStaticNum-1];fiboPrice1=afrh[ExtFiboStaticNum-1];
     }
   ObjectCreate(nameObj,OBJ_FIBO,0,afr[2],fibo_0,afr[1],fibo_100);
   ObjectSet(nameObj,OBJPROP_LEVELSTYLE,STYLE_DOT);
   ObjectSet(nameObj,OBJPROP_LEVELCOLOR,ExtFiboS);
//----
   if (ExtFiboType)
     {
      ObjectSet(nameObj,OBJPROP_FIBOLEVELS,18);
      fibo_patterns(fiboPrice, fiboPrice1);
     }
   else
     {
      ObjectSet(nameObj,OBJPROP_FIBOLEVELS,11);
      fibo_standart (fiboPrice, fiboPrice1);
     }
//----     
   return ;
  }
//--------------------------------------------------------
// Вывод фиб статических. Конец.
//--------------------------------------------------------

//--------------------------------------------------------
// Вывод фиб динамических. Начало.
//--------------------------------------------------------
void screenFiboD()
  {
   double fibo_0, fibo_100, fiboPrice, fiboPrice1;
//----
   nameObj="fiboD1";
   numOb=ObjectFind(nameObj);
   if (numOb>-1) ObjectDelete(nameObj);
   if (afrh[1]>0) {fibo_0=afrh[1];fibo_100=afrl[0];fiboPrice=afrh[1]-afrl[0];fiboPrice1=afrl[0];}
   else {fibo_0=afrl[1];fibo_100=afrh[0];fiboPrice=afrl[1]-afrh[0];fiboPrice1=afrh[0];}
//----
   ObjectCreate(nameObj,OBJ_FIBO,0,afr[2],fibo_0,afr[1],fibo_100);
   ObjectSet(nameObj,OBJPROP_LEVELSTYLE,STYLE_DOT);
   ObjectSet(nameObj,OBJPROP_LEVELCOLOR,ExtFiboD);
   if (ExtFiboType)
     {
      ObjectSet(nameObj,OBJPROP_FIBOLEVELS,18);
      fibo_patterns(fiboPrice, fiboPrice1);
     }
   else
     {
      ObjectSet(nameObj,OBJPROP_FIBOLEVELS,14);
      fibo_standart (fiboPrice, fiboPrice1);
     }
//----
   return ;
  }
//--------------------------------------------------------
// Вывод фиб динамических. Конец.
//--------------------------------------------------------

//--------------------------------------------------------
// Фибы с паттернами. Начало.
//--------------------------------------------------------
void fibo_patterns(double fiboPrice,double fiboPrice1)
  {
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL,0);
   ObjectSetFiboDescription(nameObj, 0, "0  -->  "+DoubleToStr(fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+1,0.382);
   ObjectSetFiboDescription(nameObj, 1, "38.2  -->  "+DoubleToStr(fiboPrice*0.382+fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+2,0.5);
   ObjectSetFiboDescription(nameObj, 2, "50.0  -->  "+DoubleToStr(fiboPrice*0.5+fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+3,0.618);
   ObjectSetFiboDescription(nameObj, 3, "61.8  -->  "+DoubleToStr(fiboPrice*0.618+fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+4,0.707);
   ObjectSetFiboDescription(nameObj, 4, "70.7  -->  "+DoubleToStr(fiboPrice*0.707+fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+5,0.786);
   ObjectSetFiboDescription(nameObj, 5, "78.6  -->  "+DoubleToStr(fiboPrice*0.786+fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+6,0.841);
   ObjectSetFiboDescription(nameObj, 6, "84.1  -->  "+DoubleToStr(fiboPrice*0.841+fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+7,0.886);
   ObjectSetFiboDescription(nameObj, 7, "88.6  -->  "+DoubleToStr(fiboPrice*0.886+fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+8,1.0);
   ObjectSetFiboDescription(nameObj, 8, "100.0  -->  "+DoubleToStr(fiboPrice+fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+9,1.127);
   ObjectSetFiboDescription(nameObj, 9, "112.8  -->  "+DoubleToStr(fiboPrice*1.128+fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+10,1.272);
   ObjectSetFiboDescription(nameObj, 10, "127.2  -->  "+DoubleToStr(fiboPrice*1.272+fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+11,1.414);
   ObjectSetFiboDescription(nameObj, 11, "141.4  -->  "+DoubleToStr(fiboPrice*1.414+fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+12,1.618);
   ObjectSetFiboDescription(nameObj, 12, "161.8  -->  "+DoubleToStr(fiboPrice*1.618+fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+13,2.0);
   ObjectSetFiboDescription(nameObj, 13, "200.0  -->  "+DoubleToStr(fiboPrice*2.0+fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+14,2.414);
   ObjectSetFiboDescription(nameObj, 14, "241.4  -->  "+DoubleToStr(fiboPrice*2.414+fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+15,2.618);
   ObjectSetFiboDescription(nameObj, 15, "261.8  -->  "+DoubleToStr(fiboPrice*2.618+fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+16,4.236);
   ObjectSetFiboDescription(nameObj, 16, "423.6  -->  "+DoubleToStr(fiboPrice*4.236+fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+17,6.854);
   ObjectSetFiboDescription(nameObj, 17, "685.4  -->  "+DoubleToStr(fiboPrice*6.854+fiboPrice1, cPoint) );
//----
   return ;
  }
//--------------------------------------------------------
// Фибы с паттернами. Конец.
//--------------------------------------------------------

//--------------------------------------------------------
// Фибы стандартные. Начало.
//--------------------------------------------------------
void fibo_standart(double fiboPrice,double fiboPrice1)
  {
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL,0);
   ObjectSetFiboDescription(nameObj, 0, "0  -->  "+DoubleToStr(fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+1,0.146);
   ObjectSetFiboDescription(nameObj, 1, "14.6  -->  "+DoubleToStr(fiboPrice*0.146+fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+2,0.236);
   ObjectSetFiboDescription(nameObj, 2, "23.6  -->  "+DoubleToStr(fiboPrice*0.236+fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+3,0.382);
   ObjectSetFiboDescription(nameObj, 3, "38.2  -->  "+DoubleToStr(fiboPrice*0.382+fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+4,0.5);
   ObjectSetFiboDescription(nameObj, 4, "50.0  -->  "+DoubleToStr(fiboPrice*0.5+fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+5,0.618);
   ObjectSetFiboDescription(nameObj, 5, "61.8  -->  "+DoubleToStr(fiboPrice*0.618+fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+6,0.764);
   ObjectSetFiboDescription(nameObj, 6, "76.4  -->  "+DoubleToStr(fiboPrice*0.764+fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+7,0.854);
   ObjectSetFiboDescription(nameObj, 7, "85.4  -->  "+DoubleToStr(fiboPrice*0.854+fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+8,1.0);
   ObjectSetFiboDescription(nameObj, 8, "100.0  -->  "+DoubleToStr(fiboPrice+fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+9,1.236);
   ObjectSetFiboDescription(nameObj, 9, "1.236  -->  "+DoubleToStr(fiboPrice*1.236+fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+10,1.618);
   ObjectSetFiboDescription(nameObj, 10, "161.8  -->  "+DoubleToStr(fiboPrice*1.618+fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+11,2.618);
   ObjectSetFiboDescription(nameObj, 11, "261.8  -->  "+DoubleToStr(fiboPrice*2.618+fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+12,4.236);
   ObjectSetFiboDescription(nameObj, 12, "423.6  -->  "+DoubleToStr(fiboPrice*4.236+fiboPrice1, cPoint) );
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+13,6.854);
   ObjectSetFiboDescription(nameObj, 13, "685.4  -->  "+DoubleToStr(fiboPrice*6.854+fiboPrice1, cPoint) );
//----
   return ;
  }
//--------------------------------------------------------
// Фибы стандартные. Конец.
//--------------------------------------------------------