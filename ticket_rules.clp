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
     (  do-for-all-facts ((?f f22 partida-inventario-final ajuste-anual-de-resultado-tributario ajuste-anual-de-resultado-financiero ajuste-anual ajustes-mensuales insumos salario registro-de-accionistas cargo abono pedido traspaso pago-de-salarios cobro-de-cuentas-por-cobrar nota-de-credito-de-factura-reclamada anulacion-de-vouchers compra-de-materiales compra-de-acciones constitucion-de-spa distribucion-de-utilidad f29 gasto-investigacion-y-desarrollo pago-de-retenciones-de-honorarios pago-de-iva ajuste-de-iva-contra-debito ajuste-de-iva-contra-credito rendicion-de-vouchers-sii rendicion-de-eboletas-sii nota-de-debito-manual nota-de-debito-sii nota-de-credito-de-subcuenta-existente nota-de-credito nota-de-credito-sii venta-sii venta-anticipada pago despago gasto-sobre-compras depreciacion amortizacion gasto-afecto gasto-ventas devolucion salario honorario deposito costo-ventas compra venta gasto-promocional gasto-proveedor gasto-administrativo))

   ( eq ?f:partida ?i )
   ;contar solo los cambios en ?i, porque algunas actividades como las de cargo y de abono se pueden referir a la misma partida
   ( if (neq ?i ?i-anterior) then
     ( bind ?count (+ 1 ?count)) )

   ( bind ?partida-antigua ?f:partida)

   ( assert (modificar (hecho ?f) (partida-nueva ?count) (partida-antigua ?partida-antigua)))

   ( assert (ticket (numero ?count)))
   ( assert (nonce  (ticket ?count)))

   ( bind ?i-anterior ?i)
   ( printout t partida-antes tab ?partida-antigua tab " | " tab partida-ahora tab ?count crlf )))
   
   ( assert (modificar-actividades))
)


(defrule modificar-actividades
  ( modificar-actividades)
  ( modificar (hecho ?hecho) (partida-nueva ?nueva) (partida-antigua ?antigua))
 =>
  ( modify ?hecho (partida ?nueva))
  ( assert (modificar (hecho ?hecho) (partida-nueva ?nueva) (partida-antigua ?antigua)))
)




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



