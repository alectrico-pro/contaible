(defmodule TICKET
 (import MAIN deftemplate ?ALL) 
)


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
  (if (eq nil ?dia) then (bind ?dia 31))
  (if (eq nil ?mes) then (bind ?mes diciembre))
  (+ (* 10000 ?ano) (* 100 ( mes_to_numero ?mes)) ?dia)
)


(defglobal ?*actividades* = "")

(defrule inicio-de-los-dias-ticket
  (declare (salience 10000))
  (inicio-de-los-dias (partidas $?partidas))
  (selecciones (renumerar false))
=>
  ( printout t "----------------- TICKET ------------------" crlf)
  (progn$ (?i ?partidas)
    ( assert (ticket (numero ?i)))
    ( assert (nonce  (ticket ?i))))
)


( defrule lista-de-actividades
  ( declare (salience 10000))
  ( actividad (nombre ?actividad))
  =>
  ( bind ?*actividades* (sym-cat ?*actividades* " " ?actividad ) )
;:  ( printout t ?*actividades* crlf)
)



( defrule fechando-partidas
  ( declare (salience 9000))
(no) 
  ( selecciones (renumerar true))
  ( inicio-de-los-dias (partidas $?partidas))

  =>

  ( printout t "----------------- TICKET: fechando partidas ------------------" crlf)
  ( progn$ (?i ?partidas)
     (  do-for-all-facts ((?actividad f22 partida-inventario-final ajuste-anual-de-resultado-tributario ajuste-anual-de-resultado-financiero ajuste-anual ajustes-mensuales insumos salario registro-de-accionistas cargo abono pedido traspaso pago-de-salarios cobro-de-cuentas-por-cobrar nota-de-credito-de-factura-reclamada anulacion-de-vouchers compra-de-materiales compra-de-acciones constitucion-de-spa distribucion-de-utilidad f29 gasto-investigacion-y-desarrollo pago-de-retenciones-de-honorarios pago-de-iva ajuste-de-iva rendicion-de-vouchers-sii rendicion-de-eboletas-sii nota-de-debito-manual nota-de-debito-sii nota-de-credito-de-subcuenta-existente nota-de-credito nota-de-credito-sii venta-sii venta-anticipada pago despago gasto-sobre-compras depreciacion amortizacion gasto-afecto gasto-ventas devolucion salario honorario deposito costo-ventas compra venta gasto-promocional gasto-proveedor gasto-administrativo  ))
     ( eq ?actividad:partida ?i )
 
     ; ( printout t partida ?actividad:partida tab ?actividad:dia "/" ?actividad:mes "/" ?actividad:ano tab (to_serial_date ?actividad:dia ?actividad:mes ?actividad:ano) crlf)
     )
  )
  ( assert (ordenar-actividades))
  ( assert (modificar-actividades))
)


(deffunction fecha-sort (?f1 ?f2)

   (bind ?dia1 (fact-slot-value ?f1 dia))
   (bind ?mes1 (fact-slot-value ?f1 mes))
   (bind ?ano1 (fact-slot-value ?f1 ano))

   (bind ?dia2 (fact-slot-value ?f2 dia))
   (bind ?mes2 (fact-slot-value ?f2 mes))
   (bind ?ano2 (fact-slot-value ?f2 ano))
   
   (bind ?fecha1 (to_serial_date ?dia1 ?mes1 ?ano1))
   (bind ?fecha2 (to_serial_date ?dia2 ?mes2 ?ano2))

   (> ?fecha1 ?fecha2)
)

(defrule ordenar-actividades
   ( selecciones (renumerar true))

   =>
   ( assert (modificar-actividades))

   ;el orden interesa para las actividades que carecen de dia y mes especificaos en la entrada (Están a nil aquí)
   (bind ?actividades (find-all-facts ((?f partida-inventario-final ajuste-anual-de-resultado-tributario ajuste-anual-de-resultado-financiero ajuste-anual ajustes-mensuales insumos salario registro-de-accionistas cargo abono pedido traspaso pago-de-salarios cobro-de-cuentas-por-cobrar nota-de-credito-de-factura-reclamada anulacion-de-vouchers compra-de-materiales compra-de-acciones constitucion-de-spa distribucion-de-utilidad gasto-investigacion-y-desarrollo pago-de-retenciones-de-honorarios pago-de-iva ajuste-de-iva rendicion-de-vouchers-sii rendicion-de-eboletas-sii nota-de-debito-manual nota-de-debito-sii nota-de-credito-de-subcuenta-existente nota-de-credito nota-de-credito-sii venta-sii venta-anticipada pago despago gasto-sobre-compras depreciacion amortizacion gasto-afecto gasto-ventas devolucion salario honorario deposito costo-ventas compra venta gasto-promocional gasto-proveedor gasto-administrativo f29 f22 )) TRUE))
  (bind ?actividades (sort fecha-sort ?actividades))

  ( bind ?count 0)
  ( bind ?i-anterior 0)

  ( progn$ (?actividad ?actividades)
     ;obteniendo los slots
     ( bind ?partida-antigua (fact-slot-value ?actividad partida))
     ( bind ?dia (fact-slot-value ?actividad dia))
     ( bind ?mes (fact-slot-value ?actividad mes))
     ( bind ?ano (fact-slot-value ?actividad ano))

     ;considerar que algunos kernels se definen a través de varias actividades
     ;ejemplo partida, abono, cargo
     ( if (neq ?partida-antigua ?i-anterior) then
        ( bind ?count (+ 1 ?count)))

     ;count es el valor que se incrementa con cada kernel
     ;si la secuenci coincde con el número de partida existente
     ;no será necesario modificar la actividad.
     ( if (neq ?count ?partida-antigua) then
        ( assert (modificar-actividad (hecho ?actividad) ( partida-nueva ?count) (partida-antigua ?partida-antigua)))
       ; ( printout t ?partida-antigua " tiene fecha: " ?dia "/"  ?mes "/" ?ano  "." crlf)
       ; ( printout t ?partida-antigua " -> " ?count crlf) 
     )
   
     ( assert (ticket (numero ?count)))
     ( assert (nonce  (ticket ?count)))
     ( bind ?i-anterior ?partida-antigua)
   )
)


( defrule ordenar-actividades-antiguo
  ( declare (salience 9000))
(no)
  ( ordenar-actividades )
  ( selecciones (renumerar true))
  ( inicio-de-los-dias (partidas $?partidas))

  =>

  ( bind ?a ?*actividades*)
;  ( do-for-all-facts ((?f pedido rendicion-de-vouchers-sii)) TRUE (printout t ?f:partida crlf))
  ;para generar la lista de deftemplate usar ?*äctividades 
;  (  do-for-all-facts ((?f ?*actividades*)) TRUE (printout t ?f:partida crlf ))
; y luego copiar desde el mensaje de error que arroje el sistema.

  ( printout t "----------------- TICKET:ordenando actividades ------------------" crlf)
  ( bind ?count 0)
  ( bind ?i-anterior 0)
  ( progn$ (?i ?partidas)
     (  do-for-all-facts ((?actividad f22 partida-inventario-final ajuste-anual-de-resultado-tributario ajuste-anual-de-resultado-financiero ajuste-anual ajustes-mensuales insumos salario registro-de-accionistas cargo abono pedido traspaso pago-de-salarios cobro-de-cuentas-por-cobrar nota-de-credito-de-factura-reclamada anulacion-de-vouchers compra-de-materiales compra-de-acciones constitucion-de-spa distribucion-de-utilidad f29 gasto-investigacion-y-desarrollo pago-de-retenciones-de-honorarios pago-de-iva ajuste-de-iva rendicion-de-vouchers-sii rendicion-de-eboletas-sii nota-de-debito-manual nota-de-debito-sii nota-de-credito-de-subcuenta-existente nota-de-credito nota-de-credito-sii venta-sii venta-anticipada pago despago gasto-sobre-compras depreciacion amortizacion gasto-afecto gasto-ventas devolucion salario honorario deposito costo-ventas compra venta gasto-promocional gasto-proveedor gasto-administrativo))

	   ( eq ?actividad:partida ?i )
	   ;contar solo los cambios en ?i, porque algunas actividades como las de cargo y de abono se pueden referir a la misma partida

	   ( if (neq ?i ?i-anterior) then
	     ( bind ?count (+ 1 ?count)) )

	   ( bind ?partida-antigua ?actividad:partida)

	   ;la actividad debe ser modificada con efecto posterior, fuera de do-for-all-facts
	   ( if (neq ?count ?partida-antigua)
	     then
	       ( assert (modificar-actividad (hecho ?actividad)
	       ( partida-nueva ?count) (partida-antigua ?partida-antigua)))
	   )

	   ( assert (ticket (numero ?count)))
	   ( assert (nonce  (ticket ?count)))  
	   ( bind ?i-anterior ?i)
	  ;( printout t partida-antes tab ?partida-antigua tab " | " tab partida-ahora tab ?count crlf ))
     )
     ( assert (modificar-actividades))
  )
)


(defrule modificar-actividades
  ( modificar-actividades)
  ?m <- ( modificar-actividad (hecho ?hecho) (partida-nueva ?nueva) (partida-antigua ?antigua))
;  ( not ( exists (modificar-actividad (partida-antigua ?nueva)))) ;no hay que pisar las partidas existentes
  (test  (neq ?nueva ?antigua))
 =>
  ( modify ?hecho (partida ?nueva))
  ( assert (modificar-revision (partida-nueva ?nueva) (partida-antigua ?antigua) ))
  ( retract ?m )
 ;  ( printout t "Modificando el hecho " ?hecho " remplazando partida " ?antigua " con partida: " ?nueva crlf)
)



(defrule cambiar-a-modificar-revisiones
  ( not (exists ( modificar-actividad)))
  ( not (exists ( modificar-revisiones)))
  =>
  ( assert (modificar-revisiones))
  ( printout t "Cambiando a modificar revisiones ............ " crlf)
)


(defrule modificar-revisiones-sin-referencia
  ( modificar-revisiones)
  ?m        <- ( modificar-revision (partida-nueva ?nueva) (partida-antigua ?antigua))
  ?revision <- ( revision (old ?antigua))
  (not (exists ( partida (referencia ?antigua))))
  =>
  ( modify ?revision ( partida ?nueva ))
  ( assert (ticket (numero ?nueva)))
  ( assert (nonce  (ticket ?nueva)))
  ( retract ?m )
 ; ( printout t "Modificando revisión " tab  ?antigua " se ha cambiado a " ?nueva crlf)
)


(defrule modificar-revisiones-con-referencia
  ( modificar-revisiones)
  ?m        <- ( modificar-revision (partida-nueva ?nueva) (partida-antigua ?antigua))
  ?revision <- ( revision (old ?antigua))
  ?partida  <- ( partida (referencia ?antigua)) 
  =>
  ( modify ?partida  ( referencia ?nueva ))
  ( modify ?revision ( partida ?nueva ))
  ( assert (ticket (numero ?nueva)))
  ( assert (nonce  (ticket ?nueva)))
  ( retract ?m )
  ( printout t "Modificando revisión con referencia " tab  ?antigua " se ha cambiado a " ?nueva crlf)
)


(defrule crear-revision-sin-referencia
  ( modificar-revisiones)
  ?m        <- ( modificar-revision (partida-nueva ?nueva) (partida-antigua ?antigua))
  (not (exists ( revision (old ?antigua))))
  (not (exists ( partida (referencia ?antigua))))
  =>
  ( assert (revision (partida ?nueva) (old ?antigua)))
  ( assert (ticket (numero ?nueva)))
  ( assert (nonce  (ticket ?nueva)))
  ( retract ?m )
;  ( printout t "Creando revisión sin referencia " tab  ?antigua " se ha cambiado a " ?nueva crlf)
)


(defrule crear-revisiones-con-referencia
  ( modificar-revisiones)
  ?m        <- ( modificar-revision (partida-nueva ?nueva) (partida-antigua ?antigua))
  (not (exists ( revision (old ?antigua))))
  ?partida  <- ( partida (referencia ?antigua))
  =>
  ( modify ?partida  ( referencia ?nueva ))
  ( assert ( revision ( partida ?nueva ) (old ?antigua)))
  ( assert (ticket (numero ?nueva)))
  ( assert (nonce  (ticket ?nueva)))
  ( retract ?m )
  ( printout t "Creando revisión con referencia " tab  ?antigua " se ha cambiado a " ?nueva crlf)
)




(defrule revisiones-sin-tickets
  ( modificar-revisiones)
  ?m <- ( modificar-revision (partida-nueva ?nueva) (partida-antigua ?antigua))
  (exists ( revision (partida ?antigua)))
  (not (exists (ticket (numero ?antigua))))
 =>
  ( assert (ticket (numero ?antigua )))
  ( printout t "Ticket no existe " ?antigua " ahora ha sido creado " crlf)
)


(defrule revisiones-sin-nonce
  ( modificar-revisiones)
  ?m <- ( modificar-revision (partida-nueva ?nueva) (partida-antigua ?antigua))
  (exists ( revision (partida ?antigua)))
  (not (exists (nonce (ticket ?antigua))))
 =>
  ( assert (nonce (ticket ?antigua )))
  ( printout t "Nonce no existe " ?antigua " ahora ha sido creado " crlf)
)


(defrule modificar-cargos
(no)
  ( modificar-revisiones)
  ?m <- ( modificar-cargo (partida-nueva ?nueva) (partida-antigua ?antigua))
  ?cargo <-  ( cargo (partida ?antigua))
  (not (exists ( cargo (partida ?nueva))))
 =>
  ( modify ?cargo (partida ?nueva))
  ( retract ?m )
  ( printout t "Modificando cargo de la partida " ?antigua " se ha cambiado a " ?nueva crlf)
)


(defrule modificar-abonos
(no)
  ( modificar-revisiones)
  ?m <- ( modificar-cargo (partida-nueva ?nueva) (partida-antigua ?antigua))
  ?abono <-  ( abono (partida ?antigua))
  ( not (exists ( abono (partida ?nueva))))
 =>
  ( modify ?abono (partida ?nueva))
  ( retract ?m )
  ( printout t "Modificando abono de la partida " ?antigua " se ha cambiado a " ?nueva crlf)
)



(defrule no-existe-la-revision
(no)
  ( modificar-revisiones)
  ?m <- ( modificar-revision (partida-nueva ?nueva) (partida-antigua ?antigua))
  (not (exists ( revision (partida ?nueva))))

 =>
  ( retract ?m )
  ( assert (ticket (numero ?nueva)))
  ( assert (nonce  (ticket ?nueva)))
  ( printout t "Falta la revisión para la partida " ?nueva "... creándola " crlf)
  ( assert (revision (partida ?nueva) (old ?antigua) (revisado true)))
)


(defrule modificar-partidas
(no)
  ( modificar-revisiones)
  ?m <- ( modificar-partida (partida-nueva ?nueva) (partida-antigua ?antigua))
  ?partida <- ( partida (numero ?antigua))
  (not (exists (partida (numero ?nuevo))))
 =>
  ( retract ?m )
  ( modify ?partida (numero ?nueva))
  ( printout t "Modificando la partida " ?nueva " por " ?antigua crlf)
)


(defrule revisiones-que-faltan
  ( declare (salience -100))
  ( not (exists ( modificar-actividad)))
  ( exists ( modificar-revisiones))
  ?m <- ( modificar-revision (partida-nueva ?nueva) (partida-antigua ?antigua))
  =>
  ( printout t "Revisión que faltaron  por modificar -> nueva: " tab ?nueva " antigua: " tab ?antigua "----" crlf)
  ( retract ?m)
 ;( halt )
)


(defrule concluyendo-modificaciones-de-revisiones
  ( not (exists ( modificar-actividad)))
  ( exists ( modificar-revisiones))
  ( not (exists (modificar-revision)))
  =>
  ( printout t "Terminando de  modificar revisiones ............ " crlf)
 ; ( printout t "Actividades son:" crlf)
    ( do-for-all-facts
      ( (?ticket ticket) (?actividad f22 partida-inventario-final ajuste-anual-de-resultado-tributario ajuste-anual-de-resultado-financiero ajuste-anual ajustes-mensuales insumos salario registro-de-accionistas cargo abono pedido traspaso pago-de-salarios cobro-de-cuentas-por-cobrar nota-de-credito-de-factura-reclamada anulacion-de-vouchers compra-de-materiales compra-de-acciones constitucion-de-spa distribucion-de-utilidad f29 gasto-investigacion-y-desarrollo pago-de-retenciones-de-honorarios pago-de-iva ajuste-de-iva rendicion-de-vouchers-sii rendicion-de-eboletas-sii nota-de-debito-manual nota-de-debito-sii nota-de-credito-de-subcuenta-existente nota-de-credito nota-de-credito-sii venta-sii venta-anticipada pago despago gasto-sobre-compras depreciacion amortizacion gasto-afecto gasto-ventas devolucion salario honorario deposito costo-ventas compra venta gasto-promocional gasto-proveedor gasto-administrativo) (?revision revision) ) (eq ?actividad:partida ?revision:partida ?ticket:numero)      
    ; (printout t ?actividad:partida tab revisado tab ?revision:revisado  crlf))
 ;  (printout t "-------------------------------------------------" crlf)
)
)
; (eq ?actividad:partida ?revision:partida )



(defrule revisando-revisiones
(no)
  ( not (exists ( modificar-actividad)))
  ( exists ( modificar-revisiones))
  ( not (exists (modificar-revision)))
  =>
  ( printout t "Revisiones son: " crlf)
    ( do-for-all-facts ((?revision revision)) true
      (printout t ?revision:partida tab ?revision:revisado  crlf))
  ( printout t "---------------------" crlf)
)


;Esto es otra funcionalidad, permite programar qué partidas incluir para un book

(defrule revision-general

  (revision-general
    (partidas $?partidas))
 =>
  (printout t "Revision general hallada en el archivo <empresa>-revisiones.txt" crlf)
  (progn$  (?i ?partidas)
    (do-for-all-facts
        ((?f revision))     (eq ?i ?f:partida)
        (modify ?f ( no-incluir true  ))
        (printout t "Revisión " ?f:partida " ahora no se incluirá." crlf)) )
)



