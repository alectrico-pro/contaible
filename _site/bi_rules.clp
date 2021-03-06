;https://www.rbasesoria-madrid.com/que-ocurre-si-el-patrimonio-neto-se-reduce-por-debajo-del-capital-social
;El problema surge cuando la sociedad acumula pérdidas y el patrimonio neto disminuye por debajo de la cifra de capital social. En este sentido la LSC en su art. 363.1.e) establece que la sociedad de capital deberá disolverse cuando  “Por pérdidas que dejen reducido el patrimonio neto a una cantidad inferior a la mitad del capital social, a no ser que éste se aumente o se reduzca en la medida suficiente, y siempre que no sea procedente solicitar la declaración de concurso“.

;Bussiness Intelligence 
;Este modulo verifica e informa de errores contables
;
(defmodule BI
 (import MAIN deftemplate ?ALL)
 (export ?ALL)
)


(defrule iterando-abonos
  (no)
 =>
  (printout t "abonos" crlf)
  (do-for-all-facts ((?f abono)) TRUE  
    (printout t ?f:partida crlf)
  ) 
)



(defrule fin
  ( declare (salience -100) )
 =>
; ( printout k "</ul>" crlf)

  ( close k )
)

;esto genera un markdown para que jekyll lo publique en el blog necios
(defrule inicio-kindle-k-partida-rules
   ( declare (salience 10000))
   ( empresa (nombre ?empresa))

  =>

   ( if (neq nil k) then (close k))
   ( if (neq nil h) then (close h))


   ( bind ?archivo (str-cat "./doc/" ?empresa "/bi.markdown"))

   ( open ?archivo k "w")

   ( printout k "--- " crlf)
;   ( printout k "title: Libro Diaro" crlf)
   ( printout k "permalink: /" ?empresa "/bi " crlf)
   ( printout k "layout: page" crlf)
   ( printout k "--- " crlf)
   ( printout k "" crlf)
   ( printout k "<h1> BI </h1>" crlf)
)

(defrule iterando-f29-f22-lista
  ( f29-f22 (codigo-f29 ?codigo) (cuenta ?cuenta))
  ( subtotales (cuenta ?cuenta) (deber ?deber) (acreedor ?acreedor))
  ( formulario-f22  (codigo ?codigo) (valor ?valor) (anual true) )
  ( exists  ( cuenta (nombre ?cuenta)))
  =>
   (printout t "F22s----------LISTA-------------" crlf)
   (printout k "<table><thead> <tr> <th> F22s LISTA </th></tr></thead> " crlf)
   (do-for-all-facts ((?f f29-f22))  ( eq ?codigo ?f:codigo-f29)
     (printout t ?f:codigo-f29 tab ?valor tab (* ?deber 0.19) tab  (* ?acreedor 0.19) tab ?f:cuenta crlf)
     (printout k "<tr> <td> " ?f:codigo-f29 " </td><td> " ?valor  " </td><td> " (* ?deber 0.19) " </td><td> "  (* ?acreedor 0.19) "</td><td>"  ?f:cuenta "</td></tr>" crlf)
   )
   (printout t "---------------------------" crlf)
)




(defrule partidas-sin-revision
  (partida (numero ?numero)) 
  (not (exists (revision (partida ?numero))))
 =>
  (printout t "Partida sin registro de revisión: " ?numero crlf)
)


(defrule formulario-f22-encabezado
  (declare (salience 20))
 =>
  (printout k "<table>" crlf)
  (printout t crlf crlf F22 crlf)
  
  (printout t Codigo tab valor tab saldo tab iva tab resultado tab cuenta crlf)
  (printout k "<thead><tr> <th> " Código "</th><th> " Valor "</th><th> " Saldo " </th><th> " IVA "</th> <th> " Resultado "</th><th> " Cuenta "</th></tr> </thead>  " crlf)
  ( assert (hacer-f22))
)




(defrule consolidando-codigo-f22-iguales-codigos
  (declare (salience 30))
  (hacer-f22)
  ?c1 <- (codigo-f22 (codigo ?codigo)  (valor ?valor))
  ?c2 <- (codigo-f22 (codigo ?codigo2) (valor ?valor2))

  (test ( eq ?codigo ?codigo2))
  (test ( < ?codigo2 0))
  (test ( > ?codigo 0))

  (f29-f22    (cuenta ?cuenta)  (codigo-f29 ?codigo) )
  (f29-f22    (cuenta ?cuenta2) (codigo-f29 ?codigo2))

  (subtotales (cuenta ?cuenta)  (debe ?debe)  (haber ?haber))
  (subtotales (cuenta ?cuenta2) (debe ?debe2) (haber ?haber2))

  (cuenta (nombre ?cuenta) (tipo acreedora))
  (cuenta (nombre ?cuenta2) (tipo acreedora))

 =>

  ( bind ?nvalor (+ ?valor ?valor2))
  ( bind ?ndebe  (+ ?debe ?debe2))
  ( bind ?nhaber (+ ?haber ?haber2))
  ( modify ?c1 (codigo ?codigo) (valor ?nvalor))
  ( retract ?c2)
  ( printout t "Consolidando =" tab ?codigo " Valor: " ?nvalor  crlf)
  ( printout k "<table>" crlf)
  ( printout k "<thead> <tr> <th> Consolidando  </th><th>" ?codigo "</th> <th> " ?nvalor " </th> </tr> </thead" crlf)
  ( printout t tab "valor: " ?valor tab " Valor2 " ?valor2 crlf)
  ( printout t tab tab codigo tab valor debe tab haber tab cuenta crlf)
  ( printout t tab "1: " tab ?codigo tab ?valor tab ?debe tab ?haber tab ?cuenta tab crlf)
  ( printout t tab "2: " tab ?codigo2 tab ?valor2 tab ?debe2 tab ?haber2 tab ?cuenta2 tab crlf)
  ( printout t tab "-------------------------------------" crlf)
  ( printout t tab tab tab ?nvalor tab ?ndebe tab ?nhaber tab "dif: " (abs (- ?nvalor (+ ?ndebe ?nhaber))) crlf)
  ( printout t "Diferencia de cuenta acreedora es: " (abs (- ?nvalor (* 0.19 ?debe))) crlf)}
  
)



(defrule consolidando-los-rechazados-de-cuentas-haber-mayor-con-dos-cuentas
  (declare (salience 30))
  (hacer-f22)

  ?c1 <- (codigo-f22 (codigo ?codigo)  (valor ?valor))
  ?c2 <- (codigo-f22 (codigo ?codigo2) (valor ?rechazo))

  (test ( eq ?codigo (* -1 ?codigo2)))
  (test ( < ?codigo2 0))
  (test ( > ?codigo 0))

  (f29-f22    (cuenta ?cuenta)  (codigo-f29 ?codigo) )
  (f29-f22    (cuenta ?cuenta) (codigo-f29 ?codigo2))

  (subtotales (cuenta ?cuenta)  (debe ?debe)  (haber ?haber))
  (cuenta (nombre ?cuenta) )

  (test (> ?haber ?debe))

 =>

  ( bind ?nvalor (+ ?valor ?rechazo))
  ( bind ?ndebe  (+ ?debe ?rechazo))
  ( modify ?c1 (codigo ?codigo) (valor ?nvalor))
  ( retract ?c2)
  ( printout k "<table>" crlf)
  ( printout t "-----------------------------------------------" crlf)
  ( printout t tab tab codigo tab valor tab rechazo crlf)
  ( printout k "<tr><td></td><td>código </td><td> valor </td> <td> ajuste </td> </tr>" crlf)
  ( printout t tab "1: " tab ?codigo tab ?valor tab ?rechazo crlf)
  ( printout k "<tr> <td> 1: </td> <td> " ?codigo " </td><td> " ?valor "</td><td>" ?rechazo "</td></tr>" crlf)
  ( printout t tab "cuenta " ?cuenta " debe: " ?debe " haber: " ?haber crlf)
  ( printout k "<tr> <td> cuenta: </td> <td> " ?cuenta "</td><td> " ?debe "</td> <td> " ?haber "</td><td> </tr> " crlf)
  ( printout t tab "Será ajustado el saldo de la cuenta para aceptar rechazos informados por los códigos." crlf)
  ( printout t tab (- ?haber ?rechazo) crlf)
  ( printout k "<tr> <td> " (- ?haber ?rechazo)  "</td></tr> " crlf)
  ( printout k "</table> " crlf)
  ( printout t tab "-------------------------------------" crlf)
  ( printout t "-----------------------------------------------" crlf)
)



(defrule consolidando-los-rechazados-de-cuentas-haber-mayor-con-tres-cuentas
  (declare (salience 30))
  (hacer-f22)

  ?c1 <- (codigo-f22 (codigo ?codigo)  (valor ?valor))
  ?c2 <- (codigo-f22 (codigo ?codigo2) (valor ?rechazo))
 
  (test ( eq ?codigo (* -1 ?codigo2)))
  (test ( < ?codigo2 0))
  (test ( > ?codigo 0))

  ?f1 <- (f29-f22    (cuenta ?cuenta)   (codigo-f29 ?codigo))
  ?f2 <- (f29-f22    (cuenta ?cuenta2)  (codigo-f29 ?codigo))
  ?f3 <- (f29-f22    (cuenta ?cuenta)   (codigo-f29 ?codigo2))

  (subtotales (cuenta ?cuenta)   (debe ?debe)  (haber ?haber))
  (subtotales (cuenta ?cuenta2)  (debe ?debe2)  (haber ?haber2))

  (cuenta (nombre ?cuenta) )
  (cuenta (nombre ?cuenta2))

  (test (> ?haber ?debe))

  (test (neq ?cuenta ?cuenta2))

 =>

  ( printout k "<table>" crlf)

; ( printout k "<li><span style='color: white; background-color: cornflowerblue'>[    ]</span> -------- Consolidación 3X --- Acreedora --------------  </li>" crlf)

  ( bind ?nvalor (+ ?valor ?rechazo))
  ( bind ?ndebe  (+ ?debe ?rechazo))
  ( modify ?c1 (codigo ?codigo) (valor ?nvalor))
  ( retract ?c2)
  ( retract ?f1)
  ( retract ?f2)
  ( retract ?f3)
  ( printout t "-------- Consolidación 3X --- Acreedora --------------" crlf)
  ( printout t tab tab codigo tab valor tab rechazo crlf) 
  ( printout k "<thead> " crlf)
  ( printout k "<tr><th align='center' colspan=7> Consolidación 3X --- Acreedora </th></tr> " crlf) 
  ( printout k "<tr><th> caso </th> <th> cuenta </th><th style='background-color:gold'> Meta </th><th> </th> <th> debe </th> <th> haber </th> </tr> " crlf)
  ( printout t tab "a): " ?cuenta  " debe: " ?debe " haber: " ?haber crlf)
  ( printout k "<tr> <td> a):  </td> <td> " ?cuenta "</td><td></td><td> </td><td align='right' > " ?debe "</td> <td align='right'>  " ?haber "</td> </tr> " crlf)
  ( printout t tab "b): " ?cuenta2 " debe: " ?debe2 " haber: " ?haber2 crlf) 
  ( printout k "<tr><td> b): </td><td> " ?cuenta2 " </td> <td> </td><td></td><td align='right'> " ?debe2 "</td> <td align='right'> " ?haber2 " </td> </tr>" crlf)
  ( printout t tab "c): " tab ?codigo tab ?valor tab ?rechazo crlf)
  ( if (> ?rechazo 0)
    then
   ( printout k "<tr><td> c): </td> <td> " ?codigo " </td><td> " ?valor " </td> <td> </td> <td> </td><td align='right'> "  ?rechazo " </td> </tr> " crlf)
    else
   ( printout k "<tr><td> c): </td> <td> " ?codigo " </td><td> " ?valor " </td> <td> </td><td align='right' > " (abs ?rechazo) " </td><td> </td> </tr> " crlf)
  )
  ( printout t tab "------------------------------------------------------------" crlf)
  
  ( printout t tab "                                       a (=) " ?haber crlf)
  ( printout k "<tr><td></td><td></td><td></td><td> a </td><td> (=) </td><td align='right'>  " ?haber  " </td></tr>" crlf)
  ( printout t tab "                                       b (+) " ?haber2 crlf)
  ( printout k "<tr><td></td><td></td><td></td><td> b </td><td> (+) </td><td align='right'>  " ?haber2  " </td></tr>" crlf)

  ( printout t tab "                                         (=) " (+ ?haber ?haber2 ) crlf)
  ( printout k "<tr><td></td><td></td><td></td><td>  </td><td>  (=) </td><td align='right'> " (+ ?haber ?haber2 ) " </td></tr>" crlf)

  ( printout t tab "                                       c (-) " ?rechazo crlf)
  ( printout k "<tr><td></td><td></td><td></td><td>   c </td><td> (-) </td> <td align='right'> " ?rechazo "</td> </tr>"crlf)

  ( printout t tab "                                           -------------------- " crlf)

  ( printout k "<tr><td></td><td></td><td> " ?valor "</td><td> </td><td>  (=) </td><td align='right'> " (+ ?haber ?haber2 ?rechazo ) " </td></tr> "  crlf)

  ( printout t tab "                                         (=) " (+ ?haber ?haber2 ?rechazo ) crlf)

  (if
    (eq ?valor (+ ?haber ?haber2 ?rechazo))  then
     (printout t "                    PASS ok"  crlf)
     ( printout k "<tr style='background-color:lightgreen' ><td> </td><td></td><td></td><td></td><td></td><td>   PASA OK </td><td></td></tr> "  crlf)
    else
     (printout t "                    FAIL  "  crlf)
     ( printout k "<tr style='background-color:crimson' > <td></td><td></td><td></td><td></td><td></td><td>   NO PASA </td></tr> " crlf)
  )
  ( printout t "-----------------------------------------------" crlf)
  ( printout k "</thead>" crlf)
 ;able> " crlf)
)



(defrule consolidando-los-rechazados-de-cuentas-debe-mayor-con-codigos-de-la-misma-cuenta-solo-iva

  (declare (salience 30))
  (hacer-f22)

  ?c1 <- (codigo-f22 (codigo ?codigo-f29)  (valor ?valor))
  ?c2 <- (codigo-f22 (codigo ?codigo-de-rechazo) (valor ?rechazo))

  (test ( eq ?codigo-f29 (* -1 ?codigo-de-rechazo)))
  (test ( < ?codigo-de-rechazo 0))
  (test ( > ?codigo-f29 0))

  (f29-f22    (cuenta ?cuenta)  (codigo-f29 ?codigo-f29) )
  (f29-f22    (cuenta ?cuenta)  (codigo-f29 ?codigo-de-rechazo))

  (subtotales (cuenta ?cuenta)  (debe ?debe)  (haber ?haber))

  (cuenta (nombre ?cuenta) )

  (test (> ?debe ?haber))

 =>

  ( bind ?nvalor (round (+ ?valor ?rechazo)))
  ( bind ?iva (round (* 0.19 ?debe)) )
  ( modify ?c1 (codigo ?codigo-f29) (valor ?nvalor))
  ( retract ?c2)
  ( printout t "------- Consolidación 2X Deudoras -------------" crlf)
  ( printout k "<table>" crlf)
  ( printout k "<thead> <tr> <th colspan='8' align='center'> Consolidación 2X Deudoras </th> </tr>" crlf)
  
  ( printout t tab tab codigo tab valor tab rechazo crlf)
  ( printout k "<tr> <th></th> <th> cuenta </th><th> debe </th> <th> haber </th><th colspan='3'>  iva </th> </tr> " crlf)
  ( printout k "</thead>" crlf)
  ( printout t tab "a): " ?cuenta  " debe: " ?debe tab iva tab  ?iva crlf)
  ( printout k "<tr> <td> a): </td> <td>" ?cuenta "</td> <td align='right'> " ?debe " </td> <td align='right'> 0 </td> <td></td><td></td> <td align='right'> " ?iva " </td> </tr> " crlf)
  ( printout t tab "    " tab codigo tab valor tab ajuste tab iva crlf)
  ( printout k "<tr>  <td> F29 </td> <td> código </td> <td> </td> <td>  </td><td> valor <small> b): </small> </td> <td> ajuste por transacciones rechazadas <small> c): </small> </td> </tr> " crlf)
  ( printout t tab "c: " tab ?codigo-f29 tab ?valor tab ?nvalor tab ?iva crlf)
  ( printout k "<tr> <td> </td> <td> " ?codigo-f29 " </td> <td></td><td></td> <td align='right'> " ?valor " </td> <td align='right'>" ?rechazo "</td></tr>" crlf)
  ( printout t tab "------------------------------------------------------------" crlf)
  ( printout k "<thead>" crlf)
  ( printout k "<tr> <th> </th> <th></th> <th></th> <th></th><th></th> <th></th><th style='background-color:gold'> Meta </th> </tr> " crlf)
  ( printout k "</thead> " crlf)
  ( printout t tab "                                       a (=) " ?valor crlf)
  ( printout k "<tr> <td> b): <td></td><td></td> </td> <td> (=) </td> <td align='right'> " ?valor "</td> </tr>" crlf)
  ( printout t tab "                                       c (+) " ?rechazo crlf)
  ( printout k "<tr> <td> c): </td> <td></td><td></td> <td> (+) </td> <td align='right'> " ?rechazo "</td>  </tr>" crlf)

  ( printout t tab "                                           -------------------- " crlf)
  ( printout t tab "                                         (=) " ?nvalor crlf)
  ( printout k "<tr><td></td><td> </td><td></td> <td> (=) </td> <td align='right'> " ?nvalor "</td><td></td><td> " ?iva "</td> </tr>" crlf)

  (if (< (abs  (- ?nvalor ?iva)) 2)  then
     (printout t "                    PASA OK"  crlf)
    ( printout k "<tr style='background-color:lightgreen'> <td> </td> <td></td><td></td><td> </td> <td></td><td></td> <td></td><td> PASA </td> </tr>" crlf)
    else
     (printout t "                    NO PASA  "  crlf)
    ( printout k "<tr style='background-color:crimson'> <td> </td> <td> </td> <td> </td><td></td><td></td><td></td><td><td></td><td></td><td> NO PASA </td> </tr>" crlf)

  )

  ( printout t tab (abs (- ?nvalor ?iva)) crlf)
  ( printout t tab "-------------------------------------" crlf)
  ( printout t "-----------------------------------------------" crlf)
  ( printout k "" crlf)
 ; ( printout k "</table>" crlf)
)



(defrule consolidando-los-rechazados-de-cuentas-debe-mayor-con-tres-cuentas

  (declare (salience 30))
(no probado)
  (hacer-f22)

  ?c1 <- (codigo-f22 (codigo ?codigo-f29)  (valor ?valor))
  ?c2 <- (codigo-f22 (codigo ?codigo-de-rechazo) (valor ?rechazo))

  (test ( eq ?codigo-f29 (* -1 ?codigo-de-rechazo)))
  (test ( < ?codigo-de-rechazo 0))
  (test ( > ?codigo-f29 0))

  (f29-f22    (cuenta ?cuenta)  (codigo-f29 ?codigo-f29) )
  (f29-f22    (cuenta ?cuenta2) (codigo-f29 ?codigo-f29) )
  (f29-f22    (cuenta ?cuenta2) (codigo-f29 ?codigo-de-rechazo) )


  (f29-f22    (cuenta ?cuenta)  (codigo-f29 ?codigo-de-rechazo))

  (subtotales (cuenta ?cuenta)  (debe ?debe)  (haber ?haber))
  (cuenta (nombre ?cuenta) )

  (test (> ?debe ?haber))

  (test (neq ?cuenta ?cuenta2))

 =>

  ( bind ?nvalor (+ ?valor ?rechazo))
  ( modify ?c1 (codigo ?codigo-f29) (valor ?nvalor))
  ( retract ?c2)
  ( printout t "-----------------------------------------------" crlf)
  ( printout t tab tab codigo tab valor tab rechazo crlf)
  ( printout t tab "1: " tab ?codigo-f29 tab ?valor tab ?rechazo crlf)
  ( printout t tab "cuenta " ?cuenta " debe: " ?debe " haber: " ?haber crlf)
  ( printout t tab "Será ajustado el saldo de la cuenta para aceptar rechazos informados por los códigos." crlf)
  ( printout t tab tab (- ?debe ?rechazo) crlf)
  ( printout t tab "-------------------------------------" crlf)
  ( printout t "-----------------------------------------------" crlf)

)




(defrule consolidando-codigo-f22-deudor
  (declare (salience 30))
(no)
  (hacer-f22)
  ?c1 <- (codigo-f22 (codigo ?codigo)  (valor ?valor))
  ?c2 <- (codigo-f22 (codigo ?codigo2) (valor ?valor2))
  (test ( eq ?codigo (* -1 ?codigo2)))
  (test ( < ?codigo2 0))
  (test ( > ?codigo 0))
  (f29-f22    (cuenta ?cuenta) (codigo-f29 ?codigo)  )
  (subtotales (cuenta ?cuenta) (debe ?debe) (haber ?haber))
  (cuenta (nombre ?cuenta) (tipo deudor))
 =>
  ( bind ?nvalor (+ ?valor ?valor2))
  ( modify ?c1 (codigo ?codigo) (valor ?nvalor))
  ( retract ?c2)
  ( printout t "Cambiando " ?codigo " Valor: " ?nvalor  crlf)
  ( printout t "Valor " ?valor tab " Valor2 " ?valor2 tab (abs (- ?valor ?valor2)) crlf)
  ( printout t "Diferencia de cuenta deudor es: " (abs (- ?nvalor (* 0.19 ?debe))) crlf)
)


(defrule comprobando-formulario-f22-deudora
  (declare (salience 19))
  (hacer-f22)
  (f29-f22 (cuenta ?cuenta) (codigo-f29 ?codigo) )
  (formulario-f22  (codigo ?codigo) (valor ?valor) (anual true) )
  (exists  (cuenta (nombre ?cuenta)))
  (subtotales (cuenta ?cuenta) (debe ?debe) (haber ?haber))
  (exists  (cuenta (nombre ?cuenta) (tipo deudor)))
 =>

  ( bind ?iva-de-saldo (round (* ?debe 0.19)))
  ( if (eq ?iva-de-saldo ?valor)
    then
   (bind ?resultado 'PASA OK')
   (printout k "<tr><td>"  ?codigo "</td><td>"  ?valor  "</td><td>" ?debe "</td><td>" ?iva-de-saldo "</td><td style='background-color:lightgreen'>" ?resultado "</td><td>" ?cuenta  "</td></tr>" crlf)
    else
   (bind ?resultado 'NO PASA')
   (printout k "<tr><td>"  ?codigo "</td><td>"  ?valor  "</td><td>" ?debe "</td><td>" ?iva-de-saldo "</td><td>" ?resultado "</td><td>" ?cuenta  "</td></tr>" crlf)
  )

  (printout t ?codigo tab ?valor tab ?debe tab ?iva-de-saldo tab ?resultado tab ?cuenta  crlf) 
  (assert (codigo-f22 (codigo ?codigo) (valor ?valor) (cuenta ?cuenta) (saldo ?debe) (iva ?iva-de-saldo)))

)

(defrule comprobando-formulario-f22-acreedora
  (declare (salience 18))
  (hacer-f22)
  (f29-f22 (cuenta ?cuenta) (codigo-f29 ?codigo) )
  (formulario-f22  (codigo ?codigo) (valor ?valor) (anual true) )
  (exists  (cuenta (nombre ?cuenta)))
  (subtotales (cuenta ?cuenta) (debe ?debe) (haber ?haber))
  (exists  (cuenta (nombre ?cuenta) (tipo acreedora)) )
 =>
  ( bind ?iva-de-saldo (round (* ?haber 0.19)))
  ( if (< (abs (- ?iva-de-saldo ?valor) ) 2)
    then 
   (bind ?resultado 'PASA OK')
   (printout k "<tr><td>"  ?codigo "</td><td>"  ?valor  "</td><td>" ?haber "</td><td>" ?iva-de-saldo "</td><td style='background-color:lightgreen'>" ?resultado "</td><td>" ?cuenta  "</td></tr>" crlf)
    else
   (bind ?resultado 'NO PASA')
   (printout k "<tr><td>"  ?codigo "</td><td>"  ?valor  "</td><td>" ?haber "</td><td>" ?iva-de-saldo "</td><td>" ?resultado "</td><td>" ?cuenta  "</td></tr>" crlf)
  )

  (printout t  ?codigo tab ?valor tab ?haber tab ?iva-de-saldo tab ?resultado  tab ?cuenta crlf)
  (assert (codigo-f22 (codigo ?codigo) (valor ?valor) (cuenta ?cuenta) (saldo ?haber) (iva ?iva-de-saldo)))
)

(defrule ver-codigo-f22
  (declare (salience -1))
(no)
  (codigo-f22 (codigo ?codigo) (valor ?valor) (cuenta ?cuenta) (saldo ?saldo) (iva ?iva))
  (test (> ?codigo 0))
  (exists  (cuenta (nombre ?cuenta)))
  (subtotales (cuenta ?cuenta) (debe ?debe) (haber ?haber))

 =>
  (bind ?diferencia (abs (- ( abs ?valor) (abs ?iva))))
  (if  (<= ?diferencia 1)
   then
    (printout t "Código: " ?codigo " Valor: " tab ?valor tab  " Saldo: " tab ?saldo  tab " iva: " tab ?iva tab  " dif: " tab ?diferencia tab " Bien!  cuenta: " tab ?cuenta  crlf)
   else
    (printout t "Código: " ?codigo " Valor: " tab ?valor tab  " Saldo: " tab ?saldo tab  " iva: " tab ?iva tab " dif: " tab ?diferencia tab " Mal?! cuenta: " tab ?cuenta crlf)
  )
)



(defrule formulario-f22-pie
  (declare (salience 17))
 =>
  (printout k "</table>" crlf)
  (printout t "-----------------------------------------------" crlf)  
  (printout t crlf crlf crlf)
)


(defrule iterando-venta-sii
  (no)
 =>
  (printout t "venta-sii" crlf)
  (do-for-all-facts ((?f venta-sii)) TRUE 
    (printout t ?f:partida crlf)
  )  
)



(defrule inicio-modulo-bi
  ( declare (salience 10000))
  =>
  ( printout t "========================= BI: Business Intelligence ============" crlf)
  ( bind ?reglas ( get-defrule-list ACTIVIDAD))
  ( assert (reglas (lista ?reglas)))
;  ( printout t ?reglas )
;  ( while (> (length$ ?reglas) 0)  do
 ;  ( bind ?regla (nth$ 1 ?reglas))
;  ( printout t ?regla crlf)
;   ( printout t (defrule (sym-cat ACTIVIDAD:: ?regla ) ) crlf)
  ; ( bind ?reglas (rest$ ?reglas))
 ; )
)

(defrule borrando-hechos-irrelevantes
 (no)
  (or
    ?hecho-irrelevante <- (ccm)
    ?hecho-irrelevante <- (ticket)
    ?hecho-irrelevante <- (nonce)
    ?hecho-irrelevante <- (f29)
    ?hecho-irrelevante <- (ajustes-mensuales)
    ?hecho-irrelevante <- (ajuste-de-iva)
  )
  =>
  (retract ?hecho-irrelevante)
)




(defrule actividades-registradas
 (no)
  (actividad (nombre ?nombre))
  =>
  (printout t actividad tab ?nombre "|" crlf)
)




(defrule hechos-que-no-tienen-regla-registrada
  (no)
   ( hecho (id ?id) (regla ?regla ) (partida ?numero))
   ( reglas (lista $?lista ))
   ( test (not (member$ ?regla $?lista)))
  =>
   ( printout t ?numero "El hecho " ?id " No tiene registrada su regla " ?regla crlf)
)


(defrule hechos-que-tienen-regla-registrada
   ( hecho (id ?id) (regla ?regla ) (partida ?numero))
   ( reglas (lista $?lista ))
   ( test (member$ ?regla $?lista))
  =>
   ( printout t "El hecho " ?id " tiene registrada su regla " ?regla crlf)
  ; ( printout t "Matches de esa regla son " (get-matches ?regla) crlf)
)


(defrule partidas-sin-anotacion-de-hecho
  (partida (numero ?numero) (hecho nil) (actividad ?actividad) (descripcion ?descripcion))
 =>
  (printout t "Partida sin anotación de hecho: " ?numero tab ?actividad tab ?descripcion crlf)
)




(defrule mostrando-hechos
  (no)
   (hecho (id ?id) (gravado true) (partida ?numero) (regla ?regla))
  =>
   (printout t ?id tab partida tab ?numero tab ?regla "|" crlf)
)



(defrule detectando-hecho-gravado-iva
   (balance (ano ?ano))
   (cargo (cuenta iva-credito) (ano ?ano) (realizado true) (partida ?numero))
   (partida (numero ?numero) (actividad ?actividad) (descripcion ?descripcion) )
   (test (neq ?actividad ajuste) )
  =>
;   (printout t "k<-hv Hecho gravado detectado IVA" tab ?numero tab ?actividad crlf)
   (assert (hecho (gravado true) (id iva) (partida ?numero) (regla ?actividad)))
)


;razonando a la inversa
;encuentro en las tablas 
;las hechos
;gravados con iva
(defrule detectando-hecho-gravado-n
   (balance (ano ?ano))
   (abono (cuenta retencion-de-iva-articulo-11) (ano ?ano) (partida ?numero))
   (partida (numero ?numero) (actividad ?actividad) (descripcion ?descripcion))
  =>
;  (printout t "k<-n  Hecho gravado detectado  n "  tab ?numero tab ?actividad crlf)
   (assert (hecho (gravado true) (id n) (partida ?numero) (regla ?actividad)))
)


(defrule warning-doble-hecho
  (hecho (partida ?numero) (id ?id1))
  (hecho (partida ?numero) (id ?id2))
  (test (neq ?id1 ?id2))
 =>
; (printout t "Warning =============================================" crlf)
; (printout t " La partida " ?numero " participa en dos hechos gravados " crlf)
 ;(printout t ?id1 tab ?id2 crlf)
) 


;los cargos y abonos no realizados son normales
;para las partidas que están fuera de la fecha 
;requerida para el balance en el facts
;balance
(defrule cargo-no-realizado
   (partida (numero ?numero) (actividad ?actividad))
   (abono (realizado false) (partida ?numero) (ano ?ano))
   (balance (ano ?ano))
  =>
   (printout t "x<-c Cargo no realizado: " tab ?numero tab ?actividad crlf)
)


(defrule cargo-realizado-pero-no-mostrado-en-partida
   (partida (numero ?numero) (actividad ?actividad))
   (cuenta  (mostrada-en-partida false) (partida ?numero) (ano ?ano))
   (balance (ano ?ano))
  =>
   (printout t "x<-Cuenta No mostrado en partida: " tab ?numero tab ?actividad crlf)
)

(defrule tributacion-no-cumplida
   (partida (numero ?numero) (actividad ?actividad))
   (cuenta  (nombre ?cuenta) (partida ?numero))
   (tributacion (cumplida false) (cuenta ?cuenta) )
  =>
   (printout t "x<-Tributación no Cumplida: " tab partida tab ?numero tab ?actividad crlf)
)



(defrule abono-no-realizado
   (partida (numero ?numero) (actividad ?actividad))
   (abono (realizado false) (partida ?numero) (ano ?ano) )
   (balance (ano ?ano))
  =>
   (printout t "x->a Abono no realizado: " tab ?numero tab ?actividad crlf)
)



(defrule cargo-realizado
  (no)
   (abono (realizado true) (partida ?numero))
   (partida (numero ?numero) (actividad ?actividad) (ano ?ano))
   (balance (ano ?ano))
  =>
   (printout t "k<-c Cargo realizado: " tab ?numero  tab ?actividad crlf)
)


(defrule abono-realizado
  (no)
   (abono (realizado true) (partida ?numero) (ano ?ano))
   (partida (numero ?numero) (actividad ?actividad))
   (balance (ano ?ano))
  =>
   (printout t "k->a Abono realizado: " tab ?numero tab ?actividad crlf)
)


(defrule mala-formacion-de-cuenta
   (cuenta (nombre ?nombre) (ano ?ano) (debe ?debe) (haber ?haber) (partida ?partida))
   (balance (ano ?ano))
   (test (and (or (neq 0 ?debe) (neq 0 ?haber)) (eq nil ?partida)))
   
  =>
  (printout t "X-cta Cuenta Mal Formada: " tab ?nombre tab ?debe tab ?haber tab ?partida crlf  )
)


(defrule detectando-plan-de-cuentas
  (no)
   (balance (ano ?ano))
   (cuenta (ano ?ano) (nombre ?nombre) (padre ?padre))
   (exists (cuenta (ano ?ano) (nombre ?padre) (partida ?numero)))
  =>
   (printout t "k<-cta Cuenta Aceptada: " tab ?nombre " es hija de " tab ?padre " para el sistema " crlf)
)

;Esto es anormal, esta regla está en el foco BI, pero
;está en este archivo que contiene el módulo MAIN
;pero hay que entender que BI es un CONCERN
;debe ubicarse en un tiempo presente o futuro lo que
;necsite para trabajar.
;y además manejer al foco.
;el módulo MAIN es importante porque exporta a todos los otros
(defrule borrando-cuentas-sin-uso
  (no)
  (balance (ano ?ano))
  ?c <- (cuenta (nombre ?nombre) (ano ?ano) (partida nil))
  (not (exists (cuenta (ano ?ano) (nombre ?nombre) (partida ?partida&:(neq nil ?partida)))))
 =>
  ( retract ?c)
  ( printout t "x<-cta Cuenta Eliminada: " tab ?nombre  crlf)
)

