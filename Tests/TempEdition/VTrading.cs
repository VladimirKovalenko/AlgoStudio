using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using com.pfsoft.proftrading.message;
using com.pfsoft.proftrading;
using PTLRuntime.NETScript;

namespace UnitTester
{
    public partial class MT4Funcs
    {
        [TestMethod]
        public void VTrading()
        {
            //OrderPrint не проверяется посольку функция воиди и делает прсто прин в аутпут АС.

            //чистим датакеш
            BaseApplication.TestApplication.MultiDataCache.DCache.clean();

            //кладем деньги
            UpdateBalance(10000);

            //сообщаем котировку
            double bid = 1.12345;
            double ask = 1.22345;
            string symbol = "EURUSD";
            DateTime now = System.DateTime.Now;
            UpdateQuote("EUR/USD", bid, ask, now);

            //параметры для OrderSend
            int cmd = 1;
            int volume = 1;
            double price = bid;
            int slippage=30;
            double stoploss=0;
            double tareprofit=0;
            string comment = "";
            int magic=123;
            //int expiration=NETScriptBase.TimeToInt(now.Ticks+10000000);
            int expiration = 0;
            int arrow_color = mql4.Black;
            

            //Отправка ордера
            int ticket = mql4.OrderSend(symbol, cmd, volume, price, slippage, stoploss, tareprofit, comment, magic, expiration, arrow_color);
            Assert.AreEqual(0, mql4.GetLastError());

            Assert.IsTrue(ticket > 0);
            Assert.AreEqual(0, mql4.GetLastError());

            //Выбираем поставленный ордер для дальнейшей работы
             //by number
            Assert.IsTrue(mql4.OrderSelect(ticket, 1));
            Assert.IsFalse(mql4.OrderSelect(-1, 1));
            Assert.IsFalse(mql4.OrderSelect(12345, 1));

            //by position in trades
            Assert.IsTrue(mql4.OrderSelect(0, 0, 0));
            Assert.IsFalse(mql4.OrderSelect(-1, 0, 0));
            Assert.IsFalse(mql4.OrderSelect(12345, 0, 0));

            mql4.OrderSelect(ticket, 1);
            //Возвращает тип операции текущего выбранного ордера
            Assert.AreEqual(cmd, mql4.OrderType());
            Assert.AreEqual(0, mql4.GetLastError());
            //Возвращает номер тикета для текущего выбранного ордера.
            Assert.AreEqual(ticket, mql4.OrderTicket());
            Assert.AreEqual(0, mql4.GetLastError());
            //Возвращает значение цены закрытия позиции при достижении уровня убыточности (stop loss) для текущего выбранного ордера.
            Assert.AreEqual(stoploss, mql4.OrderStopLoss());
            Assert.AreEqual(0, mql4.GetLastError());
            //Возвращает значение цены закрытия позиции при достижении уровня прибыльности (take profit) для текущего выбранного ордера
            //double TakeProfit = OrderTakeProfit();
            Assert.AreEqual(tareprofit, mql4.OrderTakeProfit());
            //Возвращает наименование финансового инструмента для текущего выбранного ордера.
            //string Symb = OrderSymbol();
            Assert.AreEqual(symbol, mql4.OrderSymbol());
            //Возвращает значение свопа для текущего выбранного ордера.
            //double swap = OrderSwap();
            Assert.AreEqual(0, mql4.OrderSwap());
            //Возвращает общее количество открытых и отложенных ордеров.
            //int total = OrdersTotal();
            Assert.AreEqual(1, mql4.OrdersTotal());
            //Возвращает количество закрытых позиций и удаленных ордеров в истории текущего счета, загруженной в клиентском терминале.
            //int accTotal = OrdersHistoryTotal();
            Assert.AreEqual(0, mql4.OrdersHistoryTotal());
            //Возвращает значение чистой прибыли (без учёта свопов и комиссий) для выбранного ордера.
            //double profit = OrderProfit();
            double prof = mql4.OrderProfit();
            double lotsize=mql4.MarketInfo(mql4.Symbol(), 15);
            //Возвращает время открытия выбранного ордера.	
            //datetime OpTime = OrderOpenTime();
            Assert.AreEqual(NETScriptBase.TimeToInt(now.Ticks), mql4.OrderOpenTime());
            //Возвращает цену открытия для выбранного ордера.
            //double ClPr = OrderOpenPrice();
            Assert.AreEqual(price, mql4.OrderOpenPrice());
            //Возвращает идентификационное ("магическое") число для выбранного ордера.
            //int Mag = OrderMagicNumber();


            Assert.AreEqual(volume, mql4.OrderLots(), 0.00001);
            
            

            Assert.AreEqual(0, mql4.OrderCloseTime());
            Assert.AreEqual(ask, mql4.OrderClosePrice());
            Assert.AreEqual("", mql4.OrderComment());
            Assert.AreEqual(0, mql4.OrderCommission());

            Assert.IsTrue(mql4.OrderClose(ticket, 1, ask, 10));
            Assert.AreEqual(0, mql4.GetLastError());
        }
    }
}
