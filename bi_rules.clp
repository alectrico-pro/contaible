;Bussiness Intelligence 
;Este modulo verifica e informa de errores contables
;
(defmodule BI
 (import MAIN deftemplate ?ALL)
 (export ?ALL)
)

(defrule inicio-modulo-bi
  =>
  (printout t "========================= BI: Business Intelligence ============" crlf)
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

(defrule detectando-hecho-gravado-iva
   (balance (ano ?ano))
   (cargo (cuenta iva-credito) (ano ?ano) (realizado true) (partida ?numero))
   (partida (numero ?numero) (actividad ?actividad) (descripcion ?descripcion) )
  =>
   (printout t "k<-hv Hecho gravado detectado IVA" tab ?numero crlf)
   (printout t ?actividad crlf ?descripcion crlf crlf)
)


;razonando a la inversa
;encuentro en las tablas 
;las hechos
;gravados con iva
(defrule detectando-hecho-gravado-n
   (balance (ano ?ano))
   (cargo (cuenta retencion-de-iva-articulo-11) (ano ?ano) (partida ?partida))
  =>
   (printout t "Hecho gravado n detectado"  tab ?partida  crlf(
)

;los cargos y abonos no realizados son normales
;para las partidas que están fuera de la fecha 
;requerida para el balance en el facts
;balance
(defrule cargo-no-realizado
   (partida (numero ?numero) (actividad ?actividad))
   (abono (realizado false) (partida ?numero) (ano ?ano))
   (balance (ano ?ano))
  =>
   (printout t "x<-c Cargo no realizado: " tab ?numero tab ?actividad crlf)
)


(defrule abono-no-realizado
   (partida (numero ?numero) (actividad ?actividad))
   (abono (realizado false) (?numero) (ano ?ano) )
   (balance (ano ?ano))
  =>
   (printout t "x->a Abono no realizado: " tab ?numero tab ?actividad crlf)
)


(defrule cargo-realizado
  (no)
   (abono (realizado true) (partida ?numero))
   (partida (numero ?numero) (actividad ?actividad) (ano ?ano))
   (balance (ano ?ano))
  =>
   (printout t "k<-c Cargo realizado: " tab ?numero  tab ?actividad crlf)
)


(defrule abono-realizado
  (no)
   (abono (realizado true) (partida ?numero) (ano ?ano))
   (partida (numero ?numero) (actividad ?actividad))
   (balance (ano ?ano))
  =>
   (printout t "k->a Abono realizado: " tab ?numero tab ?actividad crlf)
)


(defrule mala-formacion-de-cuenta
   (cuenta (nombre ?nombre) (ano ?ano) (debe ?debe) (haber ?haber) (partida ?partida))
   (balance (ano ?ano))
   (test (and (or (neq 0 ?debe) (neq 0 ?haber)) (eq nil ?partida)))
   
  =>
  (printout t "X-cta Cuenta Mal Formada: " tab ?nombre tab ?debe tab ?haber tab ?partida crlf  )
)


(defrule detectando-plan-de-cuentas
  (no)
   (balance (ano ?ano))
   (cuenta (ano ?ano) (nombre ?nombre) (padre ?padre))
   (exists (cuenta (ano ?ano) (nombre ?padre) (partida ?numero)))
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
  (balance (ano ?ano))
  ?c <- (cuenta (nombre ?nombre) (ano ?ano) (partida nil))
  (not (exists (cuenta (ano ?ano) (nombre ?nombre) (partida ?partida&:(neq nil ?partida)))))
 =>
  ( retract ?c)
  ( printout t "x<-cta Cuenta Eliminada: " tab ?nombre  crlf)
)

