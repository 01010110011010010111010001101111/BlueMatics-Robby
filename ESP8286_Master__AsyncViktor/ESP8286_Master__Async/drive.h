const char handleDrive[] PROGMEM = R"=====( 

<!DOCTYPE html>
<html lang="de">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1">
<meta name="theme-color" content="#00BCD4" />
<title>BlueMatics Robby</title>
<style type="text/css">
body {
  background: #00BCD4;
  min-height: 100vh;
  overflow: hidden;
  font-family: Roboto;
  color: #fff;
  text-align: center;
-moz-user-select: none;
-khtml-user-select: none;
user-select: none;
}
.container {
  bottom: 0;
  position: fixed;
  margin: 1em;
  right: 0px;
}
.buttons {
  box-shadow: 0px 5px 11px -2px rgba(0, 0, 0, 0.18), 
              0px 4px 12px -7px rgba(0, 0, 0, 0.15);
  border-radius: 50%;
  display: block;
  width: 56px;
  height: 56px;
  margin: 20px auto 0;
  position: relative;
  -webkit-transition: all .5s ease-out;
          transition: all .5s ease-out;  
}
.buttons:active, 
.buttons:focus, 
.buttons:hover {
  box-shadow: 0 0 4px rgba(0,0,0,.14),
    0 4px 8px rgba(0,0,0,.28);
}
.buttons:not(:last-child) {
  width: 40px;
  height: 40px;
  margin: 20px auto 0;
  opacity: 0;
  -webkit-transform: translateX(50px);
      -ms-transform: translateX(50px);
          transform: translateX(50px);
}
.container:hover 
.buttons:not(:last-child) {
  opacity: 1;
  -webkit-transform: none;
      -ms-transform: none;
          transform: none;
  margin: 15px auto 0;
}

.connection_state {
  bottom: 0;
  position: fixed;
  margin: 1em;
  left: 0px;
}

.sd_states {
  top:5%;
  position: fixed;
  margin: 1em;
  left: 0px;
}


.logo {
  top: 20px;
  position: fixed;
  margin: 1em;
  left: 20%;
  right: 20%;
}

 @media screen and (max-width: 560px) {
.logo {
  top: 20px;
  position: fixed;
  margin: 1em;
  left: 5%;
  right: 5%;
  }
  .dpadbuttons {
  margin-top: 30%;
}
}


.dpadbuttons {
  margin-top: 15%;
}
.dpadbuttons a {
  margin-left:15px;
  width: 64px;
  height: 64px;
  display: inline-block;
  position: relative;
  line-height: 64px;
  background-color: #eaeaea;
  background-image: -webkit-gradient(linear, left top, left bottom, from(#f6f6f6), to(#eaeaea));
  background-image: -webkit-linear-gradient(top, #f6f6f6, #eaeaea);
  background-image: -moz-linear-gradient(top, #f6f6f6, #eaeaea); 
  background-image: -ms-linear-gradient(top, #f6f6f6, #eaeaea); 
  background-image: -o-linear-gradient(top, #f6f6f6, #eaeaea);
  background-image: linear-gradient(top, #f6f6f6, #eaeaea);
  -moz-border-radius: 32px;
  -webkit-border-radius: 32px;
  border-radius: 32px;
  -moz-box-shadow: 0 1px 1px rgba(0, 0, 0, .25), 0 2px 3px rgba(0, 0, 0, .1);
  -webkit-box-shadow: 0 1px 1px rgba(0, 0, 0, .25), 0 2px 3px rgba(0, 0, 0, .1);
  box-shadow: 0 1px 1px rgba(0, 0, 0, .25), 0 2px 3px rgba(0, 0, 0, .1);
}
.dpadbuttons a:active {
  top: 1px;
  background-image: -webkit-gradient(linear, left top, left bottom, from(#eaeaea), to(#f6f6f6));
  background-image: -webkit-linear-gradient(top, #eaeaea, #f6f6f6);
  background-image: -moz-linear-gradient(top, #eaeaea, #f6f6f6); 
  background-image: -ms-linear-gradient(top, #eaeaea, #f6f6f6); 
  background-image: -o-linear-gradient(top, #eaeaea, #f6f6f6);
  background-image: linear-gradient(top, #eaeaea, #f6f6f6);
}
.dpadbuttons a::before{
    content: '';
    position: absolute;
    z-index: -1;
    top: -8px;
    right: -8px;
    bottom: -8px;
    left: -8px;
    background-color: #eaeaea;
    -moz-border-radius: 140px;
    -webkit-border-radius: 140px;
    border-radius: 140px;
  opacity: 0.5;   
}
.dpadbuttons a:active::before {
  top: -9px;
}
.dpadbuttons a:hover::before { opacity: 1; }
.dpadbuttons a.up:hover::before {
  background-color: #c6f0f8;
}
.dpadbuttons a.left:hover::before {
  background-color: #dae1f0;
}
.dpadbuttons a.stop:hover::before {
  background-color: #000000;
}
.dpadbuttons a.right:hover::before {
  background-color: #fadae6;
}
.dpadbuttons a.down:hover::before {
  background-color: #f8ebb6;
}
.up img { vertical-align: -7px; }
.right img { vertical-align: -12px; }
.left img { vertical-align: -12px;}
.down img { vertical-align: -7px;}

.dpadbuttons a img { border: 0; }






.buttons:nth-last-child(1) {
  -webkit-transition-delay: 25ms;
          transition-delay: 25ms;
  background-image: url('data:image/png;base64,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');
  background-size: contain;
}

.buttons:not(:last-child):nth-last-child(2) {
  -webkit-transition-delay: 50ms;
          transition-delay: 20ms;
  background-image: url('data:image/png;base64,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');
  background-size: contain;
}

.buttons:not(:last-child):nth-last-child(3) {
  -webkit-transition-delay: 75ms;
          transition-delay: 40ms;
  background-image: url('data:image/png;base64,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');
  background-size: contain;
}

.buttons:not(:last-child):nth-last-child(4) {
  -webkit-transition-delay: 100ms;
          transition-delay: 60ms;
  background-image: url('data:image/png;base64,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');
  background-size: contain;
}
.buttons:not(:last-child):nth-last-child(5) {
  -webkit-transition-delay: 125ms;
          transition-delay: 65ms;
  background-image: url('data:image/png;base64,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');
  background-size: contain;
}

[tooltip]:before {
  bottom: 25%;
  font-family: arial;
  font-weight: 600;
  border-radius: 2px;
  background: #585858;
  color: #fff;
  content: attr(tooltip);
  font-size: 12px;
  visibility: hidden;
  opacity: 0;
  padding: 5px 7px;
  margin-right: 12px;
  position: absolute;
  right: 100%;
  white-space: nowrap;
  visibility: visible;
  opacity: 1;
}


</style>

<script language="JavaScript">
'use strict'                
 var ip = location.host;
 
 
 let connection = null; 
 function start(){
  connection=new WebSocket("ws://"+ip+":81");
  connection.onopen = function(){
    connection.send('Client connected  ' + new Date()); 
    connection.send('MAP');
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
        
        if(jsObj.sd=1){
        document.getElementById("sdIcon").src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAQAAADYBBcfAAAAAmJLR0QA/4ePzL8AAAAJcEhZcwAACxMAAAsTAQCanBgAAAAHdElNRQfiAQIUMgz/2OLkAAABPklEQVQ4y+3TsUvbcRAF8I8xNtGUdLA4SKuDCEIHFwcVXKyg+AdYwf9ASsFBcHWUUijFbgrqIg4OInQpDq3QoU6CKFqKSpE2DoagRiLN79shUbQ4uZp3w3H3ePfuhqOCB42q69ykV4dmT6Uk1IhJWDTuoz6Xzn321oUGR4oCcVBj1HscyyooyIsEKWsibf6q9smCAcNOzKu34bDk99y6IJjSeudeafU+WDDtqyA40FMikl7LC4Iflk0aVPef9LEl4UbsXBFJ/eZky+2MJS+uRc+MWHVxS7jJ1Z2llV6WnYNpvPHNnl9yt0TBoba4J44VZeXkXUpLlofUSRvSdcfFs8acxr3yCLUab1BBxqpOLeU6EimK/LHinVpNcnEddsVUi6FKpOjMlhlfTDi3reDEb/t2fPcTtEvprrxABffDPzFscym3xjWhAAAAAElFTkSuQmCC';
        }else{
        document.getElementById("sdIcon").src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAQAAADZc7J/AAAAAmJLR0QA/4ePzL8AAAAJcEhZcwAACxMAAAsTAQCanBgAAAAHdElNRQfiAQIVBw/FIhvfAAABZUlEQVRIx+2TTyjDcRjGP5tf5E+SWpTTpERWWi4OykFqB6QkpThQ9Eq57DJJcZSDg5cVJQfSSg7a3Y3DakWTG8VldkDI/v4cbLOt7S7tOb3f5/0+z/ft7flCGWX8C1h+S7HRjwM7NuqppgoDCyamtouTE76IEiPIgppSpdGMykiLrXiZzbM2MQGTDcBDGwD7KtIhbobkQN1i0+fsBDLKKQDTelh8VOnmlUqOuMFDC8sMA+PqyxiM4QMgwSRnxNUsYbPLXB4xkt2BXNOVLlPE8OpSUYMPavKIZO4SXfhzW+zoYp54kGMaCxzfLAUvdDLBSvbYowFxME8rzbRRV2QkmwGyB4SJ8MInCUK8Z6+6CLBNX4kIRHBqxJAmZkqm5BxwFu28sqnrPzmYKim/0qAMUFvAPhJiS/1ilTWeaTDo5YEKrFjTmTBJEeeOVb0E3DyRJEmYWwJc6HXGR1NyTwh7+TOX8TfwDTD0aXB6cjtNAAAAAElFTkSuQmCC';   
        }

                if(jsObj.sd_type=1){
        document.getElementById("sdTypeIcon").src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAB3RJTUUH4gECFQ0qdMknEgAAAWhJREFUWMPtl8FKw0AQhmcm2TTSbYi0hUpLe9SL4KkevPbUY1/Auz6BD+OriO8gCh69GESEYIxt092Mlwoe7KZJW1DYH4Y9/MzOx8DADIJBrVbrdjabHSKihopiZmo0Gm9RFB3/5rum5CRJOvP5vAMbChH3VnlUkMiwBSFivsozdoCIHomIEDHI87zDvD4PEQEiPjNzQkSvlQDa7fZ5mqae1loqpY6m0+m1UuqgqLjv+w+e510Q0ZMQIg3DcBHH8eat7Pf7pwDApiCibDweN2FXqtVqiQlASnlT5j8qCyCEeDf5ruvGOwXYtiyABbAAFsACWAAL8P8AuGAzLbtJlwbQWocmP8syubN2DQaDszWW0sVwONzeUjoajZrdbve0Xq9fOY4TFQEAAAsh7qWUl71e72QymexXLu77/h0A5ACgli+XiO88HQTBS6XDZOkjADhVLrIfee6fHUO3YKRSRPzc9DxHxI9V/hcxhYv50K+DfQAAAABJRU5ErkJggg==';
        }
                if(jsObj.sd_type=2){
        document.getElementById("sdTypeIcon").src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAB3RJTUUH4gECFRE1H7Z3ugAAAf5JREFUWMPtl0FrE0EUx997s9lNWGc3u4jFIgRSQTwYCAH3VDD5At689FQ8CD0aP4HXile/QD6C5+ApFz+BBwONhEgqtCFszDY7M71kS7AzaSK0etgHA8MM//d+s+8tvIewtEKh8BkAHgOAhFs227bHcRy/+PP8GwCou1i2bf/MgtIKwK2/fMVEtrGuSIh+AEAIAPellLROjYiAiGMAiJevcpVSD5RSeIMuRcRTIjq5Oss2jUbDGw6HO3Ec1+fz+afFYhHqnBARcM6PHMf5UqlUxlJKORqNdqbT6f5sNvsghPB0OsbYlHP+plgsfq1Wq6e9Xm9iJPV9/xUiavMXhuF7k8513Y+mvAdB8HrjBLmu+4wxNtE5iqLoqUnHOT9AxIVO1+l07m0MwBh7sszxNUftdvuRSWdZ1ksAuNDplFLaurK0JSrEukIyFlqapllArVRbU/CPLQfIAXKAHCAHyAFygHUAytCs/G0stTFAEAQ2Y8zR3XW7XccUIQgCjohan4PBwNkYQEpZk1L6urt+v39oAkiS5LlSSttl1ev1gxu/UbPZ3C2Xy+8YY+em7paIEs/zjqMo2st0tVptz/f9YyL6vUZ35nne21ar9dDUUH7fdsQiImVZ1tajWalU+nWtKU3T9GLbqpJSgpTbT3RCiOS/+Q1XC2ayXOIO4p5nm0uGPOyXeReAAgAAAABJRU5ErkJggg==';
        }
                if(jsObj.sd_type=0){
        document.getElementById("sdTypeIcon").src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAC4jAAAuIwF4pT92AAAAB3RJTUUH4gECFRQzi6ImygAAAWxJREFUWMPt1jFLXEEUBeDPXcNilEQrsUlQC8GAURDsUtj5C+xMYWURSGu/vYJgk/wC7VPH3iqLFqKSEBQVdRux0GTX5tnIm/d23+7bQvfANDP3zjkz996Zy0tHTwafAqYwjiHUcI0D7Och8jU+oow91BNGDduR/at2CSinkIbGBgbbIWA9OllWEaW0eKbhcbO4uXqK7womkgx6m0g8OEIFO1HS/cMMljAZ41fEAn61EoJv2MUy3gdshnEaCMNWqzkwhrcN2H0PCPjRagiOGxQ6Epi/6MSDNpdQCZ/zJv+AkwD5b4zmST6bQH6PL3mSf8J5wtVv5kk+j2oC+WrGj67hbL8KEP/HYoMvbGasRURPye/wtRP9w07g9JUsGzZ7Vf1RExKHy050RIXodxuIWavi8Nn3hEVM400gBJW8BQ/gJ25jxnaWDXsz+JTQF5jPvQrajq6AZnOgjjP8iammi06UYQHvAkl4g7+6aBIPp+aStQQ4rkkAAAAASUVORK5CYII=';
        }
               if(jsObj.sd_format=16){
        document.getElementById("sdFormatIcon").src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH4gECFSkkYpnrswAAAB1pVFh0Q29tbWVudAAAAAAAQ3JlYXRlZCB3aXRoIEdJTVBkLmUHAAACQ0lEQVRYw+2Wy0tVURTGf+ktCbIoEnugDgQL0lkh2gMHKkKkOJWIiP4JJ9G0QSCFJDUQaiBCDaOQohQfg5BelndicG/YoLCHD7padp18B1abfY5dz60Q7geHs85aa++z1trrsaGA/4wtHl4HUOrhFwODQEbf9UCN9ngOvBb/FFC5zn+ngckw4SyQDXnKjd4vw/9k+Pcj1gfPjUA54TEg8HAKeCzPA90l0Z3yPKv3XqARGAfuAe+ktwfoEn0TWBH9JCo8M9r4esSx3ZXOEPBK9C2Pbo3xertvs0SEIY3AJaOzBFxRRJrE6wP2Ab1AM1CkowmwzaG//0lizoSc24IJfxZYBKqAQzq2LHDU2avWrN+VawRGgDtGJ7D+qt5fTX4sACVAD3AibmkGEejzyOqMR6vyPONUREW+IkBIjwBYBp6aCKwCrUrQduXEX4nAG8kGPLJHkg3nEoFiD68UeKkceGv4JUq4UZXcB2ddCvgCfAQeilek7H8GPAB+FoZPAbniAHBZSfVCY/R0iO5JTcJvSra0KikRx4A2T0s+69HrNPJFYEwVkVb1bBhV2rxFzcdnwG5gXrJrjqxCpRgb1WbguAY0iJ9Rs+kCLgAHQ25csVqxD0fMPWHOaW79wEVnRP+GfIRnh5n3SQ2sHvHOA4ejFufDgFlDn9NVrhv4rKgcy4cBGUP/cGRJTUOArWY6BkcxF8e745qASTPzUxpWQ8aJlGTvlZS3zS1qfxwDzkRcreeNXhkw4cjTKuF/ip2KWiUFbBasAfoxsay6/JWhAAAAAElFTkSuQmCC';
        }
               if(jsObj.sd_format=32){
        document.getElementById("sdFormatIcon").src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH4gECFSkxD0QPWAAAAB1pVFh0Q29tbWVudAAAAAAAQ3JlYXRlZCB3aXRoIEdJTVBkLmUHAAACWklEQVRYw+2XXYhNURTHf+4dhsmQaabxglLm1sQoTU2mSR7kceRVjRfx6lFSnhQelJJmQkkepIYp+UrkI3mRxPgoGkXGZ5rRNd0ZY2wv/12r3T6H0z1SuqtOZ9///p9111p7rbPWgZr8Y5kVwTYBjRG8CJwFJvW7C2iTjofAsPB1wNLf/O9z4EHS5ijgEq5Ww/tp8M8Gv5TyvL/6PbkuYoD38AlwQ5577oTWm+W5070Z6AbuAeeAV+I1AVu0PgZ81/pmWnhGpPhIyrENinMNeKz18Qi3zXg9L6asLsWQbmCv4UwABxWR9cIGgMXAUWADUNDReJkTrCt/kpgjCedWNuF3wDdgGVDSsTmgM9C10jy/MGsE7gCnDcdbf0j3cZMfZaAeOAz0VFuaPgIDkb1VxqMZeT4ZVMSSvCJAwjsCYAq4ZSIwA2xUgvYqJ/5KBJ5q70xk77r2bmeJQDGCNQKPlAPPDF6vhLurknsXPPcaGAM+AVeFFZT994ErwI9a86lJVtmmhCwD08AH4Dyw2nBagROqkIreC8PAzjwMOKkS+iLlvqRsNnca/H3wUjpVrQGloKHsMcrbhS0Htppu16BSdJotGvKYmmbLkF3GgDS5KM6bpDacRdYCL4EXUvoR6Ejhtxsj9+eRBz0K6VslogMuJ3BXqEs6YCivSigAc4H5QJ/xri/g9ZpE7U8YeDNJEVgUYB3GgH3GwB3CpvMqPz9COeACsBs4oOnXG1ASb43asVMJftUxjGs4baomApXIaDYKbDe8rpTxewpoyfphEsoCeVtQJYzVGsR/Jb8AGkPEpnFK77sAAAAASUVORK5CYII=';
        }
               if(jsObj.sd_size=1881){
        document.getElementById("sdSizeIcon").src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAC4jAAAuIwF4pT92AAAAB3RJTUUH4gECFSI7DGU/jQAAAeRJREFUWMPt1U2ITWEYB/DfGF8TcmvkSpFZKLFQFhrkI0sLZWNLolhhoRRFTYaympSdkmxYKCLZKI0aS0kK2VGTJqLr3px75x6b59bb6bgz2Tr/Op1znvf/POf5+L/voUKFChX+dwwkz6uwG5uwHDN4hE/Bywu+e7EdNfzCBzzHt1iv4RDa8Z6jibf4WExkBV6iG8QcHcziZIFbxytksd7jt/ElkoItYc+SWFnwnvSCLUwCZ7HwEMM4gzWYwAN8xVJMYQQtTEbVi6N76+I5xSLciY6OYgcO4Chup6SRguOFqKCF/WG7GrYujpeMdH0knXYgj8Rga4wox+W59HE9iL+xOmzTYZuKGfdDmsBNXMLTZBSb+znvQSOczyX2VtjuYSjEeSREOBPVXSxJoHjdKtNADwdDBznGohM9zMZ9CIOJdn6GOAewrCTmGD5H1cfiynAqJQ3ifHy4gRMlgV7E+nTMW4iuHknkGC/pwMYkxmTY3mHJgiTItcT5RhB2YWecEZJx1HEf26KSZuFMUbJ1a9iHDWHrhC9YiTd/mVeGw0mw031mm+PKPDTQxdlUAx28DjF1C9m3Q2A9TOB9nBNrI0Yb3/Es2dutKKqR+Oahhbt4bI62zQe1EGQTP6o/W4UKFSr8C/4AREeciZoe6pYAAAAASUVORK5CYII=';
        }
               if(jsObj.sd_size>1881){
        document.getElementById("sdSizeIcon").src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAC4jAAAuIwF4pT92AAAAB3RJTUUH4gECFSQSGI0AZwAAAZ9JREFUWMPt1D1sTlEcBvBf3zYtUR8hQaWDAfExipRKRZB0kEpE2AwslSZWko5GiUXMYpEYxGLoYrFLEywkpHQSEZQqqnotz03e3PQdWCznSU5yz/M/5/l/nktBQUHBf0Z32/cabMdqfP1HvUFsxS/8DNcT7b6sxealHkziC77hI+5jw184PoJn+Ix5fMKj2I7iNd6Ff48H8auFrqwbOIlpnMHYCo6W4qwdQxHcjTu4EK3B2PswkOQu4Q1O40qnbI6hwsQKtgrDjRZeD3+5g94oFlKhbbiN3xivy9+OLbiJWUyFO4AT+J79eRxOWR9mbuBesp3EwZy/GmcV9mEGvZirW9Rqc74HT7EZp3K4CztxDmdzbiT7Qxm2+fADadFL7Eo7N2I5OtMJcAL9uNXs44dEth+bsLZDC4Ya3MXwj7E+3FSCG05LF/AkgYwl0Oe1QC/uRmQxr6HCtQ4BHG9wdTbL+JEqVnibwRzNvkpVq7yIcW0vYEdKWHOtTOtMw9lIhmmuwa/C3jjsz71ZvMK62Lqju5Rqvyi/4YKCgoKCAvgDx/1jxaP3fbkAAAAASUVORK5CYII=';
        }
        document.getElementById("connectionIcon").src = 'data:image/png;base64,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';


        
   }else 
    { 
     console.log('Server: ', e.data);  //Daten des Websocket ausgeben, wenn kein json Objekt mit 'request'
    }
   }
  };

 }
 function check(){
 connection.send('TIMESTAMP: ' + new Date());

  
 if (connection.readyState==1){


        if(jsObj.sd=1){
        document.getElementById("sdIcon").src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAQAAADYBBcfAAAAAmJLR0QA/4ePzL8AAAAJcEhZcwAACxMAAAsTAQCanBgAAAAHdElNRQfiAQIUMgz/2OLkAAABPklEQVQ4y+3TsUvbcRAF8I8xNtGUdLA4SKuDCEIHFwcVXKyg+AdYwf9ASsFBcHWUUijFbgrqIg4OInQpDq3QoU6CKFqKSpE2DoagRiLN79shUbQ4uZp3w3H3ePfuhqOCB42q69ykV4dmT6Uk1IhJWDTuoz6Xzn321oUGR4oCcVBj1HscyyooyIsEKWsibf6q9smCAcNOzKu34bDk99y6IJjSeudeafU+WDDtqyA40FMikl7LC4Iflk0aVPef9LEl4UbsXBFJ/eZky+2MJS+uRc+MWHVxS7jJ1Z2llV6WnYNpvPHNnl9yt0TBoba4J44VZeXkXUpLlofUSRvSdcfFs8acxr3yCLUab1BBxqpOLeU6EimK/LHinVpNcnEddsVUi6FKpOjMlhlfTDi3reDEb/t2fPcTtEvprrxABffDPzFscym3xjWhAAAAAElFTkSuQmCC';
        }else{
        document.getElementById("sdIcon").src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAQAAADZc7J/AAAAAmJLR0QA/4ePzL8AAAAJcEhZcwAACxMAAAsTAQCanBgAAAAHdElNRQfiAQIVBw/FIhvfAAABZUlEQVRIx+2TTyjDcRjGP5tf5E+SWpTTpERWWi4OykFqB6QkpThQ9Eq57DJJcZSDg5cVJQfSSg7a3Y3DakWTG8VldkDI/v4cbLOt7S7tOb3f5/0+z/ft7flCGWX8C1h+S7HRjwM7NuqppgoDCyamtouTE76IEiPIgppSpdGMykiLrXiZzbM2MQGTDcBDGwD7KtIhbobkQN1i0+fsBDLKKQDTelh8VOnmlUqOuMFDC8sMA+PqyxiM4QMgwSRnxNUsYbPLXB4xkt2BXNOVLlPE8OpSUYMPavKIZO4SXfhzW+zoYp54kGMaCxzfLAUvdDLBSvbYowFxME8rzbRRV2QkmwGyB4SJ8MInCUK8Z6+6CLBNX4kIRHBqxJAmZkqm5BxwFu28sqnrPzmYKim/0qAMUFvAPhJiS/1ilTWeaTDo5YEKrFjTmTBJEeeOVb0E3DyRJEmYWwJc6HXGR1NyTwh7+TOX8TfwDTD0aXB6cjtNAAAAAElFTkSuQmCC';   
        }

        if(jsObj.sd_type=1){
        document.getElementById("sdTypeIcon").src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAB3RJTUUH4gECFQ0qdMknEgAAAWhJREFUWMPtl8FKw0AQhmcm2TTSbYi0hUpLe9SL4KkevPbUY1/Auz6BD+OriO8gCh69GESEYIxt092Mlwoe7KZJW1DYH4Y9/MzOx8DADIJBrVbrdjabHSKihopiZmo0Gm9RFB3/5rum5CRJOvP5vAMbChH3VnlUkMiwBSFivsozdoCIHomIEDHI87zDvD4PEQEiPjNzQkSvlQDa7fZ5mqae1loqpY6m0+m1UuqgqLjv+w+e510Q0ZMQIg3DcBHH8eat7Pf7pwDApiCibDweN2FXqtVqiQlASnlT5j8qCyCEeDf5ruvGOwXYtiyABbAAFsACWAAL8P8AuGAzLbtJlwbQWocmP8syubN2DQaDszWW0sVwONzeUjoajZrdbve0Xq9fOY4TFQEAAAsh7qWUl71e72QymexXLu77/h0A5ACgli+XiO88HQTBS6XDZOkjADhVLrIfee6fHUO3YKRSRPzc9DxHxI9V/hcxhYv50K+DfQAAAABJRU5ErkJggg==';
        }
        if(jsObj.sd_type=2){
        document.getElementById("sdTypeIcon").src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAB3RJTUUH4gECFRE1H7Z3ugAAAf5JREFUWMPtl0FrE0EUx997s9lNWGc3u4jFIgRSQTwYCAH3VDD5At689FQ8CD0aP4HXile/QD6C5+ApFz+BBwONhEgqtCFszDY7M71kS7AzaSK0etgHA8MM//d+s+8tvIewtEKh8BkAHgOAhFs227bHcRy/+PP8GwCou1i2bf/MgtIKwK2/fMVEtrGuSIh+AEAIAPellLROjYiAiGMAiJevcpVSD5RSeIMuRcRTIjq5Oss2jUbDGw6HO3Ec1+fz+afFYhHqnBARcM6PHMf5UqlUxlJKORqNdqbT6f5sNvsghPB0OsbYlHP+plgsfq1Wq6e9Xm9iJPV9/xUiavMXhuF7k8513Y+mvAdB8HrjBLmu+4wxNtE5iqLoqUnHOT9AxIVO1+l07m0MwBh7sszxNUftdvuRSWdZ1ksAuNDplFLaurK0JSrEukIyFlqapllArVRbU/CPLQfIAXKAHCAHyAFygHUAytCs/G0stTFAEAQ2Y8zR3XW7XccUIQgCjohan4PBwNkYQEpZk1L6urt+v39oAkiS5LlSSttl1ev1gxu/UbPZ3C2Xy+8YY+em7paIEs/zjqMo2st0tVptz/f9YyL6vUZ35nne21ar9dDUUH7fdsQiImVZ1tajWalU+nWtKU3T9GLbqpJSgpTbT3RCiOS/+Q1XC2ayXOIO4p5nm0uGPOyXeReAAgAAAABJRU5ErkJggg==';
        }
        if(jsObj.sd_type=0){
        document.getElementById("sdTypeIcon").src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAC4jAAAuIwF4pT92AAAAB3RJTUUH4gECFRQzi6ImygAAAWxJREFUWMPt1jFLXEEUBeDPXcNilEQrsUlQC8GAURDsUtj5C+xMYWURSGu/vYJgk/wC7VPH3iqLFqKSEBQVdRux0GTX5tnIm/d23+7bQvfANDP3zjkz996Zy0tHTwafAqYwjiHUcI0D7Och8jU+oow91BNGDduR/at2CSinkIbGBgbbIWA9OllWEaW0eKbhcbO4uXqK7womkgx6m0g8OEIFO1HS/cMMljAZ41fEAn61EoJv2MUy3gdshnEaCMNWqzkwhrcN2H0PCPjRagiOGxQ6Epi/6MSDNpdQCZ/zJv+AkwD5b4zmST6bQH6PL3mSf8J5wtVv5kk+j2oC+WrGj67hbL8KEP/HYoMvbGasRURPye/wtRP9w07g9JUsGzZ7Vf1RExKHy050RIXodxuIWavi8Nn3hEVM400gBJW8BQ/gJ25jxnaWDXsz+JTQF5jPvQrajq6AZnOgjjP8iammi06UYQHvAkl4g7+6aBIPp+aStQQ4rkkAAAAASUVORK5CYII=';
        }
        if(jsObj.sd_format=16){
        document.getElementById("sdFormatIcon").src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH4gECFSkkYpnrswAAAB1pVFh0Q29tbWVudAAAAAAAQ3JlYXRlZCB3aXRoIEdJTVBkLmUHAAACQ0lEQVRYw+2Wy0tVURTGf+ktCbIoEnugDgQL0lkh2gMHKkKkOJWIiP4JJ9G0QSCFJDUQaiBCDaOQohQfg5BelndicG/YoLCHD7padp18B1abfY5dz60Q7geHs85aa++z1trrsaGA/4wtHl4HUOrhFwODQEbf9UCN9ngOvBb/FFC5zn+ngckw4SyQDXnKjd4vw/9k+Pcj1gfPjUA54TEg8HAKeCzPA90l0Z3yPKv3XqARGAfuAe+ktwfoEn0TWBH9JCo8M9r4esSx3ZXOEPBK9C2Pbo3xertvs0SEIY3AJaOzBFxRRJrE6wP2Ab1AM1CkowmwzaG//0lizoSc24IJfxZYBKqAQzq2LHDU2avWrN+VawRGgDtGJ7D+qt5fTX4sACVAD3AibmkGEejzyOqMR6vyPONUREW+IkBIjwBYBp6aCKwCrUrQduXEX4nAG8kGPLJHkg3nEoFiD68UeKkceGv4JUq4UZXcB2ddCvgCfAQeilek7H8GPAB+FoZPAbniAHBZSfVCY/R0iO5JTcJvSra0KikRx4A2T0s+69HrNPJFYEwVkVb1bBhV2rxFzcdnwG5gXrJrjqxCpRgb1WbguAY0iJ9Rs+kCLgAHQ25csVqxD0fMPWHOaW79wEVnRP+GfIRnh5n3SQ2sHvHOA4ejFufDgFlDn9NVrhv4rKgcy4cBGUP/cGRJTUOArWY6BkcxF8e745qASTPzUxpWQ8aJlGTvlZS3zS1qfxwDzkRcreeNXhkw4cjTKuF/ip2KWiUFbBasAfoxsay6/JWhAAAAAElFTkSuQmCC';
        }
        if(jsObj.sd_format=32){
        document.getElementById("sdFormatIcon").src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH4gECFSkxD0QPWAAAAB1pVFh0Q29tbWVudAAAAAAAQ3JlYXRlZCB3aXRoIEdJTVBkLmUHAAACWklEQVRYw+2XXYhNURTHf+4dhsmQaabxglLm1sQoTU2mSR7kceRVjRfx6lFSnhQelJJmQkkepIYp+UrkI3mRxPgoGkXGZ5rRNd0ZY2wv/12r3T6H0z1SuqtOZ9///p9111p7rbPWgZr8Y5kVwTYBjRG8CJwFJvW7C2iTjofAsPB1wNLf/O9z4EHS5ijgEq5Ww/tp8M8Gv5TyvL/6PbkuYoD38AlwQ5577oTWm+W5070Z6AbuAeeAV+I1AVu0PgZ81/pmWnhGpPhIyrENinMNeKz18Qi3zXg9L6asLsWQbmCv4UwABxWR9cIGgMXAUWADUNDReJkTrCt/kpgjCedWNuF3wDdgGVDSsTmgM9C10jy/MGsE7gCnDcdbf0j3cZMfZaAeOAz0VFuaPgIDkb1VxqMZeT4ZVMSSvCJAwjsCYAq4ZSIwA2xUgvYqJ/5KBJ5q70xk77r2bmeJQDGCNQKPlAPPDF6vhLurknsXPPcaGAM+AVeFFZT994ErwI9a86lJVtmmhCwD08AH4Dyw2nBagROqkIreC8PAzjwMOKkS+iLlvqRsNnca/H3wUjpVrQGloKHsMcrbhS0Htppu16BSdJotGvKYmmbLkF3GgDS5KM6bpDacRdYCL4EXUvoR6Ejhtxsj9+eRBz0K6VslogMuJ3BXqEs6YCivSigAc4H5QJ/xri/g9ZpE7U8YeDNJEVgUYB3GgH3GwB3CpvMqPz9COeACsBs4oOnXG1ASb43asVMJftUxjGs4baomApXIaDYKbDe8rpTxewpoyfphEsoCeVtQJYzVGsR/Jb8AGkPEpnFK77sAAAAASUVORK5CYII=';
        }
        if(jsObj.sd_size=1881){
        document.getElementById("sdSizeIcon").src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAC4jAAAuIwF4pT92AAAAB3RJTUUH4gECFSI7DGU/jQAAAeRJREFUWMPt1U2ITWEYB/DfGF8TcmvkSpFZKLFQFhrkI0sLZWNLolhhoRRFTYaympSdkmxYKCLZKI0aS0kK2VGTJqLr3px75x6b59bb6bgz2Tr/Op1znvf/POf5+L/voUKFChX+dwwkz6uwG5uwHDN4hE/Bywu+e7EdNfzCBzzHt1iv4RDa8Z6jibf4WExkBV6iG8QcHcziZIFbxytksd7jt/ElkoItYc+SWFnwnvSCLUwCZ7HwEMM4gzWYwAN8xVJMYQQtTEbVi6N76+I5xSLciY6OYgcO4Chup6SRguOFqKCF/WG7GrYujpeMdH0knXYgj8Rga4wox+W59HE9iL+xOmzTYZuKGfdDmsBNXMLTZBSb+znvQSOczyX2VtjuYSjEeSREOBPVXSxJoHjdKtNADwdDBznGohM9zMZ9CIOJdn6GOAewrCTmGD5H1cfiynAqJQ3ifHy4gRMlgV7E+nTMW4iuHknkGC/pwMYkxmTY3mHJgiTItcT5RhB2YWecEZJx1HEf26KSZuFMUbJ1a9iHDWHrhC9YiTd/mVeGw0mw031mm+PKPDTQxdlUAx28DjF1C9m3Q2A9TOB9nBNrI0Yb3/Es2dutKKqR+Oahhbt4bI62zQe1EGQTP6o/W4UKFSr8C/4AREeciZoe6pYAAAAASUVORK5CYII=';
        }
        if(jsObj.sd_size>1881){
        document.getElementById("sdSizeIcon").src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAC4jAAAuIwF4pT92AAAAB3RJTUUH4gECFSQSGI0AZwAAAZ9JREFUWMPt1D1sTlEcBvBf3zYtUR8hQaWDAfExipRKRZB0kEpE2AwslSZWko5GiUXMYpEYxGLoYrFLEywkpHQSEZQqqnotz03e3PQdWCznSU5yz/M/5/l/nktBQUHBf0Z32/cabMdqfP1HvUFsxS/8DNcT7b6sxealHkziC77hI+5jw184PoJn+Ix5fMKj2I7iNd6Ff48H8auFrqwbOIlpnMHYCo6W4qwdQxHcjTu4EK3B2PswkOQu4Q1O40qnbI6hwsQKtgrDjRZeD3+5g94oFlKhbbiN3xivy9+OLbiJWUyFO4AT+J79eRxOWR9mbuBesp3EwZy/GmcV9mEGvZirW9Rqc74HT7EZp3K4CztxDmdzbiT7Qxm2+fADadFL7Eo7N2I5OtMJcAL9uNXs44dEth+bsLZDC4Ya3MXwj7E+3FSCG05LF/AkgYwl0Oe1QC/uRmQxr6HCtQ4BHG9wdTbL+JEqVnibwRzNvkpVq7yIcW0vYEdKWHOtTOtMw9lIhmmuwa/C3jjsz71ZvMK62Lqju5Rqvyi/4YKCgoKCAvgDx/1jxaP3fbkAAAAASUVORK5CYII=';
        }

 document.getElementById("connectionIcon").src = 'data:image/png;base64,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';
 }
 else{

      //if not connected, set empty image
      document.getElementById("sdIcon").src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAB3RJTUUH4gEDCiAS0ydGSwAAABpJREFUWMPtwQEBAAAAgiD/r25IQAEAAADvBhAgAAGX91fXAAAAAElFTkSuQmCC';   
      document.getElementById("sdTypeIcon").src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAB3RJTUUH4gEDCiAS0ydGSwAAABpJREFUWMPtwQEBAAAAgiD/r25IQAEAAADvBhAgAAGX91fXAAAAAElFTkSuQmCC';
      document.getElementById("sdFormatIcon").src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAB3RJTUUH4gEDCiAS0ydGSwAAABpJREFUWMPtwQEBAAAAgiD/r25IQAEAAADvBhAgAAGX91fXAAAAAElFTkSuQmCC';
      document.getElementById("sdSizeIcon").src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAB3RJTUUH4gEDCiAS0ydGSwAAABpJREFUWMPtwQEBAAAAgiD/r25IQAEAAADvBhAgAAGX91fXAAAAAElFTkSuQmCC';



 document.getElementById("connectionIcon").src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAMAAACdt4HsAAAA4VBMVEUAAAB9fX19fX19fX19fX2BgYF9fX1+fn59fX19fX19fX19fX1/f399fX19fX1+fn59fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX1+fn59fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX2SkpJ9fX19fX19fX19fX19fX19fX19fX19fX19fX2SkpKQkJCXl5d9fX2JiYmQkJCFhYWEhISEhISPj4+Hh4eTk5ORkZGSkpKBgYF9fX2UlJSMjIwlzjGSAAAASHRSTlMAAwYMCBAkF0s9EyEaMTcdRu3BQill6Pj0gF1XUvCQcS3do+Opl8WFede+uX1pYP7fy3Vt0bStnInZlyGxpO/c9Oq1ZjTCwLbHrjhTAAAEHklEQVRYw+VV6XaaQBgNwwCyDAiIdQWC4K5x1zZp0r227/9AnRl2RcWe01+954QEZu6db7lf5uFfAgg8EkVRrSns/WR5HvQf63W92+3qen2x9By1tArDicHieI76riXD23Suaj8eL0H3WzJzlc46RuN4De9Gdu0Kf9473oZuaxdyV41jOTzOpQK+cmgcS2NrnpXC3JxVfenbw7U1c5rBdtQ9XVyBfPit/PG60azKLGCiVSC57f0ov8UTssVv5tlTFRY0GA2W7zLbxihZkrws3atg7WJo1iSzcyPG5+8yX1/ylgUAMLkw2hmb9czw4yrToHVEZ1jNnPrLnt7o9jbbQ8eVcNGolByktRjJdG+i2d3zUUzmcNzIO3Bjt7GLGawB2svk84zshnrcGguGYTr9pGt5DcTQIGp+/G1AI5hEGXVA2NHLfu5GLuYOkaZFX6v0vFGV0tF1P/fmHI26STM0lLDSrX69txPpwvSmn31Eq7Re1hcein2oICRRQ0zKjFKHcjTkcqc+4Rf5qumjib/3dv3Fic/noNhn7mN2V99uuRxDU1RExx9lXNywmCI+u80M276j5DbB2myc6Ual0Ohp7DsxMaQgwehPYT5KR7EohFq8upgRDhDEgVHHgevLoM1TQd6L8xgXVUGJSmCI5DzRzlXEbwskEacevgeFF9EqHMcaOcvXT41sdIhuZ0FjVIuvhOFjo2eTkyqFsxBIWMEcd7uGeelyUJBMxm14LMaEBMe67o1LDg6Ol2DwDyWgXhmHPVNCwEqzrvc9O3gZpYo95Q6Bd8shotlK1X0vdqhcJgU9bP0g3QzEl+hGgsSdNwTYAz2rlTObENBJVgn/hgD9n7jZiXgr9/yskMczwB/X/Y2nkmjg7UIyksDg57cP799/+UoebXIoKxEmAAxzlRs+Sfjf3v/CeCKP168gXmeu82l8gCpwH36leOMT/o3gQSgAwIPwIyPwuxPxH8oB4kCU71kB6w4+DoIkwmZT+CSWpqe7qq8J/+knR1bKAUAQ5fHhKea/mXcUACZGET5GCp/xRUALey+UUOGTBaLs7oaGFZ4+W+UJBQqvby188t+DMxH4Gx4DIDhDCRqDiSzLcpIkKIqiaTJPIMsafhMEiWMxwIV5wFzAcpykYJaLkCqa1WolRBXDFFUVuTVeU4jO+UyTkzlJ0OSai6mVTrtlzdbOcNrEmA5XK2dmtdqdSlVUUY2XBY5jIchJhHyZryFCb1nr1XRge9ux0TcwJn5waA6dGdbAEjgORZJYCLMKMCvQTgXGk8m4nwjMqQAiAjSE0xQ4kgJKUnBW0+YApzAYTIfO2ppfS4EWEVINBVfeRSopYiUFqSItokyLCCG82AksQ7IRoibGfdQ03EbSR4iPBsxVL1AAAgizv6gByM9/gvIT+AeevlMDy20U7QAAAABJRU5ErkJggg==';
}
    if(!connection || connection.readyState == 3) start();
  }
  
 start();
 setInterval(check, 1000);

function sendCMD(Value){
  connection.send(Value);
}


function sendUP() {
    sendCMD('vor');
}function sendLEFT() {
    sendCMD('links');
}function sendRIGHT() {
    sendCMD('rechts');
}function sendDOWN() {
    sendCMD('zur');
}function sendSERVOLEFT() {
    sendCMD("servo-");
}function sendSERVORIGHT() {
    sendCMD("servo+");
}

function sendSTOP() {
    sendCMD('off');
}



</script>
</head>
<body>

 <nav class="container"  > 
    <a href="./more" class="buttons" tooltip="more"></a>
  <a href="./" class="buttons" tooltip="home"></a>
    <a href="./map" class="buttons" tooltip="map"></a>
    <a href="./states" class="buttons" tooltip="states"></a>

    <a class="buttons" tooltip="menu" href="#"></a>
  </nav>
  
   <div class="connection_state"  > 
  <img id="connectionIcon" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAMAAACdt4HsAAAA4VBMVEUAAAB9fX19fX19fX19fX2BgYF9fX1+fn59fX19fX19fX19fX1/f399fX19fX1+fn59fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX1+fn59fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX2SkpJ9fX19fX19fX19fX19fX19fX19fX19fX19fX2SkpKQkJCXl5d9fX2JiYmQkJCFhYWEhISEhISPj4+Hh4eTk5ORkZGSkpKBgYF9fX2UlJSMjIwlzjGSAAAASHRSTlMAAwYMCBAkF0s9EyEaMTcdRu3BQill6Pj0gF1XUvCQcS3do+Opl8WFede+uX1pYP7fy3Vt0bStnInZlyGxpO/c9Oq1ZjTCwLbHrjhTAAAEHklEQVRYw+VV6XaaQBgNwwCyDAiIdQWC4K5x1zZp0r227/9AnRl2RcWe01+954QEZu6db7lf5uFfAgg8EkVRrSns/WR5HvQf63W92+3qen2x9By1tArDicHieI76riXD23Suaj8eL0H3WzJzlc46RuN4De9Gdu0Kf9473oZuaxdyV41jOTzOpQK+cmgcS2NrnpXC3JxVfenbw7U1c5rBdtQ9XVyBfPit/PG60azKLGCiVSC57f0ov8UTssVv5tlTFRY0GA2W7zLbxihZkrws3atg7WJo1iSzcyPG5+8yX1/ylgUAMLkw2hmb9czw4yrToHVEZ1jNnPrLnt7o9jbbQ8eVcNGolByktRjJdG+i2d3zUUzmcNzIO3Bjt7GLGawB2svk84zshnrcGguGYTr9pGt5DcTQIGp+/G1AI5hEGXVA2NHLfu5GLuYOkaZFX6v0vFGV0tF1P/fmHI26STM0lLDSrX69txPpwvSmn31Eq7Re1hcein2oICRRQ0zKjFKHcjTkcqc+4Rf5qumjib/3dv3Fic/noNhn7mN2V99uuRxDU1RExx9lXNywmCI+u80M276j5DbB2myc6Ual0Ohp7DsxMaQgwehPYT5KR7EohFq8upgRDhDEgVHHgevLoM1TQd6L8xgXVUGJSmCI5DzRzlXEbwskEacevgeFF9EqHMcaOcvXT41sdIhuZ0FjVIuvhOFjo2eTkyqFsxBIWMEcd7uGeelyUJBMxm14LMaEBMe67o1LDg6Ol2DwDyWgXhmHPVNCwEqzrvc9O3gZpYo95Q6Bd8shotlK1X0vdqhcJgU9bP0g3QzEl+hGgsSdNwTYAz2rlTObENBJVgn/hgD9n7jZiXgr9/yskMczwB/X/Y2nkmjg7UIyksDg57cP799/+UoebXIoKxEmAAxzlRs+Sfjf3v/CeCKP168gXmeu82l8gCpwH36leOMT/o3gQSgAwIPwIyPwuxPxH8oB4kCU71kB6w4+DoIkwmZT+CSWpqe7qq8J/+knR1bKAUAQ5fHhKea/mXcUACZGET5GCp/xRUALey+UUOGTBaLs7oaGFZ4+W+UJBQqvby188t+DMxH4Gx4DIDhDCRqDiSzLcpIkKIqiaTJPIMsafhMEiWMxwIV5wFzAcpykYJaLkCqa1WolRBXDFFUVuTVeU4jO+UyTkzlJ0OSai6mVTrtlzdbOcNrEmA5XK2dmtdqdSlVUUY2XBY5jIchJhHyZryFCb1nr1XRge9ux0TcwJn5waA6dGdbAEjgORZJYCLMKMCvQTgXGk8m4nwjMqQAiAjSE0xQ4kgJKUnBW0+YApzAYTIfO2ppfS4EWEVINBVfeRSopYiUFqSItokyLCCG82AksQ7IRoibGfdQ03EbSR4iPBsxVL1AAAgizv6gByM9/gvIT+AeevlMDy20U7QAAAABJRU5ErkJggg==" width="64" height="64">
      <img id="sdIcon" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAB3RJTUUH4gEDCiAS0ydGSwAAABpJREFUWMPtwQEBAAAAgiD/r25IQAEAAADvBhAgAAGX91fXAAAAAElFTkSuQmCC" width="32" height="32">
      <img id="sdTypeIcon" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAB3RJTUUH4gEDCiAS0ydGSwAAABpJREFUWMPtwQEBAAAAgiD/r25IQAEAAADvBhAgAAGX91fXAAAAAElFTkSuQmCC" width="32" height="32">
      <img id="sdFormatIcon" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAB3RJTUUH4gEDCiAS0ydGSwAAABpJREFUWMPtwQEBAAAAgiD/r25IQAEAAADvBhAgAAGX91fXAAAAAElFTkSuQmCC" width="32" height="32">
      <img id="sdSizeIcon" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAB3RJTUUH4gEDCiAS0ydGSwAAABpJREFUWMPtwQEBAAAAgiD/r25IQAEAAADvBhAgAAGX91fXAAAAAElFTkSuQmCC" width="32" height="32">   
  </div>

   <div class="logo"  > 
    <img src="data:image/png;base64,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" alt="BMLOGO" height="100%" width="100%">
  </div>

 

//Die Richtungstasten senden nach dem Klick ein Befehl über ws zum ESP
      <div class="dpadbuttons">
      <a class="up" onmousedown="sendUP()" ><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACIAAAAiCAYAAAA6RwvCAAAABmJLR0QAzQDNAM2UZCwLAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH4gEJEwcSdaiMtQAAAXtJREFUWMPtlb1KA0EUhb9NWFYUiSBsI9oJYqNwERuLYCc+gaIPIMEXsLFQX8BCrMVSEKwFG4uIHNTKwkJIYZFmSROIiLHZhBCN5Gd3DbinuczuzJ0P5swZSDWkcgZZLMkBjoArMyv+CYgkF7gE1sNP22Z2niiIpHGgCMy3/ToFCmb2GTuIpBngCZjoMOUeyJtZtZe+mR4h8sDrLxAAS8CrpKlYQCTtADddrvGBkqS1yI5GUgY4Bgp9+nAfODCzet8gkjzgGlgZMCYugA0z++gZRNIk8ABMR5RZL8CymQVde0TSHFCKEAJgFniTtNAVSGiwZ2A0hiQfAR4lbXU8mjCu94DDhJ6XE2C3EX5OCJEFzoDNhN+6O2DVzKqOpDHg1vO8RYBcLkelUvlWa7VaXzt5ntfs0d6/XC43TeyEVzT7Q4860Hrd3vsBMTMnkkBr8VA9TpAMQ6IUJAVJQVKQxEB83x8OkCAI8H0f13WbtQHoum5z3Frjhk/1v/QFZl941PVyvB4AAAAASUVORK5CYII=" /></a><br><br>
      <a class="left" onmousedown="sendLEFT()" ><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACIAAAAiCAYAAAA6RwvCAAAABmJLR0QAzQDNAM2UZCwLAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH4gEJEwooBgorSgAAAZxJREFUWMPN1zGL1EAYxvHfziWYVQTFWmuxEqdwC4vDTvQLKPgBRPwCFoKoX8DisBZLQbCw0s7iRAa52trGxs4VEu5scnqr6+3eJpvxaZLM+zL5z/MyeSf0oJTSiZTSsS5zhB4gNvAeG9lAUkojPMfFrgvq6sh93OqjvKGDG9fwWE8KK0Kcxxs9KqwAcQZpTmhvMJB2i37C8TnhZhCQlFLAW5y1Bh3Fkae4Yk0aLenGHWwtyqvrWlmWptOpoig0ze9qFUWhLEt1XWuaRlEUJpPJr/cXS0BsLgMBZVmC8Xg88/xnzrzxsADiHN4ZQOEQiJPY6aMfrQySUiqxjVMGUvhHI3uFCwbUPEee4LqBNQ/ktQz6CyTGuI3b/4MjYowv8Cw7SKu7+JgdJMa4i018ze2IGON3XMJuVpAW5gtuLMqrqkpVVUIIM1fMjO3f78eO1H3bD90DPDwEeLRWRw7oEV5mK82BFe/hJj7nPqGJMTa4jB9ZQVqYb5hkB2lhdvpuAysfeto2sJUdpNU9fMgO0raBq+vaSav8C5/uOsdPIFVn6qDUv0wAAAAASUVORK5CYII=" /></a>
      <a class="stop" onmousedown="sendSTOP()" ><img src="" /></a>
      <a class="right" onmousedown="sendRIGHT()" ><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACIAAAAiCAYAAAA6RwvCAAAABmJLR0QAzQDNAM2UZCwLAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH4gEJEwoYINMb5gAAAXtJREFUWMPNl71KXEEYhh/Hc/CsIhhSx1pSiW+hhUWSTpIbUNgbMOQGbAIxuQELkzpYCkKKVAYsUpwQXoK1tU2adCFwhl2rjaIbWbO433mrYWaYefhmvj8YU7ZnbM+Ne05ifE0DX21PR4MALAMfbU9FgwBsATttAAF4a3ujDSAAn20vRYD0hzuTH04aJA+ZmwV+2J6JfJqBHgHHtlM0CMA6sDfKxht+X9d1P+dMURSUZUnTNOR8af2iKMg50+l0aJqGsixHuWdb0vs7gdju35N1nko6iXqaq/pie7ENIAk4tT0fDQKwANS2y2gQgMfA0fUEGQEC8Bx41wYQgE9tAOlKqqNBPkg6iP6s34GX0e77E3giqRcJ0gNWJP0eObJWVUVVVaSUSCn9HQ/Wrs4N9o6gF5LO75T0/rO3uS1Rvpb0JroeOQR2owujM2BTUj8S5A+wKilH16xrkn5F9zVdSafRDdb+sPA9aZBvwKvo3vcMePav8D0x2X4w7hkX901rU8hf9fwAAAAASUVORK5CYII=" /></a><br><br>
      <a class="down" onmousedown="sendDOWN()" ><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACIAAAAiCAYAAAA6RwvCAAAABmJLR0QAxADEAMTvec1RAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH4gEJEwwcceR4eQAAAW1JREFUWMPtl71KA0EUhb+MWRasBGvTCWIVPEJkG9OK1lb6AL6DYOUjKD6AWAmChVZ2Fkq4SBqbdIKNIKkMLhuNzSoR87MxmyhhD2xx9w4zH8zMnXMhU6beyiUdWKlUWlEU4XkeAM45wjD8iqMoAvgRB0GQaI18UhDnHL7vf/vXHvfKJZr/v2xNBpKBZCAZyMSA5M3MB6Y65FpAc2wg8XcNFEexgJm1+gypASUn6QVYBk7+YEdugaKkugOQ9AZsAbtjhDgEAkmNjn7EzNaAixFDbEs67muMzGwBMGA6ZYBXYEVSNbFDM7NZ4A6YSwmiBpQk1QeqI5Kegfn4Rg2rU2CxG0TfgiYpBFaBgyEg9oBNSc1UzLOZ7cQnPanegQ1Jl6m6+BimDFwleBqegCVJj6m3E20wBaAKzHTrPIDyZ30Y2aMn6QEoAPcd0kfx9WwMOm/utyfQzDzgDFjvVqTGAhLD5IB94FzSTdY4T6Q+AF4dX4s6WYpkAAAAAElFTkSuQmCC" /></a><br><br>
   
      <a class="left" onmousedown="sendSERVOLEFT()" ><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACIAAAAiCAYAAAA6RwvCAAAABmJLR0QAzQDNAM2UZCwLAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH4gEJEwooBgorSgAAAZxJREFUWMPN1zGL1EAYxvHfziWYVQTFWmuxEqdwC4vDTvQLKPgBRPwCFoKoX8DisBZLQbCw0s7iRAa52trGxs4VEu5scnqr6+3eJpvxaZLM+zL5z/MyeSf0oJTSiZTSsS5zhB4gNvAeG9lAUkojPMfFrgvq6sh93OqjvKGDG9fwWE8KK0Kcxxs9KqwAcQZpTmhvMJB2i37C8TnhZhCQlFLAW5y1Bh3Fkae4Yk0aLenGHWwtyqvrWlmWptOpoig0ze9qFUWhLEt1XWuaRlEUJpPJr/cXS0BsLgMBZVmC8Xg88/xnzrzxsADiHN4ZQOEQiJPY6aMfrQySUiqxjVMGUvhHI3uFCwbUPEee4LqBNQ/ktQz6CyTGuI3b/4MjYowv8Cw7SKu7+JgdJMa4i018ze2IGON3XMJuVpAW5gtuLMqrqkpVVUIIM1fMjO3f78eO1H3bD90DPDwEeLRWRw7oEV5mK82BFe/hJj7nPqGJMTa4jB9ZQVqYb5hkB2lhdvpuAysfeto2sJUdpNU9fMgO0raBq+vaSav8C5/uOsdPIFVn6qDUv0wAAAAASUVORK5CYII=" /></a>
      <a class="right" onmousedown="sendSERVORIGHT()" ><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACIAAAAiCAYAAAA6RwvCAAAABmJLR0QAzQDNAM2UZCwLAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH4gEJEwoYINMb5gAAAXtJREFUWMPNl71KXEEYhh/Hc/CsIhhSx1pSiW+hhUWSTpIbUNgbMOQGbAIxuQELkzpYCkKKVAYsUpwQXoK1tU2adCFwhl2rjaIbWbO433mrYWaYefhmvj8YU7ZnbM+Ne05ifE0DX21PR4MALAMfbU9FgwBsATttAAF4a3ujDSAAn20vRYD0hzuTH04aJA+ZmwV+2J6JfJqBHgHHtlM0CMA6sDfKxht+X9d1P+dMURSUZUnTNOR8af2iKMg50+l0aJqGsixHuWdb0vs7gdju35N1nko6iXqaq/pie7ENIAk4tT0fDQKwANS2y2gQgMfA0fUEGQEC8Bx41wYQgE9tAOlKqqNBPkg6iP6s34GX0e77E3giqRcJ0gNWJP0eObJWVUVVVaSUSCn9HQ/Wrs4N9o6gF5LO75T0/rO3uS1Rvpb0JroeOQR2owujM2BTUj8S5A+wKilH16xrkn5F9zVdSafRDdb+sPA9aZBvwKvo3vcMePav8D0x2X4w7hkX901rU8hf9fwAAAAASUVORK5CYII=" /></a>
    
    </div>


</body>
</html>




)=====";

