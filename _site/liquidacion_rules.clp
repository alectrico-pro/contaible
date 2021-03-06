(defmodule LIQUIDACION (import MAIN deftemplate ?ALL ) )


(deffunction mes_to_numero ( ?mes )
  ( switch ?mes
    ( case enero      then 1)
    ( case febrero    then 2)
    ( case marzo      then 3)
    ( case abril      then 4)
    ( case mayo       then 5)
    ( case junio      then 6)
    ( case julio      then 7)
    ( case agosto     then 8)
    ( case septiembre then 9)
    ( case octubre    then 10)
    ( case noviembre  then 11)
    ( case diciembre  then 12)
  )
)

(deffunction to_serial_date( ?dia ?mes ?ano)
  (+ (* 10000 ?ano) (* 100 ( mes_to_numero ?mes)) ?dia)
)


(defrule fin-liquidacion
  ( declare (salience -10000) )
 =>

  ( close k )
)

(defrule fin-liquidacion-resumen

  ( declare (salience -10000) )

 =>
  ( printout t "------------------------" crlf)
  ( printout t "liquidaciones-realizadas" crlf)
  ( do-for-all-facts ((?f liquidacion)) (eq ?f:cumplida true)
    ( printout t ?f:partida tab ?f:cuenta tab ?f:cumplida crlf)
  )

  ( printout t "---------------------------" crlf)
  ( printout t "liquidaciones-no-realizadas" crlf)
  ( do-for-all-facts ((?f liquidacion)) (eq ?f:cumplida false)
    ( printout t ?f:partida tab ?f:cuenta tab ?f:cumplida crlf)
  )

  ( printout t "---------------------------" crlf)
  ( printout t "tributaciones-realizadas" crlf)
  ( do-for-all-facts ((?f tributacion)) (eq ?f:cumplida true)
    ( printout t ?f:partida tab ?f:cuenta tab ?f:cumplida crlf)
  )

  ( printout t "---------------------------" crlf)
  ( printout t "tributaciones-no-realizadas" crlf)
  ( do-for-all-facts ((?f tributacion)) (eq ?f:cumplida false)
    ( printout t ?f:partida tab ?f:cuenta tab ?f:cumplida crlf)
  )
)


;esto genera un markdown para que jekyll lo publique en el blog necios
(defrule inicio-kindle-k-liquidacion-rules
   ( declare (salience 10000))
   ( empresa (nombre ?empresa))
  =>

   ( bind ?archivo (str-cat "./doc/" ?empresa "/liquidacion.markdown"))
   ( open ?archivo k "w")

   ( printout k "--- " crlf)
;   ( printout k "title: " ?empresa "-liquidacion" crlf)
;  ( printout k "permalink: /" ?empresa "-liquidacion/ " crlf)
   ( printout k "layout: page" crlf)
   ( printout k "--- " crlf)
   ( printout k "" crlf)
   ( printout k "<h1> Liquidaciones  </h1>" crlf)
)



(defrule ajustar-ano-financieras-perdedoras
   (declare (salience 2))
   (balance (ano ?ano) (mes ?mes))
   (empresa (nombre ?empresa))
   (ticket (numero ?numero))
   (ajuste-anual (ano ?ano) (liquidacion financiera) (partida ?numero) (efecto perdedor) )

   (or
     (cuenta (nombre ?nombre&:(neq ?nombre ingresos-brutos)) (padre false) (grupo resultado))
     (cuenta (nombre ?nombre) (padre ingresos-brutos) (grupo resultado))
     (cuenta (nombre ?nombre&:(eq ?nombre inventario-final) ))
 )

  =>
   ( assert (partida (numero ?numero) (empresa ?empresa) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Ajuste Anual A??o: Liquidacion Financiera Perdedor " ?ano )) (actividad liquidacion-financiera) ))
   ( assert (liquidacion (cuenta ?nombre) (partida ?numero) (dia 31) (mes ?mes) (ano ?ano) (liquidadora perdidas-y-ganancias) (efecto perdedor)))
)


(defrule ajustar-ano-financieras-ganadoras
   (declare (salience 1))
   (balance (ano ?ano) (mes ?mes))
   (empresa (nombre ?empresa))
   (ticket (numero ?numero))
   (ajuste-anual (ano ?ano) (liquidacion financiera) (partida ?numero) (efecto ganador) )

   (or
     (cuenta (nombre ?nombre&:(neq ?nombre ingresos-brutos)) (padre false) (grupo resultado))
     (cuenta (nombre ?nombre) (padre ingresos-brutos) (grupo resultado))  
   )

  =>
   ( assert (partida (numero ?numero) (empresa ?empresa) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Ajuste Anual A??o: Liquidacion Financiera Ganancias " ?ano )) (actividad liquidacion-financiera) ))
   ( assert (liquidacion (cuenta ?nombre) (partida ?numero) (ano ?ano) (liquidadora perdidas-y-ganancias) (efecto ganador)))
)




(defrule ajustar-ano-tributarias-deducciones
   (declare (salience 1))

   (balance (ano ?ano) (mes ?mes ))
   (empresa (nombre ?empresa))
   (ticket (numero ?numero))
   (ajuste-anual (ano ?ano) (liquidacion tributaria) (partida ?numero) (efecto deduccion) )

   (or
     (cuenta (partida ?partida) (nombre ?nombre&:(neq ?nombre ingresos-brutos)) (padre false) (grupo resultado))
     (cuenta (partida ?partida) (nombre ?nombre) (padre ingresos-brutos) (grupo resultado))  )


  =>
   ( assert
     (partida (numero ?numero) (empresa ?empresa) (dia 31) (mes ?mes) (ano ?ano)
     (descripcion (str-cat "Ajuste Anual A??o: Liquidacion Tributaria Deducciones " ?ano ))
     (actividad liquidacion-tributaria) ))

   ( assert
     (tributacion (cuenta ?nombre) (partida ?numero) (ano ?ano)
     (liquidadora base-imponible) (efecto deduccion)))
  
   ( assert
     (tributacion (cuenta no-importa) (partida ?numero) (ano ?ano)
     (liquidadora base-imponible) (efecto deduccion-propyme)))

   ( assert
     (tributacion (cuenta no-importa) (partida ?numero) (ano ?ano)
     (liquidadora base-imponible) (efecto deduccion-propyme)))

)




(defrule ajustar-ano-tributarias-aportes

   (declare (salience 1))

   (balance (mes ?mes) (ano ?ano))
   (empresa (nombre ?empresa))
   (ticket (numero ?numero))
   (ajuste-anual (ano ?ano) (liquidacion tributaria) (partida ?numero) (efecto aporte))

   (or
     (cuenta (partida ?partida)  (nombre ?nombre&:(neq ?nombre ingresos-brutos)) (padre false) (grupo resultado))
     (cuenta (partida ?partida)  (nombre ?nombre) (padre ingresos-brutos) (grupo resultado)))


  =>

   ( assert (partida (numero ?numero) (empresa ?empresa) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Ajuste Anual A??o: Liquidacion Tributaria Aportes " ?ano )) (actividad liquidacion-financiera) ))
   ( assert (tributacion (cuenta ?nombre) (partida ?numero) (ano ?ano) (liquidadora base-imponible) (efecto aporte)))

)





(defrule determinar-resultado-financiero
  ( declare (salience -1))
  (balance (ano ?ano) (mes ?mes))
  (empresa (nombre ?empresa)) 
  (ticket (numero ?numero))

  (ajuste-anual-de-resultado-financiero
    (ano ?ano)
    (partida ?numero))

 =>
  ( assert (partida (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) 
    (empresa ?empresa)
    (actividad determinacion-del-resultado-financiero)
    (descripcion "v/Para determinar el valor del Resultado Financiero per??odo.")))

  ( assert (liquidacion (cuenta idpc) 
    (partida ?numero) (ano ?ano)
    (liquidadora perdidas-y-ganancias)))

  ( assert (liquidacion (cuenta reserva-legal)
    (partida ?numero) (ano ?ano)
    (liquidadora perdidas-y-ganancias)))

  ( assert (liquidacion (cuenta utilidad)
    (partida ?numero) (ano ?ano)
    (liquidadora perdidas-y-ganancias)))
)


(defrule determinar-resultado-tributario
  (declare (salience -2))
  (balance (ano ?ano))
  (empresa (nombre ?empresa))
  (ticket (numero ?numero))
  (ajuste-anual-de-resultado-tributario
    (ano ?ano)
    (partida ?numero))

 =>
 ;no es necesario  y tampoco ha sido probado

 ; ( assert (partida (numero ?numero) (dia 31) (mes diciembre) (ano ?ano)
 ;   (empresa ?empresa)
 ;   (actividad determinacion-del-resultado-tributario)
 ;   (descripcion "v/Para determinar el valor del resultado Tributario del Periodo")))

 ; ( assert (liquidacion (cuenta idpc)
 ;   (partida ?numero) (ano ?ano)
 ;   (liquidadora base-imponible)))

 ; ( assert (liquidacion (cuenta reserva-legal)
 ;   (partida ?numero) (ano ?ano)
  ;  (liquidadora base-imponible)))

;  ( assert (liquidacion (cuenta utilidad-tributaria)
 ;   (partida ?numero) (ano ?ano)
  ;  (liquidadora base-imponible)))
)



(defrule inicio-de-modulo-liquidacion
 (declare ( salience 10000))
=>
 ( printout t  "---------------------- LIQUIDACION --------------------" crlf)
)

(defrule liquidacion-mostrar-partida
  ( declare (salience 8000))
  ?partida<-(partida (numero ?numero) )
  (or ( liquidacion (partida ?numero))
      ( tributacion (partida ?numero))
      ( provision   (partida ?numero))
  )
 =>
  ( assert (cabeza ?numero))
)

;============================== Tabla de la Partida ================================
(defrule encabezado
  ( cabeza ?numero )
  ;( balance ( dia ?top ) (mes ?mes) (ano ?ano))
 ; ( empresa (nombre ?empresa) (razon ?razon))
  ;( test (>= ?top ?dia))
 =>
  ( printout t crlf crlf crlf)
  ( printout t "==================================================================" crlf)
  ( printout t FECHA tab Parcial tab Debe tab Haber tab Descripcion crlf)
  ( printout t "==================================================================" crlf)
  ( printout t "Partida " ?numero crlf)
  ( printout t ".................................................................." crlf)

  ( printout k "<table style='background-color: lightyellow' ><tbody>" crlf)
  ( printout k "<tr style='color: white; background-color: black'><td colspan='9'> Partida " ?numero  "</td></tr>" crlf)
  ( printout k "<tr><th>DEBE</th><th> HABER </th> <th colspan='6'> Cuenta </th></tr>" crlf)
  ( assert (fila ?numero))
)



(defrule footer
  ?fila <- ( fila ?numero )
;  ( balance ( dia ?top ) (mes ?mes) (ano ?ano))
  ( empresa (nombre ?empresa) (razon ?razon))
  ( partida (numero ?numero) (debe ?debe) (haber ?haber) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?descripcion))
  ( test (or (> ?debe 0) (> ?haber 0))) 
 ; ( test (>= ?top ?dia))
 =>
  ( retract ?fila )
  ( printout t "------------------------------------------------------------------" crlf)
  ( printout t tab tab ?debe tab ?haber tab "( " ?dia " de " ?mes tab ?ano tab " )" crlf)
  ( printout t "==================================================================" crlf)
  ( printout t ?razon crlf)
  ( printout t ?descripcion crlf)
  ( printout t crlf crlf)
  
  ( printout k "<tr style='color: white; background-color: black'> <td> " ?debe "</td><td> " ?haber "</td><td colspan='3'>( " ?dia " de " ?mes tab ?ano tab " ) </td></tr>" crlf)
  ( printout k "<tr><td colspan='9'>" ?razon "</td></tr>" crlf)
  ( printout k "<tr><td colspan='9'>" ?descripcion "</td></tr>" crlf)
  ( printout k "<table><tbody> " crlf )

)



(defrule muestra-saldo-liquidadora-saldo-nulo
(no)
   ?f1 <- (cuenta (nombre ?nombre) (debe ?debe) (haber ?haber) (saldo ?saldo))
   ;test (eq false ?verificada))
   (test (= ?debe ?haber))
  =>
   ( bind ?saldo (- ?debe ?haber ) )
;  ( modify  ?f1 ( saldo ?saldo ) (verificada (not ?verificada)))
 ;  ( retract ?f1)
   ( printout t crlf)
   ( printout t "-----------------------------------------------------" crlf)
   ( printout t tab tab ?nombre  tab saldo-nulo crlf)
   ( printout t "----------------------------------------------------" crlf)
   ( printout t tab (round ?debe) tab "|" tab (round ?haber) crlf)
   ( printout t tab (round ?saldo) crlf)
   ( printout t crlf)

)



(defrule muestra-saldo-liquidadora-saldo-deudor
   ?f1 <- (cuenta (nombre ?nombre) (partida ?partida) (debe ?debe) (haber ?haber) (saldo ?saldo) (tipo liquidadora))  
   (test (> ?debe ?haber))
  => 
   ( bind ?saldo (- ?debe ?haber ) )
   ( printout t crlf)
   ( printout t "-----------------------------------------------------" crlf)
   ( printout t tab tab ?nombre  tab saldo-deudor crlf)
   ( printout t "----------------------------------------------------" crlf)
   ( printout t ?partida tab (round ?debe) tab "|" tab (round ?haber) crlf)
   ( printout t tab (round ?saldo) crlf)
   ( printout t crlf)
 
   ( printout k "<table>" crlf)
   ( printout k "<tr style='background-color: blanchedalmond'><td></td><td colspan = '2'> " ?nombre "</td></tr>" crlf)
   ( printout k "<tr><td></td><td> DEBE </td> <td> HABER </td></tr>" crlf)
   ( printout k "<tr><td></td><td>" (round ?debe)  "</td> <td>" (round ?haber) "</td></tr>" crlf)
   ( printout k "<tr><td></td><td style='background-color: blanchedalmond'>" (round ?saldo)  "</td></tr>" crlf) 
   ( printout k "</table>" crlf)

)


(defrule muestra-saldo-liquidadora-saldo-acreedor 
   ?f1 <- (cuenta (nombre ?nombre) ( partida ?partida) (debe ?debe) (haber ?haber) (saldo ?saldo) (tipo liquidadora) ) 
   (test (< ?debe ?haber))
  => 
   ( bind ?saldo (- ?haber ?debe ) )
   ( printout t crlf)
   ( printout t "-----------------------------------------------------" crlf)
   ( printout t tab tab ?nombre tab saldo-acreedor crlf)
   ( printout t "-----------------------------------------------------" crlf)
   ( printout t ?partida tab (round ?debe) tab "|" tab (round ?haber) crlf)
   ( printout t tab tab "|" tab (round ?saldo) crlf)
   ( printout t crlf)
   ( printout k "<table>" crlf)
   ( printout k "<tr style='background-color: blanchedalmond'><td> </td><td colspan='2'>" ?nombre "</td></tr>" crlf)
   ( printout k "<tr><td></td><td> DEBE </td> <td> HABER </td></tr>" crlf)
   ( printout k "<tr><td></td><td>" (round ?debe)  "</td><td> " (round ?haber) "</td></tr>" crlf)
   ( printout k "<tr><td></td><td></td><td  style='background-color: blanchedalmond'>" (round ?saldo) "</td></tr>" crlf)
   ( printout k "</table>" crlf)
)


(defrule liquidar-cuentas-financieras-ganadoras
  (declare (salience 80))
    (fila ?numero )
    (empresa (nombre ?empresa ))

    ?partida <- (partida
      (numero ?numero )
      (dia    ?dia)
      (mes    ?mes)
      (ano    ?ano)
      (debe   ?debep)
      (haber  ?haberp))

    ?liquidacion <- (liquidacion
       (partida ?numero)
       (cuenta ?nombre) (ano ?ano)
       (liquidadora ?liquidora)
       (efecto ganador) )

    ?cuenta <- (cuenta
      (partida   ?partida-cuenta)
      (nombre    ?nombre)
      (debe      ?debe)
      (haber     ?haber)
      (grupo     ?grupo)
      (deducible ?deducible)
      (liquidada false))

   ?liquidadora <- (cuenta
      (nombre ?liquidora)
      (partida nil)
      (haber ?haber-liquidadora))

   (test (> ?debe ?haber))

 =>

   ( modify ?liquidacion
     ( cumplida true))
   
   ( modify ?cuenta
     ( liquidada true )
     ( haber     ?debe)
     ( debe      ?haber))

   ( modify ?liquidadora
       ( haber (+ ?debe ?haber-liquidadora)))

   ( bind ?saldo (- ?debe ?haber))
   ( modify ?partida (debe (+ ?debep ?saldo)) (haber (+ ?haberp ?saldo)))
   ( printout t tab (round ?saldo) tab " ---| " tab tab ?nombre crlf)
   ( printout t tab tab "    |-> " tab (round ?saldo)  tab tab "r<" ?liquidora ">" crlf)
   ( printout t crlf )
   ( printout k "<tr><td>" (round ?saldo) "</td><td><small> " (if (eq ?deducible true) then ganadoras-deducible else ganadoras-no-deducible) "</small></td> <td colspan='2'>" ?nombre "</td></tr>" crlf)
   ( printout k "<tr><td></td><td>"  (round ?saldo) "</td><td></td><td> r(" ?liquidora ") </td></tr>"  crlf)

)


(defrule liquidar-cuentas-financieras-perdedoras

    (declare (salience 80))

    (fila ?numero )

    (empresa (nombre ?empresa ))

    ?partida <- (partida
      (numero ?numero )
      (dia    ?dia)
      (mes    ?mes)
      (ano    ?ano)
      (debe   ?debep)
      (haber  ?haberp))

    ?liquidacion <- (liquidacion
       (partida ?numero)
       (cuenta ?nombre) (ano ?ano)
       (liquidadora ?liquidora)
       (efecto perdedor))

    ?cuenta <- (cuenta
      (partida   ?partida-cuenta)
      (nombre    ?nombre)
      (debe      ?debe)
      (haber     ?haber)
      (grupo     ?grupo)
      (deducible ?deducible)
      (liquidada false)) 


    ?liquidadora <- (cuenta
      ( nombre ?liquidora)
      ( partida nil)
      ( debe ?debe-liquidadora))

    (test (> ?haber ?debe))

  =>


   ( modify ?liquidacion (cumplida true))

   ( modify ?cuenta
     ( liquidada true )
     ( haber     ?debe)
     ( debe      ?haber))   

   ( modify ?liquidadora
       ( debe (+ ?haber ?debe-liquidadora)))

   ( bind ?saldo (- ?haber ?debe ))
   ( modify ?partida (debe (+ ?debep ?saldo)) (haber (+ ?haberp ?saldo)))
   ( printout t tab tab "    |-- " tab (round ?saldo) tab ?nombre crlf)
   ( printout t tab (round ?saldo) tab " <--|" tab tab "r<" ?liquidora ">" crlf)
   ( printout t crlf )
   ( printout k "<tr><td> </td><td>" (round ?saldo) "</td><td> </td><td>" ?nombre "</td></tr>" crlf)
   ( printout k "<tr><td>"  (round ?saldo) "</td><td><small> " (if (eq ?deducible true) then perdedoras-deducible else perdedoras-no-deducible) "</small> </td><td colspan='2'> r(" ?liquidora ") </td></tr>"  crlf)

)



(defrule liquidar-activos-fijos-propyme

    (declare (salience 80))
    (selecciones (regimen propyme))
    (fila ?numero )
    (empresa (nombre ?empresa ))

    ?partida <- (partida
      (numero ?numero )
      (dia    ?dia)
      (mes    ?mes)
      (ano    ?ano)
      (debe   ?debep)
      (haber  ?haberp))


    ?tributacion <- (tributacion
       (partida ?numero)
       (cuenta no-importa) (ano ?ano)
       (liquidadora ?liquidora)
       (efecto deduccion-propyme))


    ;este registro debe estar en 
    ;alectrico-2021-valor-activos.txt
    ?af <- ( registro-de-depreciacion
       ( nombre-del-activo    ?nombre-activo )
       ( valor-de-adquisicion ?valor) 
       ( dia-de-adquisicion   ?dia-de-adquisicion)
       ( mes-de-adquisicion   ?mes-de-adquisicion)
       ( ano-de-adquisicion   ?ano)
       ( liquidado            false) )

    ?liquidadora <- (cuenta
      (nombre   base-imponible)
      (partida  nil)
      (debe     ?debe-liquidadora))

    ( balance (dia ?top)       (mes ?mes_top)     (ano ?ano_top))
    ( test (>= (to_serial_date ?top   ?mes_top          ?ano_top)
               (to_serial_date ?dia-de-adquisicion  ?mes-de-adquisicion  ?ano)))

 =>

  ( modify ?tributacion (cumplida true))

  ( modify ?af (liquidado true))

  ( modify ?liquidadora
       ( debe (+ ?debe-liquidadora ?valor)))


  ( modify ?partida (debe (+ ?debep ?valor)) (haber (+ ?haberp ?valor)))
  ( printout t tab tab "    |-- " tab (round ?valor) tab ?nombre-activo crlf)
  ( printout t tab (round ?valor) tab " <--|" tab "r<" base-imponible ">" crlf)
  ( printout t crlf )
  ( printout k "<tr><td></td><td >" (round ?valor) "</td><td></td><td style='color: white; background-color: cornflowerblue'>" ?nombre-activo " <small>Deprec./Amort. Inst. Propyme </small></td></tr>" crlf)
  ( printout k "<tr><td>" (round ?valor) "</td><td></td><td colspan='2'> r( base-imponible )  </td></tr>"  crlf)

)



(defrule liquidar-cuentas-tributarias-deducciones-rechazadas
  (declare (salience 80))

    (fila ?numero )

    (empresa (nombre ?empresa ))

    ?partida <- (partida
      (numero ?numero )
      (dia    ?dia)
      (mes    ?mes)
      (ano    ?ano)
      (debe   ?debep)
      (haber  ?haberp))

   ?tributacion <- (tributacion
       (partida ?numero)
       (cuenta ?nombre) (ano ?ano)
       (liquidadora ?liquidora)
       (efecto  deduccion))


    ?cuenta <- (cuenta
      (partida   ?partida-cuenta)
      (dia       ?dia-partida)
      (mes       ?mes-partida)
      (ano       ?ano-partida)
      (nombre    ?nombre)
      (debe      ?debe)
      (haber     ?haber)
      (grupo     ?grupo)
      (tributada false))

    ?liquidadora <- (cuenta (nombre ?liquidora) (partida nil) (debe ?debe-liquidadora))

    (test (> ?debe ?haber))

    (revision (partida ?partida-cuenta) (rechazado true) )
    
    ?r <- (cuenta (nombre rechazados) (partida nil) (debe ?debe-rechazados) (haber ?haber-rechazados) )

 =>

   ( modify ?tributacion (cumplida true))

   ( bind ?saldo (- ?debe ?haber))

   ( modify ?cuenta
       ( tributada true )
       ( haber     ?debe)
       ( debe      ?haber))

 ;  ( modify ?liquidadora ( debe (+ ?debe-liquidadora ?debe)))

   ( modify ?r (debe (+ ?debe-rechazados ?debe )) (haber (+ ?haber-rechazados ?haber)))

   ( modify ?partida (debe (+ ?debep ?saldo)) (haber (+ ?haberp ?saldo)))
   ( printout t tab tab "    |-- " tab (round ?saldo) tab ?nombre crlf)
   ( printout t tab (round ?saldo)  tab" <--| " tab "r<" ?liquidora ">" crlf)
   ( printout t crlf )
   ( printout k "<tr style='decoration-text: line-through; background-color: violet; color: white '><td></td><td>" (round ?saldo) "</td><td></td><td>" ?nombre "</td></tr>" crlf)
   ( printout k "<tr><td>" (round ?saldo) "</td><td></td><td colspan='2'> r(" ?liquidora ")  </td></tr>"  crlf)

)


;esta regla es espec??fica para inventario pues no se pueden rechazar y 
;no est?? asociado a cuentas que se puedan asociar a registro de revisiones
(defrule liquidar-inventario-deducciones

  (declare (salience 80))

    (fila ?numero )

    (empresa (nombre ?empresa ))

    ?partida <- (partida
      (numero ?numero )
      (dia    ?dia)
      (mes    ?mes)
      (ano    ?ano)
      (debe   ?debep)
      (haber  ?haberp))
   
   ?tributacion <- (tributacion
       (partida ?numero)
       (cuenta ?nombre) (ano ?ano)
       (liquidadora ?liquidora)
       (efecto  deduccion))


    ?cuenta <- (cuenta
      (partida   ?partida-cuenta)
      (nombre    ?nombre)
      (debe      ?debe)
      (haber     ?haber)
      (grupo     ?grupo)
      (deducible ?deducible)
      (tributada false))

    (partida-inventario-final (partida ?partida-inventario))

    ?liquidadora <- (cuenta (nombre ?liquidora) (partida nil) (debe ?debe-liquidadora))

    (test (> ?debe ?haber))

    (revision (partida ?partida-inventario) (rechazado false) )
 
    (test (eq ?nombre inventario-final))
    (test (eq ?liquidora base-imponible))

  =>

   ( modify ?tributacion (cumplida true))

   ( bind ?saldo (- ?debe ?haber))

   ( modify ?cuenta
       ( tributada true )
       ( haber     ?debe)
       ( debe      ?haber))


   ( modify ?liquidadora
       ( debe (+ ?debe-liquidadora ?debe)))


  ( modify ?partida (debe (+ ?debep ?saldo)) (haber (+ ?haberp ?saldo)))
  ( printout t tab tab "    |-- " tab (round ?saldo) tab ?nombre crlf)
  ( printout t tab (round ?saldo)  tab" <--| " tab "r<" ?liquidora ">" crlf)
  ( printout t crlf )
  ( printout k "<tr><td> </td><td>" (round ?saldo) "</td><td><small> " (if (eq ?deducible true) then inventario-deducciones-deducible else inventario-deducciones-no-deducible)   "</small></td><td>" ?nombre "</td></tr>" crlf)
  ( printout k "<tr><td>" (round ?saldo) "</td><td></td><td colspan='2'> r(" ?liquidora ")  </td></tr>"  crlf)
)


(defrule liquidar-cuentas-tributarias-deducciones
  (declare (salience 80))

    (fila ?numero )

    (empresa (nombre ?empresa ))

    ?partida <- (partida
      (numero ?numero )
      (dia    ?dia)
      (mes    ?mes)
      (ano    ?ano)
      (debe   ?debep)
      (haber  ?haberp))

   ?tributacion <- (tributacion
       (partida ?numero)
       (cuenta ?nombre) (ano ?ano)
       (liquidadora ?liquidora)
       (efecto  deduccion)) 


    ?cuenta <- (cuenta
      (partida   ?partida-cuenta)
      (nombre    ?nombre)
      (debe      ?debe)
      (haber     ?haber)
      (grupo     ?grupo)
      (deducible ?deducible)
      (tributada false))

    ?liquidadora <- (cuenta (nombre ?liquidora) (partida nil) (debe ?debe-liquidadora))
 
    (test (> ?debe ?haber))

    (test (eq ?deducible true))

 =>

   ( modify ?tributacion (cumplida true))

   ( bind ?saldo (- ?debe ?haber))
   
   ( modify ?cuenta
       ( tributada true )
       ( haber     ?debe)
       ( debe      ?haber))


   ( modify ?liquidadora
       ( debe (+ ?debe-liquidadora ?debe)))


  ( modify ?partida (debe (+ ?debep ?saldo)) (haber (+ ?haberp ?saldo)))
  ( printout t tab tab "    |-- " tab (round ?saldo) tab ?nombre crlf)
  ( printout t tab (round ?saldo)  tab" <--| " tab "r<" ?liquidora ">" crlf)
  ( printout t crlf )
  ( printout k "<tr><td></td><td>" (round ?saldo) "</td><td></td><td>" ?nombre "</td></tr>" crlf)
  ( printout k "<tr><td>" (round ?saldo) "</td><td><small> " (if (eq ?deducible true) then deducciones-deducible else deducciones-no-deducible) "</small> </td><td colspan='2'> r(" ?liquidora ")  </td></tr>"  crlf)
   
)


(defrule liquidar-cuentas-tributarias-aportes-rechazados

    (declare (salience 280))

    (fila ?numero )

    (empresa (nombre ?empresa ))

    ?partida <- (partida
      (numero ?numero )
      (dia    ?dia)
      (mes    ?mes)
      (ano    ?ano)
      (debe   ?debep)
      (haber  ?haberp))


   ?tributacion <- (tributacion
        (partida     ?numero)
        (cuenta      ?nombre) (ano ?ano)
        (liquidadora ?liquidora)
        (efecto      aporte))

    ?cuenta <- (cuenta
      (partida   ?partida-cuenta)
      (nombre    ?nombre)
      (debe      ?debe)
      (haber     ?haber)
      (grupo     ?grupo)
      (deducible ?deducible)
      (tributada false))


    ?liquidadora <- (cuenta
      ( nombre ?liquidora)
      ( partida nil)
      ( haber ?haber-liquidadora))

    ;en las cuentas de resultado, el haber significa ganancia o aporte
    (test (> ?haber ?debe))

    ?r <- (cuenta (nombre rechazados) (partida nil) (debe ?debe-rechazados) (haber ?haber-rechazados) )

    (revision (partida ?partida-cuenta) (rechazado true) )

    (test (eq ?deducible true))


 =>

   ( modify ?tributacion (cumplida true))

   ( bind ?saldo (- ?haber ?debe))


   ( modify ?cuenta
       ( tributada true  )
       ( haber     ?debe)
       ( debe      ?haber))

;   ( modify ?liquidadora
 ;      ( haber (+ ?haber ?haber-liquidadora)))

   ( modify ?r (debe (+ ?debe-rechazados ?debe )) (haber (+ ?haber-rechazados ?haber)))

   ( modify ?partida (debe (+ ?debep ?saldo)) (haber (+ ?haberp ?saldo)))
   ( printout t tab (round ?saldo) tab " --| " tab tab ?nombre crlf)
   ( printout t tab tab "   |-> " tab (round ?saldo)  tab tab "r<" ?liquidora ">" crlf)
   ( printout t crlf )
   ( printout k "<tr style='background-color: violet; color: white' ><td>" (round ?saldo) "</td><td></td><td colspan='2'>" ?nombre "</td></tr>" crlf)
   ( printout k "<tr><td> " (if (eq ?deducible true) then aportes-deducible else aportes-no-deducible)  " </td><td>"  (round ?saldo) "</td><td></td><td> r(" ?liquidora ") </td></tr>"  crlf)
)





(defrule liquidar-cuentas-tributarias-aportes-no-rechazados

    (declare (salience 280))

    (fila ?numero )

    (empresa (nombre ?empresa ))

    ?partida <- (partida
      (numero ?numero )
      (dia    ?dia)
      (mes    ?mes)
      (ano    ?ano)
      (debe   ?debep)
      (haber  ?haberp))


   ?tributacion <- (tributacion
        (partida     ?numero)
        (cuenta      ?nombre) (ano ?ano)
        (liquidadora ?liquidora)
        (efecto      aporte))

    ?cuenta <- (cuenta
      (partida   ?partida-cuenta)
      (nombre    ?nombre)
      (debe      ?debe)
      (haber     ?haber)
      (grupo     ?grupo)
      (deducible ?deducible)
      (tributada false)) 


    ?liquidadora <- (cuenta
      ( nombre ?liquidora)
      ( partida nil)
      ( haber ?haber-liquidadora))

    ;en las cuentas de resultado, el haber significa ganancia o aporte
    (test (> ?haber ?debe))

    (revision (partida ?partida-cuenta) (rechazado false) )

    (test (eq ?deducible true))

 =>

   ( modify ?tributacion (cumplida true))

   ( bind ?saldo (- ?haber ?debe))


   ( modify ?cuenta
       ( tributada true  )
       ( haber     ?debe)
       ( debe      ?haber))

   ( modify ?liquidadora
       ( haber (+ ?haber ?haber-liquidadora)))


   ( modify ?partida (debe (+ ?debep ?saldo)) (haber (+ ?haberp ?saldo)))
   ( printout t tab (round ?saldo) tab " --| " tab tab ?nombre crlf)
   ( printout t tab tab "   |-> " tab (round ?saldo)  tab tab "r<" ?liquidora ">" crlf)
   ( printout t crlf )
   ( printout k "<tr><td>" (round ?saldo) "</td><td><small> " (if (eq ?deducible true) then aportes-deducible else aportes-no-deducible) "</small></td> <td colspan='2'>" ?nombre "</td></tr>" crlf)
   ( printout k "<tr><td></td><td>"  (round ?saldo) "</td><td></td><td> r(" ?liquidora ") </td></tr>"  crlf)
)







;--------------------------------------- determinaci??n de utilidad tributaria y la financiera-
(defrule determinacion-de-la-base-imponible-efecto-deduccion
   (declare (salience 180))
   ?f <-  (fila ?numero)
   (empresa (nombre ?empresa))
   (ajuste-anual-de-resultado-financiero (partida ?numero))


   ?partida     <- (partida (dia ?dia) (mes ?mes) (numero ?numero) (debe ?debep) (haber ?haberp))
   ?f1          <- (tributacion (partida ?numero) (cuenta ?nombre) (ano ?ano) (liquidadora ?liquidora) (efecto deduccion))
   ?acreedora   <- (cuenta (partida ?numero2&:(neq nil ?numero2)) (parte ?parte) (nombre ?nombre)  (debe ?debe)  (haber ?haber&:(> ?haber 0))  (tipo ?tipo) (liquidada ?liquidada) (tributada false) (grupo ?grupo) (circulante ?circulante))
   ?liquidador  <- (cuenta (nombre ?liquidora) (debe ?debe2) (haber ?haber2) (tipo liquidadora) )
   (cuenta (nombre base-imponible) (partida nil))
 =>
;  ( printout t "nombre " tab ?nombre tab ?liquidora tab ?haber2 crlf)
  ( bind ?saldo ?haber)
  ( modify ?acreedora  (tributada true))
   ( modify ?liquidador
     ( ano ?ano)
     ( empresa ?empresa )
     ( haber (+ ?haber2 ?saldo) )
   )
   ( modify ?partida (debe (+ ?debep ?saldo)) ( haber (+ ?haberp ?saldo)))
  ( printout t "t-- Tributando deduccion cuenta " ?nombre " en " ?liquidora crlf)
  ( printout t "La cuenta de base imponible tiene un debe de " tab ?debe2 " y un haber de " tab ?haber2 crlf)
   ( printout t tab tab ?saldo tab "--|" tab tab ?nombre crlf)
   ( printout t tab tab tab "  |->" tab ?saldo tab tab "r<" ?liquidora ">" crlf)
   ( printout t crlf )
 ;  ( printout t "determinacion-de-la-base-imponible-efecto-aporte" clrf)

   ( printout k "<tr><td>" ?saldo "</td><td> </td><td colspan='2'> r(" ?nombre ") partida " ?numero2 " </td></tr>" crlf)
   ( printout k "<tr><td></td><td>" ?saldo "</td><td> </td><td>" ?liquidora "</td></tr>" crlf)
)




(defrule determinacion-de-la-base-imponible-efecto-aporte
   (declare (salience 181))
   ?f <- (fila ?numero)
(no)
   (ajuste-anual-de-resultado-tributario (partida ?numero))


   (empresa (nombre ?empresa))
   ?partida     <- (partida (dia ?dia) (mes ?mes) (numero ?numero) (debe ?debep) (haber ?haberp))
   ?f1          <- (tributacion (partida ?numero) (cuenta ?nombre) (ano ?ano) (liquidadora ?liquidora) (efecto aporte))
   ?acreedora   <- (cuenta (partida ?numero2&:(neq nil ?numero2)) (parte ?parte) (nombre ?nombre)  (debe ?debe&:(> ?debe 0))  (haber ?haber)  (tipo ?tipo) (liquidada ?liquidada) (tributada false) (grupo ?grupo) (circulante ?circulante))
   ?liquidador  <- (cuenta (nombre ?liquidora) (debe ?debe2) (haber ?haber2) (tipo liquidadora) )
   (cuenta (nombre base-imponible) (partida nil))

 =>
 ; ( printout t "nombre " tab ?nombre tab ?liquidora tab ?haber2 crlf)
  ( bind ?saldo ?debe)
  ( modify ?acreedora  (tributada true))
   ( modify ?liquidador
     ( ano ?ano)
     ( empresa ?empresa )
     ( debe (+ ?debe2 ?saldo) )
   )
   ( modify ?partida (debe (+ ?debep ?saldo)) ( haber (+ ?haberp ?saldo)))
  ( printout t "t-- Tributando aporte cuenta " ?nombre " en " ?liquidora crlf)
  ( printout t "La cuenta de base imponible tiene un debe de " tab ?debe2 " y un haber de " tab ?haber2 crlf)
   ( printout t tab tab ?saldo tab "--|" tab tab "r<" ?liquidora "> partida " crlf)
   ( printout t tab tab tab "  |->" tab ?saldo tab tab ?nombre crlf)
   ( printout t crlf )

   ( printout k "<tr><td>" ?saldo "</td><td> </td><td colspan='2'> r(" ?liquidora ") partida " ?numero2 " </td></tr>" crlf)
   ( printout k "<tr><td></td><td>" ?saldo "</td><td> </td><td>" ?nombre "</td></tr>" crlf)
)


(defrule obtencion-base-imponible-efecto-deduccion
   (declare (salience 180))
 (no)
   (fila ?numero)
;   (ajuste-anual-de-resultado-tributario (partida ?numero))

   (empresa (nombre ?empresa))
   ?partida     <- (partida (dia ?dia) (mes ?mes) (numero ?numero) (debe ?debep) (haber ?haberp))
   ?f1          <- (tributacion (partida ?numero) (cuenta ?nombre) (ano ?ano) (liquidadora ?liquidora1) (efecto deduccion))
   ?acreedora   <- (cuenta (partida ?partida) (parte ?parte) (nombre ?nombre)  (debe ?debe)  (haber ?haber)  (tipo ?tipo) (liquidada true) (tributada false) (grupo ?grupo) (circulante ?circulante))
;   ?acreedora   <- (cuenta (partida nil) (parte ?parte) (nombre ?nombre) (debe ?debe) (haber ?haber) (tributada false) (grupo ?grupo) (circulante ?circulante))

;   ?acreedora   <- (cuenta (nombre ?nombre)  (debe ?debe)  (haber ?haber)  (tributada false) )

   ?liquidador  <- (cuenta (nombre ?liquidora) (debe ?debe2) (haber ?haber2) (tipo liquidadora) )
;   (test (and (= ?debe 0) (= ?haber 0)))
;   ( test (< ?haber2 ?debe2))
;   ( test (eq ?nombre utilidad ))
;    ( test (neq nil ?partida))
  =>
   ( bind ?saldo (round (* 1 (- ?haber ?debe))))
   ( modify ?acreedora  (tributada true))

   ( assert ( cuenta
                ( dia ?dia)
                ( mes ?mes)
                ( ano ?ano)
                ( empresa ?empresa)
                ( de-resultado true)
                ( parte ?parte)
                ( circulante ?circulante)
                ( nombre ?nombre)
                ( grupo ?grupo)
                ( tipo acreedora)
                ( partida ?numero)
                ( tributada true)
                ( origen real )
                ( haber (+ ?haber ?saldo))))
   ( modify ?liquidador
     ( ano ?ano)
     ( empresa ?empresa )
     ( saldo ?saldo )
   )
   ( modify ?partida (debe (+ ?debep ?saldo)) ( haber (+ ?haberp ?saldo)))
 ( printout t "t-- Tributando cuenta " ?nombre " en " ?liquidora crlf)
 ( printout t "La cuenta de base imponible tiene un debe de " tab ?debe2 " y un haber de " tab ?haber2 crlf)
   ( printout t tab tab ?saldo tab "--|" tab tab tab ?nombre crlf)
   ( printout t tab tab tab "  |->" tab ?saldo tab tab "r<" ?liquidora ">" crlf)
   ( printout t crlf )

   ( printout k "<tr><td colspan='6'>t-- Tributando cuenta " ?nombre " en " ?liquidora "</td></tr>" crlf)
   ( printout k "<tr><td colspan='6'>t--La cuenta de base imponible tiene un debe de " tab ?debe2 " y un haber de " tab ?haber2 "</td><tr>" crlf)

   ( printout k "<tr style='background-color: azure'><td colspan='6'>La cuenta de liquidacion tiene un debe de " tab ?debe2 " y un haber de " tab ?haber2 "</td></tr>" crlf)
   ( printout k "<tr style='background-color: azure'><td> " ?saldo "</td><td></td><td colspan='2'>"  ?nombre "</td></tr>" crlf)
   ( printout k "<tr style='background-color: azure'><td> </td><td>" ?saldo "</td><td></td><td> r(" ?liquidora ") </td></tr>" crlf)
)


(defrule obtencion-utilidad-negativa
   (declare (salience 81))
   (fila ?numero)
  
   (ajuste-anual-de-resultado-financiero (partida ?numero))


   (empresa (nombre ?empresa))
   ?partida     <- (partida (dia ?dia) (mes ?mes) (numero ?numero) (debe ?debep) (haber ?haberp))
   ?f1          <- (liquidacion (partida ?numero) (cuenta ?nombre) (ano ?ano) (liquidadora ?liquidora))
   ?acreedora   <- (cuenta (de-resultado true) (partida nil) (parte ?parte) (nombre ?nombre)  (debe ?debe)  (haber ?haber)  (tipo acreedora) (liquidada false) (grupo ?grupo) (circulante ?circulante))
   ?liquidador  <- (cuenta (nombre ?liquidora) (debe ?debe2) (haber ?haber2) (tipo liquidadora) )
   (test (and (= ?debe 0) (= ?haber 0)))
   ( test (< ?haber2 ?debe2))
   ( test (eq ?nombre utilidad ))
  =>
   
   ( bind ?saldo (round (* 1 (- ?haber2 ?debe2))))
   ( modify ?acreedora  (liquidada true))

   ( assert ( cuenta
                ( dia ?dia)
                ( mes ?mes)
                ( ano ?ano)
                ( empresa ?empresa)
                ( de-resultado true)
                ( parte ?parte)
                ( circulante ?circulante)
                ( nombre ?nombre)
                ( grupo ?grupo)
                ( tipo acreedora)
                ( partida ?numero)
                ( liquidada true)
                ( origen real )
                ( haber (+ ?haber ?saldo))))
   ( modify ?liquidador
     ( ano ?ano)
     ( empresa ?empresa )
     ( saldo ?saldo )
   )
   ( modify ?partida (debe (+ ?debep ?saldo)) ( haber (+ ?haberp ?saldo)))
  ;  ( printout t "x-- Liquidando cuenta de resultados, cuando no hay utilidad" ?nombre " en " ?liquidora crlf)
   ;( printout t "La cuenta de liquidacion tiene un debe de " tab ?debe2 " y un haber de " tab ?haber2 crlf)
   ( printout t tab tab ?saldo tab "--|" tab tab tab ?nombre crlf)
   ( printout t tab tab tab "  |->" tab ?saldo tab tab "r<" ?liquidora ">" crlf)
   ( printout t crlf )
   ( printout t "obtencion-utilidad-negativa" crlf)

   ( printout k "<tr> <td colspan='8'>x-- Liquidando cuenta de resultados (cuando hay p??rdidas tributarias) en: " ?nombre " en " ?liquidora "</td></tr>" crlf)

   ( printout k "<tr style='font-weight:bold; color: white; background-color: crimson'> <td>" ?saldo "</td><td></td><td>" ?nombre "</td><tr>" crlf)
   ( printout k "<tr><td></td><td>" ?saldo "</td><td> </td><td colspan='2'> r(" ?liquidora ") </td></tr>" crlf)
)


(defrule obtencion-utilidad-tributaria-positiva
   ( declare (salience 81)) 

   ( fila ?numero)

  ;este paso es redundante, pero igual aclara
   (ajuste-anual-de-resultado-tributario (partida ?numero))

   ( empresa (nombre ?empresa))
   
   ?partida     <- (partida (dia ?dia) (mes ?mes) (numero ?numero) (debe ?debep) (haber ?haberp))

   (cuenta (nombre reserva-legal) (haber ?reserva-legal))
   (cuenta (nombre idpc) (haber ?idpc))

   ?f1          <- (liquidacion (partida ?numero) (cuenta ?nombre) (ano ?ano) (liquidadora ?liquidora))


   ;esta es la cuenta de referenica, los cambios no se realizan aqui, sino que se agregan cuentas del 
   ;mismo tipo, con assert en RHS.
   ?acreedora   <- (cuenta (de-resultado true) (partida nil) (parte ?parte) (nombre ?nombre)  (debe ?debe)  (haber ?haber)  (tipo acreedora) (liquidada false) (grupo ?grupo) (circulante ?circulante))

   ?liquidador  <- (cuenta (partida ?partida-de-liquidacion) (nombre ?liquidora) (debe ?debe2) (haber ?haber2) (tipo liquidadora) )
   (not (cuenta (partida ?numero) (nombre ?nombre) (liquidada true) ))

;   ( test (and (= ?debe 0) (= ?haber 0)))
   ( test (> ?haber2 ?debe2))
   ( test (eq ?nombre utilidad-tributaria))
  =>
   ( bind ?saldo (round (- (- (- ?haber2 ?debe2) ?reserva-legal  ) ?idpc )))
;   ( modify ?acreedora  (liquidada true))
   ( assert ( cuenta
                ( dia ?dia)
                ( mes ?mes)
                ( ano ?ano)
                ( empresa ?empresa)
                ( de-resultado true)
                ( parte ?parte)
                ( circulante ?circulante)
                ( nombre ?nombre)
                ( grupo ?grupo)
                ( tipo acreedora)
                ( partida ?partida-de-liquidacion)
                ( liquidada true)
                ( origen real )
                ( haber (+ ?haber ?saldo))))

   ( modify ?liquidador
     ( ano ?ano)
     ( empresa ?empresa )
     ( saldo ?saldo )
   )

   ( modify ?partida (debe (+ ?debep ?saldo)) ( haber (+ ?haberp ?saldo)))
 ; ( printout t "x-- Liquidando cuenta de resultados, cuando hay ganancia en " ?nombre " hacia " ?liquidora crlf)
 ; ( printout t "La cuenta de " ?partida-de-liquidacion tab ?liquidora tab ?debe2 " y un haber de " tab ?haber2 crlf)
   ( printout t tab tab ?saldo tab "--|" tab tab tab ?nombre crlf)
   ( printout t tab tab tab "  |->" tab ?saldo tab tab "r<" ?liquidora ">" crlf)
   ( printout t crlf )


   ( printout k "<tr><td colspan='6'>x-- Liquidando cuenta de resultados ( cuando hay ganancia) en " ?nombre " en " ?liquidora "</td></tr>" crlf)
   ( printout k "<tr style='background-color: azure'><td colspan='6'>La cuenta de liquidacion tiene un debe de " tab ?debe2 " y un haber de " tab ?haber2 "</td></tr>" crlf)
   ( printout k "<tr style='background-color: gold'><td> " ?saldo "</td><td></td><td colspan='2'>"  ?nombre "</td></tr>" crlf)
   ( printout k "<tr style='background-color: azure'><td> </td><td>" ?saldo "</td><td></td><td> r(" ?liquidora ") </td></tr>" crlf)
 ; ( printout t  "obtencion-utilidad-tributaria-positiva" crlf)
)





(defrule obtencion-utilidad-positiva
   ( declare (salience 81))
   ( fila ?numero)
  
   (ajuste-anual-de-resultado-financiero (partida ?numero))

   ( empresa (nombre ?empresa))

   ?partida     <- (partida (dia ?dia) (mes ?mes) (numero ?numero) (debe ?debep) (haber ?haberp))

   (cuenta (nombre reserva-legal) (haber ?reserva-legal))
   (cuenta (nombre idpc) (haber ?idpc))

   ?f1          <- (liquidacion (partida ?numero) (cuenta ?nombre) (ano ?ano) (liquidadora ?liquidora))

   ?acreedora   <- (cuenta (de-resultado true) (partida nil) (parte ?parte) (nombre ?nombre)  (debe ?debe)  (haber ?haber)  (tipo acreedora) (liquidada false) (grupo ?grupo) (circulante ?circulante))
   ?liquidador  <- (cuenta (nombre ?liquidora) (debe ?debe2) (haber ?haber2) (tipo liquidadora) )

   ( test (and (= ?debe 0) (= ?haber 0)))
   ( test (> ?haber2 ?debe2))
   ( test (eq ?nombre utilidad ))
  =>
;   ( bind ?saldo (round (- (- (- ?haber2 ?debe2) ?reserva-legal  ) ?idpc )))
   ( bind ?saldo (round (- (- ?haber2 ?debe2) ?reserva-legal  ) ))

   ( modify ?acreedora  (liquidada true))

   ( assert ( cuenta
                ( dia ?dia)
                ( mes ?mes)
                ( ano ?ano)
                ( empresa ?empresa)
                ( de-resultado true)
                ( parte ?parte)
                ( circulante ?circulante)
                ( nombre ?nombre)
                ( grupo ?grupo)
                ( tipo acreedora)
                ( partida ?numero)
                ( liquidada true)
                ( origen real )
                ( haber (+ ?haber ?saldo))))
   ( modify ?liquidador
     ( ano ?ano)
     ( empresa ?empresa )
     ( saldo ?saldo )
   )
   ( modify ?partida (debe (+ ?debep ?saldo)) ( haber (+ ?haberp ?saldo)))
;:   ( printout t "x-- Liquidando cuenta de resultados, cuando hay utilidad" ?nombre " en " ?liquidora crlf)
 ;:  ( printout t "La cuenta de liquidacion tiene un debe de " tab ?debe2 " y un haber de " tab ?haber2 crlf)
   ( printout t tab tab ?saldo tab "--|" tab tab tab ?nombre crlf)
   ( printout t tab tab tab "  |->" tab ?saldo tab tab "r<" ?liquidora ">" crlf)
   ( printout t crlf )

;   ( printout k "</tbody> </table>" crlf)

 ;  ( printout k "<table><tbody>" crlf)
   ( printout k "<tr> <td colspan='8'>x-- Liquidando cuenta de resultados (cuando hay ganancia) en: " ?nombre " en " ?liquidora "</td></tr>" crlf)

   ( printout k "<tr style='font-weight:bold; background-color: gold'> <td> " ?saldo "</td><td></td><td>" ?nombre "</td><tr>" crlf)
   ( printout k "<tr><td></td><td>" ?saldo "</td><td> </td><td colspan='2'> r(" ?liquidora ") </td></tr>" crlf)
 ;  ( printout k "</tbody> </table>" crlf)
   ( printout t  "obtencion-utilidad-positiva partida " ?numero crlf)

)

;------------------- liquidaciones --------------------------------------------------


;toma lo que se ha tirado a la cuenta liquidadora y lo reparte entre
;reserva, impuesto y utilidad
(defrule liquidar-cuenta-de-resultados
   ( declare (salience 81))
   ( fila ?numero)
  
   (ajuste-anual-de-resultado-financiero (partida ?numero))


   ( empresa (nombre ?empresa))
   ?partida     <- (partida (dia ?dia) (mes ?mes) (numero ?numero) (debe ?debep) (haber ?haberp))
   ?f1          <- (liquidacion (partida ?numero) (cuenta ?nombre) (ano ?ano) (liquidadora ?liquidora))
   ?acreedora   <- (cuenta (de-resultado true) (partida nil) (parte ?parte) (nombre ?nombre)  (debe ?debe)  (haber ?haber)  (tipo acreedora) (liquidada false) (grupo ?grupo) (circulante ?circulante))
   ?liquidador  <- (cuenta (nombre ?liquidora) (debe ?debe2) (haber ?haber2) (tipo liquidadora) )
   ( test (and (= ?debe 0) (= ?haber 0)))
   ( test (> ?haber2 ?debe2))
   ( test (> ?parte 0))
  =>
   ( bind ?saldo (round (* ?parte (- ?haber2 ?debe2))))
   ( modify ?acreedora  (liquidada true))

   ( assert ( cuenta  
                ( dia ?dia)
                ( mes ?mes)
                ( ano ?ano)
                ( empresa ?empresa)
                ( de-resultado true)
                ( parte ?parte)
                ( circulante ?circulante)
                ( nombre ?nombre)
                ( grupo ?grupo)
                ( tipo acreedora)
                ( partida ?numero)
                ( liquidada true)
                ( origen real )
                ( haber (+ ?haber ?saldo))))
   ( modify ?liquidador
     ( ano ?ano)
     ( empresa ?empresa )
     ( saldo ?saldo )
   )
   ( modify ?partida (debe (+ ?debep ?saldo)) ( haber (+ ?haberp ?saldo)))
;   ( printout t "x-- Liquidando cuenta de resultados " ?nombre " en " ?liquidora crlf)
;   ( printout t "La cuenta de liquidacion tiene un debe de " tab ?debe2 " y un haber de " tab ?haber2 crlf)
   ( printout t tab tab ?saldo tab "--|" tab tab tab ?nombre crlf)
   ( printout t tab tab tab "  |->" tab ?saldo tab tab "r<" ?liquidora ">" crlf)
   ( printout t crlf )

   ( printout k "<tr> <td colspan='7'> x-- Liquidando cuenta de resultados " ?nombre " en " ?liquidora "</td></tr>" crlf)
   ( printout k "<tr> <td colspan='7'> La cuenta de liquidacion tiene un debe de " tab ?debe2 " y un haber de " tab ?haber2 "</td></tr>" crlf)
   ( printout k "<tr style='background-color: lightgreen'><td>" ?saldo "</td> <td></td> <td colspan='2' >"    ?nombre     "</td></tr>" crlf)
   ( printout k "<tr style='background-color: lightgreen'><td></td><td>" ?saldo "</td> <td> </td><td colspan='2'> r(" ?liquidora ") </td></tr> "  crlf)
   ( printout t liquidar-cuenta-de-resultados tab partida tab ?numero crlf) 
)



(defrule crea-cuenta-perdidas-y-ganancias
   ( declare (salience 2))
   ( empresa (nombre ?empresa))
   ( balance (dia ?dia_b) (mes ?mes_b) (ano ?ano ))
   ( partida (numero ?partida ) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (descripcion ?descripcion))
   ( cuenta (nombre perdidas-y-ganancias) (partida nil) (grupo ?grupo-i) (padre ?padre-i) (circulante ?circulante-i) (naturaleza ?naturaleza-i) (tipo ?tipo-i) (origen ?origen-i) (de-resultado ?de-resultado-i))
  =>
 ;  ( printout t "creando cuenta perdidas-y-ganancias - partida " tab ?partida crlf)
   ( assert (cuenta (partida ?partida) (descripcion liquidando-inventario) (dia ?dia) (mes ?mes) (ano ?ano) (nombre perdidas-y-ganancias) (grupo ?grupo-i) (empresa ?empresa) (padre ?padre-i) (circulante ?circulante-i) (naturaleza ?naturaleza-i)(tipo ?tipo-i) (origen ?origen-i) (de-resultado ?de-resultado-i) (liquidada true)))
)



(defrule crea-cuenta-base-imponible
   ( declare (salience 2))
   ( empresa (nombre ?empresa))
   ( balance (dia ?dia_b) (mes ?mes_b) (ano ?ano ))
   ( partida (numero ?partida-cuenta ) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (descripcion ?descripcion))
   ( not (cuenta (partida ?part&:(neq nil ?part)) (nombre base-imponible)))
   ( exists (tributacion (partida ?partida-cuenta) ))
   ( cuenta (nombre base-imponible) (partida nil) (grupo ?grupo-i) (padre ?padre-i) (circulante ?circulante-i) (naturaleza ?naturaleza-i) (tipo ?tipo-i) (origen ?origen-i) (de-resultado ?de-resultado-i))
  =>
  ; ( printout t "creando cuenta base-imponible "  ?partida-cuenta crlf)
   ( assert (cuenta (partida ?partida-cuenta) (descripcion base-imponible) (dia ?dia) (mes ?mes) (ano ?ano) (nombre base-imponible) (grupo ?grupo-i) (empresa ?empresa) (padre ?padre-i) (circulante ?circulante-i) (naturaleza ?naturaleza-i)(tipo ?tipo-i) (origen ?origen-i) (de-resultado ?de-resultado-i) (tributada true)))
)



;inventario-----------------------------------------------------------------------------------


;La operaci??n de inventario final se hace al final del per??odo
;Pero necesito que funciones para cualquier per??do, as?? que
;las operaciones de cargo y abono estar??n fijadas para los datos
;de balance que sean ingreados y no por la fecha de la partida 
;de inventario-final

(defrule caratula-de-inventario-final
   ( declare (salience 3))
   ?partida-inventario-final <-  ( partida-inventario-final (partida ?numero) (hecho false) )
   ( empresa (nombre ?empresa))
   ( balance ( mes ?mes) (ano ?ano))
  =>

   ( printout t " Inicio de Cuenta de Inventario Final ----------------------------"  crlf)

   ( printout k "<table><tbody> " crlf)
   ( printout k "<tr><td colspan='3'> Cuenta de Inventario en " ?mes " de " ?ano "</td></tr>"  crlf)
   ( printout k "<tr style='background-color: cornflowerblue'><td> Partida </td> <td> DEBE </td> <td> HABER </td> </tr>" crlf)


   ( printout t Nombre tab DEBE tab HABER tab partida crlf)
   ( bind ?suma-debe 0)
   ( bind ?suma-haber 0)

   ( do-for-all-facts ((?f cuenta)) (and (neq nil ?f:partida) (eq ?f:nombre inventario))
     ( printout t ?f:nombre tab ?f:debe tab ?f:haber tab ?f:partida crlf)
     ( bind ?suma-debe  (+ ?suma-debe  ?f:debe) )
     ( bind ?suma-haber (+ ?suma-haber ?f:haber) )
     ( printout k "<tr> <td>" ?f:partida "</td><td> " (round ?f:debe) "</td><td>" (round ?f:haber) "</td></tr>" crlf)
   )

   ( printout t tab tab (round ?suma-debe) tab (round ?suma-haber) crlf)
   ( printout k "<tr> <td></td><td> " (round ?suma-debe) "</td><td>" (round ?suma-haber) "</td></tr>" crlf)

;  ( do-for-all-facts ((?f cuenta)) (eq ?f:nombre inventario-final)
;    ( printout t ?f:nombre tab ?f:debe tab ?f:haber tab ?f:partida crlf)
;  )


   ( assert
     (partida (numero ?numero) (empresa ?empresa) (dia 31) (mes ?mes) (ano ?ano)
     (descripcion (str-cat "Ajuste Anual A??o: Liquidacion Inventario Final " ?ano ))
     (actividad liquidacion-inventario) ))

   ;primero pasa el inventario a inventario-final para que quede del lado derecho
   ;luego pasar el inventario-final a perdidas y ganancias como efecto perdedor
   ;luego pasa el inventerio-final a perdias-y-ganancias como efecto deduccion
;   ( assert
 ;    (liquidacion (cuenta inventario) (partida ?numero) (ano ?ano)
  ;   (liquidadora inventario-final) (efecto ganador)))

   ( assert
     (liquidacion (cuenta inventario) (partida ?numero) (ano ?ano)
     (liquidadora inventario-final) (efecto ganador)))


   ( assert
     (liquidacion (cuenta inventario-final) (partida ?numero) (ano ?ano)
     (liquidadora perdidas-y-ganancias) (efecto perdedor)))


   ( assert
     (tributacion (cuenta inventario-final) (partida ?numero) (ano ?ano)
     (liquidadora base-imponible) (efecto deduccion)))



   ( modify ?partida-inventario-final (hecho true) (saldo (- ?suma-debe ?suma-haber)))
)


(defrule pie-de-inventario-final
  ( declare (salience 1))
  ?f1          <- ( partida-inventario-final (partida ?partida) )
=>
   ( printout t " Fin de Cuenta de Inventario Final ----------------------------"  crlf)

   ( printout k "<tr><td colspan='2'> Fin de Cuenta de Inventario Final </td></tr>"  crlf)
   ( printout k "</tbody></table>" crlf)
)




(defrule liquidando-inventario-corriente-a-inventario-final-deudor
   ( declare (salience 2))
(no)
   ( empresa (nombre ?empresa))
   ( balance (dia ?dia_b) (mes ?mes_b) (ano ?ano_top))
   ( partida (numero ?partida ) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (descripcion ?descripcion))
   ?perdidas-y-ganancias <- ( cuenta (nombre perdidas-y-ganancias) (debe ?debe-i) (haber ?haber-i))

   (or
     ?i  <- ( cuenta (nombre inventario) (partida ?partida-inventario) (debe ?debe) (liquidada false) (grupo ?grupo) (padre ?padre) (circulante ?circulante) (naturaleza ?naturaleza) (tipo ?tipo) (origen ?origen) (de-resultado ?de-resultado))
     ?i  <- ( cuenta (nombre inventario-inicial) (partida ?partida-inventario) (debe ?debe) (liquidada false) (grupo ?grupo) (padre ?padre) (circulante ?circulante) (naturaleza ?naturaleza) (tipo ?tipo) (origen ?origen) (de-resultado ?de-resultado))
   )

   ?f1          <- ( partida-inventario-final (partida ?partida) )
   ( test (> ?debe 0) )
   ( test (>= (to_serial_date ?dia_b ?mes_b ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  =>
   ( printout t ?partida tab ?debe tab "|" crlf)
   ( printout k "<tr style='color: white; background-color: black' ><td>" ?partida "</td><td>" ?debe "</td></tr>" crlf)
   ( modify ?i (liquidada true) )

   ( assert (abono (partida ?partida-inventario) (dia ?dia_b) (mes ?mes_b) (ano ?ano) (empresa ?empresa) (cuenta inventario) (monto ?debe) (glosa final)))
   ( assert (cuenta (partida ?partida-inventario) (descripcion liquidando-inventario) (dia ?dia) (mes ?mes) (ano ?ano) (nombre inventario) (grupo ?grupo) (empresa ?empresa) (padre ?padre) (circulante ?circulante) (naturaleza ?naturaleza) (haber ?debe) (tipo ?tipo) (origen ?origen) (de-resultado ?de-resultado) (liquidada true)))
   ( modify ?perdidas-y-ganancias (partida ?partida) (debe (+ ?debe-i ?debe)) (liquidada true))
)



(defrule liquidando-inventario-en-inventario-final-acreedor
   ( declare (salience 2))
(no)
   ( empresa (nombre ?empresa))
   ( balance (dia ?dia_b) (mes ?mes_b) (ano ?ano_top ))
   ( partida (numero ?partida ) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (descripcion ?descripcion))
   ?perdidas-y-ganancias <- ( cuenta (nombre perdidas-y-ganancias) (debe ?debe-i) (haber ?haber-i) (grupo ?grupo-i) (padre ?padre-i))

   (or
     ?i  <- ( cuenta (nombre inventario) (partida ?partida-inventario) (haber ?haber) (liquidada false) (grupo ?grupo) (padre ?padre) (circulante ?circulante) (naturaleza ?naturaleza) (tipo ?tipo) (origen ?origen) (de-resultado ?de-resultado))
     ?i  <- ( cuenta (nombre inventario-inicial) (partida ?partida-inventario) (haber ?haber) (liquidada false) (grupo ?grupo) (padre ?padre) (circulante ?circulante) (naturaleza ?naturaleza) (tipo ?tipo) (origen ?origen) (de-resultado ?de-resultado))
   )

   ?f1 <- ( partida-inventario-final (partida ?partida) )
   ( test (> ?haber 0))
   ( test (>= (to_serial_date ?dia_b ?mes_b ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  =>
   ( printout t ?partida tab tab "|" tab ?haber crlf)
   ( printout k "<tr> <td>"  ?partida "</td><td></td><td>" ?haber "</td></tr>" crlf)
   ( modify ?i (liquidada true) ) 
   ( assert (cargo (partida ?partida-inventario) (dia ?dia_b) (mes ?mes_b) (ano ?ano) (empresa ?empresa) (cuenta inventario) (monto ?haber) (glosa final)))
   ( assert (cuenta (partida ?partida-inventario) (descripcion liquidando-inventario) (dia ?dia) (mes ?mes) (ano ?ano) (nombre inventario) (grupo ?grupo) (empresa ?empresa) (padre ?padre) (circulante ?circulante) (naturaleza ?naturaleza) (haber ?haber) (tipo ?tipo) (origen ?origen) (de-resultado ?de-resultado) (liquidada true)))
   ( modify ?perdidas-y-ganancias (partida ?partida) (haber (+ ?haber-i ?haber)) (liquidada true))
)




(defrule provisionando-idpc
   ( declare (salience 81))
   (fila ?numero)
   ( empresa (nombre ?empresa))
   ( balance (dia ?dia_b) (mes ?mes_b) (ano ?ano_top))
   ?partida <-  ( partida (numero ?numero ) (debe ?debep) (haber ?haberp) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (descripcion ?descripcion))
   ?f1          <- (provision (partida ?numero) (cuenta ?nombre) (ano ?ano) (liquidadora ?liquidora))

   ?acreedora   <- (cuenta (nombre ?nombre)  (debe ?debe)  (haber ?haber) (ano ?ano) (grupo ?grupo))
   ?liquidador  <- (cuenta (partida nil) (nombre ?liquidora) (debe ?debe2) (haber ?haber2)  )

   ( test (> ?haber ?debe))
   ( test (>= (to_serial_date ?dia_b ?mes_b ?ano_top) (to_serial_date ?dia ?mes ?ano)))

  =>
   ( modify ?partida (debe (+ ?debep ?haber)) ( haber (+ ?haberp ?haber)))

   ( assert (abono (partida ?numero) (dia ?dia_b) (mes ?mes_b) (ano ?ano) (empresa ?empresa) (cuenta impuesto-a-la-renta-por-pagar) (monto ?haber) (glosa final)))

   ( assert (cargo (partida ?numero) (dia ?dia_b) (mes ?mes_b) (ano ?ano) (empresa ?empresa) (cuenta ?liquidora) (monto ?haber) (glosa final)))

   ( printout t tab tab (round ?haber) tab "|" tab tab ?nombre tab ?grupo crlf)
   ( printout t tab tab tab "|" tab (round ?haber) tab tab "r<" ?liquidora ">" crlf)
   ( printout t  crlf )
   ( retract ?f1 )
;  ( printout t "Provisionando deudor <<" ?nombre ">> hacia <<" ?liquidora ">>" crlf)

   ( printout k "<tr> <td> " (round ?haber) "</td><td> </td><td>" ?nombre "#" ?grupo  "</td></tr>" crlf)
   ( printout k "<tr><td> </td><td>" (round ?haber) "</td><td> r(" ?liquidora ") </td></tr>" crlf)

)
 
