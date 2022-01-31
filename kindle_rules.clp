;#Este modulo debiese generarl html para kindle y sitos web
;#Este modulo no funciona bien, agrega algunas cuentas
;como inventario que no están en las partida originales
;Esto ya se incroporó a partidas
( defmodule KINDLE ( import MAIN ?ALL ))

(deffunction mes_to_numero_v ( ?mes )
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


(defrule inicializando-archivos
   (declare (salience 10000))
   (empresa (nombre ?empresa))
   (balance (ano ?ano))
 =>
   ( bind ?archivo (str-cat "./doc/" ?empresa ".markdown"))
   ( open ?archivo k "w")
   ( printout t "Archivo para html y kindle: " ?archivo crlf)
   ( printout k "--- " crlf)
   ( printout k "title: " ?empresa crlf)
   ( printout k "permalink: /" ?empresa  "/ " crlf)
   ( printout k "layout: page" crlf)
   ( printout k "--- " crlf)
)

(defrule cierre
  (declare (salience -10000))
  =>
  ( close )
)

(defrule inicio-de-modulo-kindle
   (declare (salience 9000))
   (empresa (nombre ?empresa))
   ( ticket (numero ?numero))
  => 
 ; ( bind ?archivo (str-cat "./doc/" ?empresa ".markdown"))
;  ( dribble-on ?archivo)
   ( assert (cabeza ?numero ))
)


;============================== Tabla de la Partida ================================
(defrule encabezado
  ?c <- ( cabeza ?numero )
  ?partida <-  ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
  ( revision (voucher ?voucher) (revisado true) (partida ?numero) (folio ?folio) (descripcion ?descripcion) (legal ?legal) (rcv ?rcv) (ccm ?ccm) (a-corregir ?a-corregir) (old ?old) (tipo ?tipo))

  ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
  ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

 =>
  ( retract ?c )
  ( printout k crlf crlf )
  ( printout k "<br> <br> <br> <br> <br> <br> " crlf)

  ( printout k "<table>" crlf)
  ( printout k "<thead><th colspan='6'>Partida " ?numero "</th></thead>"crlf)
  ( printout k "<tbody>" crlf)
  ( assert (fila ?numero))
)



(defrule footer
  ( declare (salience 60))
  ?fila <- ( fila ?numero )
  ( balance ( dia ?top ) (mes ?mes_top) (ano ?ano_top))
  ( empresa (nombre ?empresa) (razon ?razon))
  ( partida (numero ?numero) (proveedor ?proveedor) (debe ?debe) (haber ?haber) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?descripcion) (actividad ?actividad))
  ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
 =>
  ( retract ?fila )
  ( printout k "<tr> <hr> </tr>" crlf)
  ( printout k "<tr> <td> </td> <td> " ?debe " </td> <td> " ?haber "</td> <td> ( " ?dia " de " ?mes tab ?ano tab " ) </td> </tr>" crlf)
 ; ( printout k "==================================================================" crlf)
  ( printout k "<tr><td colspan='8'> " ?razon  " </td> </tr>" crlf)
  ( printout k "<tr><td colspan='8'> Partida " ?numero ": " ?descripcion " </td></tr>" crlf)
  ( if  (neq nil ?proveedor) then (  printout k "<tr> <td>efectuado a " ?proveedor " </td> </tr>" crlf ) )
  ( printout k "<tr><td colspan = '8'> " ?actividad "</td> </tr>" crlf)
  ( printout k "</tbody>" crlf)
  ( printout k "</table>" crlf)
) 


(defrule muestra-libro-mayor-resultados-subcuentas
   ( declare (salience 65))
   ( fila ?numero )
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( empresa (nombre ?empresa))
   ?partida <- ( partida (numero ?numero) (debe ?debe) (haber ?haber) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?descripcion))
   ?padre <- (cuenta (liquidada false) (partida ?numero) (empresa ?empresa) (nombre ?nombre) (dia ?dia) (mes ?mes) (ano ?ano) (debe ?debe1)  (haber ?haber1)  (saldo ?saldo1)  (grupo resultado))
   ?cuenta <- (cuenta (mostrada-en-partida false) (partida ?numero) (empresa ?empresa) (padre ?nombre) (dia ?dia) (mes ?mes) (ano ?ano) (nombre ?nombre2) (debe ?debe2) (haber ?haber2) (saldo ?saldo2) (grupo resultado) (origen ?origen))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ( test (neq 0 (+ ?debe1 ?haber1)))
  =>
   ( modify ?cuenta (mostrada-en-partida true))
   ( printout k "<tr> <td colspan='2'>" ?saldo2 " </td> <td colspan='2'> " ?nombre2 # ?nombre " </td></tr>" crlf)
) 



(defrule muestra-libro-mayor-activos-subcuentas
   ( declare (salience 65))
   ( fila ?numero )
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( empresa (nombre ?empresa))
   ?partida <- ( partida (numero ?numero) (debe ?debe) (haber ?haber) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?descripcion))
   ?padre <- (cuenta (liquidada false) (partida ?numero) (empresa ?empresa) (nombre ?nombre) (dia ?dia) (mes ?mes) (ano ?ano) (debe ?debe1)  (haber ?haber1)  (saldo ?saldo1)  (grupo activo))
   ?cuenta <- (cuenta (mostrada-en-kindle false) (partida ?numero) (empresa ?empresa) (padre ?nombre) (dia ?dia) (mes ?mes) (ano ?ano) (nombre ?nombre2) (debe ?debe2) (haber ?haber2) (saldo ?saldo2) (grupo activo) (origen ?origen))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ( test (neq 0 (+ ?debe1 ?haber1)))

  =>
   ;( modify ?partida (debe (+ ?debe ?debe2)) (haber (+ ?haber ?haber2)))
   ( modify ?cuenta (mostrada-en-kindle true))
;   ( printout k ?debe " | " ?haber " --" partida  crlf)
   ( printout k "<tr><td colspan='2'>" ?saldo2 "</td> <td colspan='2'>" ?nombre2 # ?nombre "</td> </tr>" crlf)
)




(defrule muestra-libro-mayor-pasivos-subcuentas
   ( declare (salience 64))
   ( fila ?numero)
   ( empresa (nombre ?empresa))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ?partida <- ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (debe ?debe) (haber ?haber))
   ?padre <- (cuenta (liquidada false) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (nombre ?nombre) (debe ?debe1)  (haber ?haber1)  (saldo ?saldo1)  (grupo pasivo))
   ?cuenta <- (cuenta  (mostrada-en-kindle false) (partida ?numero) (empresa ?empresa) (padre ?nombre)  (nombre ?nombre2) (dia ?dia) (mes ?mes) (ano ?ano) (debe ?debe2) (haber ?haber2) (saldo ?saldo2) (origen ?origen) )
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ( test (neq 0 (+ ?debe1 ?haber1)))

  =>
  ; ( modify ?partida (debe (+ ?debe ?debe2)) (haber (+ ?haber ?haber2)))
   ( modify ?cuenta (mostrada-en-kindle true))
 ;  ( printout k ?debe " | " ?haber " --" partida  crlf)
   ( printout k "<tr> <td> " ?saldo2 " </td> <td> </td> <td colspan='7'> " ?nombre2 # ?nombre " </td> </tr> " crlf)
)



(defrule muestra-libro-mayor-activos-mayores
   ( declare (salience 63))
   ( fila ?numero )
   ( empresa (nombre ?empresa))
   ( balance (dia ?top ) (mes ?mes_top) (ano ?ano_top))
   ?partida <- ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (debe ?debe) (haber ?haber))
   ?cuenta <- (cuenta (mostrada-en-kindle false) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (nombre ?nombre) (debe ?debe1) (haber ?haber1) (saldo ?saldo) (padre false) (grupo activo))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ( test (neq 0 (+ ?debe1 ?haber1)))
  =>
   ( modify ?partida (debe (+ ?debe ?debe1)) (haber (+ ?haber ?haber1)))
   ( modify ?cuenta (mostrada-en-kindle true))
 ;  ( printout k ?debe " | " ?haber " --" partida  crlf)
   ( printout k "<tr>  <td> </td> <td> " ?debe1 "</td> <td> " ?haber1 "</td> <td> a[" ?nombre "] </td> </tr>" crlf)
)

(defrule muestra-de-resultados
   ( declare (salience 62))
   ( fila ?numero )
   ( empresa (nombre ?empresa))
   ( balance ( dia ?top ) (mes ?mes_top) (ano ?ano_top))
   ?partida <- ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (debe ?debe) (haber ?haber))
   ?cuenta <- (cuenta (mostrada-en-kindle false) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (nombre ?nombre) (debe ?debe1) (haber ?haber1) (saldo ?saldo1) (padre false) (grupo resultado) )
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  =>
   ( modify ?partida (debe (+ ?debe ?debe1)) (haber (+ ?haber ?haber1)))
   ( modify ?cuenta (mostrada-en-kindle true))
 ;  ( printout k ?debe " | " ?haber " --" partida  crlf)
   ( printout k "<tr>  <td> </td> <td>" ?debe1 " </td> <td> " ?haber1 "</td> <td> r[" ?nombre "] </td> </tr>" crlf)
)
               


(defrule muestra-cuentas-tributarias
   ( declare (salience 62))
   ( fila ?numero )
   ( empresa (nombre ?empresa))
   ( balance ( dia ?top ) (mes ?mes_top) (ano ?ano_top))
   ?partida <- ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (debe ?debe) (haber ?haber))
   ?cuenta <- (cuenta (mostrada-en-kindle false) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (nombre ?nombre) (debe ?debe1) (haber ?haber1) (saldo ?saldo1) (padre false) (grupo tributario) )
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  =>
   ( modify ?partida (debe (+ ?debe ?debe1)) (haber (+ ?haber ?haber1)))
   ( modify ?cuenta (mostrada-en-kindle true))
 ;  ( printout k ?debe " | " ?haber " --" partida  crlf)
   ( printout k "<tr>  <td> </td> <td> " ?debe1 "</td> <td>" ?haber1 "</td> <td> t[" ?nombre "] </td></tr> " crlf)
)




(defrule muestra-libro-mayor-pasivos-mayores
   ( declare (salience 62))
   ( fila ?numero )
   ( empresa (nombre ?empresa))
   ( balance ( dia ?top ) (mes ?mes_top) (ano ?ano_top))
   ?partida <- ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (debe ?debe) (haber ?haber))
   ?cuenta <- (cuenta (mostrada-en-kindle false) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (nombre ?nombre) (debe ?debe1) (haber ?haber1) (saldo ?saldo1) (padre false) (grupo pasivo)) 
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ( test (neq 0 (+ ?debe1 ?haber1)))
  
  => 
   ( modify ?partida (debe (+ ?debe ?debe1)) (haber (+ ?haber ?haber1)))
   ( modify ?cuenta (mostrada-en-kindle true))
 ;  ( printout k ?debe " | " ?haber " --" partida  crlf)
   ( printout k "<tr>  <td> </td> <td> " ?debe1 " </td> <td> " ?haber1 " </td> <td> p[" ?nombre "] </td> </tr>" crlf)
)



(defrule muestra-libro-patrimonio
   ( declare (salience 61))
   ( fila ?numero )
   ( empresa (nombre ?empresa))
   ( balance ( dia ?top ) (mes ?mes_top) (ano ?ano_top))
   ?partida <- ( partida (numero ?numero) (debe ?debe) (haber ?haber) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?descripcion))
   ?cuenta <- (cuenta (mostrada-en-kindle false) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (nombre ?nombre) (debe ?debe1) (haber ?haber1) (saldo ?saldo1) (padre false) (grupo patrimonio) (origen real))
   ( test (> ?saldo1 0) )
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

  =>
   ( modify ?partida (debe (+ ?debe ?debe1)) (haber (+ ?haber ?haber1)))
   ( modify ?cuenta (mostrada-en-kindle true))
 ;  ( printout k ?debe " | " ?haber " --" partida  crlf)
   ( printout k " <tr> <td> </td> <td> " ?debe1 " </td> <td>  " ?haber1 " </td> <td> " ?nombre " </td> </tr>" crlf)
)



