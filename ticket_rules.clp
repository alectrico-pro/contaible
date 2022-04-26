(defmodule TICKET
 (import MAIN deftemplate ?ALL) 
)

(defglobal ?*actividades* = "")

(defrule inicio-de-los-dias-ticket
  (declare (salience 10000))
(no)
  (inicio-de-los-dias (partidas $?partidas))
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



( defrule kk
  ( declare (salience 9000))
  ( inicio-de-los-dias (partidas $?partidas))
  =>
  ( bind ?a ?*actividades*)
;  ( do-for-all-facts ((?f pedido rendicion-de-vouchers-sii)) TRUE (printout t ?f:partida crlf))
  ;para generar la lista de deftemplate usar ?*äctividades 
;  (  do-for-all-facts ((?f ?*actividades*)) TRUE (printout t ?f:partida crlf ))
; y luego copiar desde el mensaje de error que arroje el sistema.

  ( printout t "----------------- TICKET ------------------" crlf)
  ( bind ?count 0)
  ( progn$ (?i ?partidas)
     (  do-for-all-facts ((?f registro-de-accionistas abono cargo pedido traspaso pago-de-salarios cobro-de-cuentas-por-cobrar nota-de-credito-de-factura-reclamada anulacion-de-vouchers compra-de-materiales compra-de-acciones constitucion-de-spa distribucion-de-utilidad f29 gasto-investigacion-y-desarrollo pago-de-retenciones-de-honorarios pago-de-iva ajuste-de-iva-contra-debito ajuste-de-iva-contra-credito rendicion-de-vouchers-sii rendicion-de-eboletas-sii nota-de-debito-manual nota-de-debito-sii nota-de-credito-de-subcuenta-existente nota-de-credito nota-de-credito-sii venta-sii venta-anticipada pago despago gasto-sobre-compras depreciacion amortizacion gasto-afecto gasto-ventas devolucion salario honorario deposito costo-ventas compra venta gasto-promocional gasto-proveedor gasto-administrativo))

   (eq ?f:partida ?i )

   ( printout t ?f:partida crlf )))

)


(defrule inicio-de-los-dias-ticket-y-renumeracion
  (declare (salience 10000))
(no)
  (inicio-de-los-dias (partidas $?partidas))
=>
  ( printout t "----------------- TICKET ------------------" crlf)
  ( bind ?count 0)
  (progn$ (?i ?partidas)
    ;para todos los facts que refieran esta partida, 
    ;cambiar la referencia a un orden secuencial
    (bind ?count (+ 1 ?count))
    ( do-for-all-facts (?f abono) (eq ?i ?f:numero)
       (modify ?f ( numero ?count))
       ( printout t "REN " ?count crlf)
       ( assert (ticket (numero ?count)))
       ( assert (nonce  (ticket ?count))))
)



(defrule revision-general
  (revision-general
    (partidas $?partidas))
 =>
  (printout t "Revision general hallada en el archivo <empresa>-revisiones.txt" crlf)
  (progn$  (?i ?partidas)
    (do-for-all-facts
        ((?f revision))     (eq ?i ?f:partida)
        (modify ?f ( rechazado true  ))
        (printout t "Revisión " ?f:partida " ahora indica rechazo." crlf)) )
)



