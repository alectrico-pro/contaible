(defmodule ECUACION
 (import MAIN deftemplate ?ALL)
)

(defrule inicio-de-modulo-ecuacion
   (declare (salience 10000))
   (empresa (nombre ?empresa ))
   (balance (ano ?ano))
  =>
   (set-strategy breadth)
   (printout t "--------------------- ECUACION ------------------" crlf)
)


(defrule alerta-cuentas-con-saldo-negativo
   ?f1 <- (cuenta (nombre ?nombre) (saldo ?saldo ))
   (test (< ?saldo 0))
  =>
   ( retract ?f1)
   ( printout t "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO" crlf)
   ( printout t " ALERTA ---> " ?nombre " tiene saldo negativo, puede ser un ERROR  "  crlf)
   ( printout t "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO" crlf crlf)
)



;este es un algortimo con enfoque global a todas las cuentas de una empresa para un año dado
(defrule sumando-activos-circulantes
   (declare (salience 9))
   (empresa (nombre ?empresa))
   (balance (ano ?ano_top))
   ?f1 <- (cuenta
       (ano ?ano)
       (empresa ?empresa) 
       (grupo activo)
       (nombre ?nombre)
       (saldo ?saldo )
       (circulante true)
       (mayoreado false)
       (balanceado false)
       (padre false)
       (origen real))

   ?f2 <- (ecuacion
        (empresa ?empresa)
        (ano ?ano)
        (activo-circulante ?activo-circulante) )
   (test (> ?saldo 0))
   (test (> ?ano_top ?ano))
  =>
   ( bind   ?total (+ ?activo-circulante ?saldo ))
   ( modify ?f2 (activo-circulante ?total))
   ( modify ?f1 (balanceado true))
   ( printout t "--+acirculante= " ?total tab ?saldo " de " ?nombre crlf)
)


(defrule sumando-activos-fijos-a-ecuacion
   (declare (salience 9))
   (empresa (nombre ?empresa))
   (balance (ano ?ano_top))
   ?f1 <- (cuenta 
           (ano ?ano )
           (empresa ?empresa)
           (grupo activo)
           (nombre ?nombre)
           (saldo ?saldo )
           (origen real )
           (circulante false)
           (balanceado false))
   ?f2 <- (ecuacion
           (empresa ?empresa)
           (ano ?ano)
           (activo-fijo ?activo-fijo) )
   (test (> ?saldo 0))
   (test (> ?ano_top ?ano))
  =>
   ( bind ?total (+ ?activo-fijo ?saldo ))
   ( modify ?f2 (activo-fijo ?total))
   ( modify ?f1 (balanceado true))
   ( printout t "--+a f i j o  = " ?total tab ?saldo " de " ?nombre crlf)
)

(defrule sumando-pasivos-circulantes-a-ecuacion
   (declare (salience 9))
   (empresa (nombre ?empresa))
   (balance (ano ?ano_top))
   ?f1 <- (cuenta
           (ano ?ano)
           (empresa ?empresa)
           (grupo pasivo)
           (nombre ?nombre)
           (saldo ?saldo )
           (circulante true)
           (origen real)
           (balanceado false))
   ?f2 <- (ecuacion
           (empresa ?empresa)
           (ano ?ano)
           (pasivo-circulante ?pasivo-circulante) )
   (test (> ?saldo 0))
   (test (> ?ano_top ?ano))
  =>
   ( bind ?total (+ ?pasivo-circulante ?saldo ))
   ( modify ?f2 (pasivo-circulante ?total))
   ( modify ?f1 (balanceado true))
   ( printout t "--+pcirculante= " ?total tab ?saldo " de " ?nombre crlf)
)

(defrule sumando-pasivos-fijos-a-ecuacion
   (declare (salience 9))
   (empresa (nombre ?empresa))
   (balance (ano ?ano_top))
   ?f1 <- (cuenta 
           (ano ?ano)
           (empresa ?empresa)
           (grupo pasivo)
           (nombre ?nombre)
           (saldo ?saldo )
           (origen real)
           (verificada false)
           (circulante false))

   ?f2 <- (ecuacion
           (empresa ?empresa)
           (ano ?ano)
           (pasivo-fijo ?pasivo-fijo) )
   (test (> ?saldo 0))
   (test (> ?ano_top ?ano))
  =>
   ( bind ?total (+ ?pasivo-fijo ?saldo ))
   ( modify ?f2 (pasivo-fijo ?total))
   ( modify ?f1 (verificada true))
  ( printout t "--+p f i j o  = " ?total tab ?saldo " de " ?nombre crlf)
)


(defrule sumando-activos-a-ecuacion
   (declare (salience 8))
   (empresa (nombre ?empresa))
   (balance (ano ?ano_top))
   ?f1 <- (cuenta
       (ano ?ano)
       (empresa ?empresa)
       (grupo activo)
       (nombre ?nombre)
       (saldo ?saldo )
       (verificada false)
       (origen real))
   ?f2 <- (ecuacion
           (empresa ?empresa) 
           (ano ?ano)
           (activos ?activos))
   (test (> ?saldo 0))
   (test (> ?ano_top ?ano))
  =>
   ( bind ?total (+ ?activos ?saldo ))
   ( modify ?f2 (empresa ?empresa) (activos ?total))
   ( modify ?f1 (verificada true))
  ( printout t "--+a c t i v o= " ?total tab ?saldo " de " ?nombre crlf)
)



(defrule sumando-pasivos-a-ecuacion
   (declare (salience 9))
   (empresa (nombre ?empresa))
   (balance (ano ?ano_top))
   ?f1 <- (cuenta
         (ano ?ano)
         (empresa ?empresa)
         (grupo pasivo)
         (nombre ?nombre)
         (saldo ?saldo )
         (verificada false)
         (origen real) )
   ?f2 <- (ecuacion 
           (empresa ?empresa)
           (ano ?ano)
           (pasivos ?pasivos) )
   (test (> ?saldo 0))
   (test (> ?ano_top ?ano))
  =>
   ( bind ?total (+ ?pasivos ?saldo ))
   ( modify ?f2 (empresa ?empresa) (pasivos ?total) )
   ( modify ?f1 (verificada true))
   ( printout t "--+p a s i v o= " ?total tab ?saldo " de " ?nombre crlf)
)


(defrule sumando-patrimonio-a-ecuacion
   (declare (salience 9))
   (empresa (nombre ?empresa))
   (balance (ano ?ano_top))
   ?f1 <- (cuenta
      (empresa ?empresa)
      (ano ?ano)
      (nombre ?nombre) 
      (grupo patrimonio)
      (saldo ?saldo )
      (verificada false)
      (origen real) )
   ?f2 <- (ecuacion
            (empresa ?empresa)
            (ano ?ano)
            (patrimonio ?patrimonio) )
   (test (> ?saldo 0))
   (test (> ?ano_top ?ano))
  =>
   ( bind ?total (+ ?patrimonio ?saldo ))
   ( modify ?f2 (patrimonio ?total ))
   ( modify ?f1 (verificada true))
   ( printout t "--+patrimonio = " ?total tab ?saldo " de " ?nombre crlf)
)

(defrule sumando-resultados-a-ecuacion
   (declare (salience 9))
   (empresa (nombre ?empresa))
   (balance (ano ?ano_top))
   ?f1 <- (cuenta
        (empresa ?empresa)
        (ano ?ano)
        (nombre ?nombre)
        (grupo resultados)
        (saldo ?saldo )
        (origen real)
        (verificada false))
   ?f2 <- (ecuacion (empresa ?empresa) (ano ?ano) ( resultados ?resultados) )
   (test (> ?saldo 0))
   (test (> ?ano_top ?ano))
  =>
   ( bind ?total (+ ?resultados ?saldo ))
   ( modify ?f2 (resultados ?total ))
   ( modify ?f1 (verificada true))
   ( printout t "--+resultados= " ?total tab ?saldo " de " ?nombre crlf)
)


(defrule activos
  (empresa (nombre ?empresa))
  (balance (ano ?ano_top))

  ?f1 <- (cuenta
         (empresa ?empresa)
         (ano ?ano)
         (tipo ?tipo)
         (grupo activo)
         (nombre ?nombre)
         (debe ?debe)
         (haber ?haber)
         (saldo ?saldo)
         (codigo ?codigo)
         (verificada true)
         (origen real)
         (descripcion ?descripcion))
  (test (> ?ano_top ?ano))
 =>
 ( printout t ?tipo tab activos tab tab (round ?debe) tab "|" tab (round ?haber) tab "->s" tab (round ?saldo) tab tab ?nombre crlf )
)

(defrule pasivos
  (empresa (nombre ?empresa ))
  (balance (ano ?ano_top))

  ?f1 <- (cuenta
        (empresa ?empresa)
        (ano ?ano)
        (tipo ?tipo)
        (grupo pasivo)
        (nombre ?nombre)
        (debe ?debe)
        (haber ?haber)
        (saldo ?saldo)
        (codigo ?codigo)
        (verificada true)
        (origen real)
        (descripcion ?descripcion))
  (test (> ?ano_top ?ano))
 =>
  ( printout t ?tipo -pasivos tab (round ?debe) tab "|" tab  (round ?haber) tab"->s" tab (round ?saldo) tab tab ?nombre tab crlf )
)

(defrule patrimonio
  (empresa (nombre ?empresa ))
  (balance (ano ?ano_top))

  ?f1 <- (cuenta 
         (empresa ?empresa)
         (ano ?ano)
         (tipo ?tipo)
         (grupo patrimonio)
         (nombre ?nombre)
         (debe ?debe)
         (haber ?haber)
         (saldo ?saldo)
         (codigo ?codigo)
         (verificada true)
         (origen real)
         (descripcion ?descripcion))
  ( test (> ?ano_top ?ano))
 =>
  ( printout t ?tipo -patrimonio tab (round ?debe) tab "|" tab ?haber tab "->s" tab ?saldo tab tab ?nombre tab crlf )
)

(defrule liquidadora
  (empresa (nombre ?empresa ))
  (balance (ano ?ano_top))

  ?f1 <- (cuenta
         (empresa ?empresa)
         (ano ?ano)
         (grupo liquidadora)
         (tipo ?tipo)
         (nombre ?nombre)
         (debe ?debe)
         (haber ?haber)
         (saldo ?saldo)
         (codigo ?codigo)
         (origen real)
         (descripcion ?descripcion))
  (test (> ?ano_top ?ano))
 =>
  ( printout t ?tipo -liquidadora tab (round ?debe) tab "|" tab (round ?haber) tab (round ?saldo) tab "->s" tab ?nombre tab crlf )
)


(defrule igualdad-del-inventario
   (declare (salience -100 ))
   (empresa (nombre ?empresa))
   (balance (ano ?ano_top ))

   ?f1 <- (ecuacion
         (empresa ?empresa)
         (ano ?ano)
         (activos ?activos)
         (pasivos ?pasivos)
         (patrimonio ?patrimonio)
         (resultados ?resultados) )
   (test (> ?ano_top ?ano))
  => 
   ( bind ?fuentes (+ ?pasivos ?patrimonio ))
   ;( printout t tab "-------ANALIZANDO PRINCIPIOS CONTABLES --------------" crlf crlf )

   ;( printout t " Activos ?= Pasivos + Patrimonio" crlf)
   ;( printout t ?activos "=" ?pasivos "+" ?patrimonio  crlf crlf)
   ( printout t "(" ?activos "?=" ?fuentes ")" crlf)
   ( if (= ?fuentes ?activos ) then ( 
     printout t ?activos "=" ?pasivos "+" ?patrimonio  crlf tab tab ":) A=P+K" crlf crlf
   ))
   ( if (not (= ?fuentes ?activos )) then (
     printout t ?activos "<>" ?pasivos "+" ?patrimonio  crlf crlf
   ))
   ; printout t tab "------- FIN DEL ANALISIS              --------------" crlf crlf )
)

(defrule ecuaciones
  (declare (salience -101))
  (ecuacion (empresa ?empresa) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
=>
  (printout t "ecuación de la partida " tab ?numero tab ?dia " de " ?mes tab ?ano crlf)
) 


