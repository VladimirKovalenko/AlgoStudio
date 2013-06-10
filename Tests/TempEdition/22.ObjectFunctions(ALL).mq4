datetime DT1=D'2013.02.06 9:45:00';
datetime DT2=D'2013.02.06 11:00:00';
datetime DT3=D'2013.02.06 13:15:00';
double Price1=1.35450;
double Price2=1.35550;
double Price3=1.35650;

int start()	{
	for(int i=0;i<1000; i++){
		// Создание всех объектов   
		//--------------------------------------------- 
		bool OBJ_VLINE1=ObjectCreate("OBJ_VLINE1",OBJ_VLINE,0,DT1,1.3);
		bool OBJ_HLINE1=ObjectCreate("OBJ_HLINE1",OBJ_HLINE,0,D'2013.02.06 11:00:00',Price1);
		bool OBJ_TREND1=ObjectCreate("OBJ_TREND1",OBJ_TREND,0,DT1,Price1,DT2,Price2);
		bool OBJ_TRENDBYANGLE1=ObjectCreate("OBJ_TRENDBYANGLE1",OBJ_TRENDBYANGLE,0,DT1,Price1,DT2,Price2);
		bool OBJ_REGRESSION1=ObjectCreate("OBJ_REGRESSION1",OBJ_REGRESSION,0,DT1,Price1,DT2,Price2);
		bool OBJ_CHANNEL1=ObjectCreate("OBJ_CHANNEL1",OBJ_CHANNEL,0,DT1,Price1,DT2,Price2,DT3,Price3);
		bool OBJ_STDDEVCHANNEL1=ObjectCreate("OBJ_STDDEVCHANNEL1",OBJ_STDDEVCHANNEL,0,DT1,Price1,DT2,Price2);
		bool OBJ_GANNLINE1=ObjectCreate("OBJ_GANNLINE1",OBJ_GANNLINE,0,DT1,Price1,DT2,Price2);
		bool OBJ_GANNFAN1=ObjectCreate("OBJ_GANNFAN1",OBJ_GANNFAN,0,DT1,Price1,DT2,Price2);
		bool OBJ_GANNGRID1=ObjectCreate("OBJ_GANNGRID1",OBJ_GANNGRID,0,DT1,Price1,DT2,Price2);
		bool OBJ_FIBO1=ObjectCreate("OBJ_FIBO1",OBJ_FIBO,0,DT1,Price1,DT2,Price2);
		bool OBJ_FIBOTIMES1=ObjectCreate("OBJ_FIBOTIMES1",OBJ_FIBOTIMES,0,DT1,Price1,DT2,Price2);
		bool OBJ_FIBOFAN1=ObjectCreate("OBJ_FIBOFAN1",OBJ_FIBOFAN,0,DT1,Price1,DT2,Price2);
		bool OBJ_EXPANSION1=ObjectCreate("OBJ_EXPANSION1",OBJ_EXPANSION,0,DT1,Price1,DT2,Price2,DT3,Price3);
		bool OBJ_FIBOCHANNEL1=ObjectCreate("OBJ_FIBOCHANNEL1",OBJ_FIBOCHANNEL,0,DT1,Price1,DT2,Price2,DT3,Price3);
		bool OBJ_RECTANGLE1=ObjectCreate("OBJ_RECTANGLE1",OBJ_RECTANGLE,0,DT1,Price1,DT2,Price2);
		bool OBJ_TRIANGLE1=ObjectCreate("OBJ_TRIANGLE1",OBJ_TRIANGLE,0,DT1,Price1,DT2,Price2,DT3,Price3);
		bool OBJ_ELLIPSE1=ObjectCreate("OBJ_ELLIPSE1",OBJ_ELLIPSE,0,DT1,Price1,DT2,Price2);
		bool OBJ_PITCHFORK1=ObjectCreate("OBJ_PITCHFORK1",OBJ_PITCHFORK,0,DT1,Price1,DT2,Price2,DT3,Price3);
		bool OBJ_CYCLES1=ObjectCreate("OBJ_CYCLES1",OBJ_CYCLES,0,DT1,Price1,DT2,Price2);
		bool OBJ_TEXT1=ObjectCreate("OBJ_TEXT1",OBJ_TEXT,0,DT1,Price1);
		bool OBJ_ARROW1=ObjectCreate("OBJ_ARROW1",OBJ_ARROW,0,DT1,Price1);
		bool OBJ_LABEL1=ObjectCreate("OBJ_LABEL1",OBJ_LABEL,0,DT1,Price1);
		//--------------------------------------------- 
		
		
		//ObjectDescription для объектов типа OBJ_TEXT и OBJ_LABEL
		//--------------------------------------------- 
		string OD1=ObjectDescription("OBJ_TEXT1");
		string OD2=ObjectDescription("OBJ_LABEL1");
		//--------------------------------------------- 
		
		
		//Поиск объекта с указанным именем.
		//--------------------------------------------- 
		bool OF=ObjectFind("OBJ_VLINE1");
		//--------------------------------------------- 
		
		
		//Возвращаем значение указанного свойства объекта.
		//--------------------------------------------- 
		datetime OG1=ObjectGet("OBJ_FIBOCHANNEL1",OBJPROP_TIME1);
		double OG2=ObjectGet("OBJ_FIBOCHANNEL1",OBJPROP_PRICE2);
		color OG3=ObjectGet("OBJ_VLINE1",OBJPROP_COLOR);
		double OG4=ObjectGet("OBJ_VLINE1",OBJPROP_STYLE);
		double OG5=ObjectGet("OBJ_VLINE1",OBJPROP_WIDTH);
		int OG6=ObjectGet("OBJ_ARROW1",OBJPROP_ARROWCODE);
		int OG7=ObjectGet("OBJ_ARROW1",OBJPROP_TIMEFRAMES);
		bool OG8=ObjectGet("OBJ_FIBOARC1",OBJPROP_ELLIPSE);
		int OG9=ObjectGet("OBJ_LABEL1",OBJPROP_FONTSIZE);
		int OG10=ObjectGet("OBJ_LABEL1",OBJPROP_CORNER);
		int OG11=ObjectGet("OBJ_LABEL1",OBJPROP_XDISTANCE);
		int OG12=ObjectGet("OBJ_LABEL1",OBJPROP_YDISTANCE);
		bool OG13=ObjectGet("OBJ_TREND1",OBJPROP_BACK);
		bool OG14=ObjectGet("OBJ_TREND1",OBJPROP_RAY);
		double OG15=ObjectGet("OBJ_TREND1",OBJPROP_SCALE);
		double OG16=ObjectGet("OBJ_FIBOCHANNEL1",OBJPROP_FIBOLEVELS);
		color OG17=ObjectGet("OBJ_FIBOCHANNEL1",OBJPROP_LEVELCOLOR);
		double OG18=ObjectGet("OBJ_FIBOCHANNEL1",OBJPROP_LEVELSTYLE);
		double OG19=ObjectGet("OBJ_FIBOCHANNEL1",OBJPROP_LEVELWIDTH);
		double OG20=ObjectGet("OBJ_FIBOCHANNEL1",OBJPROP_FIRSTLEVEL+3);
		bool OG21=ObjectGet("OBJ_TRENDBYANGLE1",OBJPROP_ANGLE);
		bool OG22=ObjectGet("OBJ_STDDEVCHANNEL1",OBJPROP_DEVIATION);
		//--------------------------------------------- 
		
		
		//Функции Set/Get ObjectFiboDescription
		//--------------------------------------------- 
		bool OSFD=ObjectSetFiboDescription("OBJ_FIBOFAN1",2,"BVB");			//присваиваем новое описание уровню объекта Фибоначчи
		string OGFD=ObjectGetFiboDescription("OBJ_FIBOFAN1",2);				//Функция возвращает описание уровня объекта Фибоначчи.
		//--------------------------------------------- 
		
		//Функции  ObjectShiftByValue
		//--------------------------------------------- 
		int OGSBV=ObjectGetShiftByValue("OBJ_TREND1",Price1);				//Функция вычисляет и возвращает номер бара (смещение относительно текущего бара) для указанной цены.
		double OGVBS=ObjectGetValueByShift("OBJ_TREND1",2);					//Функция вычисляет и возвращает значение цены для указанного бара (смещение относительно текущего бара).
		//--------------------------------------------- 
		
		//Меняем одну из координат
		//--------------------------------------------- 
		bool OM1=ObjectMove("OBJ_FIBOCHANNEL1", 0,DT1+600,(Price1+30*Point));
		//--------------------------------------------- 
		
		//Устанавливаем новое значение
		//--------------------------------------------- 
		bool OS1=ObjectSet("OBJ_FIBOCHANNEL1",OBJPROP_TIME1,DT1+600);
		bool OS2=ObjectSet("OBJ_FIBOCHANNEL1",OBJPROP_PRICE2, (Price1+20*Point));
		bool OS3=ObjectSet("OBJ_VLINE1",OBJPROP_COLOR,447);
		bool OS4=ObjectSet("OBJ_VLINE1",OBJPROP_STYLE,2);
		bool OS5=ObjectSet("OBJ_VLINE1",OBJPROP_WIDTH,5);
		bool OS6=ObjectSet("OBJ_ARROW1",OBJPROP_ARROWCODE,138);
		bool OS7=ObjectSet("OBJ_ARROW1",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M30);
		bool OS8=ObjectSet("OBJ_FIBOARC1",OBJPROP_ELLIPSE,1);
		bool OS9=ObjectSet("OBJ_LABEL1",OBJPROP_FONTSIZE,15);
		bool OS10=ObjectSet("OBJ_LABEL1",OBJPROP_CORNER,1);
		bool OS11=ObjectSet("OBJ_LABEL1",OBJPROP_XDISTANCE,135);
		bool OS12=ObjectSet("OBJ_LABEL1",OBJPROP_YDISTANCE,235);
		bool OS13=ObjectSet("OBJ_TREND1",OBJPROP_BACK,1);
		bool OS14=ObjectSet("OBJ_TREND1",OBJPROP_RAY,1);
		bool OS15=ObjectSet("OBJ_TREND1",OBJPROP_SCALE,2);
		bool OS16=ObjectSet("OBJ_FIBOCHANNEL1",OBJPROP_FIBOLEVELS,16);
		bool OS17=ObjectSet("OBJ_FIBOCHANNEL1",OBJPROP_LEVELCOLOR,447);
		bool OS18=ObjectSet("OBJ_FIBOCHANNEL1",OBJPROP_LEVELSTYLE,STYLE_DASHDOTDOT);
		bool OS19=ObjectSet("OBJ_FIBOCHANNEL1",OBJPROP_LEVELWIDTH,5);
		bool OS20=ObjectSet("OBJ_FIBOCHANNEL1",OBJPROP_FIRSTLEVEL+3,0.0268);
		bool OS21=ObjectSet("OBJ_TRENDBYANGLE1",OBJPROP_ANGLE,30);
		bool OS22=ObjectSet("OBJ_STDDEVCHANNEL1",OBJPROP_DEVIATION,5);
		bool OS23=ObjectSetText("OBJ_TEXT1","Проверка",17,"Times New Roman", Green);
		//--------------------------------------------- 
		
		//Возвращает общее число объектов указанного типа на графике.
		//--------------------------------------------- 
		int OT=ObjectsTotal();
		//--------------------------------------------- 
		
		//Возвращаем имя и тип объктов
		//--------------------------------------------- 
		for(int j=0;j<25;j++)
		{
		string ObjN=ObjectName(j);
		int ObjT=ObjectType(ObjN);
		}
		//--------------------------------------------- 
		
		
		//Удаление
		//--------------------------------------------- 
		bool ODel=ObjectDelete("OBJ_HLINE1");
		
		int ObDelA=ObjectsDeleteAll();
		//--------------------------------------------- 
		
		
		}
  return(0);
}
