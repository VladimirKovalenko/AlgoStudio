int start()
{
	
	double q=		iAC(NULL, 0, 0);
	double w=		iAD(NULL, 0, 0);
	double e=		iAlligator(NULL, 0, 13, 8, 8, 5, 5, 3, MODE_SMMA, PRICE_MEDIAN, MODE_GATORJAW, 1);
	double r=		iADX(NULL,0,14,PRICE_HIGH,MODE_MAIN,0);
//	double t=		iATR(NULL,0,12,0);
	double y=		iAO(NULL, 0, 2);
	double u=		iBearsPower(NULL, 0, 13,PRICE_CLOSE,0);
	double i=		iBands(NULL,0,20,2,0,PRICE_LOW,MODE_LOWER,0);
//	double o=		iBandsOnArray(ExtBuffer,total,2,0,0,MODE_LOWER,0);//Расчет индикатора Bollinger Bands на данных, хранящихся в массиве.
	double p=		iBullsPower(NULL, 0, 13,PRICE_CLOSE,0);
	double s=		iFractals(NULL, 0, MODE_UPPER, 3);
	double a=		iForce(NULL, 0, 13,MODE_SMA,PRICE_CLOSE,0);
//	double d=	iEnvelopesOnArray(ExtBuffer,10,13,MODE_SMA,0,0.2,MODE_UPPER,0);//Расчет индикатора Envelopes на данных, хранящихся в массиве. 
	double f=		iEnvelopes(NULL, 0, 13,MODE_SMA,10,PRICE_CLOSE,0.2,MODE_UPPER,0);	
	double g=		iDeMarker(NULL, 0, 13, 1);
	double h=		iCustom(NULL, 0, "SampleInd",13,1,0);
//	double j=	iCCIOnArray(ExtBuffer,total,12,0);//Расчет индикатора Commodity Channel Index на данных, хранящихся в массиве.
	double k=		iCCI(Symbol(),0,12,PRICE_TYPICAL,0);
//	double l=	iStdDevOnArray(ExtBuffer,100,10,0,MODE_EMA,0);//Расчет индикатора Standard Deviation на данных, хранящихся в массиве
	double l=		iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0);
	double z=		iWPR(NULL,0,14,0);
	double x=		iStdDev(NULL,0,10,0,MODE_EMA,PRICE_CLOSE,0);
	double c=		iRVI(NULL, 0, 10,MODE_MAIN,0);
//	double v=	iRSIOnArray(ExtBuffer,1000,14,0);//Расчет индикатора Standard Deviation на данных, хранящихся в массиве
	double b=		iRSI(NULL,0,14,PRICE_CLOSE,0);
	double n=		iSAR(NULL,0,0.02,0.2,0);
	double m=		iOBV(NULL, 0, PRICE_CLOSE, 1);
	double qq=		iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
	double ww=		iOsMA(NULL,0,12,26,9,PRICE_OPEN,1);
//	double ee=	iMAOnArray(ExtBuffer,0,5,0,MODE_LWMA,0);//Расчет индикатора Standard Deviation на данных, хранящихся в массиве
	double rr=		iMA(NULL,0,13,8,MODE_SMMA,PRICE_MEDIAN,0);
	double tt=		iMFI(NULL,0,14,0);
//	double yy=	iMomentumOnArray(mybuffer,100,12,0);//Расчет индикатора Momentum на данных, хранящихся в массиве.
	double uu=		iMomentum(NULL,0,12,PRICE_CLOSE,0);
	double ii=		iBWMFI(NULL, 0, 0);
	double oo=		iIchimoku(NULL, 0, 9, 26, 52, MODE_TENKANSEN, 1);
	double pp=		iGator(NULL, 0, 13, 8, 8, 5, 5, 3, MODE_SMMA, PRICE_MEDIAN, MODE_UPPER, 1);
  return(0);
}

