const char html[] PROGMEM = R"=====( 
<!DOCTYPE html>
<html lang="de">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1">
<title>ESP8266 Web Server</title>
<style type="text/css">
body {font-family: Verdana; font-size: 12px; color: black; background-color: white}
h0 {font-family: Verdana; font-size: 16px; color: blue; background-color: white}
button {font-family: Verdana; font-size: 12px; margin: 12px; color: white}
</style>

<script language="JavaScript">
'use strict'                
 var ip = location.host;
 let connection = null; 
 function start(){
  connection=new WebSocket("ws://"+ip+":81");
  connection.onopen = function(){
    connection.send('Die Verbindung zum ESP wurde hergestellt  ' + new Date()); 
    connection.send('ping');
  };
 connection.onerror = function(error){
   console.log('WebSocket Error ', error);
 };
 connection.onclose = function(){
   console.log('Websocket closed!');   
   check();//reconnect now
 };
 connection.onmessage = function(e){
   if (connection.readyState === 1) {   //Verbindung wurde hergestellt      
     let jsObj = JSON.parse(e.data);
     if (jsObj.action == "request") {
       document.getElementById("linesensor").innerHTML = jsObj.linesensorvalue;
       document.getElementById("motorleft").innerHTML = jsObj.motorleft;
       document.getElementById("motorright").innerHTML = jsObj.motorright;
       document.getElementById("distanz").innerHTML = jsObj.distanzsensorvalue;
       document.getElementById("lightleft").innerHTML = jsObj.lichtlinks;       
       document.getElementById("lightright").innerHTML = jsObj.lichtrechts;      
       document.getElementById("servo").innerHTML = jsObj.servovalue;  
       document.getElementById("wiicam").innerHTML = jsObj.wiicam;  
       document.getElementById("infarot").innerHTML = jsObj.infarot;  
       document.getElementById("ultraschall").innerHTML = jsObj.ultraschall;  
         
       document.getElementById("integer").innerHTML = jsObj.integer;
      }
    else 
    { 
     console.log('Server: ', e.data);  //Daten des Websocket ausgeben, wenn kein json Objekt mit 'request'
    }
   }
  };
 }
 function check(){
    document.getElementById("READY_STATE").innerHTML = connection.readyState;
    if(!connection || connection.readyState == 3) start();
  }
  
 start();
 setInterval(check, 1000);

function sendCMD(Value){
  connection.send(Value);
}            
 
</script>

</head>

<body>
  <h0>BlueMatics</h0><br>
  Liniensensor:    <span id="linesensor">...</span><br>
  Radcoder Links: <span id="motorleft">...</span><br>
  Radcoder Rechts: <span id="motorright">...</span><br>
  Distanzsensor: <span id="distanz">...</span><br>
  Lichtsensor Links:    <span id="lightleft">...</span><br>
  Lichtsensor Rechts: <span id="lightright">...</span><br>
  Wiicam: <span id="wiicam">...</span><br>
  Infrarot: <span id="infarot">...</span><br>
  Servo: <span id="servo">...</span><br>
  Ultraschall: <span id="ultraschall">...</span><br>
  <p>
  
  <br><button style="background-color:red" onclick="sendCMD('state_linedetector')" >LINIENSENSOR</button> <span id="STATE_1"></span>
  <button style="background-color:red" onclick="sendCMD('state_engine')">MOTORTEST</button> <span id="STATE_2"></span>
  <button style="background-color:red" onclick="sendCMD('state_engine_dir')">LENKUNG</button> <span id="STATE_3"></span>
  <button style="background-color:red" onclick="sendCMD('state_distance_sensor')">DISTANZSENSOREN</button> <span id="STATE_4"></span>
  <button style="background-color:red" onclick="sendCMD('state_lightsensor')">LICHTSENSOR</button> <span id="STATE_5"></span>
  <button style="background-color:red" onclick="sendCMD('state_wiicam')">WIICAM</button> <span id="STATE_6"></span>
  <button style="background-color:red" onclick="sendCMD('state_irtower')">IRTOWER</button> <span id="STATE_7"></span>
  <button style="background-color:red" onclick="sendCMD('state_servo')">SERVO</button> <span id="STATE_8"></span>
  <button style="background-color:red" onclick="sendCMD('state_ultrasonic')">ULTRASCHALLSENSOR</button> <span id="STATE_9"></span>
  <br>
  <button style="background-color:black" onclick="sendCMD('off')">off</button></p>
  <br>
  <br>
  <br>
    <button style="background-color:black" onclick="sendCMD('vor')">VOR</button>
      <br>
      <button style="background-color:black" onclick="sendCMD('links')">LINKS</button>
      <button style="background-color:black" onclick="sendCMD('rechts')">RECHTS</button>
      <br>
    <button style="background-color:black" onclick="sendCMD('zur')">ZURÜCK</button>  
  <br>
  <br>
  <br>
  <p>Servoposition</p><br>
  <button style="background-color:blue" onclick="sendCMD('servo+')">+</button>  
  <button style="background-color:blue" onclick="sendCMD('servo-')">-</button>  

  <p>Mediaplayer</p><br>
  <button style="background-color:red" onclick="sendCMD('playpause')">PLAY/PAUSE</button>  
  <button style="background-color:red" onclick="sendCMD('next')">NEXT</button>  
  <button style="background-color:red" onclick="sendCMD('prev')">PREVIOUS</button>  
  <button style="background-color:red" onclick="sendCMD('volumeup')">VOLUME UP</button>  
  <button style="background-color:red" onclick="sendCMD('volumedown')">VOLUME DOWN</button> 
  <p>Connection<br>
  ReadyState: <span id="READY_STATE">...</span></p>
</body>
</html>
)=====";
/**/


