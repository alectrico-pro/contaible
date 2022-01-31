;Bussiness Intelligence 
;Este modulo verifica e informa de errores contables
;
(defmodule BI
 (import MAIN deftemplate ?ALL)
 (export ?ALL)
)

(defrule borrando-hechos-irrelevantes
 (no)
  (or
    ?hecho-irrelevante <- (ccm)
    ?hecho-irrelevante <- (ticket)
    ?hecho-irrelevante <- (nonce)
    ?hecho-irrelevante <- (f29)
    ?hecho-irrelevante <- (ajustes-mensuales)
    ?hecho-irrelevante <- (ajuste-de-iva)
  )
  =>
  (retract ?hecho-irrelevante)
)

;razonando a la inversa
;encuentro en las tablas 
;las hechos
;gravados con iva
(defrule detectando-hecho-gravado-n
   (abono (cuenta retencion-de-iva-articulo-11) (partida ?partida))
  =>
   (printout t "Hecho gravado n detectado"  tab ?partida  crlf(
)


(defrule cargo-no-realizado
  (no)
   (partida (numero ?partida) (actividad ?actividad))
   (abono (realizado false) (partida ?partida))
  =>
   (printout t "x<-c Cargo no realizado: " tab ?partida tab ?actividad crlf)
)


(defrule abono-no-realizado
 (no)
   (partida (numero ?partida) (actividad ?actividad))
   (abono (realizado false) )
  =>
   (printout t "x->a Abono no realizado: " tab ?partida tab ?actividad crlf)
)


(defrule cargo-realizado
   (abono (realizado true) (partida ?numero))
   (partida (numero ?numero) (actividad ?actividad))
  =>
   (printout t "k<-c Cargo realizado: " tab ?numero  tab ?actividad crlf)
)


(defrule abono-realizado
   (abono (realizado true) (partida ?numero) )
   (partida (numero ?numero) (actividad ?actividad))
  =>
   (printout t "k->a Abono realizado: " tab ?numero tab ?actividad crlf)
)


(defrule mala-formacion-de-cuenta
   (cuenta (nombre ?nombre) (debe ?debe) (haber ?haber) (partida ?partida))
   (test (and (or (neq 0 ?debe) (neq 0 ?haber)) (eq nil ?partida)))
  =>
  (printout t "X-cta Cuenta Mal Formada: " tab ?nombre tab ?debe tab ?haber tab ?partida crlf  )
)

(defrule detectando-hecho-gravado-iva
   (abono (cuenta iva-credito) (realizado true) (partida ?partida))
  =>
   (printout t "k<-hv Hecho gravado detectado IVA" tab ?partida crlf)
)


(defrule detectando-plan-de-cuentas
  (no)
   (cuenta (nombre ?nombre) (padre ?padre))
   (exists (cuenta (nombre ?padre) (partida ?numero)))
  =>
   (printout t "k<-cta Cuenta Aceptada: " tab ?nombre " es hija de " tab ?padre " para el sistema " crlf)
)

;Esto es anormal, esta regla está en el foco BI, pero
;está en este archivo que contiene el módulo MAIN
;pero hay que entender que BI es un CONCERN
;debe ubicarse en un tiempo presente o futuro lo que
;necsite para trabajar.
;y además manejer al foco.
;el módulo MAIN es importante porque exporta a todos los otros
(defrule borrando-cuentas-sin-uso
  (no)
  ?c <- (cuenta (nombre ?nombre) (partida nil))
  (not (exists (cuenta (nombre ?nombre) (partida ?partida&:(neq nil ?partida)))))
 =>
  ( retract ?c)
  ( printout t "x<-cta Cuenta Eliminada: " tab ?nombre  crlf)
)

