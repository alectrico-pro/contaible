(defmodule TICKET
 (import MAIN deftemplate ?ALL) 
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



( defrule enumerar-partidas

  ( declare (salience 9000))
  ( selecciones (renumerar true))
  ( inicio-de-los-dias (partidas $?partidas))

  =>

  ( bind ?a ?*actividades*)
;  ( do-for-all-facts ((?f pedido rendicion-de-vouchers-sii)) TRUE (printout t ?f:partida crlf))
  ;para generar la lista de deftemplate usar ?*äctividades 
;  (  do-for-all-facts ((?f ?*actividades*)) TRUE (printout t ?f:partida crlf ))
; y luego copiar desde el mensaje de error que arroje el sistema.

  ( printout t "----------------- TICKET ------------------" crlf)
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
   ( printout t partida-antes tab ?partida-antigua tab " | " tab partida-ahora tab ?count crlf )))
   
   ( assert (modificar-actividades))
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
  ( printout t "Modificando el hecho " ?hecho " remplazando partida " ?antigua " con partida: " ?nueva crlf)
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
  ( printout t "Modificando revisión " tab  ?antigua " se ha cambiado a " ?nueva crlf)
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
  ( printout t "Creando revisión sin referencia " tab  ?antigua " se ha cambiado a " ?nueva crlf)
)


(defrule crear-revisiones-con-referencia
  ( modificar-revisiones)
  ?m        <- ( modificar-revision (partida-nueva ?nueva) (partida-antigua ?antigua))
  (not (exists ( ( revision (old ?antigua)))))
  ?partida  <- ( partida (referencia ?antigua))
  =>
  ( modify ?partida  ( referencia ?nueva ))
    ( assert ?revision ( partida ?nueva ) (old ?antigua))
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
  ( printout t "Actividades son:" crlf)
    ( do-for-all-facts
      ( (?ticket ticket) (?actividad f22 partida-inventario-final ajuste-anual-de-resultado-tributario ajuste-anual-de-resultado-financiero ajuste-anual ajustes-mensuales insumos salario registro-de-accionistas cargo abono pedido traspaso pago-de-salarios cobro-de-cuentas-por-cobrar nota-de-credito-de-factura-reclamada anulacion-de-vouchers compra-de-materiales compra-de-acciones constitucion-de-spa distribucion-de-utilidad f29 gasto-investigacion-y-desarrollo pago-de-retenciones-de-honorarios pago-de-iva ajuste-de-iva rendicion-de-vouchers-sii rendicion-de-eboletas-sii nota-de-debito-manual nota-de-debito-sii nota-de-credito-de-subcuenta-existente nota-de-credito nota-de-credito-sii venta-sii venta-anticipada pago despago gasto-sobre-compras depreciacion amortizacion gasto-afecto gasto-ventas devolucion salario honorario deposito costo-ventas compra venta gasto-promocional gasto-proveedor gasto-administrativo) (?revision revision) ) (eq ?actividad:partida ?revision:partida ?ticket:numero)      
      (printout t ?actividad:partida tab revisado tab ?revision:revisado  crlf))
   (printout t "-------------------------------------------------" crlf)
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



