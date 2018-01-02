const char handleMAP[] PROGMEM = R"=====( 
<head>

<meta name="viewport" content="width=device-width, initial-scale=1" /> 
<style>
body {
  background: #00BCD4;
  min-height: 100vh;
  overflow: hidden;
  font-family: Roboto;
  color: #fff;
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


.buttons:nth-last-child(1) {
  -webkit-transition-delay: 25ms;
          transition-delay: 25ms;
  background-image: url('data:image/png;base64,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');
  background-size: contain;
}

.buttons:not(:last-child):nth-last-child(2) {
  -webkit-transition-delay: 50ms;
          transition-delay: 20ms;
  background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAMAAACdt4HsAAACl1BMVEUAAAACAgIDAwMEBAQAAAAAAAAAAAACAgIAAAABAQEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADt7e0AAAAAAAAAAAAAAAAGBgYAAAAAAAD5+flDQ0P09PQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAQEAAAAAAADl5eXPz8/19fVMTExXV1cAAAAAAAAAAAC8vLwAAAAAAAD4+Pj+/v7l5eX8/Pzb29vIyMj09PSsrKz5+fmMjIxiYmJ3d3daWlo+Pj7z8/P39/cUFBQuLi4eHh75+fn39/f09PQLCwv09PT09PTs7OxxcXEAAADf399/f3/v7+8AAADJycnk5OTf398AAACsrKzT09P5+fnDw8P+/v729va4uLi4uLilpaX8/Pzb29uhoaH19fW+vr6YmJjX19fAwMCzs7O3t7dqamr29vaDg4Nra2s3Nzf19fXy8vKQkJCHh4cKCgra2togICAAAADZ2dkNDQ3s7OwwMDAkJCTg4OAWFhby8vINDQ3KyspNTU1ISEje3t51dXV1dXXHx8eYmJiSkpLCwsJKSkpHR0fc3Ny3t7fY2NiIiIgAAABoaGh8fHz///8AAAD9/f1JSUn29vbPz88dHR319fXKysq9vb36+vrl5eXb29uTk5NNTU3y8vLT09PFxcXDw8PR0dG5ubm3t7eXl5f4+PjV1dXHx8e1tbWurq7r6+vn5+fMzMzBwcGwsLDv7+/Z2dmcnJyLi4tzc3MGBgbh4eHX19epqamUlJRpaWleXl4fHx/Ozs6ysrKtra2mpqaioqKQkJCDg4OCgoJ/f395eXltbW1YWFg7Ozs3NzcvLy/d3d2goKCFhYVoaGhgYGBKSkpISEgXFxePDAQiAAAAmHRSTlMAAgQGNAu3Fgm8nYcOr42KOBmlXEAp/auDdG9gHxzNy6+hlpBqZVdQSi0hFBH+9dvS0aeTLyMiEvz6+fb18+3p3tzb2tnPzsrHxcC3tqCdnJGPgX99fHt5c1tLRhn28PDv7u7r6+rp6efm5uXi4d7b09LPycPAvbi3trOxr62iop2NhYKAf3d1amlmZVlQSUZCOzk2MjEkFCGQjS8AAATuSURBVFjDtVf1l9pAEG6wQwtcr73eXd3d3d3d3d3d3d0lodACpUAp0DvKUa7t1d3d/5hCdjbJhiSV9zo/ZPdl5/syMzs7OynzP4XCI0X9C7z1+OHV+jbt1m3Z6i2jjpgp1V+RUOOrtacJabr9lOqPDWk92AEwkmOcWU39CXwgLScdd5t/64lqKK0k0w9plRmOd6R/I+srqRXwO0llb9xX6Lp78QLxsstReSMGCsFBd6Lw4gUv7Yz7XEVFcX7Fsb+tDEMVXqn48hUv8d07l1381ozOopTx8dDFTOevFiW4+Qi7BMMgzkT3J1pSLniK8XRvpg1j8Fog5KDlJOiGSbsCcRxOYp2LLlpBKoRhsrCeliSYhvGFtKI4IzBZqyHyYRiOflCoHQjff/XqfjggybCrksCJSXjVLQjZ6/MMyPnXFwReXEbjkjpmnqAaLF7ns+UBQ8hXPrKuxmjc1kolNiDIfSh0mxHJ7RDHcA0Ni2s3pMgIeB9jlSgjIfc558DQIRpsAlQfLgCXGEm5hNdjaFhe0AiZMAHcxhngYWTEg7MaTTpZyyMTBkNwHLAsCf6Zflwlo7C5np4lmE168E4Kf56NyztQuYI2YkU+eyTOQg7chVyUxDtQZPEpTbLPrqwPFIQgCAXggQye9qcmDwgfOhlz1CmCMaQHt2Xw59hsIPchl83GoQRBoSyeFThrRSXssK5WFl9JIItuKuKZm1Dh0KHrP7ZSiqAv7CIaSlm97z5pPFNKJGPViuX5WngFDQ/Tan6aviGJZ75BEJ4gAmt9aYIoDQxiPPMQki2CCMpqUgSrCBfecml/g8CDvEVaJehsrmQJqhG78II/OD7mkRjPvICk8bHDgDQBNZwguCw4ekGnGM9AOYqgyqEznU4R7IOthfAQh1eMZ0DpGapuG9O7QJ1A73xQO/0EgwjvBwKUDlMtY9ukYqCGenSF9wEYAJ/pgROdhe4t8u3phqgPIIH9I6ce9YvwH0HlKQpBb2O5RummZBScggD4wsiKDwhQfBy6lmxFoc7QZBhfyuFf4nqSQOXAYkLXkwp8SDhpURylI0jfQkPv7Hx0O1EHoapCuYbYieUHd2mgcHfQ1YDLidJPAe+5vuJNJv4NLTJgaW5FfMGqxuGC7uDur0ck/JGLx3tRFhmMtXGjQmnngRNhmpPkBx7+Icm/v3cDjb1yrTl6rr08zHUxwpv8Xqn//Xt/6T0UXDASNJrojLUEF7x+E6yXwLqchLGN/bJNyABwonIX3FTEHAr453ijellaliMaLfUxjHM8KZbtb77cgdlcnTGvPtnzag9weomIND4ZxbPOhuoVc0QdL9VoNN+exMKZfkRucVnSxJBtrQvdhYAha4SgU45ccwvRrpvRYpr/fnbZcpVVmf859j3tBJh47Om1mCcU8iSfPf98V7AwK41vAHiRDQVzxA1yoMQpetVDV90K+EyGtvXW0MoyuZ/FWLGuhP04p207FinAAz10LWrk5WQBXkrUDepsnS/XKPc05BpNBfWVf5sos6bWkO4dMuEzmulyjdb8HPvv/v0oVZatds0NPWc25vOiyYJmBkt2DVOtiQ30AFekUDesXzevZnXLgKrNmzdv1t+gs7SoXsOUV85WWU94r2SF1t5qYkH+SFPZmi1rljWNzKtd19amERj/pxx6s71NeY3NZtO0Kl+5oVYG/QsGbJghWITjZwAAAABJRU5ErkJggg==');
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
}
[tooltip]:hover:before,
[tooltip]:hover:after {
  visibility: visible;
  opacity: 1;
}
</style>
</head>
<body>
  <nav class="container"  > 
    <a href="#" class="buttons" tooltip="more"></a>
    <a href="#" class="buttons" tooltip="drive Robby"></a>
    <a href="#" class="buttons" tooltip="get the App"></a>
    <a href="#" class="buttons" tooltip="test Robby"></a>
    <a class="buttons" tooltip="menu" href="#"></a>
</body>
)=====";

