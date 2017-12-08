<?php
$myIp = getHostByName(getHostName());
$r = $myIp;

$host = $r; //ip vom Host
$port = '10053'; //port
$null = NULL; //null var

//eerzeuge TCP/IP stream socket
$socket = socket_create(AF_INET, SOCK_STREAM, SOL_TCP);
//widerverwendbarer port
socket_set_option($socket, SOL_SOCKET, SO_REUSEADDR, 1);

//binde socket zum host
socket_bind($socket, 0, $port);

//listening auf port
socket_listen($socket);
echo "\n\n\nServer gestartet\nWarte auf Verbindung...\n";
echo "\n\nIhre IP-Adresse lautet: ".$host."\nIhr Port lautet: ".$port."\n\n";

//listening socket in die arrayliste eintragen
$clients = array($socket);

//starte endless loop, damit unser script nicht aufhört
while (true) {
    //manage multiple verbindungen
    $changed = $clients;
    //Rückgabe in $changed array
    socket_select($changed, $null, $null, 0, 10);

    //Checke nach neuen sockets
    if (in_array($socket, $changed)) {
        $socket_new = socket_accept($socket); //akzeptiere neuen socket
        $clients[] = $socket_new; //füge socket zu client array hinzu

        $header = socket_read($socket_new, 1024); //socket-data auslesen
        perform_handshaking($header, $socket_new, $host, $port); //websocket handshake

        socket_getpeername($socket_new, $ip); //ip address vom verbundenen socket
        $response = mask(json_encode('connected')); //json data
        send_message($response); //Nitification an alle user

        //mache Platz für neuen socket
        $found_socket = array_search($socket, $changed);
        unset($changed[$found_socket]);
    }

    //loop über alle verbundenen sockets
    foreach ($changed as $changed_socket) { 

        //checke alles was an daten reinkommt
        while(socket_recv($changed_socket, $buf, 1024, 0) >= 1)
        {
			
            $received_text = unmask($buf); //unmask data
            $tst_msg = json_decode($received_text); //json decode
			
			//Auswertung der Nachrichten
			if (strpos($received_text, "RW:") === 0):
				$small = substr($received_text, 0, 6);
				echo "\n".$small;
			elseif (strpos($received_text, "VW:") === 0):
				$small = substr($received_text, 0, 6);
				echo "\n".$small;
			elseif (strpos($received_text, "L:") === 0):
				$small = substr($received_text, 0, 5);
				echo "\n".$small;
			elseif (strpos($received_text, "R:") === 0):
				$small = substr($received_text, 0, 5);
				echo "\n".$small;
			elseif (strpos($received_text, "Brofist") === 0):
				send_message(mask(json_encode('BrofistIsOk')));
			else:
				echo "\n".$received_text;
			endif;

			
            break 2; //beende den loop
        }

        $buf = @socket_read($changed_socket, 1024, PHP_NORMAL_READ);
        if ($buf === false) { // Checke nach verbindungsabbruch
            // lösche clients in $clients array
			echo "\nVerbindung zu RoboRemote geschlossen";
            $found_socket = array_search($changed_socket, $clients);
            socket_getpeername($changed_socket, $ip);
            unset($clients[$found_socket]);

            //Notification an alle user
            $response = mask(json_encode('disconnected'));
            send_message($response);
        }
    }
}
// Schließe den listening socket
socket_close($sock);

function send_message($msg)
{
    global $clients;
    foreach($clients as $changed_socket)
    {
        @socket_write($changed_socket,$msg,strlen($msg));
    }
    return true;
}


function unmask($text) {
    $length = ord($text[1]) & 127;
    if($length == 126) {
        $masks = substr($text, 4, 4);
        $data = substr($text, 8);
    }
    elseif($length == 127) {
        $masks = substr($text, 10, 4);
        $data = substr($text, 14);
    }
    else {
        $masks = substr($text, 2, 4);
        $data = substr($text, 6);
    }
    $text = "";
    for ($i = 0; $i < strlen($data); ++$i) {
        $text .= $data[$i] ^ $masks[$i%4];
    }
    return $text;
}

//bereite nachricht für den transver zum client vor
function mask($text)
{
    $b1 = 0x80 | (0x1 & 0x0f);
    $length = strlen($text);

    if($length <= 125)
        $header = pack('CC', $b1, $length);
    elseif($length > 125 && $length < 65536)
        $header = pack('CCn', $b1, 126, $length);
    elseif($length >= 65536)
        $header = pack('CCNN', $b1, 127, $length);
    return $header.$text;
}

//handshake neuer client.
function perform_handshaking($receved_header,$client_conn, $host, $port)
{
    $headers = array();
    $lines = preg_split("/\r\n/", $receved_header);
    foreach($lines as $line)
    {
        $line = chop($line);
        if(preg_match('/\A(\S+): (.*)\z/', $line, $matches))
        {
            $headers[$matches[1]] = $matches[2];
        }
    }

    $secKey = $headers['Sec-WebSocket-Key'];
    $secAccept = base64_encode(pack('H*', sha1($secKey . '258EAFA5-E914-47DA-95CA-C5AB0DC85B11')));
    //hand shaking header
    $upgrade  = "HTTP/1.1 101 Web Socket Protocol Handshake\r\n" .
    "Upgrade: websocket\r\n" .
    "Connection: Upgrade\r\n" .
    "WebSocket-Origin: $host\r\n" .
    "WebSocket-Location: ws://$host:$port/demo/shout.php\r\n".
    "Sec-WebSocket-Accept:$secAccept\r\n\r\n";
    socket_write($client_conn,$upgrade,strlen($upgrade));
}