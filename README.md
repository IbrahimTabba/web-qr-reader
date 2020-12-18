
# Web QR-Code Reader
QR-Code reader library for **flutter web**.
  Since all flutter QR-Code reader plugins works only on Android/IOS and not supported for web.
  This library provides all basic functionality to implement QR-Reader for web (data stream / pause / resume).

![allow access](https://github.com/IbrahimTabba/web-qr-reader/blob/0.0.1/example/images/1.png?raw=true)

![scan qr](https://github.com/IbrahimTabba/web-qr-reader/blob/0.0.1/example/images/2.png?raw=true)


## How to use 
 -  add dependencies into you project pubspec.yaml file
	```
	dependencies:
	  web_qr_reader: latest_version
	```
 -  add  `WebQrReader` where you want to show web cam QR-reader .
	```
		WebQrReader(  controller: controller,  )
	```
 -  you can handle camera state with `WebQrReaderController`
	```
		Row(  
		  mainAxisAlignment: MainAxisAlignment.center,  
		  children: [  
		    MaterialButton(  
		      onPressed: () { controller.pause(); },  
		  child: Text(  
		        'Pause'  
		  ),  
		  ),  
		  MaterialButton(  
		      onPressed: () { controller.play(); },  
		  child: Text(  
		        'Resume'  
		  ),  
		  )  
		  ],  
		)
	```
	4.  to get the content of QR image there are two methods : 
		 
		 - listen for the `WebQrReaderController` value :
			```
			controller.addListener(() {  
			  print(controller.value.qrContent);  
			});
			```
		- listen for the `WebQrReaderController` stream:
			```
				StreamBuilder(  
				  stream: controller.scannedDataStream,  
				  builder: (context,AsyncSnapshot<String> snapshot){  
				    if(snapshot.hasData){  
				      return Text('${snapshot.data}');  
				  }  
				    return Text('No Qr Value Yet!!');  
				  },  
				),
			```

## License

see License File

