//+------------------------------------------------------------------+
//|                                                  Integra_v2.7.18 |
//|                                                           Kordan |
//|    http://www.leprecontrading.com/client/register.php?ref=103264 |
//+------------------------------------------------------------------+

//INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA
/*
   Советник с динамическим лотом выставления колен сопровождения серии. Т.е. колени выставляются не ранее PipStep по сигналам индикаторов.  
   Лотность колен возрастает с увеличением пройденного расстояния от PipStep до сигнала индикаторов с целью максимально приблизить
уровень ТП к текущей цене.
   Трал в валюте депозита сделан с целью приближения уровня динамического ТП серии с каждым коленом к текущей цене при больших объемах
и максимальному извлечению прибыли в начале серии при еще малых объемах ордеров.
   Добавлено перекрытие ордеров.
*/

#property copyright             "Kordan"
#property link                  "http://www.leprecontrading.com/client/register.php?ref=103264"
#include <stderror.mqh>                               // Моя партнерка в компании Лепрекон - "Возврат спреда". Прекрасно работают парни. Рекомендую.                                                     
#include <stdlib.mqh>                                 // Kordan    Z984090990532 или R355833322963

extern string t0 =              "ТП в валюте депозита";
extern bool   valute               =         false;      // TRUE - ТП в валюте депо(как у Kordan-а), false - в пунктах,при TRUE расчет ММ может быть неправильным
extern double DefaultProfit      =           0;      // Тейк профит в валюте депозита (гарантированная сумма профита)

extern string t1 =              "Установки расстояний";
extern int    Tral_Start         =            5;      // Расстояние начала трала от линии Profit в пунктах (классический ТП в пунктах)
extern int    Tral_Size          =            5;      // Величина трала после Tral_Start в пунктах
extern int    PipStep            =           13;      // Шаг открытия колен в пунктах

extern string t2 =              "Установки объемов и MМ";
extern int    Bonus              =            0;      // Средства, не учавствующие в торговле (в валюте депозита)
extern double Risk               =            0;      // Первая сделка размером в % от свободных средств, если Risk=0 то первая сделка открывается размером DefaultLot
extern double DefaultLot         =          0.1;      // Начальный лот, работает если Risk=0
extern double LotExponent        =            2;      // Коэффициент увеличения лота
extern int    TypeLotExp         =            2;      // тип LotExponent (0 - как у Кордана,1 - возведением в степень(геометрическая),2- арифметическая ),увеличение с учетом расстояния сверх пипстепа(если FixLot=FALSE)

extern string t2.2=               "Изменение установок после N-го колена ";
extern int    LotN               =              7;      // с какого колена нужно изменить настройки
extern double LotExponentNew       =            1;      // Коэффициент увеличения лота
extern int    PipStepNew           =           35;      // Шаг открытия колен в пунктах

extern string t2.3=               "Закрытие Встречным";
extern bool   CloseBy             =        True;      // Если TRUE, то Закрытие Встречным, если FALSE - обычно;

extern string t3 =              "Переход на фикслот";
extern int    FixLotPercent      =           30;      // Процент просадки для автоперехода на фиксированный лот
extern bool   FixLot             =        FALSE;      // Если TRUE, то фиксированный лот, если FALSE - динамический
extern string t2.1=              "Установки локирования";
extern bool   UseLock            =        FALSE; 
extern bool   Common             =         true;      //переключатель режимов: 
                                                      //true - рассчёт по общему эквити(nтолько для LockDrwdn и LockPercentDrwdn), 
                                                      //false - рассчёт по балансу текущего инструмента
extern bool   TradeAfterLock     =        true;      //Торговать ли дальше после выставления лока(при false работает только перекрытие, при true колени просевшей серии будут выставлятся дальше)                                                    
extern bool   LeadingAfterLock   =       false;      //Работает ли перекрытие после выставления лока                                                   
extern double LockPercent        =          40;      // Процент локового ордера от суммарного объема основной серии
extern int    LotTradeN          =           5;      // с какого колена можно открыть Лок при соблюдении одного из следующих условий
extern double PipsLock           =           0;      // Число пунктов до слива для открытия локового ордера 
extern double LockDrwdn          =           0;      // Просадка для открытия локового ордера в валюте депо
extern double LockPercentDrwdn   =          25;      // Процент просадки для открытия локового ордера 
extern double LockMargLevel      =     1000.00;      // Уровень запрета выст ордеров по уровню маржи
extern bool   LockCCI            =       FALSE;     // Использование индикатора CCI для открытия локового ордера

extern string t4 =              "Установки перекрытия";
extern int    LeadingOrder       =            4;      // C какого колена работает перекрытие
extern int    ProfitPersent      =           30;      // Процент перекрытия(10...50)
extern int    SecondProfitPersent=           50;      // Процент перекрытия когда подключается предпоследний ордер

extern string t5 =              "Ограничения"  ;
extern int    MaxTrades          =            5;      // Максимальное количество одновременно открытых колен
extern double MaxLot             =            1;      // Ограничение на максимальный лот, если MaxLot=0, то макс возможный лот ДЦ
extern int    CurrencySL         =            0;      // Ограничение по просадке в валюте депозита. Если  CurrencySL=0, то отключено.

extern string t6 =              "Закрыть Всё"  ;
extern bool   Close_All          =        FALSE;      // При вкл - принудительно закрываются все позиции, новый цикл не начинается

extern string t7 =              "Разрешить торговлю";
extern bool   ManualTrade        =        FALSE;      // При ManualTrade = TRUE первый ордер серии открывается вручную, далее серия сопровождается советником автоматически
extern bool   NewCycle_ON        =         TRUE;      // При запрете - цикл дорабатывается до конца, новый цикл не начинается
extern bool   TradeBuy           =         TRUE;      // FALSE\TRUE - Запретить\Разрешить длинные позиции  
extern bool   TradeSell          =         TRUE;      // FALSE\TRUE - Запретить\Разрешить короткие позиции 

extern string t8 =              "Установки CCI";
extern bool   CCI_NR         =            FALSE;      // FALSE\TRUE - выбор между стандартным индикатором CCI и iCCI.NR 
extern int    CCI_TimeFrame      =            2;      // ТФ      CCI  (0-текущий ТФ графика, 1=М1,2=М5,3=М15,4=М30,5=Н1,6=Н4,7=D1,8=W1,9=MN1)   
extern int    Level              =          100;      // Уровень CCI     
extern int    Period_CCI         =           14;      // Период  CCI 
extern double Sens               =            1;      // Порог шумоподавления в пунктах.
       int    PriceTip           =            5;      // Тип цены
                                                      // 0 - PRICE_CLOSE    - цена закрытия 
                                                      // 1 - PRICE_OPEN     - цена открытия
                                                      // 2 - PRICE_HIGH     - макс.цена
                                                      // 3 - PRICE_LOW      - мин.цена
                                                      // 4 - PRICE_MEDIAN   - средняя цена,(high+low)/2
                                                      // 5 - PRICE_TYPICAL  - типичная цена,(high+low+close)/3
                                                      // 6 - PRICE_WEIGHTED - взвешенная цена закрытия,(high+low+close+close)/4
extern string t9 =              "Фильтры уровней по МА";
extern int    TipMAFilter        =            2;      // Тип фильтра. Если 0-Выкл, если 1-фильтр shvondera, если 2-фильтр Kordana
extern int    TF_MA              =           60;      // Таймфрейм МА по фильтру Швондера или Кордана ( 5, 15, 60)
extern int    Period_МА          =         1000;      // Период скользящей средней
extern int    Distance_МА        =          350;      // Если Тип1 - Дистанция в пунктах на сколько цена должна отойти от МА для открытия ордера. Работа в сторону МА.
                                                      // Если Тип2 - Уровень запрета открытия ордеров выше/ниже от скользящей средней в пунктах. Отсечка на краях диапазона.
extern string t10 =             "Фильтр времени на выходные"; 
extern bool   UseFilterTime      =        FALSE;      // Использовать запрет торговли в пятницу после и в понедельник до указанных времен
extern int    StartHourMonday    =            7;      // Время начала торговли в понедельник
extern int    EndHourFriday      =           19;      // Время конца  торговли в пятницу

extern string t11 =             "Изменение цвета и размера индикации";
extern color  ColorInd           =       Silver;      // Цвет основной индикации
extern color  ColorTP            =       Silver;      // Цвет линии Profit
extern color  ColTPTrail         =   DarkOrange;      // Цвет линии Profit после срабатывания трала
extern color  ColorZL            =  DeepSkyBlue;      // Цвет линии безубытка
extern int    xDist1             =          300;      // Расстояние по горизонтали блока трала и нехватки средств
extern int    xDist2             =          800;      // Расстояние по горизонтали блока суммарных профитов и объемов
extern int    FontSize           =            9;      // Размер шрифта индикации

extern string t12 =             "Дополнительные параметры";
extern bool   Info               =         TRUE;      // Вкл индикации, звукового сопровождения открытия колен и подробного протоколирования
extern bool   VisualMode         =         TRUE;      // Вкл режима ручного управления
extern int    MagicNumber        =          777;      // Уникальный номер советника (при MagicNumber=0 сов подхватывает ручные ордера)
extern int    MagicNumberCloseby =        12345;      // Уникальный номер советника (при MagicNumber=0 сов подхватывает ручные ордера)
extern string MagicNumList       =  "111 0 888";      // Список, через пробел, магиков которые советник будет считать своими (не более 10)
extern int    PauseTrade         =            6;      // Время ожидания между торговыми командами в сек 

//********************************************************************************************

#import "mt4gui.dll"
   string   tbVersion()                                     ;
   string   tbGetText(int,int)                              ;   
   bool     tbIsClicked(int,int)                            ;                       
   bool     tbIsChecked(int,int)                            ;     
   int      tbPutObject(int,string,int,int,int,int,string)  ; 
   int      tbSetBgColor(int,int,int)                       ;                      
   int      tbSetTextColor(int,int,int)                     ;                   
   int      tbRemove(int,int)                               ;                              
   int      tbRemoveAll(int)                                ;                                                 
   int      tbSetText(int,int,string,int,string)            ;                                
   int      tbSetChecked(int,int,bool)                      ;                     
   int      tbEnable(int,int,int)                           ;                        
   int      tbAddListItem(int,int,string)                   ;                 
   int      tbGetListSel(int,int)                           ;                         
   int      tbSetListSel(int,int,int)                       ;              
#import

//INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA 

   int      mper[10]={0,1,5,15,30,60,240,1440,10080,43200},magic[10];
   int      hwnd=0, btn1=0;
   int      dig,Error,Lpos,Lpos1,Cpos,PrcCL1,cmagic,totalord,totalbuy,totalsell,spr,freez,stlev,
            buybtn,sellbtn,closebtn,lottxt,lotbtnp,lotbtnm,closesellbtn,closebuybtn, maxtrades,pipstep;
   color    col,ZLcolor,TPcolor;
   double   TPPrice,ZeroLine,Cprofit,Lprofit,Lprofit1,PrcCL,CurrentDrawdown,CurrentUrov,Profit,SumProfit,SumLotBuy,SumLotSell,
            Lot,LotR,Sum_lot,Sumlot,minLot,maxLot,delta,delta2,TV,Price,DrawDownRate,FreeMargin,Balance,Sredstva,One_Lot,Step,
            ProfitBuy,ProfitSell,LastLotBuy,LastLotSell,LastPriceBuy,LastPriceSell,lotexponent,CP_Lot_step ;
   string   comment,prevar,DrawDownString="no_drawdown";
   bool     CloseTrigger,NoTrade,CloseAll,CloseFM,fixlot,Lockbuy,Locksell; 

//INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA  
   
int init(){  

   DeleteObject()    ;  // Сброс триггера и очистка экрана
   TV      = MarketInfo(Symbol(),MODE_TICKVALUE     ) ;  
   minLot  = MarketInfo(Symbol(),MODE_MINLOT        ) ; 
   maxLot  = MarketInfo(Symbol(),MODE_MAXLOT        ) ;
   One_Lot = MarketInfo(Symbol(),MODE_MARGINREQUIRED) ;  // Размер свободных средств, необходимых для открытия 1 лота на покупку
   Step    = MarketInfo(Symbol(),MODE_LOTSTEP       ) ;  // Шаг изменения размера лота
   dig     = LotDecimal();
   
//*********************************************************************************************  
   
if (VisualMode){
   hwnd=WindowHandle(Symbol(),Period());
   tbRemoveAll(hwnd);
   lottxt      = tbPutObject(hwnd,"text"  , 77,-39,70,20, DoubleToStr(LotR,2));
   buybtn      = tbPutObject(hwnd,"button",149,-39,70,20,"Buy"              );
   sellbtn     = tbPutObject(hwnd,"button",  5,-39,70,20,"Sell"             );
   closebtn    = tbPutObject(hwnd,"button",221,-39,90,20,"Закрыть все"      );
   closesellbtn= tbPutObject(hwnd,"button",313,-39,90,20,"Закрыть Sell"     );
   closebuybtn = tbPutObject(hwnd,"button",405,-39,90,20,"Закрыть Buy"      );
   tbSetBgColor(hwnd,closebtn,Gold);
}   
  
//***************** Автоматический переход на пятизнак **************************************** 

   int _digits = MarketInfo(Symbol(), MODE_DIGITS);
      if (_digits == 5 || _digits == 3){
         Tral_Start        *= 10;
         Tral_Size         *= 10;
         PipStep           *= 10;
         PipStepNew        *= 10;
         Distance_МА       *= 10;
      }
         
//***************  Защита от неправильного выставления параметров  ****************************

   if(CCI_TimeFrame< 2 || CCI_TimeFrame>4) CCI_TimeFrame = 2;
  // if(DefaultProfit<=0 )  DefaultProfit = 0.01  ;
  // if(LockPercent  <=0 )  LockPercent=1         ;
   if(DefaultLot   <=0 )  DefaultLot=0.01       ;
   if (LeadingOrder >0){ if (LeadingOrder <3)   LeadingOrder=3        ;}
   if(AllowTrade() == false) return(0)          ;
//************************************Начаальные переменные********************************** 

   maxtrades=MaxTrades;
   lotexponent=LotExponent;
   pipstep=PipStep;

//********************************************************************************************* 

cmagic=0; string st; int k=StringLen(MagicNumList);
for (int a=0; a<k; a++){
   if (StringSubstr(MagicNumList,a,1)!=" "){
      st=st+StringSubstr(MagicNumList,a,1); 
         if(a < k-1) continue;
   }
      if (st!=""){
         magic[cmagic]=StrToInteger(st); cmagic++; st="";
      }
   } 
   return(0);
}

//INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA  
  
int deinit() {
   DeleteObject();  // Сброс триггера и очистка экрана
   tbRemoveAll(WindowHandle(Symbol(),Period()));
   return(0);
} 
     
//INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA

int start(){

   CurrentCondition();
   FreeMargin = NormalizeDouble(AccountFreeMargin()- Bonus, 2) ;
   Balance    = NormalizeDouble(AccountBalance   ()- Bonus, 2) ;
   Sredstva   = NormalizeDouble(AccountEquity    ()       , 2) ;
   if (Sumlot ==0) Sumlot = 0.00000001                         ;  // Защита от нулевого значения 
   spr        = MarketInfo(Symbol(),MODE_SPREAD     )          ;
   freez      = MarketInfo(Symbol(),MODE_FREEZELEVEL)          ; 
   stlev      = MarketInfo(Symbol(),MODE_STOPLEVEL  )          ;
   Lot        = GetLot()                                       ; 
   if (MaxLot ==0 || MaxLot > maxLot)         MaxLot = maxLot   ;               
//  CP_Lot_step = Lot* LotExponent                               ;   /// переменная для расчета арифметического увеличения лота
//   if (LeadingOrder>= 2) CheckOverlapping()                    ; 
 
//***************  Защита от неправильного выставления стопуровней  ***************************

int levels        =spr+freez+stlev          ;
   if(PipStep    <=levels) PipStep   =levels;
   if(Tral_Start <=levels) Tral_Start=levels; 

//===============================================================================================================================

if(time() && VisualMode){
   if(tbGetText(hwnd,lottxt)!="")LotR=StrToDouble(tbGetText(hwnd,lottxt));
   if (tbIsClicked(hwnd,buybtn)){
      comment=StringConcatenate("Integra -Pучник, ","Magic : ",MagicNumber);
         SendOrder(OP_BUY , LotR,0,0,0, comment, MagicNumber);
   }

   if (tbIsClicked(hwnd,sellbtn)){
      comment=StringConcatenate("Integra -Pучник, ","Magic : ",MagicNumber);
         SendOrder(OP_SELL, LotR,0,0,0, comment, MagicNumber);
   }

   if (tbIsClicked(hwnd,closebtn    )) CloseThisSymbolAll(MagicNumber         );
   if (tbIsClicked(hwnd,closesellbtn)) CloseThisSymbolAll(MagicNumber, OP_SELL);
   if (tbIsClicked(hwnd,closebuybtn )) CloseThisSymbolAll(MagicNumber, OP_BUY );   
}
 
//===========================================  Управление закрытием ордеров  ==========================================

if (SumProfit<0 && CurrencySL!=0){
   if (MathAbs(SumProfit)>=CurrencySL){
      if (Info) Print("Просадка превысила заданный уровень");
         CloseFM=true;
   }
} 
     
if (totalord==0)  {CloseAll=false; Close_All=false;Lockbuy=false;Locksell=false;}
   if (Close_All || CloseAll || CloseFM){
      CloseOrders() ; Indication ("ICloseAll",2,10,150,"Закрытие ордеров",FontSize,"Times New Roman",ColorInd);
      DeleteObject(); // Сброс триггера и очистка экрана
      CloseFM=false;
         if (Info && Close_All)   Print("Закрыть ВСЁ");
   return(0);
   }

//===============================   Переход на фиксированный лот   ====================================================

if (CurrentDrawdown<=FixLotPercent) fixlot=false; else fixlot=true ;
if (FixLot)  fixlot=true ; 

//==============================   Изменение настроек после N-го колена==============================

   if (LotN > 0) {
       if (totalbuy >= LotN || totalsell >=LotN )
                  {
   LotExponent=LotExponentNew ;     
   PipStep=PipStepNew;
                    } 
                           else  
        {
   LotExponent=lotexponent ;     
   PipStep=pipstep;
        }  
                  }    
//***********************    
CP_Lot_step = Lot* LotExponent                               ;   /// переменная для расчета арифметического увеличения лота
                    
//===============================   Lock   ====================================================


if (totalbuy>0 || totalsell>0)
{
Lockbuy=false;
Locksell=false;
 for(int cnt = OrdersTotal() - 1; cnt >= 0; cnt--){
       if (OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES))
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
            {
               if  (OrderType()==OP_BUY)
                  {
                  if(StringFind(OrderComment()," Lock-Buy",0)!=-1) Lockbuy=true;
                  }
               if  (OrderType()==OP_SELL)
                  {
               if(StringFind(OrderComment()," Lock-Sell",0)!=-1) Locksell=true;
                  }
            }  
 } 
}
if (UseLock) { 
/* double CurrentMargLevel = 10000;
   if (AccountMargin()>0) {
    CurrentMargLevel = (AccountEquity()/AccountMargin())*100;}*/
double lock1=NormalizeDouble(Sumlot/100*LockPercent,dig);
if (lock1>maxLot) lock1=maxLot;
double  pips, dwdn,drwdnprs,Balans,Equity;
/*double ProfitBuy = CurrentCondition("Buy" ,"ProfitBuy" );
double ProfitSell= CurrentCondition("Sell","ProfitSell");*/
Balans   = Balance;
Equity   = Sredstva;
   
if (Sumlot>0) {
   if (Balans>Equity)    pips=NormalizeDouble((Equity-AccountStopoutLevel()*Equity/ 100.0)/Sumlot/TV,0);
    if (Common)    {
     if (Balans<=Equity)    {
     dwdn=0;
     drwdnprs=0;}
     else {
 dwdn=NormalizeDouble(Balans-Equity,3);
 drwdnprs=  CurrentDrawdown;
      }
    }
   else
    {
     if (SumProfit>=0) {
     dwdn=0;
     drwdnprs=0;}
        else      {
       dwdn=NormalizeDouble(-SumProfit,3);
       drwdnprs= NormalizeDouble(dwdn*100/Balans,3);
         }
    }

//dwdn=NormalizeDouble(GetMoney("Balance")-GetMoney("Sredstva"),3);
if (!Locksell &&!Lockbuy&& SumLotBuy!=SumLotSell)
      { if ((LockPercentDrwdn>0 && CurrentDrawdown>=LockPercentDrwdn) || (PipsLock>0 && pips<=PipsLock) || (LockDrwdn>0 && dwdn>=LockDrwdn)||(LockMargLevel>0 && LockMargLevel>CurrentUrov)) {
         if ((Sum_lot<0||ProfitSell<0<ProfitBuy) && LockCCI==false&&totalsell>=LotTradeN)                      {if(Info) Print("Oткрытие локового ордера  Lock-Buy") ; SendOrder(OP_BUY ,lock1,0,0,MagicNumber,"Integra" + " Lock-Buy" ,Error);}
      else 
         if ((Sum_lot<0||ProfitSell<0<ProfitBuy) && Signal_CCI()== 1 && LockCCI==true&&totalsell>=LotTradeN)   {if(Info) Print("Oткрытие локового ордера  Lock-Buy") ; SendOrder(OP_BUY ,lock1,0,0,MagicNumber,"Integra" + " Lock-Buy" ,Error);}
         
         if ((Sum_lot>0||ProfitBuy<0<ProfitSell) && LockCCI==false&& totalbuy>=LotTradeN)                      {if(Info) Print("Oткрытие локового ордера  Lock-Sell"); SendOrder(OP_SELL,lock1,0,0,MagicNumber,"Integra" + " Lock-Sell",Error);}
      else
         if ((Sum_lot>0||ProfitBuy<0<ProfitSell) && Signal_CCI()==-1 && LockCCI==true&& totalbuy>=LotTradeN)   {if(Info) Print("Oткрытие локового ордера  Lock-Sell"); SendOrder(OP_SELL,lock1,0,0,MagicNumber,"Integra" + " Lock-Sell",Error);} 
      }
 } 
}
}  
if   (!TradeAfterLock) { 
 if (Lockbuy) MaxTrades=totalsell-1; else MaxTrades=maxtrades;
 if (Locksell) MaxTrades=totalbuy-1; else MaxTrades=maxtrades;               }
//=========================================  Расчет динамического профита  ============================================
if(DefaultProfit<=0 )  Profit = 0.01  ;  
if(DefaultProfit>0 ){
      if(!valute)
{Profit = NormalizeDouble(Lot*DefaultProfit*Point*MarketInfo(Symbol(),MODE_LOTSIZE)/10000,2); }   //MarketInfo(Symbol(),MODE_LOTSIZE)/10000/Point
      if(valute)           {if(Risk!=0) Profit = NormalizeDouble(Lot*DefaultProfit/minLot,2); else Profit = DefaultProfit;  }
                     }
                     
//==========================================  Трейлинг профита  =======================================================
   
if (SumProfit>(Profit+Tral_Start*TV*Sumlot) && !CloseTrigger){
   CloseTrigger=1; TPcolor=ColTPTrail; ZLcolor=ColorZL ;
}   
         
   if (!CloseTrigger){
   TPcolor=ColorTP; ZLcolor=ColorZL      ;
   delta  = (Profit-SumProfit)/TV/Sumlot ; // Число пунктов до профита
   delta2 =  SumProfit/TV/Sumlot         ; // Число пунктов до безубытка 
      if (Sum_lot>0){
      TPPrice=NormalizeDouble(Bid+(delta+Tral_Start)*Point,Digits); ZeroLine=NormalizeDouble(Bid-delta2*Point,Digits)  ;
      }
      else{
      TPPrice=NormalizeDouble(Ask-(delta+Tral_Start)*Point,Digits); ZeroLine=NormalizeDouble(Ask+delta2*Point,Digits)  ;
      } 
   }

      if (!IsTesting() || IsVisualMode() || !IsOptimization()){
         DrawLine("ILineTP",TPPrice,TPcolor,2); DrawLine("ILineZL",ZeroLine,ZLcolor,0); 
         DrawText("ItxtTP","Уровень ТП",TPPrice,TPcolor); DrawText("ItxtБУ","Уровень БУ",ZeroLine,ZLcolor);
      }
      if (totalord==0) ObjectDelete("ItxtБУ");
      
//==========================  Триггер трала  ======================================
if (Sum_lot!=0){ 
   if (CloseTrigger==1){       
//==========================  Buy  ======================================

      if (Sum_lot>0){
         if (Bid<=NormalizeDouble(TPPrice,Digits)){
            if (Info)  Print("Команда трала на закрытие Buy SL");                 CloseAll=true ;
         }
            else 
         if (TPPrice<(Bid-Tral_Size*Point)) TPPrice=NormalizeDouble(Bid-Tral_Size*Point,Digits) ;
      }

//==========================  Sell  ====================================== 

      if (Sum_lot<0){
         if (Ask>=NormalizeDouble(TPPrice,Digits)){
            if (Info)  Print("Команда трала на закрытие Sell SL ");               CloseAll=true ;
         }
            else 
         if (TPPrice>(Ask+Tral_Size*Point)) TPPrice=NormalizeDouble(Ask+Tral_Size*Point,Digits) ;
      }
   } 
}
  
//********************************************************************************************* 

if (!IsTesting() || IsVisualMode() || !IsOptimization()){
   if (Info){
   MainIndication(); 
   SetOrdersInfo();
   Price = PriceCCI(Level);   
   } 
}

//============================================================  Начало серии  ===================================================
if (!ManualTrade && NewCycle_ON && time() && !Close_All && !NoTrade&&!Locksell&&!Lockbuy){
//=========================================================  Открытие первого Buy  ==============================================

double StartLot                                      ; 
int ticketbuy=0, ticketsell=0                        ;  
   if (TradeBuy && totalbuy==0){
      if (ticketbuy ==0){
         if (GetMASignalS()==1 || !TipMAFilter==1){
            if (!GetMASignal()==1 || !TipMAFilter==2){
               if (Signal_CCI()==1){
                  DeleteObject()                     ;
                  StartLot = NormalizeDouble(Lot,dig);     
                  if(Info) Print("Команда на открытие первого BUY");
                     comment=StringConcatenate("1-й ордер Buy, ","Magic : ",MagicNumber)           ;
                        ticketbuy = SendOrder(OP_BUY , StartLot, 0, 0, MagicNumber, comment, Error);
                  if (!IsTesting() || IsVisualMode() || !IsOptimization()){
                     if (Info) PlaySound("alert.wav");
                        Sleep(1000); // если это не тестирование - "засыпаем" на 1 секунду.; 
                  }
               }
            }
         }
      } 
   }   
   
//=========================================================  Открытие первого Sell  =============================================

   if (TradeSell && totalsell==0){
      if (ticketsell==0){
         if (GetMASignalS()==-1 || !TipMAFilter==1){
            if (!GetMASignal()==-1 || !TipMAFilter==2){
               if (Signal_CCI()==-1){
                  DeleteObject()                     ;
                  StartLot = NormalizeDouble(Lot,dig);    
                  if(Info) Print("Команда на открытие первого SELL");
                     comment=StringConcatenate("1-й ордер Sell, ","Magic : ",MagicNumber)            ;
                        ticketsell  = SendOrder(OP_SELL, StartLot, 0, 0, MagicNumber, comment, Error);
                  if (!IsTesting() || IsVisualMode() || !IsOptimization()){
                     if (Info) PlaySound("alert.wav");
                        Sleep(1000); // если это не тестирование - "засыпаем" на 1 секунду.; 
                  }
               }
            } 
         }   
      }        
   }   
}        

//=====================================================  Сопровождение серии  ===================================================

if (time() && !Close_All && !NoTrade){  
double NewLot,afmc;
ObjectDelete("InewLot");

      //==========================  Buy  ======================================

   if (TradeBuy && totalbuy>0 && totalbuy<=MaxTrades&&!Lockbuy){
      if (Ask<(LastPriceBuy-PipStep*Point)){  
         NewLot = NewLot(1)                                          ;
            afmc = AccountFreeMarginCheck(Symbol(), OP_BUY, NewLot)  ;
if(Info) Indication ("InewLot",3,10,115,StringConcatenate("Ожидаем ордер: Buy ",DoubleToStr(NewLot,dig)," / ","Оcтанется : $",DoubleToStr(afmc,0)),FontSize,"Times New Roman",ColorInd);            
           
      if(afmc<=0) return; else
         if (GetMASignalS()==1 || !TipMAFilter==1){
            if (!GetMASignal()==1 || !TipMAFilter==2){
               if (Signal_CCI()==1){
                  if (Info)  Print("Команда индикаторов на открытие колена - BUY")                 ;   
                     comment=StringConcatenate(totalbuy+1,"-й ордер Buy, " ,"Magic : ",MagicNumber);
                        ticketbuy = SendOrder(OP_BUY, NewLot, 0, 0, MagicNumber, comment, Error)   ;
                  if (!IsTesting() || IsVisualMode() || !IsOptimization()){
                     if (Info) PlaySound("alert.wav")                                              ;
                        Sleep(1000); // если это не тестирование - "засыпаем" на 1 секунду.;      
                  }     
               }         
            }
         }     
      }         
   }   
      
      //==========================  Sell  =====================================

   if (TradeSell && totalsell>0 && totalsell<=MaxTrades&&!Locksell){
      if (Bid>(LastPriceSell+PipStep*Point)){ 
         NewLot = NewLot(2)                                          ;
            afmc = AccountFreeMarginCheck(Symbol(), OP_SELL, NewLot) ;
if(Info) Indication ("InewLot",3,10,115,StringConcatenate("Ожидаем ордер: Sell ",DoubleToStr(NewLot,dig)," / ","Оcтанется : $",DoubleToStr(afmc,0)),FontSize,"Times New Roman",ColorInd);            
  
      if(afmc<=0) return; else
         if (GetMASignalS()==-1 || !TipMAFilter==1){
            if (!GetMASignal()==-1 || !TipMAFilter==2){
               if (Signal_CCI()==-1){
                  if (Info)  Print("Команда индикаторов на открытие колена - SELL")                   ; 
                     comment=StringConcatenate(totalsell+1,"-й ордер Sell, ","Magic : ",MagicNumber)  ;
                        ticketsell = SendOrder(OP_SELL, NewLot, 0, 0, MagicNumber, comment, Error)    ; 
                  if (!IsTesting() || IsVisualMode() || !IsOptimization()){
                     if (Info) PlaySound("alert.wav")                                                 ;
                        Sleep(1000); // если это не тестирование - "засыпаем" на 1 секунду.;       
                  }
               }
            }  
         } 
      }        
   }            
}    
if (LeadingOrder >0){
 if (!LeadingAfterLock) if (!Lockbuy && !Locksell) CheckOverlapping()  ;    
 if (LeadingAfterLock)   CheckOverlapping()          ;   
                      }                       
//================================================= 
   
      return(0);  // Выход из start
}

//INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++           ФУНКЦИИ            +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//=========================================================================================================================================//
// Qimer . Функция контроля наличия своего магика                                                                                          //
//=========================================================================================================================================//

bool MagicCheck(){
   for(int i=0; i<cmagic; i++){
      if (OrderMagicNumber()==magic[i]) return(true);
   }
   return(false);
}

//=========================================================================================================================================//
// shvonder . Фильтр уровней по МА S                                                                                                       //
//=========================================================================================================================================//  

int GetMASignalS(){
   if (TipMAFilter==1){
int Signal = 0;
double iMA_Signal = iMA(Symbol(), TF_MA, Period_МА, 0, MODE_SMMA, PRICE_CLOSE, 1);
int Ma_Bid_Diff = MathAbs(iMA_Signal - Bid)/Point;
   if(Ma_Bid_Diff > Distance_МА && Bid > iMA_Signal) Signal = -1; //Sell
   if(Ma_Bid_Diff > Distance_МА && Bid < iMA_Signal) Signal =  1; //Buy   
double LevelNoBuy =iMA_Signal-Distance_МА*Point;
double LevelNoSell=iMA_Signal+Distance_МА*Point; 
      if (!IsTesting() || IsVisualMode() || !IsOptimization()){
         DrawLine("ILevelNoBuy  ", LevelNoBuy  , RoyalBlue, 3); 
         DrawLine("ILevelNoSell ", LevelNoSell , Crimson  , 3);  
         DrawText("ItxtLevelBuy ","Filter shvonder - запрет Buy" , LevelNoBuy , RoyalBlue);
         DrawText("ItxtLevelSell","Filter shvonder - запрет Sell", LevelNoSell, Crimson  );
      }
   }
return(Signal);
}

//=========================================================================================================================================//
// Kordan . Фильтр уровней по МА K                                                                                                         //
//=========================================================================================================================================//  

int    GetMASignal(){
   if (TipMAFilter==2){
int    Signal = 0;
double iMA_Signal  = iMA(Symbol(),TF_MA,Period_МА, 0, MODE_SMMA, PRICE_CLOSE, 1);
int    Ma_Bid_Diff = MathAbs(iMA_Signal - Bid)/Point;
double LevelNoBuy =iMA_Signal+Distance_МА*Point;
double LevelNoSell=iMA_Signal-Distance_МА*Point;
      if(Ma_Bid_Diff > Distance_МА){ 
         if(Bid > iMA_Signal) Signal = 1; //Запрет Buy
         if(Bid < iMA_Signal) Signal =-1; //Запрет Sell  
      }   
      if (!IsTesting() || IsVisualMode() || !IsOptimization()){
         DrawLine("ILevelNoBuy  ", LevelNoBuy  , RoyalBlue, 3); 
         DrawLine("ILevelNoSell ", LevelNoSell , Crimson  , 3);
         DrawText("ItxtLevelBuy ","Filter Kordan - запрет Buy" , LevelNoBuy , RoyalBlue);  
         DrawText("ItxtLevelSell","Filter Kordan - запрет Sell", LevelNoSell, Crimson  ); 
      }  
   } 
return(Signal);                      
}

//=========================================================================================================================================//
// Kordan . Сигнал СCI                                                                                                                     //
//=========================================================================================================================================// 
int Signal_CCI(){
double x0,x1,x2,x3,x4;
int Signal = 0;
 x0 = iClose(Symbol(),mper[CCI_TimeFrame+1], 0)      ;
 x1 = iClose(Symbol(),mper[CCI_TimeFrame+1], 2)      ;
if (CCI_NR) {
 x2 = iCustom(NULL,mper[CCI_TimeFrame],"iCCI.NR", Period_CCI,PriceTip,Sens, 0,0);
 x3 = iCustom(NULL,mper[CCI_TimeFrame],"iCCI.NR", Period_CCI,PriceTip,Sens, 0,1);
 x4 = iCustom(NULL,mper[CCI_TimeFrame],"iCCI.NR", Period_CCI,PriceTip,Sens, 0,3);}
if (!CCI_NR) {
 x2 = iCCI(NULL,mper[CCI_TimeFrame],Period_CCI,0,0)  ; 
 x3 = iCCI(NULL,mper[CCI_TimeFrame],Period_CCI,0,1)  ;
 x4 = iCCI(NULL,mper[CCI_TimeFrame],Period_CCI,0,3)  ;}
   if (x2>-Level && x3<-Level && x2>x4 && x1>x0) Signal = 1;    //Buy 
   if (x2< Level && x3> Level && x2<x4 && x1<x0) Signal =-1;    //Sell
return(Signal);
}
//=========================================================================================================================================//
// Kordan . Функция получения информации по открытым ордерам                                                                               //
//=========================================================================================================================================// 

void CurrentCondition(){
totalord=0;totalbuy=0;totalsell=0;SumProfit=0;CurrentDrawdown=0;ProfitBuy=0;ProfitSell=0;SumLotBuy=0;SumLotSell=0;LastPriceBuy=0;LastPriceSell=0;
   for (int cnt=0;cnt<OrdersTotal();cnt++){
      if (OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)){
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber || MagicCheck()){
            if (OrderType()== OP_SELL || OrderType() == OP_BUY){
               switch(OrderType()){
                  case OP_BUY :  
                     totalbuy     ++             ; 
                     SumLotBuy    += OrderLots() ;
                     LastLotBuy    = OrderLots() ;
                     LastPriceBuy  = NormalizeDouble(OrderOpenPrice() , Digits) ;
                     ProfitBuy    += NormalizeDouble(OrderProfit()+OrderSwap()+OrderCommission(), 2); 
                        break;
                  case OP_SELL: 
                     totalsell    ++             ;
                     SumLotSell   += OrderLots() ;
                     LastLotSell   = OrderLots() ;
                     LastPriceSell = NormalizeDouble(OrderOpenPrice() , Digits) ; 
                     ProfitSell   += NormalizeDouble(OrderProfit()+OrderSwap()+OrderCommission(), 2);  
                        break; 
               default: return(0);
               }
            }
         totalord        = totalbuy + totalsell;
         SumProfit      += OrderProfit()+OrderSwap()+OrderCommission() ;
         CurrentDrawdown = NormalizeDouble(MathMax((AccountBalance()+AccountCredit()-AccountEquity())/(AccountBalance()+AccountCredit())*100,0),2);        
         Sum_lot         = NormalizeDouble(SumLotBuy-SumLotSell ,dig);  // Суммарный лот (плюс или минус)        
         Sumlot          = NormalizeDouble(MathAbs(Sum_lot     ),dig);  // Aбсолютное значение суммарного лота (значение по модулю, всегда плюс)        
         if (AccountMargin()>0) CurrentUrov = NormalizeDouble(AccountEquity()/AccountMargin()*100,0);                  
         }
      }
   }    
}

//=========================================================================================================================================//
// Kordan . Функция получения ордера с макс и мин значением прибыли                                                                        //
//=========================================================================================================================================// 

void GetOrdMaxNinProfit(){
int    Pos   =0;
double result=0,profit=0;
//   for (int cnt=OrdersTotal()-1; cnt>=0; cnt--) {
   for (int cnt=0;cnt<OrdersTotal();cnt++){
      if (OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)){
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber || MagicCheck()){
            if (OrderType()== OP_SELL || OrderType() == OP_BUY){
            
               profit = OrderProfit()           ;
               Pos    = OrderTicket()           ;
               
               if (profit>0 && profit>Lprofit){
                  Lprofit1 = Lprofit            ;
                  Lpos1    = Lpos               ; 
                  Lprofit  = profit             ; //макс значение
                  Lpos     = Pos                ;
               }
                  
               if (profit<0 && profit<Cprofit){
                  Cprofit = profit              ; //мин  значение
                  Cpos    = Pos                 ;
               }
            }
         }
      }   
   }                                                                                             
}

//=========================================================================================================================================//
// Kordan . Функция расчета лота для открытия колен                                                                                        //
//=========================================================================================================================================//

double NewLot(int OrdType){
double newlot,cp                                                                       ;

  if (OrdType==1){
           if (!fixlot) cp=MathAbs((LastPriceBuy-Ask )/Point/PipStep);   else cp=1       ;   
                     if (TypeLotExp == 2)                         // арифметическая
           newlot=NormalizeDouble(LastLotBuy+(CP_Lot_step*cp),dig) ;    else  {    
                     
                     if (TypeLotExp == 1)                          //геометричесая 
           newlot=NormalizeDouble(LastLotBuy*MathPow(LotExponent,cp),dig);  else  { 
           
                     if (TypeLotExp == 0)                          //по Kordan-у  
           newlot = NormalizeDouble(LastLotBuy*LotExponent*cp,dig)  ; else  
                     
         //            if (TypeLotExp != 2 && TypeLotExp != 1 && TypeLotExp != 0) 
           newlot = NormalizeDouble(LastLotBuy*LotExponent*cp,dig)  ;}}
          }
             
if (OrdType==2){
          if (!fixlot) cp=MathAbs((Bid-LastPriceSell)/Point/PipStep);   else cp=1       ;   
                      if (TypeLotExp == 2)                         // арифметическая
           newlot=NormalizeDouble(LastLotSell+(CP_Lot_step*cp),dig) ;      else  {  
                     
                     if (TypeLotExp == 1)                          //геометричесая 
           newlot=NormalizeDouble(LastLotSell*MathPow(LotExponent,cp),dig);  else  { 
           
                     if (TypeLotExp == 0)                          //по Kordan-у  
           newlot = NormalizeDouble(LastLotSell*LotExponent*cp,dig)  ; else  
                     
  //                   if (TypeLotExp != 2 && TypeLotExp != 1 && TypeLotExp !=0) 
           newlot = NormalizeDouble(LastLotSell*LotExponent*cp,dig)  ;}}
          }
              
if (newlot > MaxLot)    newlot = NormalizeDouble(MaxLot,dig)                 ;
if(newlot < minLot)  newlot = minLot                                                   ;            
return(newlot)                                                                         ;
} 

//=========================================================================================================================================//
// Kordan . Функция расчета начального лота                                                                                                //
//=========================================================================================================================================//

double GetLot(){  
double lot=0                                                      ;
      if(Risk!=0)                                                    // Если кол-во лотов заданно в % от свободных средств,                                                          
         lot  =MathAbs(FreeMargin*Risk/3200/One_Lot/Step)*Step ; else// то считаем стоимость лота
         lot  =MathMax(DefaultLot,minLot)                         ;  // иначе выставляется заданное значение DefaultLot не меньше мин. размерa лота
      if(lot<minLot) lot=minLot                                   ;  // Не меньше минимального  размерa лотa
      if(MaxLot==0 ) lot=lot; else
                     lot=MathMin(MaxLot, lot)                     ;  // Не больше максимально установленного размерa лотa
                                                                      
      if (lot*One_Lot>FreeMargin){                                   // Если лот дороже свободных средств,
         if (!IsTesting() || IsVisualMode() || !IsOptimization()){   // то выводим сообщение в режиме Тест,
            Indication ("INoMoney",2,xDist1,40,"Недостаточно средств!!!",FontSize+5,"Courier",Red) ;  // Нулевая маржа              
         }
            else{ 
               Indication ("INoMoney",2,xDist1,40,"Недостаточно средств!!! Торговля остановлена!!!",FontSize+5,"Courier",Red); 
                  NoTrade=TRUE                                    ;  // останавливаем торговлю
            }          
         return (0)                                               ;  // и выходим из функции start()
      } 
      else  ObjectDelete("INoMoney")                              ;                                           
return(lot)                                                       ;
}

//===================================================================================================================================================
// shvonder . 
//===================================================================================================================================================

bool AllowTrade(){
   if(Bars < Period_МА){
      Print("Недостачно баров в истории!"); 
         return(false); 
   }
   if (Bid == 0.0 || Ask == 0.0){
      Print(StringConcatenate("Неправильные цены. Ask: ", Ask, " Bid: ", Bid)); 
         return(false); 
   }
return(true);
}

//=========================================================================================================================================//
// Функция расчета знака после запятой                                                                                                     //
//=========================================================================================================================================//

int LotDecimal(){
int digits;     
   if (Step >= 1   ) digits = 0;
   if (Step >= 0.1 ) digits = 1;
   if (Step >= 0.01) digits = 2;
return(digits);
}   
 
//=========================================================================================================================================//
// Qimer . Функция фильтра по времени                                                                                                      //
//=========================================================================================================================================// 

bool time(){
   if (((Hour()<StartHourMonday && DayOfWeek()==1) || (Hour()>=EndHourFriday && DayOfWeek()==5)) && UseFilterTime) return(false);
   else return(true);
}

//=========================================================================================================================================//
// ir0407 . Функция открытия ордеров                                                                                                       //
//=========================================================================================================================================//   

int SendOrder (int Type, double Lots, int TP, int SL, int magic, string Cmnt, int Error){
double Price, Take, Stop;
int Ticket, Slippage, Color, Err; 
bool Delay = False;
   if (Info) Print("Функция открытия ордеров");
while(!IsStopped()){  
   if (!IsTesting()){ //Если мы не в режиме тестирования
      if(!IsExpertEnabled()){
         Error = ERR_TRADE_DISABLED;
         Print ("Эксперту запрещено торговать! Кнопка \"Советники\" отжата.");
         return(-1);
      }
         if (Info) Print("Эксперту разрешено торговать");
            if(!IsConnected()){
               Error = ERR_NO_CONNECTION;
               Print("Связь отсутствует!");
            return(-1);
            }
      if (Info) Print("Связь с сервером установлена");
      if(IsTradeContextBusy()){
         Print("Торговый поток занят!");
         Print(StringConcatenate("Ожидаем ",PauseTrade," cek"));
         Sleep(PauseTrade*1000);
         Delay = True;
         continue;
      }
      if (Info) Print("Торговый поток свободен");
         if(Delay){
            if(Info) Print("Обновляем котировки");
            RefreshRates();
            Delay = False;
         }
      else if (Info) Print("Котировки актуальны");
      }
            switch(Type){
               case OP_BUY:
//               if (Info) Print("Инициализируем параметры для BUY-ордера");
                Price = NormalizeDouble( Ask, Digits);
                Take = IIFd(TP == 0, 0, NormalizeDouble( Ask + TP * Point, Digits));
                Stop = IIFd(SL == 0, 0, NormalizeDouble( Ask - SL * Point, Digits));
                Color = Blue;
                break;
             case OP_SELL:
//                 if (Info) Print("Инициализируем параметры для SELL-ордера");
                 Price = NormalizeDouble( Bid, Digits);
                 Take = IIFd(TP == 0, 0, NormalizeDouble( Bid - TP * Point, Digits));
                 Stop = IIFd(SL == 0, 0, NormalizeDouble( Bid + SL * Point, Digits));
                 Color = Red;
                 break; 
             default:
               Print("!Тип ордера не соответствует требованиям!");
               return(-1);
             }   
       string NameOP=GetNameOP(Type);      
       Slippage = 2*MarketInfo(Symbol(), MODE_SPREAD);      
       if (Info) Print(StringConcatenate("Ордер: ",NameOP," / "," Цена=",Price," / ","Lot=",Lots," / ","Slip=",Slippage," pip"," / ",Cmnt)); 
       
	if(IsTradeAllowed()){
		if (Info) Print(">>>>>Торговля разрешена, отправляем ордер >>>>>");
			Ticket = OrderSend(Symbol(), Type, Lots, Price, Slippage, Stop, Take, Cmnt, magic, 0, Color);
   
		if(Ticket < 0){
         Err = GetLastError();
      if(Err == 4   || /* SERVER_BUSY       */
         Err == 129 || /* ERR_INVALID_PRICE */
         Err == 130 || /* INVALID_STOPS     */ 
         Err == 135 || /* PRICE_CHANGED     */ 
         Err == 137 || /* BROKER_BUSY       */ 
         Err == 138 || /* REQUOTE           */ 
         Err == 146 || /* TRADE_CONTEXT_BUSY*/
         Err == 136 )  /* OFF_QUOTES        */
            {
               if (!IsTesting()){
                  Print(StringConcatenate("Ошибка(OrderSend - ",Err,"): ",ErrorDescription(Err), ")"));
                  Print(StringConcatenate("Ожидаем ",PauseTrade," cek"));
                  Sleep (PauseTrade*1000);
                  Delay = True;
               continue;
               }
            }
               else{
                  Print(StringConcatenate("Критическая ошибка(OrderSend - ",Err,"): ",ErrorDescription(Err), ")"));
                  Error = Err;
               break;
               }
		}
      break;
	}
      else{
         if(Info) Print("Эксперту запрещено торговать! Снята галка в свойствах эксперта.");
      break;
      }
}
   if(Ticket > 0)
      if(Info) Print(StringConcatenate("Ордер отправлен успешно. Тикет = ",Ticket));
   else {
      if(Info) Print(StringConcatenate("Ошибка! Ордер не отправлен. (Код ошибки = ",Error,": ",ErrorDescription(Error), ")"));
   }
   return(Ticket);
}

//=========================================================================================================================================//
// KimIV . Функция "если-то" для double                                                                                                    //
//=========================================================================================================================================//

double IIFd(bool condition, double ifTrue, double ifFalse) 
{if (condition) return(ifTrue); else return(ifFalse);}

//=========================================================================================================================================//
// ir0407 +Qimer+lol. Функция закрытия ордеров                                                                                                       //
//=========================================================================================================================================//  

void CloseOrders(){
bool Delay = False,q;
double  ClosePrice;
color   CloseColor;
int Err,tickS,tickB,tiket;
	if (Info) Print("Функция закрытия ордеров");
		if (!IsTesting()){ //Если мы не в режиме тестирования
			if(!IsExpertEnabled()){
				Error = ERR_TRADE_DISABLED;
				Print("Эксперту запрещено торговать!");
				return;
			}
		if (Info) Print("Эксперту разрешено торговать");
			if(!IsConnected()){
				Error = ERR_NO_CONNECTION;
				Print("Связь отсутствует!");
				return;
			}
		}

		
   if (!IsTesting()){		
      if (Info) Print("Связь с сервером установлена");
   }
 
   if (CloseBy /*&& !IsTesting()*/)
      {
    if (SumLotBuy >0) SendOrder(OP_SELL, SumLotBuy, 0, 0,  MagicNumberCloseby,"Встречный Sell", Error) ;
    if (SumLotSell >0)  SendOrder(OP_BUY, SumLotSell, 0, 0, MagicNumberCloseby, "Встречный Buy", Error) ; 
     /* tickB=0; 
      tickS=0;
	for(int j = OrdersTotal() - 1; j >= 0; j--)  {
	   
            if (OrderSelect(j,SELECT_BY_POS, MODE_TRADES)) 
               {
               if (OrderSymbol() == Symbol() && OrderType() == OP_SELL && OrderMagicNumber()==MagicNumberCloseby) {tickS=OrderTicket(); }
               if (OrderSymbol() == Symbol() && OrderType() == OP_BUY && OrderMagicNumber()==MagicNumberCloseby) {tickB=OrderTicket();}
               }
                                                }*/
       }    
	for(int trade = OrdersTotal() - 1; trade >= 0; trade--){
	  if (CloseBy){
	   tickB=0; 
      tickS=0;
	for(int j = OrdersTotal() - 1; j >= 0; j--)  {
	   
            if (OrderSelect(j,SELECT_BY_POS, MODE_TRADES)) 
               {
               if (OrderSymbol() == Symbol() && OrderType() == OP_SELL && OrderMagicNumber()==MagicNumberCloseby) {tickS=OrderTicket(); }
               if (OrderSymbol() == Symbol() && OrderType() == OP_BUY && OrderMagicNumber()==MagicNumberCloseby) {tickB=OrderTicket();}
               }
                                               }
                 }                             
		if(OrderSelect(trade, SELECT_BY_POS, MODE_TRADES)){
		
			if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber || MagicCheck()){
if (Info) Print("Закрываем ордер #", OrderTicket());
				while(!IsStopped()){
					if(IsTradeContextBusy()){
						Print("Торговый поток занят!");
						Print(StringConcatenate("Ожидаем ",PauseTrade," cek")); 
						Sleep(PauseTrade*1000);
						Delay = True;
					continue;
					}
					
   if (!IsTesting()){		
      if (Info) Print("Торговый поток свободен");
   }					
						if (Delay){
							if (Info) Print("Обновляем котировки");
							RefreshRates();
							Delay = False;
						}
							switch(OrderType()){
								case OP_BUY : ClosePrice = NormalizeDouble(Bid, Digits); CloseColor = Blue; tiket=tickS; break;
								case OP_SELL: ClosePrice = NormalizeDouble(Ask, Digits); CloseColor = Red ; tiket=tickB; break;
							}
							
   int Slippage = 2*MarketInfo(Symbol(), MODE_SPREAD);
      if (Info) Print(StringConcatenate("Цена закрытия=",ClosePrice," / ","Slip = ",Slippage," pip"));  
							if(!IsTradeAllowed()){
								Print("Эксперту запрещено торговать, снята галка в свойствах эксперта!");
								return;
							}
								else 
	{if (CloseBy/* && !IsTesting()*/)	{ q=false; q=OrderCloseBy(OrderTicket(),tiket,CloseColor);}
   else   q=OrderClose(OrderTicket(), OrderLots(), ClosePrice, Slippage, CloseColor);
					if(!q){
						Err = GetLastError();
						if(Err == 4   || /* SERVER_BUSY       */
							Err == 129 || /* ERR_INVALID_PRICE */ 
							Err == 130 || /* INVALID_STOPS     */ 
							Err == 135 || /* PRICE_CHANGED     */ 
							Err == 137 || /* BROKER_BUSY       */ 
							Err == 138 || /* REQUOTE           */ 
							Err == 146 || /* TRADE_CONTEXT_BUSY*/
							Err == 136 ){ /* OFF_QUOTES        */
								Print(StringConcatenate("Ошибка(OrderClose - ",Err,"): ",ErrorDescription(Err), ")")); 
								Print(StringConcatenate("Ожидаем ",PauseTrade," cek")); 
								Sleep(PauseTrade*1000);
								Delay = True;
								continue;
														}
							else{
								Print(StringConcatenate("Критическая ошибка(OrderClose - ",Err,"): ",ErrorDescription(Err), ")"));
								break;
							}
					} 	else break;								
				}  
			}
				 Sleep(100);        // конец while(!IsStopped())	
			}
		}	
	}		
if (Info) Print("Конец функции закрытия ордеров.");
	return;
}
//=========================================================================================================================================//
// shvonder . Перекрытие ордеров                                                                                                           //
//=========================================================================================================================================//

void CheckOverlapping(){
Lpos = 0; Cpos = 0; Lprofit = 0; Cprofit = 0;

GetOrdMaxNinProfit();

   if (totalbuy >= LeadingOrder || totalsell >= LeadingOrder){
      if(Lprofit > 0 && Lprofit1 <= 0 && Cprofit < 0){
         if(Lprofit + Cprofit > 0 && (Lprofit + Cprofit)*100/Lprofit > ProfitPersent){
            Lpos1 = 0;
            CloseSelectOrder();  
         }
      }  else
      
   if(Lprofit > 0 && Lprofit1 > 0 && (totalbuy > LeadingOrder || totalsell > LeadingOrder) && Cprofit < 0 ){
      if(Lprofit + Lprofit1 + Cprofit > 0 && (Lprofit + Lprofit1 + Cprofit)*100/(Lprofit + Lprofit1) > SecondProfitPersent) 
         CloseSelectOrder();         
      }
   } 
}

//=========================================================================================================================================//
// shvonder . Перекрытие ордеров                                                                                                           //
//=========================================================================================================================================//

int CloseSelectOrder(){
if (Info) Print("Функция перекрытия ордеров.");
   int error =  0;
   int error1 = 0;
   int error2 = 0;
   int Result = 0;
   int Slippage = 2*MarketInfo(Symbol(), MODE_SPREAD);
   
//                       ---------------------- последний  -----------------------                            
       
   while (error1 == 0) {
      RefreshRates();
         int i = OrderSelect(Lpos, SELECT_BY_TICKET, MODE_TRADES);
            if (i != 1){
               Print ("Ошибка! Невозможно выбрать ордер с наибольшим профитом. Выполнение перекрытия отменено.");
                  return (0);
            }  
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber || MagicCheck()){
               if (OrderType() == OP_BUY) {
                  error1 =  (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits), Slippage, Blue));
                  if (error1 == 1) {
                     if (Info) Print ("Лидирующий ордер закрыт успешно."); 
                     Sleep (500);   
                  } else {
                     Print ("Ошибка закрытия лидирующего ордера, повторяем операцию. ");                     
                  }      
               } 
               
//                        -----------------------------------------------------   
            
               if (OrderType() == OP_SELL) {
                  error1 = (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits), Slippage, Red));
                  if (error1 == 1) {
                     if (Info) Print ("Лидирующий ордер закрыт успешно"); 
                     Sleep (500);   
                  } else {
                     Print ("Ошибка закрытия лидирующего ордера, повторяем операцию. ");                     
                  }
               }
            } 
      }

//                       ---------------------- пред последний  -----------------------   
                         
   if(Lpos1 != 0){
      while (error2 == 0) {
         RefreshRates();
            i = OrderSelect(Lpos1, SELECT_BY_TICKET, MODE_TRADES);
               if  (i != 1 ){
                  Print ("Ошибка! Невозможно выбрать пред ордер с наибольшим профитом. Выполнение перекрытия отменено.");
                  return (0);
               }  
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber || MagicCheck()){
               if (OrderType() == OP_BUY){
                  error2 =  (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits), Slippage, Blue));
                  if (error2 == 1){
                     if (Info) Print ("Пред Лидирующий ордер закрыт успешно."); 
                     Sleep (500);   
                  } else{
                     Print ("Ошибка закрытия пред лидирующего ордера, повторяем операцию. ");                     
                  }      
               } 
//                        -----------------------------------------------------               
               if (OrderType() == OP_SELL){
                  error2 = (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits), Slippage, Red));
                  if (error2 == 1){
                     if (Info) Print ("Пред Лидирующий ордер закрыт успешно"); 
                     Sleep (500);   
                  } else {
                     Print ("Ошибка закрытия Пред лидирующего ордера, повторяем операцию. ");                     
                  }
               }
            } 
         }
      }
      
//                      ----------- выбранный (обычно с наименьшим профитом ) -----------

   while (error == 0){
      RefreshRates();
         i = OrderSelect(Cpos, SELECT_BY_TICKET, MODE_TRADES);
            if  (i != 1 ){
               Print ("Ошибка! Невозможно выбрать ордер с наименьшим профитом. Выполнение перекрытия отменено.");
               return (0);
            }    
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber || MagicCheck()){
               if (OrderType() == OP_BUY){
                  error = (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits), Slippage, Blue)); 
                  if (error == 1 ){
                     if (Info) Print ("Перекрываемый ордер закрыт успешно."); 
                     Sleep (500);   
                  } else {
                     Print ("Ошибка закрытия перекрываемого ордера, повторяем операцию. ");                    
                  } 
               }        
               
//                             --------------------------------------------------   
             
               if (OrderType() == OP_SELL){
                  error = (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits), Slippage, Red));
                  if (error == 1){
                     if (Info) Print ("Перекрываемый ордер закрыт успешно."); 
                     Sleep (500);   
                  } else {
                     Print ("Ошибка закрытия перекрываемого ордера, повторяем операцию. ");                     
                  }
               }
            }
      }     
       
   Result = 1;
   return (Result);    
}

//=========================================================================================================================================//
// Kordan . Функция удаления объектов                                                                                                      //
//=========================================================================================================================================//

int DeleteObject() {
CloseTrigger=0; TPPrice=0; ZeroLine=0     ;
int    ObjTotal = ObjectsTotal()          ;
string ObName                             ;
   for(int i = 0; i < ObjTotal; i++){
   ObName = ObjectName(i)                 ;
      if(StringSubstr(ObName,0,1) == "I" 
      || StringSubstr(ObName,0,1) == "i"){ 
         ObjectDelete(ObName)             ;
            Comment("")                   ; 
         i = i - 1                        ;
      }
   }
return(0);      
} 

//=========================================================================================================================================//
// Qimer . Отрисовка линий                                                                                                                 //
//=========================================================================================================================================//

void DrawLine(string name,double price, color col, int width){
   if (ObjectFind(name)<0)
      ObjectCreate(name,OBJ_HLINE,0,0,price); 
         else 
            ObjectMove(name,0,Time[1],price);
         ObjectSet(name,OBJPROP_COLOR,col)  ;
      ObjectSet(name,OBJPROP_WIDTH,width)   ;
}

//=========================================================================================================================================//
// Qimer . Отрисовка текста                                                                                                                //
//=========================================================================================================================================//

void DrawText(string name, string txt, double y, color col){  
   if (ObjectFind(name)<0) ObjectCreate(name,OBJ_TEXT,0,Time[WindowFirstVisibleBar()-WindowFirstVisibleBar()/5],y);
      else ObjectMove(name,0,Time[WindowFirstVisibleBar()-WindowFirstVisibleBar()/4],y);
   ObjectSetText(name,txt,10,"Times New Roman",col);
}

//=========================================================================================================================================//
// Kordan . Индикация                                                                                                                      //
//=========================================================================================================================================//   

void Indication (string name,int corner,int Xdist,int Ydist,string txt,int fontsize,string font,color col){
   if (ObjectFind(name)<0)
      ObjectCreate(name,OBJ_LABEL,0,0,0)             ; 
         ObjectSet(name, OBJPROP_CORNER, corner)     ;
            ObjectSet(name, OBJPROP_XDISTANCE, Xdist);
         ObjectSet(name, OBJPROP_YDISTANCE, Ydist)   ;
      ObjectSetText(name,txt,fontsize,font,col)      ; 
} 

//=========================================================================================================================================//
// Функция отрисовки и расчета CCI                                                                                                         //
//=========================================================================================================================================//

double PriceCCI(double Level, int CurrentCandle=0){
double MovBuffer;
double Price, SummPrice, Abs, SummAbs;
double K = 0.015;
int j;
   for(int i=Period_CCI-1; i>=0; i--){
      j=i+CurrentCandle;
         Price = (High[j]+Low[j]+Close[j])/3;
            MovBuffer = iMA(NULL,0,Period_CCI,0,MODE_SMA,PRICE_TYPICAL,CurrentCandle);
               Abs    = MathAbs(Price-MovBuffer);
      if(i>0){
         SummPrice += Price;
            SummAbs+= Abs;
      }
   }
   if(Info==true) {        
      double CCI = (Price-MovBuffer)/((SummAbs+Abs)*K/Period_CCI);
Indication ("ICCI",2,10,45,StringConcatenate("CCI (",DoubleToStr(Level,0),",",Period_CCI,",",CCI_TimeFrame,") = ",DoubleToStr(CCI,0)),FontSize,"Times New Roman",ColorInd);   
   }
      
double H = High[CurrentCandle];
double L =  Low[CurrentCandle];
i = Period_CCI;
   if(CCI>=0){
      CCI=Level;
         Price = -(H*i-L*i*i-H*i*i+L*i-CCI*H*K-CCI*L*K+3*SummPrice*i-
            CCI*3*K*SummPrice+CCI*H*K*i+CCI*L*K*i+CCI*3*K*SummAbs*i)/(i-i*i-CCI*K+CCI*K*i);
   }
      else{
      CCI=-Level;
         Price = -(H*i-L*i*i-H*i*i+L*i+CCI*H*K+CCI*L*K+3*SummPrice*i+
            CCI*3*K*SummPrice-CCI*H*K*i-CCI*L*K*i+CCI*3*K*SummAbs*i)/(i-i*i+CCI*K-CCI*K*i);
   }
if(ObjectFind("ILineCCI")!=-1) ObjectDelete("ILineCCI"    );
if(ObjectFind("ItxtCCI" )!=-1) ObjectDelete("ItxtCCI"     );
   if(Price>H){
      ObjectCreate("ILineCCI", OBJ_HLINE, 0, 0,Price      );
         ObjectSet   ("ILineCCI", OBJPROP_COLOR, SteelBlue);
      DrawText("ItxtCCI",StringConcatenate("CCI < ", DoubleToStr(CCI,0)),Price,SteelBlue );
   }
      else ObjectCreate("ILineCCI", OBJ_HLINE, 0, 0,Price );
   if(Price<L){
      ObjectCreate("ILineCCI", OBJ_HLINE, 0, 0,Price      );
         ObjectSet   ("ILineCCI", OBJPROP_COLOR, Teal     ); 
      DrawText("ItxtCCI",StringConcatenate("CCI > ", DoubleToStr(CCI,0)),Price, Teal     );
   }
      else ObjectCreate("ILineCCI", OBJ_HLINE, 0, 0,Price );           
return(Price);
}

//=========================================================================================================================================//
// shvonder . Функция отрисовки профита и лотов ордеров                                                                                    //
//=========================================================================================================================================//

void SetOrdersInfo(){
int ObjTotal = ObjectsTotal();
   string ObName;
      for(int i = 0; i < ObjTotal; i++){
         ObName = ObjectName(i);
         if(StringSubstr(ObName,0,1) == "i"){ 
            ObjectDelete(ObName);
         i = i - 1;
         }
      }

int TotalBuyOrd = 1;
   for(i=OrdersTotal();i>=0;i--){
      if (OrderSelect(i,SELECT_BY_POS, MODE_TRADES)){
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber || MagicCheck()){  
            if (OrderType()==OP_BUY){ 
               ObjectCreate (StringConcatenate("iB",TotalBuyOrd), OBJ_TEXT, 0, Time[40], OrderOpenPrice());
               ObjectSetText(StringConcatenate("iB",TotalBuyOrd), StringConcatenate("Lot: ",DoubleToStr(OrderLots(), 2)," Prof: ",DoubleToStr(OrderProfit(),2)), 8, "Verdana", DeepSkyBlue);
            TotalBuyOrd = TotalBuyOrd + 1;
            }       
         }
      }
   }
  
int TotalSellOrd = 1;
   for(i=OrdersTotal();i>=0;i--){
      if (OrderSelect(i,SELECT_BY_POS, MODE_TRADES)){
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber || MagicCheck()){ 
            if (OrderType()==OP_SELL){  
               ObjectCreate (StringConcatenate("iS",TotalSellOrd), OBJ_TEXT, 0, Time[40], OrderOpenPrice());
               ObjectSetText(StringConcatenate("iS",TotalSellOrd), StringConcatenate("Lot: ",DoubleToStr(OrderLots(), 2)," Prof: ",DoubleToStr(OrderProfit(),2)), 8, "Verdana", DarkOrange);
            TotalSellOrd = TotalSellOrd + 1;
            }      
         }
      }
   }
}

//=========================================================================================================================================//
// Kordan . Функция главной индикации                                                                                                      //
//=========================================================================================================================================//

void MainIndication() {

   if(ObjectFind("DrawDown")>=0){
        datetime time_coordinate=ObjectGet("DrawDown",OBJPROP_TIME1)      ;
        int shift=iBarShift(Symbol(),0,time_coordinate)    ;
        double price_coordinate=iHigh(Symbol(),0,shift)+(WindowPriceMax()-WindowPriceMin())/20 ;
        bool changed=ObjectSet("DrawDown",OBJPROP_PRICE1,price_coordinate);
    }
  
    if(DrawDownRate<(AccountBalance()+AccountCredit()-AccountEquity()+AccountCredit())/AccountBalance()+AccountCredit()){
        ObjectDelete("DrawDown")                           ;
        DrawDownRate=(AccountBalance()+AccountCredit()-AccountEquity()+AccountCredit())/AccountBalance()+AccountCredit();
        prevar=StringConcatenate(DoubleToStr(DrawDownRate*100,2)," %")    ;
        ObjectCreate("DrawDown",OBJ_ARROW,0,Time[0],High[0]+(WindowPriceMax()-WindowPriceMin())/20);
        ObjectSet("DrawDown",OBJPROP_ARROWCODE,117)        ;
        ObjectSet("DrawDown",OBJPROP_COLOR,DarkOrange)     ;
        ObjectSet("DrawDown",OBJPROP_TIMEFRAMES,0)         ;
        ObjectSetText("DrawDown",prevar)                   ;
    }
 
 
      if (Sredstva >= Balance/6*5) col = ColorInd          ; 
      if (Sredstva >= Balance/6*4 && Sredstva < Balance/6*5) col = DeepSkyBlue ;
      if (Sredstva >= Balance/6*3 && Sredstva < Balance/6*4) col = Gold        ;
      if (Sredstva >= Balance/6*2 && Sredstva < Balance/6*3) col = OrangeRed   ;
      if (Sredstva >= Balance/6   && Sredstva < Balance/6*2) col = Crimson     ;
      if (Sredstva <  Balance/6                            ) col = Red         ;
     
   //-------------------------
   
   string spips;
   int pips=NormalizeDouble((AccountEquity()-AccountStopoutLevel()*AccountEquity()/ 100.0)/Sumlot/TV,0) ;
   string lock=DoubleToStr(NormalizeDouble(Sumlot/100*LockPercent,dig),dig);
      if (Sum_lot!=0){
         string Prof  = StringConcatenate("До профита "  ,DoubleToStr(delta+Tral_Start, 0)," пунктов");  // Число пунктов до профита
         string Bezub = StringConcatenate("До безубытка ",DoubleToStr(delta2, 0)          ," пунктов");  // Число пунктов до безубытка       
            if (Sum_lot <0){
               spips = StringConcatenate("До слива ",pips," пунктов вверх")  ;
               lock  = StringConcatenate("Ордер для лока: Buy ",lock)        ;
            }
               else{ 
                  spips = StringConcatenate("До слива ",pips," пунктов вниз");
                  lock  = StringConcatenate("Ордер для лока: Sell ",lock)    ;
               }
      }
                  else{
                     if (SumLotBuy==0 && SumLotSell==0){
                        spips="Нет ордеров"; Prof=""; Bezub="" ;
                     }
                        else{
                           spips ="Ждем первое колено"         ;
                           Prof  ="Трал отдыхает"              ;
                           Bezub ="Выставлен замок"            ;
                        }
                        lock = StringConcatenate("Процент локового ордера = ",LockPercent);
                  }                                

//==========================  Левый верхний угол  =====================================
     
if (MaxLot!=0) maxLot=MaxLot                                   ; 
   if (IsDemo()) string tip = "Демо"; else tip = "Реал"        ;  
   Comment(  
      "\n", StringConcatenate(" Счет : ",tip," - №: ",AccountNumber()," \ ",AccountCompany()), 
      "\n", StringConcatenate(" Серверное время = ", TimeToStr(TimeCurrent(),TIME_SECONDS))," \ ",NameDayOfWeek(DayOfWeek()),
      "\n", StringConcatenate(" Макс. лот = ",NormalizeDouble(maxLot,dig)," \ "," Мин.  лот = ",NormalizeDouble(minLot,dig)),
      "\n", StringConcatenate(" Плечо = ",AccountLeverage()," : 1  \ "," Спред = ",spr),    
      "\n", StringConcatenate(" Уровни : Заморозки = ",freez," \ "," Стопов = ",stlev," \ "," StopOut = ",AccountStopoutLevel(),"%"), 
      "\n", StringConcatenate(" Свопы : Buy = ",MarketInfo(Symbol(), MODE_SWAPLONG)," \ "," Sell = ",MarketInfo(Symbol(), MODE_SWAPSHORT)), 
      "\n","====================================",
      "\n"
        );   
            
//==========================  Левый нижний угол и центр ===============================

   if ( fixlot        ) string txt="Фиксированный лот"; else txt="Динамический лот"                                         ;
   if (!NewCycle_ON   ) Indication ("INewCycleON",2,10,150,"Запрет начала нового цикла",FontSize,"Times New Roman",ColorInd);
   if (!TradeBuy      ) Indication ("ITradeBuy"  ,2,10,135,"Ручной запрет Buy" ,FontSize,"Times New Roman",ColorInd        );
   if (!TradeSell     ) Indication ("ITradeSell" ,2,10,120,"Ручной запрет Sell",FontSize,"Times New Roman",ColorInd        );
   
if (TipMAFilter==1 || TipMAFilter==2){   
   if (GetMASignal()==1 && GetMASignalS()==-1 || GetMASignalS()==0) Indication ("ILevelBuy" ,2,10,105,"Запрет Buy" ,FontSize,"Times New Roman",ColorInd ); else ObjectDelete("ILevelBuy" );
   if (GetMASignal()==-1 && GetMASignalS()== 1 || GetMASignalS()==0) Indication ("ILevelSell",2,10,90 ,"Запрет Sell",FontSize,"Times New Roman",ColorInd ); else ObjectDelete("ILevelSell");
}   
   
   if (!time()        ) Indication ("Itime",2,10,75 ,"Включен фильтр выходныx дней",FontSize,"Times New Roman",ColorInd); else ObjectDelete("Itime" );
   if (CloseTrigger==1) Indication ("ITrail",2,xDist1,30,"Поздравляю! Пошел трал профита!",FontSize+5,"Courier",Lime   ); else ObjectDelete("ITrail"); 
Indication ("IFixLot",2,10,60 ,txt,FontSize,"Times New Roman",ColorInd);   

//==========================  Правый нижний угол  ===================================== 

Indication ("Ispips"   ,3,10,55 ,spips,FontSize,"Times New Roman",col)     ;      
Indication ("Ilock"    ,3,10,10 ,lock ,FontSize,"Times New Roman",ColorInd);
Indication ("IProf"    ,3,10,40 ,Prof ,FontSize,"Times New Roman",col)     ;  
Indication ("IBezub"   ,3,10,25 ,Bezub,FontSize,"Times New Roman",col)     ;  
Indication ("MaxDrDown",3,10,145,StringConcatenate("Макс. Просадка: ",DoubleToStr(MathMax(DrawDownRate,0)*100,2)," %"),FontSize,"Times New Roman",ColorInd);  
Indication ("IBalance ",3,10,100,StringConcatenate("Баланс   ",DoubleToStr(Balance,        2)),FontSize,"Times New Roman",ColorInd);
Indication ("IEquity  ",3,10,85 ,StringConcatenate("Свободно ",DoubleToStr(FreeMargin     ,2)),FontSize,"Times New Roman",col)     ; 
Indication ("IDrawDown",3,10,70 ,StringConcatenate("Просадка ",DoubleToStr(CurrentDrawdown,2) ,"%"),FontSize,"Times New Roman",col); 

if (Sum_lot!=0) Indication ("ICurUrov" ,3,10,130,StringConcatenate("Уровень: ",DoubleToStr(CurrentUrov,0),"%"),FontSize,"Times New Roman",ColorInd); else ObjectDelete("ICurUrov");

   if (SumProfit <0) color ColProf= LightCoral; else ColProf=Lime;
   if (ProfitBuy <0) color ColBuy = LightPink ; else ColBuy = LightGreen; 
   if (ProfitSell<0) color ColSell= LightPink ; else ColSell= LightGreen; 
   
double       LotsTake = FreeMargin/MarketInfo(Symbol(), MODE_MARGINREQUIRED)              ;  //количество лотов которое можно купить  
Indication ("Ilock"      ,3,10    ,10 , lock,FontSize,"Times New Roman",ColorInd)         ;
Indication ("IPrice"     ,1,10    ,20 , StringConcatenate(""                              ,  DoubleToStr(MarketInfo(Symbol(), MODE_BID) , Digits  )), 40 ,"Times New Roman",DodgerBlue); 
Indication ("ILotTake"   ,2,xDist2,130, StringConcatenate("Можно купить: "                ,  DoubleToStr(LotsTake   ,dig) ," лот"),FontSize,"Times New Roman",ColorInd  );
Indication ("ILot"       ,2,xDist2,115, StringConcatenate("Начальный лот: "               ,  DoubleToStr(Lot        ,dig)), FontSize,"Times New Roman",ColorInd         );      
Indication ("IProfit"    ,2,xDist2,100, StringConcatenate("Тейк профит в валюте депо: "   ,  DoubleToStr(Profit     ,  2)), FontSize,"Times New Roman",ColorInd         );      
Indication ("ISumLotBuy" ,2,xDist2,85 , StringConcatenate("Суммарный объем Buy ордеров: " ,  DoubleToStr(SumLotBuy  ,dig)), FontSize,"Times New Roman",ColorInd         );      
Indication ("ISumLotSell",2,xDist2,70 , StringConcatenate("Суммарный объем Sell ордеров: ",  DoubleToStr(SumLotSell ,dig)), FontSize,"Times New Roman",ColorInd         );      
Indication ("ISumlot"    ,2,xDist2,55 , StringConcatenate("Разность объемов ордеров: "    ,  DoubleToStr(Sumlot     ,dig)), FontSize,"Times New Roman",ColorInd         );
Indication ("IProfitBuy" ,2,xDist2,40 , StringConcatenate("Суммарный профит Buy: "        ,  DoubleToStr(ProfitBuy  ,  2)), FontSize,"Times New Roman",ColBuy           );
Indication ("IProfitSell",2,xDist2,25 , StringConcatenate("Суммарный профит Sell: "       ,  DoubleToStr(ProfitSell ,  2)), FontSize,"Times New Roman",ColSell          );    
Indication ("ISumProfit" ,2,xDist2,10 , StringConcatenate("Суммарный профит: "            ,  DoubleToStr(SumProfit  ,  2)), FontSize,"Times New Roman",ColProf          );     
      
   //-------------------------                                        
   
   if (totalbuy>MaxTrades || totalsell>MaxTrades) string Integra="Ограничение числа колен"; else Integra="Integra 2.7.18";   
      Indication ("IIntegra",2,10,25,Integra,FontSize,"Times New Roman",ColorInd);      
}

//+----------------------------------------------------------------------------+
//|  Автор    : Ким Игорь В. aka KimIV,  http://www.kimiv.ru                   |
//+----------------------------------------------------------------------------+
//|  Версия   : 01.09.2005                                                     |
//|  Описание : Возвращает наименование дня недели                             |
//+----------------------------------------------------------------------------+
//|  Параметры:                                                                |
//|    ndw - номер дня недели                                                  |
//+----------------------------------------------------------------------------+
string NameDayOfWeek(int ndw){
   if (ndw==0) return("Воскресенье") ;
   if (ndw==1) return("Понедельник") ;
   if (ndw==2) return("Вторник"    ) ;
   if (ndw==3) return("Среда"      ) ;
   if (ndw==4) return("Четверг"    ) ;
   if (ndw==5) return("Пятница"    ) ;
   if (ndw==6) return("Суббота"    ) ;
}  

//+----------------------------------------------------------------------------+
//|  Автор    : Ким Игорь В. aka KimIV,  http://www.kimiv.ru                   |
//+----------------------------------------------------------------------------+
//|  Версия   : 01.09.2005                                                     |
//|  Описание : Возвращает наименование торговой операции                      |
//+----------------------------------------------------------------------------+
//|  Параметры:                                                                |
//|    op - идентификатор торговой операции                                    |
//+----------------------------------------------------------------------------+
string GetNameOP(int op){
   switch (op) {
      case OP_BUY      : return("BUY"       );
      case OP_SELL     : return("SELL"      );
      case OP_BUYLIMIT : return("BUY LIMIT" );
      case OP_SELLLIMIT: return("SELL LIMIT");
      case OP_BUYSTOP  : return("BUY STOP"  );
      case OP_SELLSTOP : return("SELL STOP" );
      default          : return("Unknown Operation");
   }
}

//=========================================================================================================================================//
//                                                                                                                                         //
//=========================================================================================================================================//

void CloseThisSymbolAll(int _MN, int _ot=-1){
double slip=MarketInfo(Symbol(), MODE_SPREAD)*2;
   for (int trade = OrdersTotal() - 1; trade >= 0; trade--){
      OrderSelect(trade, SELECT_BY_POS, MODE_TRADES);{
         if (OrderSymbol() == Symbol() && (OrderMagicNumber() == _MN || MagicCheck()) && (OrderType() == _ot || _ot == -1)){
            RefreshRates();
            if (OrderType() == OP_BUY ) OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits), slip, Blue);
            if (OrderType() == OP_SELL) OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits), slip, Red );
         Sleep(1000);
         }
      }
   }
}

//INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA=INTEGRA