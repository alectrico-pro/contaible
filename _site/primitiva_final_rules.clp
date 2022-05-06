(defmodule PRIMITIVA_FINAL
  ( import MAIN deftemplate ?ALL )
  ( export ?ALL)
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


(defrule inicio-primitiva
  (declare (salience 10000))
=>
  ( printout t "----------------- PRIMITIVA FINAL ------------------" crlf)
)


( defrule in
 (no)
 ( cuenta (nombre inventario) (partida ?partida) (debe ?debe) (haber ?haber))
=>
 (printout t ---- tab ?debe tab "|" ?haber tab partida tab ?partida crlf)
)


(defrule corrigiendo-errores-de-grupo ;esto es un parche
  (declare (salience 10000))
  (cuenta (nombre ?nombre) (partida nil) (grupo ?grupo) (circulante ?circulante))
  ?cuenta <- (cuenta (nombre ?nombre) (grupo false) (partida ?partida))
=>
  (modify ?cuenta (grupo ?grupo) (circulante ?circulante))
;  (printout t ?nombre tab no-tiene-grupo tab partida tab ?partida tab grupo-debe-ser tab ?grupo crlf)
)

;------------------------ primitivas ---------------------------
(defrule cargar-cuenta-existente
   ( declare (salience 9800))
   ( balance (ano ?ano ))
   ( empresa (nombre ?empresa))
   ( partida (dia ?dia) (mes ?mes) (ano ?ano) (numero ?numero))
   ?cargo <- (cargo (qty ?qty) (electronico ?electronico) (tipo-de-documento ?tipo-de-documento) (activo-fijo ?activo-fijo) (partida ?numero) (realizado false) (empresa ?empresa) (ano ?ano) (cuenta ?nombre) (monto ?monto) (glosa ?glosa) )
   ?cuenta <- (cuenta (partida ?numero) (nombre ?nombre) (debe ?debe) (haber ?haber) (origen ?origen) (de-resultado ?de-resultado) (grupo ?grupo))
   ( test (> ?monto 0))
  =>
   ( assert (cuenta (qty ?qty) (electronico ?electronico) (tipo-de-documento ?tipo-de-documento) (activo-fijo ?activo-fijo) (nombre ?nombre) (partida ?numero) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (debe ( round ?monto) ) (origen real) (de-resultado ?de-resultado )) (grupo ?grupo))
   ( modify ?cargo (realizado true))
;   ( printout t "c-->" tab ?monto tab "|" tab 0 tab ?nombre tab ?dia " de " ?mes tab ?glosa tab ?grupo crlf)
)

(defrule cargar-cuenta-nueva
   ( declare (salience 9800))
   ( empresa (nombre ?empresa))
   ( balance (ano ?ano) )
   ( partida (dia ?dia) (mes ?mes) (ano ?ano) (numero ?numero))
   ?cargo <-  (cargo (electronico ?electronico) (tipo-de-documento ?tipo-de-documento) (activo-fijo ?activo-fijo )  (partida ?numero) (qty ?qty) (realizado false) (empresa ?empresa) (ano ?ano) (cuenta ?nombre) (monto ?monto) (glosa ?glosa) )
   ?cuenta <- (cuenta (partida nil) (dia nil) (mes nil) (ano nil) (nombre ?nombre ) (tipo ?tipo) (grupo ?grupo) (padre ?padre) (circulante ?circulante) (naturaleza ?naturaleza) (descripcion ?descripcion) (origen ?origen) (de-resultado ?de-resultado) )
   (test (neq nil ?tipo-de-documento))
  =>
   ( assert (cuenta (qty ?qty) (electronico ?electronico) (tipo-de-documento ?tipo-de-documento) (activo-fijo ?activo-fijo) (partida ?numero) (descripcion ?descripcion) (dia ?dia) (mes ?mes) (ano ?ano) (nombre ?nombre) (grupo activo) (empresa ?empresa) (padre ?padre) (circulante ?circulante) (naturaleza ?naturaleza) (tipo ?tipo) (origen real) (de-resultado ?de-resultado)))
;  ( printout t "n-->" tab ?nombre tab ?dia " de " ?mes tab ?glosa tab ?grupo crlf)
)

(defrule abonar-cuenta-existente
   ( declare (salience 9800))
   ( empresa (nombre ?empresa))
   ( balance (ano ?ano))
   ( partida (dia ?dia) (mes ?mes) (ano ?ano) (numero ?numero))

   ?abono  <- (abono (qty ?qty) (electronico ?electronico) (tipo-de-documento ?tipo-de-documento) (activo-fijo ?activo-fijo) (partida ?numero) (realizado false) (empresa ?empresa) (cuenta ?nombre) (monto ?monto) (glosa ?glosa) (ano ?ano))
   ?cuenta <- (cuenta (partida ?numero) (nombre ?nombre) (debe ?debe) (haber ?haber) (tipo ?tipo) (circulante ?circulante) (origen ?origen) (de-resultado ?de-resultado) (grupo ?grupo))
   (test (> ?monto 0))
  =>
   ( assert (cuenta (qty ?qty) (electronico ?electronico) (tipo-de-documento ?tipo-de-documento) (activo-fijo ?activo-fijo) (nombre ?nombre) (partida ?numero) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (haber ( round ?monto )) (origen real) (de-resultado ?de-resultado) ))
   ( modify ?abono (realizado true))
 ; ( printout t "a<--" tab 0 tab "|" tab ?monto  tab ?nombre tab ?dia " de " ?mes tab ?glosa tab ?grupo crlf)
)

(defrule abonar-cuenta-nueva
   ( declare (salience 9800))
   ( balance (dia ?top) (ano ?ano))
   ( empresa (nombre ?empresa))
   ( partida (dia ?dia) (mes ?mes) (ano ?ano) (numero ?numero))
   ?abono <-  (abono (qty ?qty) (electronico ?electronico) (tipo-de-cuenta ?tipo-de-cuenta) (activo-fijo ?activo-fijo) (partida ?numero) (realizado false) (empresa ?empresa) (ano ?ano) (cuenta ?nombre) (monto ?monto) (glosa ?glosa))
   ?cuenta <- (cuenta (nombre ?nombre) (mes nil) (partida nil) (dia nil) (circulante ?circulante) (naturaleza ?naturaleza) (padre ?padre) (tipo ?tipo) (grupo ?grupo) (descripcion ?descripcion) (origen ?origen) (de-resultado ?de-resultado))
  =>
   ( assert (cuenta (qty ?qty) (electronico ?electronico) (tipo-de-cuenta ?tipo-de-cuenta) (activo-fijo ?activo-fijo) (partida ?numero) (empresa ?empresa) (nombre ?nombre) (grupo activo) (tipo ?tipo) (padre ?padre) (circulante ?circulante) (naturaleza ?naturaleza) (descripcion ?descripcion) (origen real) (mes ?mes) (dia ?dia) (ano ?ano) (de-resultado ?de-resultado )))
  ;( printout t "abono partida " ?numero " cuenta " ?nombre tab ?mes crlf)
;  ( printout t "n<--"  tab ?nombre tab ?dia " de " ?mes tab ?glosa tab ?grupo crlf)
  
)

