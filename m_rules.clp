(defmodule MENSUAL
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
  (+ (* 10000 ?ano) (* 100 ( mes_to_numero ?mes)) ?dia)
)



(defrule inicio-de-modulo-mensual
   (declare (salience 10000))
   (empresa (nombre ?empresa ))
   (balance (ano ?ano))
  =>
   (set-strategy breadth)
;   (printout t "--------------------- MENSUAL ------------------" crlf)   
)

(defrule cuentas
  (actual (mes ?mes))
  (cuenta (nombre ?nombre) (mes ?mes) (ano ?ano) (debe ?debe))
  (test (eq iva-credito ?nombre))
 =>
 ;(printout t ?nombre tab ?mes tab ?debe crlf)
)


(defrule pagar-impuestos-mensuales
   ( actual  ( mes ?mes))
   ( ticket  ( numero ?numero) )
   ( empresa ( nombre ?empresa ))
   ?imposiciones <- ( pago-impuestos-mensuales ( mes ?mes ) (ano ?ano) (partida ?numero) (pagado false))
   ( cuenta (nombre ?nombre) (mes ?mes ) (ano ?ano) (debe ?debe) )
   ( test (eq ?nombre iva-credito ))
  =>
   ( bind ?dia 31)
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por ajuste del Credito Fiscal Contra el Debito Fiscal, mes de " ?mes))
(actividad pagar-imposiciones)))
   ( assert (abono (cuenta iva-credito) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?debe) (glosa (str-cat por-pago-de-iva ?debe))))    
   ( assert (cargo (cuenta iva-debito) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?debe) (glosa (str-cat por-pago-de-iva ?debe))))
   ( printout t "-->im Pago Impuestos Mensuales " ?mes tab ?debe crlf)

)


