//----------------------------------------------------------
//�������������� timeframe 1 ������, ����� ��� ��� �������� �������� �������� � BarsCount.
	int g1,counter1,g4,i5,h10,t11,p12;
	string c1,s2,x7,y7,z7,���8;
    bool c2,��df3,u13=true;
    int Sum6,i6,ff9;
int init()
{

  return(0);
}

int deinit()
{
    //(1
	if(c1=="PFSoft" || c2==true){
        Print("1 check successfully complete");
        }
  else Print("1 check failed");
    //1)
    //(2
    if (s2=="����") Alert("2 check successfully complete");
    else Print("2 check failed");
    //2)
    //(3
    if (��df3==true) Print("3 check successfully complete");
    else Print("3 check failed");
    //3)
    //(4
    if (g4==4) Print("4 check successfully complete");
    else Print("4 check failed");
    //4)
    //(5
    if (i5/33==3) Print("5 check successfully complete");
    else Print("5 check failed");
    //5)
    //(6
      if (i6==8 && Sum6>=100) Print("6 check successfully complete");
      else Print("6 check failed");
    //6)
    //(7
    	if(x7=="ort" && y7=="ntv" && z7=="tnt") Print("7 check successfully complete");
      else Print("7 check failed");
    //7)
    //(8
    	if (���8=="~!@#$%^&*()_+") Print("8 check successfully complete");
      else Print("8 check failed");
    //8)
    //(9
      if (ff9 == 0) Print("9 check successfully complete");
      else Print("9 check failed");
    //9)
    //(10
    	if (h10==81)Print("10 check successfully complete");
      else Print("10 check failed");
    //10)
    //(11
    if (t11==0)Print("11 check successfully complete");
    else Print("11 check failed");
    //11)
    //(12
    if ((p12-127)==0)Print("12 check successfully complete");
    else Print("12 check failed");
    //12)
    //(13
    if (u13!=true)Print("13 check successfully complete");
    else Print("13 check failed");
    //13)
  return(0);
}

int start()
{
    //1)������� ��������----------------------------------------------------------
    //�� ����� ������ ��������� ���-�� ���� do =MetaTrader
//  g1=BarsCount(Symbol(), 1);	//׸ �� ����� �� �����
	for(int i1=0; i1<10; i1++){
    	c1=" =MetaTrader";
    	Comment(i1,c1);
    	if(i1==9){
        	counter1++;
        	if(counter1/4==g1){
            	c1="PFSoft";
        		c2=true;
            	}
        	}
    	}
	//---------------------------------------------------------- 
    //2)��� �������� ������----------------------------------------------------------
   for(int ����=-10; ����<0; ����++) s2="����";
	//---------------------------------------------------------- 
	//3)����������� ���������_1---------------------------------------------------------- 
	int FF3=0;
	for(; FF3!=10; FF3++){
    	Comment(FF3," =AAA");}
    	if(FF3==10) ��df3=true; 
    	else ��df3=false;
	//---------------------------------------------------------- 
	//4)����������� �������---------------------------------------------------------- 
	for(int h4=5;;h4++){Comment(h4);if(h4>10){ g4=4; break;}}
    //---------------------------------------------------------- 
    //5)��������. ��������� � �������. ��������� while---------------------------------------------------------- 
	for(;;){
    	while(i5<100){
        	i5++;
        	}
        	i5=99;
        	break;
    	}
    //---------------------------------------------------------- 
    //6)���� ������������������ ����� �����: 1 2 3 4 5 6 7 8 9 10 11 ...�������k ���������, ����������� ����� ��������� ���� ������������������, ������� � ������ N1, ���������� ������� N2.---------------------------------------------------------- 
    //   Sum6 - ����� �����, i6 - �������� �������� (�������)
    int 
    Nom6,                          // ����� ������� ��������
    Num6;                               // ����� ������� ��������
    Nom6=3;                              // ����� ��������� ��������
    Num6=7;                              // ����� ��������� ��������
    for(i6=Nom6; i6<=Num6; i6++)           // ��������� ��������� �����
     {                                   // ������ ������ ���� �����
      Sum6=Sum6 + i6;                       // ����� �������������
      Print(Sum6);
     }                                   // ������ ����� ���� �����
	//---------------------------------------------------------- 
	//7)��������� double � �������. � switch ������ �����---------------------------------------------------------- 
	double qwe7=0;
	for(double i7=0; i7<100; i7++){
    	qwe7=qwe7+i7;
    	switch (qwe7)
		{
		    case 6: 
		        x7="ort";
		        break;
		    case 10:
		        y7="ntv";
		        break;
		    case 21:
		        z7="tnt";
		        break;
		    default:
		        break;
		}
    	}
	//---------------------------------------------------------- 
	//8)2 ������� ���������---------------------------------------------------------- 
	//	������ ���� ������ ��� ����������� ����, ���� ���������
	int q4q8=1;
	for(int i8=0; i8<10; i8+=2){
    	if(i8+q4q8!=0 && (i8+q4q8-(i8+q4q8))%2==q4q8-1){
    		for(int y8=10; y8<=12; y8++){
        		���8="~!@#$%^&*()_+";
        		}
    		}
    	}
	//----------------------------------------------------- 
	//9)3 ������� ���������---------------------------------------------------------- 
	double g9=0,gg9=0,h9=0,hh9=0,t9=0,tt9=0;
	for(int i9=0; i9<10; i9++){
    	g9=AccountEquity();
    	gg9=gg9+g9;
    	for(int j9=10; j9<20; j9++){
        	h9=AccountEquity();
    		hh9=hh9+h9;
        	for(int k9=0; k9>-10; k9--){
	        	t9=AccountEquity();
	    		tt9=tt9+t9;
        		}
        	}	
    	}
    	int ff9=((gg9+hh9/10+tt9/100)/30);  
	//----------------------------------------------------- 
	//10)������� �������� ����� �� 2 �� 10----------------------------------------------------------
	int x10=1, b10,g10;
	for(;;)
	  {
	   x10++;
       b10=MathPow(x10,2);
       if(x10==9) h10=b10;
	   if(x10==5){
    	   	continue;
    	   }
	   if(x10>=10)break;
	  }
  	//----------------------------------------------------- 
	//11)��������� � ���������, ��������� ������� � ���������----------------------------------------------------------
     	for(int i, j=0;i>-10 || j<10;i--, j++)
			{
    			t11=j+i;
    		}
	//----------------------------------------------------- 
	//12) �� ��������� � �� ���������.---------------------------------------------------------------------------------
       p12=0;
       for(int y=1;y<100; y*=2){
		   p12=p12+y;                      
           }
	//----------------------------------------------------- 
	//13) bool �������.---------------------------------------------------------------------------------
        for(int g=0; u13==true; g++){
            if(g>=10) u13=false;
            }

  return(0);
}
