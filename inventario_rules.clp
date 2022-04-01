;toma el inventario real físico y lo valoriza para colocarlo en la
;cuenta de inventario-final
( defmodule INVENTARIO ( import MAIN ?ALL ))

(deffunction numero_to_mes ( ?numero )
  ( switch ?numero
    ( case 1   then enero)
    ( case 2   then febrero)
    ( case 3   then marzo)
    ( case 4   then abril)
    ( case 5   then mayo)
    ( case 6   then junio)
    ( case 7   then julio)
    ( case 8   then agosto)
    ( case 9   then septiembre)
    ( case 10  then octubre)
    ( case 11  then noviembre)
    ( case 12  then diciembre)
    ( case 13  then enero)
    ( case 14  then febrero)
  )
)

(defrule inicio
  ( declare (salience 10000) )
 =>
)


(defrule fin
  ( declare (salience -100) )
 =>
  ( printout k "</tbody></table>" crlf)
  ( close k )
)

;esto genera un markdown para que jekyll lo publique en el blog necios
(defrule inicio-kindle-k-inventario-rules
   ( declare (salience 10000))
   ( empresa (nombre ?empresa))
  =>

   ( bind ?archivo (str-cat "./doc/" ?empresa "/inventario.markdown"))
   ( open ?archivo k "w")

   ( printout k "--- " crlf)
;   ( printout k "title: " ?empresa "-inventario" crlf)
 ;  ( printout k "permalink: /" ?empresa "-inventario/ " crlf)
   ( printout k "layout: page" crlf)
   ( printout k "--- " crlf)
   ( printout k "" crlf)
  ; ( printout k "Contabilidad para Necios® usa el siguiente código de colores para este documento." crlf)
  ; ( printout k "<li><span style='background-color: lavender'>[    ]</span> partida revisada y resultado bueno. </li>" crlf)
  ; ( printout k "<li><span style='background-color: lightyellow'>[    ]</span> cuenta mayor del activo </li>" crlf)
  ; ( printout k "<li><span style='background-color: azure'>[    ]</span> cuenta mayor del pasivo </li>" crlf)
  ; ( printout k "<li><span style='color: white; background-color: cornflowerblue'>[    ]</span> cuenta de patrimonio </li>" crlf)
  ; ( printout k "<li><span style='background-color: gold'>[    ]</span> ganancia </li>" crlf)
  ; ( printout k "<li><span style='color: white; background-color: black'>[    ]</span> pérdida </li>" crlf)
  ; ( printout k "<li><span style='background-color: blanchedalmond'>[    ]</span> subtotales de la transacción </li>" crlf)

)


(defrule INVENTARIO::inicio-de-modulo-inventario
   (declare (salience 10000))
  => 
   ( printout t "-------------------- INVENTARIO -----------------------------------------------------------" crlf)
   ( printout t "  material             dia    u       cu      ct        u      cu      ct            descripcion" crlf)
   ( printout t "..........................................................................................." crlf)
   ( printout t "                             ..........entrada.........|...........salida........." crlf)

   ( printout k "<table><tbody>" crlf)
   ( printout k "<tr> <th colspan='13'> INVENTARIO </th> </tr>" crlf)
   ( printout k "<tr><td>Ptda</td> <td> material </td> <td>dia</td> <td>mes</td> <td>u</td> <td>cu</td> <td>ct</td> <td>u</td> <td>cu</td> <td>ct</td> <td>Oper.</td> <td> Ref </td></tr>" crlf)
   ( printout k "<tr> <td></td> <td></td> <td></td> <td style='background-color: gold' colspan='3'> entrada</td> <td style='background-color: cornflowerblue' colspan='3'>salida </td> <td style='colspan=4'> </td> </tr>" crlf)
   ( assert (comando (nombre hacer-inventario)))
)



;el asiento inicial ya está implementado por el usuario en sus facts
;este tramite es una excepcion pues no generará posteriormente una liquidacion,
;por eso la cuenta inventario ya debe ir con la bandera liquidada puesta a true
;no se liquida por la operaicoń de compra ya fue liquidada en el ejercicio anterior
;me arrepentí, parece que sí hay que liquidarla, pues el nuevo inventario sí se debe liquidar a fin
;de año. Cre que había entendido mal, liquidar es un proceso más de contabilidad que se puede
;hacer cuando uno quiera o cuando sea necesario
(defrule INVENTARIO::inventario-asiento-inicial
   ( empresa (nombre ?empresa) )
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top ))
   ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ?cuenta <- ( cuenta (origen ?origen) (partida nil) (nombre inventario ) (grupo ?grupo) (circulante ?circulante) (debe ?debe) (haber ?haber) (balanceado ?balanceado) (tipo ?tipo))
   ?costos-de-mercancias <-  ( cuenta (deducible ?deducible) (origen ?origen2) (partida nil) (nombre costos-de-mercancias ) (grupo ?grupo2) (circulante ?circulante2) (tipo ?tipo2) (padre ?padre2))

   ?inventario <- (inventario (dia ?dia) (mes ?mes) (u ?unidades) (operacion asiento-inicial) (material ?material) (partida ?numero) (ct ?total) (cu ?costo_unitario) (referencia ?referencia))
   (cuenta (nombre inventario) (deducible ?deducible))
  => 
; ( assert ( cuenta (origen ?origen) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa ) (partida ?numero) (nombre inventario ) (grupo ?grupo) (circulante ?circulante) (debe ?total) (haber 0) (balanceado ?balanceado) (liquidada true))) 


   ( assert ( cuenta (origen ?origen) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa ) (partida ?numero) (nombre inventario ) (grupo ?grupo) (circulante ?circulante) (debe ?total) (haber 0) (balanceado ?balanceado) (deducible ?deducible) ))

   ( assert ( cuenta (deducible ?deducible) (origen ?origen2) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?empresa) (partida ?numero) (nombre costos-de-mercancias ) (grupo ?grupo2) (circulante ?circulante2) (haber ?total) (tipo ?tipo2) (padre ?padre2)))

   (printout t ?material tab ?dia tab ?unidades tab ?costo_unitario tab ?total tab tab tab tab inventario-inicial crlf)
   (printout k "<tr> <td><a href= '/" ?empresa "/libro-diario#Partida-" ?numero "'>" ?numero "</a></td><td>" ?material "</td> <td>" ?dia "</td> <td>" ?mes "</td> <td>" ?unidades "</td> <td>" ?costo_unitario "</td> <td>" ?total "</td> <td colspan='3'></td> <td>asiento-inicial</td><td>" (if (neq nil ?referencia) then "<a href= '/" ?empresa "/#Partida-" ?referencia "'> </a>" else "" ) "</td></tr>" crlf)
   ;( retract ?inventario )
  ;(printout t "Ignorada partida de inventario por " ?total " operacion es " asiento-inicial crlf)
)


(defrule INVENTARIO::inventario-devolucion
   ( empresa (nombre ?empresa ))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top ))
   ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ?cuenta <- ( cuenta (origen ?origen) (partida nil) (nombre inventario ) (grupo ?grupo) (circulante ?circulante) (debe ?debe) (haber ?haber) (balanceado ?balanceado) (tipo ?tipo))
   ?inventario <- (inventario (dia ?dia) (mes ?mes) (u ?unidades) (operacion devolucion) (material ?material) (partida ?numero) (ct ?total) (cu ?costo_unitario) (referencia ?referencia))
   ?costos-de-mercancias <-  ( cuenta (deducible ?deducible) (origen ?origen2) (partida nil) (nombre costos-de-mercancias ) (grupo ?grupo2) (circulante ?circulante2) (tipo ?tipo2)  (padre ?padre2))
   ( cuenta (nombre inventario) (deducible ?deducible))
  => 
   ( assert ( cuenta (origen ?origen) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?empresa) (partida ?numero) (nombre inventario ) (grupo ?grupo) (circulante ?circulante) (debe ?total) (haber 0) (balanceado ?balanceado) (tipo ?tipo) (deducible ?deducible)))

   ( assert ( cuenta (origen ?origen2) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?empresa) (partida ?numero) (nombre costos-de-mercancias ) (grupo ?grupo2) (circulante ?circulante2) (haber ?total) (tipo ?tipo2) (padre ?padre2) (deducible ?deducible) ))

   (printout t ?material tab ?dia tab ?unidades tab ?costo_unitario tab ?total tab tab tab tab devolucion crlf)
   (printout k "<tr>< <td><a href= '/" ?empresa "/libro-diario#Partida-" ?numero "'>" ?numero "</a></td>td>" ?material "</td> <td>" ?dia "</td> <td>" ?mes " </td> <td>" ?unidades "</td> <td>" ?costo_unitario "</td> <td>" ?total "</td>< td colspan='3'></td> <td>devolucion</td><td>" (if (neq nil ?referencia) then "<a href= '/" ?empresa "/#Partida-" ?referencia "'> </a>" else "" ) "</td> </tr>" crlf)

   ;(retract ?inventario)
 ; (printout t "Creada partida de inventario por " ?total " operacion es " devolucion crlf)
)


(defrule INVENTARIO::inventario-gasto-sobre-compra
   ( empresa (nombre ?empresa) )
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top ))
   ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ?cuenta <- ( cuenta (origen ?origen) (partida nil) (nombre inventario ) (grupo ?grupo) (circulante ?circulante) (debe ?debe) (haber ?haber) (balanceado ?balanceado) (tipo ?tipo))
   ?inventario <- (inventario (dia ?dia) (mes ?mes) (u ?unidades) (operacion gasto-sobre-compra) (material ?material) (partida ?numero) (ct ?total) (cu ?costo_unitario) (referencia ?referencia) )
   ?costos-de-mercancias <-  ( cuenta (deducible ?deducible) (origen ?origen2) (partida nil) (nombre costos-de-mercancias ) (grupo ?grupo2) (circulante ?circulante2) (tipo ?tipo2) (padre ?padre2))
   (cuenta (nombre inventario) (deducible ?deducible))
  => 
   ( assert ( cuenta (origen ?origen) (empresa ?empresa) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (nombre inventario ) (grupo ?grupo) (circulante ?circulante) (debe ?total) (haber 0) (balanceado ?balanceado) (tipo ?tipo) (deducible ?deducible  )))

   ( assert ( cuenta (origen ?origen2) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?empresa) (partida ?numero) (nombre costos-de-mercancias ) (grupo ?grupo2) (circulante ?circulante2) (haber ?total) (tipo ?tipo2) (padre ?padre2) (deducible ?deducible)))

   ( printout t ?material tab ?dia tab ?unidades tab ?costo_unitario tab ?total tab tab tab tab gasto-sobre-compra crlf)
   (printout k "<tr>  <td><a href= '/" ?empresa "/libro-diario#Partida-" ?numero "'>" ?numero "</a></td><td>" ?material "</td> <td>" ?dia "</td> <td>" ?unidades "</td> <td>" ?costo_unitario "</td> <td>" ?total "</td> <td colspan='3'></td> <td>gasto-sobre-compra</td>td>" (if (neq nil ?referencia) then "<a href= '/" ?empresa "/#Partida-" ?referencia "'> </a>" else "" ) "</td> </tr>" crlf)

   ;( retract ?inventario )
 ;(printout t "Creada partida de inventario por " ?total " operacion es " gasto-sobre-compra  crlf)

)


(defrule INVENTARIO::inventario-compra
   ( empresa  (nombre ?empresa ))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top ))
   ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ?cuenta <- ( cuenta (origen ?origen) (partida nil) (nombre inventario ) (grupo ?grupo) (circulante ?circulante) (debe ?debe) (haber ?haber) (balanceado ?balanceado) (tipo ?tipo))
   ?inventario <- (inventario (dia ?dia) (mes ?mes) (u ?unidades) (operacion compra) (material ?material) (partida ?numero) (ct ?total) (cu ?costo_unitario) (referencia ?referencia) )
   ?costos-de-mercancias <-  ( cuenta (deducible ?deducible) (origen ?origen2) (partida nil) (nombre costos-de-mercancias ) (grupo ?grupo2) (circulante ?circulante2) (tipo ?tipo2) (padre ?padre2))
   ( cuenta (nombre inventario) (deducible ?deducible))
  => 
   ( assert ( cuenta (origen ?origen) (partida ?numero) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (nombre inventario ) (grupo ?grupo) (circulante ?circulante) (debe ?total) (haber 0) (balanceado ?balanceado) (tipo ?tipo) (deducible ?deducible)))

   ( assert ( cuenta (deducible ?deducible) (origen ?origen2) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?empresa) (partida ?numero) (nombre costos-de-mercancias ) (grupo ?grupo2) (circulante ?circulante2) (haber ?total) (tipo ?tipo2) (padre ?padre2)))

   (printout t ?material tab ?dia tab ?unidades tab ?costo_unitario tab ?total tab tab tab tab compra crlf)
   (printout k "<tr>   <td><a href= '/" ?empresa "/libro-diario#Partida-" ?numero "'>" ?numero "</a></td><td>" ?material "</td> <td>" ?dia "</td> <td>" ?mes "</td> <td>" ?unidades "</td> <td>" ?costo_unitario "</td> <td>" ?total "</td> <td colspan='3'></td> <td>compra</td><td>" (if (neq nil ?referencia) then "<a href= '/" ?empresa "/#Partida-" ?referencia "'> </a>" else "" ) "</td> </tr>" crlf)

   ;( retract ?inventario )
;:  (printout t "Creada partida de inventario por " ?total " operacion es " compra  crlf)

)

(defrule INVENTARIO::inventario-venta
   ( empresa (nombre ?empresa))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top ))
   ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ?cuenta <- ( cuenta (origen ?origen) (partida nil) (nombre inventario ) (grupo ?grupo) (circulante ?circulante) (debe ?debe) (haber ?haber) (balanceado ?balanceado) (tipo ?tipo))
   ?inventario <- (inventario (dia ?dia) (mes ?mes) (u ?unidades) (operacion venta) (material ?material) (partida ?numero) (ct ?total) (cu ?costo_unitario) (referencia ?referencia))
   ?costos-de-mercancias <-  ( cuenta (deducible ?deducible) (origen ?origen2) (partida nil) (nombre costos-de-mercancias ) (grupo ?grupo2) (circulante ?circulante2) (tipo ?tipo2) (padre ?padre2))
   ( cuenta (nombre inventario) (deducible ?deducible))
  => 
   ( assert ( cuenta (origen ?origen) (partida ?numero) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (nombre inventario ) (grupo ?grupo) (circulante ?circulante) (debe 0) (haber ?total) (balanceado ?balanceado) (tipo ?tipo) (deducible ?deducible)  ))

   ( assert ( cuenta  (deducible ?deducible) (origen ?origen2) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?empresa) (partida ?numero) (nombre costos-de-mercancias ) (grupo ?grupo2) (circulante ?circulante2) (debe ?total) (tipo ?tipo2) (padre ?padre2)))

   (printout t ?material tab ?dia tab tab tab tab ?unidades tab ?costo_unitario tab ?total tab venta crlf)
   (printout k "<tr>  <td><a href= '/" ?empresa "/libro-diario#Partida-" ?numero "'>" ?numero "</a></td><td>" ?material "</td> <td>" ?dia "</td> <td></td> <td> </td> <td></td> <td></td> <td>" ?unidades "</td> <td>" ?costo_unitario "</td> <td>" ?total "</td><td>venta</td><td>" (if (neq nil ?referencia) then (str-cat "<a href= '" ?empresa "/#Partida-" ?referencia "'>" ?referencia "</a>") else "" ) "</td>  </tr>" crlf)

   ;(retract ?inventario)
 ;(printout t "Creada partida de inventario por " ?total " operacion es " venta crlf)
)

(defrule INVENTARIO::mostrar-inventario
  ( empresa (nombre ?empresa))
  ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top ))
  ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
  ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  ?comando <- (comando (nombre mostrar-inventario) (realizado false))
  ?inventario <- (inventario (dia ?dia) (mes ?mes) (ano ?ano) (u ?unidades) (operacion ?operacion) (material ?material) (partida ?partida) (ct ?total) (cu ?costo_unitario) (referencia ?referencia))
   ?costos-de-mercancias <-  ( cuenta (deducible ?deducible) (origen ?origen2) (partida nil) (nombre costos-de-mercancias ) (grupo ?grupo2) (circulante ?circulante2) (tipo ?tipo2) (padre ?padre2))
 => 
  ( modify ?comando (realizado true))
  ( printout t ?dia " de " ?mes " - " partida  " #" ?partida ": " ?operacion " de " ?unidades " " ?material " a " ?costo_unitario " c/u por un valor total de " ?total crlf)
  ( printout k "<tr>   <td><a href= '/" ?empresa "/libro-diario#Partida-" ?numero "'>" ?numero "</a></td><td>" ?dia " de " ?mes " - " partida  " #" ?partida ": " ?operacion " de " ?unidades " " ?material " a " ?costo_unitario " c/u por un valor total de " ?total "</td> <td>" (if (neq nil ?referencia) then "<a href= '/" ?empresa "/#Partida-" ?referencia "'> </a>" else "" ) "</td> </tr>" crlf)
)

