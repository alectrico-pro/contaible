;Este ajuste solo arregla que se vuelvan a calcular totales considerando todo las cuentas
( defmodule AJUSTEB ( import MAIN deftemplate ?ALL))


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



( defrule inicio-de-modulo-subtotal
   (declare (salience 10000))
  =>
;   ( printout t "----------------------- AJUSTEB----------------------" crlf)
   ( set-strategy depth )
)

( defrule preparacion-totales
   ?totales <- (totales )
  =>
   ( retract ?totales )
)


;(defrule preparacion-cuentas
;   ?cuenta <- ( cuenta (totalizada-como-activo true) )
;  =>
 ; ( modify ?cuenta (totalizado-como-activo false) (mostrado-en-t false) (mostrada-en-partida false) (totalizada-como-activo false) (totalizada-como-activo-circulante false) (totalizada-como-activo-fijo false) (totalizada-como-pasivo false) (totalizada-como-pasivo-circulante false) (totalizada-como-pasivo-fijo false) (totalizada-como-patrimonio false) (reseteada fals))
;)

(defrule preparacion-cuentas-activo
   ?cuenta <- ( cuenta (nombre ?nombre) (totalizada-como-activo true))
  =>
  ( modify ?cuenta (totalizada-como-activo false) )
)

(defrule preparacion-cuentas-activo-circulante
   ?cuenta <- ( cuenta (totalizada-como-activo-circulante true))
  =>
  ( modify ?cuenta (totalizada-como-activo-circulante false) )
)

(defrule preparacion-cuentas-activo-fijo
   ?cuenta <- ( cuenta (totalizada-como-activo-fijo true))
  =>
  ( modify ?cuenta (totalizada-como-activo-fijo false) )
)


(defrule preparacion-cuentas-pasivo
   ?cuenta <- ( cuenta (totalizada-como-pasivo true))
  =>
  ( modify ?cuenta (totalizada-como-pasivo false) )
)

(defrule preparacion-cuentas-pasivo-circulante
   ?cuenta <- ( cuenta (totalizada-como-pasivo-circulante true))
  =>
  ( modify ?cuenta (totalizada-como-pasivo-circulante false) )
)


(defrule preparacion-cuentas-pasivo-fijo
   ?cuenta <- ( cuenta (totalizada-como-pasivo-fijo true))
  =>
  ( modify ?cuenta (totalizada-como-pasivo-fijo false) )
)


(defrule preparacion-cuentas-patrimonio
   ?cuenta <- ( cuenta (totalizada-como-patrimonio true))
  =>
  ( modify ?cuenta (totalizada-como-patrimonio false) )
)




( defrule fin-de-modulo-subtotal
   (declare (salience 10))
  =>
;  ( printout t "----fin------------------- AJUSTEB----------------------" crlf)
)

