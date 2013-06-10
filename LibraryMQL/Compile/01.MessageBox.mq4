 #include <WinUser32.mqh>
int start()                                      
  {
//     int ret0=MessageBox("Функция ObjectCreate() вернула ошибку "+GetLastError()+" Продолжить?", "Question", MB_OK|MB_ICONQUESTION);
//     if (ret0==IDOK){
//         Alert("You click OK");
//         }
//	int ret0=MessageBox("Функция ObjectCreate() вернула ошибку "+GetLastError()+" Продолжить?", "Question", MB_OKCANCEL|MB_ICONQUESTION);
//	if (ret0==IDOK){
//    	 Alert("You click OK");
//      }
//    if (ret0==IDCANCEL){
//    	 Alert("You click CANCEL");
//      }
//	int ret0=MessageBox("Функция ObjectCreate() вернула ошибку "+GetLastError()+" Продолжить?", "Question", MB_ABORTRETRYIGNORE|MB_ICONQUESTION);
//	if (ret0==IDABORT){
//    	 Alert("You click ABORT");
//      }
//    if (ret0==IDRETRY){
//    	 Alert("You click RETRY");
//     }
//     if (ret0==IDIGNORE){
//    	 Alert("You click IGNORE");
//     }
	int ret0=MessageBox("Функция ObjectCreate() вернула ошибку "+GetLastError()+" Продолжить?", "Question", MB_YESNOCANCEL|MB_ICONQUESTION);
	if (ret0==IDYES){
    	 Alert("You click YES");
      }
    if (ret0==IDNO){
    	 Alert("You click NO");
     }
     if (ret0==IDCANCEL){
    	 Alert("You click CANCEL");
     }
//     int ret=MessageBox("Функция ObjectCreate() вернула ошибку "+GetLastError()+" Продолжить?", "Question", MB_YESNO|MB_ICONQUESTION);
//     if (ret==IDYES){
//         Alert("You click YES");
//         }
//     if (ret==IDNO){
//         Alert("You click NO");
//         }
//	int ret0=MessageBox("Функция ObjectCreate() вернула ошибку "+GetLastError()+" Продолжить?", "Question", MB_RETRYCANCEL|MB_ICONASTERISK);
//	if (ret0==IDRETRY){
//    	 Alert("You click RETRY");
//      }
//    if (ret0==IDCANCEL){
//    	 Alert("You click CANCEL");
//     }

//По заказу сделано так что тепрь не компилится
//	int ret0=MessageBox("Функция ObjectCreate() вернула ошибку "+GetLastError()+" Продолжить?", "Question", MB_CANCELTRYCONTINUE|MB_ICONQUESTION);
//		if (ret0==IDCANCEL){
//	    	 Alert("You click CANCEL");
//	     }
//	    if (ret0==IDTRYAGAIN){
//	    	 Alert("You click TRYAGAIN");
//	     }
//	    if (ret0==IDCONTINUE){
//	     	Alert("You click CONTINUE");
//	   	}
return;                                       
}
  