;https://www.rbasesoria-madrid.com/que-ocurre-si-el-patrimonio-neto-se-reduce-por-debajo-del-capital-social
;El problema surge cuando la sociedad acumula pérdidas y el patrimonio neto disminuye por debajo de la cifra de capital social. En este sentido la LSC en su art. 363.1.e) establece que la sociedad de capital deberá disolverse cuando  “Por pérdidas que dejen reducido el patrimonio neto a una cantidad inferior a la mitad del capital social, a no ser que éste se aumente o se reduzca en la medida suficiente, y siempre que no sea procedente solicitar la declaración de concurso“.

;Bussiness Intelligence 
;Este modulo verifica e informa de errores contables
;
(defmodule BI
 (import MAIN deftemplate ?ALL)
 (export ?ALL)
)


(defrule iterando-abonos
  (no)
 =>
  (printout t "abonos" crlf)
  (do-for-all-facts ((?f abono)) TRUE  
    (printout t ?f:partida crlf)
  ) 
)



(defrule iterando-venta-sii
  (no)
 =>
  (printout t "venta-sii" crlf)
  (do-for-all-facts ((?f venta-sii)) TRUE 
    (printout t ?f:partida crlf)
  )  
)



(defrule inicio-modulo-bi
  ( declare (salience 10000))
  =>
  ( printout t "========================= BI: Business Intelligence ============" crlf)
  ( bind ?reglas ( get-defrule-list ACTIVIDAD))
  ( assert (reglas (lista ?reglas)))
;  ( printout t ?reglas )
;  ( while (> (length$ ?reglas) 0)  do
 ;  ( bind ?regla (nth$ 1 ?reglas))
;  ( printout t ?regla crlf)
;   ( printout t (defrule (sym-cat ACTIVIDAD:: ?regla ) ) crlf)
  ; ( bind ?reglas (rest$ ?reglas))
 ; )
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




(defrule actividades-registradas
 (no)
  (actividad (nombre ?nombre))
  =>
  (printout t actividad tab ?nombre "|" crlf)
)




(defrule hechos-que-no-tienen-regla-registrada
  (no)
   ( hecho (id ?id) (regla ?regla ) (partida ?numero))
   ( reglas (lista $?lista ))
   ( test (not (member$ ?regla $?lista)))
  =>
   ( printout t ?numero "El hecho " ?id " No tiene registrada su regla " ?regla crlf)
)


(defrule hechos-que-tienen-regla-registrada
   ( hecho (id ?id) (regla ?regla ) (partida ?numero))
   ( reglas (lista $?lista ))
   ( test (member$ ?regla $?lista))
  =>
   ( printout t "El hecho " ?id " tiene registrada su regla " ?regla crlf)
  ; ( printout t "Matches de esa regla son " (get-matches ?regla) crlf)
)


(defrule partidas-sin-anotacion-de-hecho
  (partida (numero ?numero) (hecho nil) (actividad ?actividad) (descripcion ?descripcion))
 =>
  (printout t "Partida sin anotación de hecho: " ?numero tab ?actividad tab ?descripcion crlf)
)


(defrule mostrando-hechos
  (no)
   (hecho (id ?id) (gravado true) (partida ?numero) (regla ?regla))
  =>
   (printout t ?id tab partida tab ?numero tab ?regla "|" crlf)
)



(defrule detectando-hecho-gravado-iva
   (balance (ano ?ano))
   (cargo (cuenta iva-credito) (ano ?ano) (realizado true) (partida ?numero))
   (partida (numero ?numero) (actividad ?actividad) (descripcion ?descripcion) )
   (test (neq ?actividad ajuste) )
  =>
;   (printout t "k<-hv Hecho gravado detectado IVA" tab ?numero tab ?actividad crlf)
   (assert (hecho (gravado true) (id iva) (partida ?numero) (regla ?actividad)))
)


;razonando a la inversa
;encuentro en las tablas 
;las hechos
;gravados con iva
(defrule detectando-hecho-gravado-n
   (balance (ano ?ano))
   (abono (cuenta retencion-de-iva-articulo-11) (ano ?ano) (partida ?numero))
   (partida (numero ?numero) (actividad ?actividad) (descripcion ?descripcion))
  =>
;  (printout t "k<-n  Hecho gravado detectado  n "  tab ?numero tab ?actividad crlf)
   (assert (hecho (gravado true) (id n) (partida ?numero) (regla ?actividad)))
)


(defrule warning-doble-hecho
  (hecho (partida ?numero) (id ?id1))
  (hecho (partida ?numero) (id ?id2))
  (test (neq ?id1 ?id2))
 =>
; (printout t "Warning =============================================" crlf)
; (printout t " La partida " ?numero " participa en dos hechos gravados " crlf)
 ;(printout t ?id1 tab ?id2 crlf)
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
   (abono (realizado false) (partida ?numero) (ano ?ano) )
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

