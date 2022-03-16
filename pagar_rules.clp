;relgas para analiar lo que haya que pagar en impuestos según f29
(defmodule PAGAR
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

(deftemplate iva
  (slot credito)
  (slot debito)
)

(defrule inicio-de-modulo-pagar
   (declare (salience 10000))
   (empresa (nombre ?empresa ))
   (balance (ano ?ano))
  =>
   (set-strategy breadth)
   (printout t "--------------------- PAGAR ------------------" crlf)   
   (assert (iva (credito 0) (debito 0)))
;   (watch facts)
)


(defrule fin-de-modulo-pagar
   (declare (salience -10000))
   (empresa (nombre ?empresa ))
   (balance (ano ?ano))
  =>
   (printout t "--------------------- fin de PAGAR ------------------" crlf)
 ;  (assert
 ;   ( ajuste-de-remanente-de-iva-nuevo
  ;    ( partida 002)
   ;   ( mes-de-declaracion diciembre)
   ;   ( mes-de-presentacion enero)
   ;   ( ano-de-declaracion 2020)
   ;   ( ano-de-presentacion 2021)
   ; ))
 ;  (unwatch facts)
)


(defrule codigos-f29-base-imponible
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
   ( acumulador-mensual (cuenta ingresos-brutos) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
;   (test (> ?haber ?debe))
  =>
   ( bind ?monto (- ?haber ?debe))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 563) (valor (round ?monto)) (descripcion "BASE IMPONIBLE"  ) (mes ?mes) (ano ?ano) ))
)

(defrule codigos-f29-ppm
  ( declare (salience -1))
   ( balance (ano ?ano))

  ( actual  ( mes ?mes))
  ( tasas (ppm ?tasa-ppm) (mes ?mes) (ano ?ano))
  ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
  ( ticket ( numero ?numero ))
  ( empresa (nombre ?empresa))
;  ?c <- ( cuenta (partida ?partida) (empresa ?empresa) (nombre ingresos-brutos) (mes ?mes ) (ano ?ano) (haber ?haber) (debe ?debe))
  ( acumulador-mensual (cuenta ingresos-brutos) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
 =>
  ( bind ?ppm (* ?tasa-ppm (- ?haber ?debe)))
  ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
  ( assert ( formulario-f29 (partida ?numero) (codigo "062") (valor (round ?ppm)) (descripcion  "PPM NETO DETERMINADO") (mes ?mes) (ano ?ano) ))
  ( assert ( formulario-f29 (partida ?numero) (codigo 115) (valor (* 100 ?tasa-ppm)) (descripcion "TASA PPM 1ra Categoria"   )  (mes ?mes) (ano ?ano) ))

)




(defrule codigos-f29-debito-notas-de-credito-563
   ( declare (salience -1))
   ( balance (ano ?ano))

   (no)
   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
   ( acumulador-mensual (cuenta 563) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   ( test (> ?debe ?haber))
  =>
   ( bind ?monto (- ?debe ?haber))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 563) (valor ?monto ) (descripcion  "BASE IMPONIBLE" ) (mes ?mes) (ano ?ano) ))
)






(defrule pagar-ppm
   ( tasas (mes ?mes) (ano ?ano) (ppm ?tasa-ppm))
   ( balance (ano ?ano))

   ( actual  ( mes ?mes))
   ( ticket  ( numero ?numero) )
   ( empresa ( nombre ?empresa ))
   ?imposiciones <- ( pago-de-ppm ( mes ?mes ) (ano ?ano) (partida ?numero) (pagado false))
   ( acumulador-mensual (cuenta ingresos-brutos) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  =>
   ( bind ?dia 31)
   ( bind ?ppm (* ?tasa-ppm (- ?haber ?debe)))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por pago del ppm, con factor de  " ?tasa-ppm " mes " ?mes))
(actividad pagar-ppm)))
   ( assert (cargo (tipo-de-documento pago-de-ppm) (cuenta ppm) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?ppm) (glosa (str-cat por-pago-de-ppm ?ppm))))
   ( assert (abono (tipo-de-documento pago-de-ppm) (cuenta banco-estado) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?ppm) (glosa (str-cat por-pago-de-ppm ?ppm))))
   ( printout t "-->ppm-pago " tab ?haber tab ?ppm tab ?mes crlf)
)





(defrule codigos-f29-ppm-no
  ( declare (salience -1))
  ( balance (ano ?ano))

   (no)
  ( actual  ( mes ?mes))
  ( tasas (ppm ?tasa-ppm) (mes ?mes) (ano ?ano))
  ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
  ( ticket ( numero ?numero ))
  ( empresa (nombre ?empresa))
  ( acumulador-mensual (cuenta 563) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  ( test (> ?debe ?haber ))
 =>
  ( bind ?ppm (* ?tasa-ppm (- ?debe ?haber)))
  ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
  ( assert ( formulario-f29 (partida ?numero) (codigo 062) (valor (round ?ppm)) (descripcion  "PPM NETO DETERMINADO") (mes ?mes) (ano ?ano) ))
  ( assert ( formulario-f29 (partida ?numero) (codigo 115) (valor (* 100 ?tasa-ppm)) (descripcion "TASA PPM 1ra Categoria"   )  (mes ?mes) (ano ?ano) ))

)

(defrule codigos-f29-ppv
  ( declare (salience -1))
   ( balance (ano ?ano))

  ( actual  ( mes ?mes))
  ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
  ( ticket ( numero ?numero ))
  ( empresa (nombre ?empresa))
 ; ( pago-de-ppv ( mes ?mes ) (ano ?ano) (partida ?numero) (monto ?ppv) (pagado true)) 
 ; ?c <- ( cuenta (empresa ?empresa) (nombre ppv) (mes ?mes ) (ano ?ano) (debe ?ppv))
 ( acumulador-mensual (cuenta ppv) (haber ?haber) (debe ?ppv) (mes ?mes) (ano ?ano))
 => 
  ( printout t "ppv <- Código f29 ppv anotado " tab ?ppv crlf)
  ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
  ( assert ( formulario-f29 (partida ?numero) (codigo 771) (valor (round ?ppv)) (descripcion  "PPM VOLUNTARIO") (mes ?mes) (ano ?ano) ))
)




(defrule pagar-ppm-no
   ( balance (ano ?ano))

   (no)
   ( tasas (mes ?mes) (ano ?ano) (ppm ?tasa-ppm))
   ( actual  ( mes ?mes))
   ( ticket  ( numero ?numero) )
   ( empresa ( nombre ?empresa ))
   ?imposiciones <- ( pago-de-ppm ( mes ?mes ) (ano ?ano) (partida ?numero) (pagado false))
   ( acumulador-mensual (cuenta 563) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   ( test (> ?debe ?haber))
  =>
   ( bind ?dia 31)
   ( bind ?ppm (* ?tasa-ppm (- ?debe ?haber)))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por pago del ppm, con factor de  " ?tasa-ppm " mes " ?mes))
(actividad pagar-ppm)))
   ( assert (cargo (tipo-de-documento pago-de-ppm) (cuenta ppm) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?ppm) (glosa (str-cat por-pago-de-ppm ?ppm))))
   ( assert (abono (tipo-de-documento pago-de-ppm) (cuenta banco-estado) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?ppm) (glosa (str-cat por-pago-de-ppm ?ppm))))
   ( printout t "-->ppm-pago " tab ?haber tab ?ppm tab ?mes crlf)
)


(defrule declarar-ppm
   (no)
   ( balance (ano ?ano))

   ( actual  ( mes ?mes))
   ( tasas (ppm ?tasa-ppm) (mes ?mes) (ano ?ano))

   ( ticket  ( numero ?numero) )
   ( empresa ( nombre ?empresa ))
   ?imposiciones <- ( declaracion-de-ppm ( mes ?mes ) (ano ?ano) (partida ?numero) (pagado false))
   ( acumulador-mensual (cuenta ingresos-brutos) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  ; ?c <- ( cuenta (empresa ?empresa) (nombre ingresos-brutos) (mes ?mes ) (ano ?ano) (haber ?haber) (debe ?debe))
  =>
   ( bind ?dia 31)
   ( bind ?ppm (* ?tasa-ppm (- ?haber ?debe)))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Provisionando ppm en " ?mes ". Aunque debiera hacerse en abril del año que sigue.")) ( actividad declarar-ppm)))
   ( assert (abono (tipo-de-documento declaracion-de-ppm) (cuenta ppm) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?ppm) (glosa (str-cat por-declarar-ppm ?ppm))))
   ( assert (cargo (tipo-de-documento declaracion-de-ppm) (cuenta provision-impuesto-a-la-renta) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?ppm) (glosa (str-cat por-declarar-ppm ?ppm))))
   ( printout t "-->ppm-declara " tab ?haber tab ?ppm tab ?mes crlf)
)

(defrule codigos-f29-retencion-tasa-ley-21-133
  ( declare (salience -1))
   ( balance (ano ?ano))

  ( actual  ( mes ?mes))
 ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
  ( ticket ( numero ?numero ))
  ( empresa (nombre ?empresa))
  ( acumulador-mensual (qty ?qty) (cuenta 151) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
;  ?c <- ( cuenta (partida ?partida) (empresa ?empresa) (nombre retenciones-por-pagar) (mes ?mes ) (ano ?ano) (haber ?haber) (debe ?debe))
  
 =>
  ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
  ( assert ( formulario-f29 (partida ?numero) (codigo 151) (valor ?haber) (descripcion  "RETENCION TASA LEY 21.133 SOBRE RENTAS") (mes ?mes) (ano ?ano) ))
)


(defrule codigos-f29-codigo-39
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
  ( acumulador-mensual (qty ?qty) (cuenta 39) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  =>
   ( bind ?monto (- ?debe ?haber))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 39) (valor ?monto) (descripcion "IVA RETENIDO A TERCEROS POR CAMBIO DE SUJETO "  ) (mes ?mes) (ano ?ano) ))
)


(defrule codigos-f29-codigo-511
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
  ( acumulador-mensual (qty ?qty) (cuenta 511) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  =>
   ( bind ?monto (- ?debe ?haber))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 511) (valor ?monto) (descripcion "CRED.IVA POR DCTOS. ELECTRONICOS "  ) (mes ?mes) (ano ?ano) ))
)



(defrule codigos-f29-codigo-512
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
  ( acumulador-mensual (qty ?qty) (cuenta 512) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  =>
   ( bind ?monto (- ?debe ?haber))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 512) (valor ?qty) (descripcion "NOTAS DE DEBITO EMITIDAS DEL GIRO"  ) (mes ?mes) (ano ?ano) ))
)

(defrule codigos-f29-codigo-513
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
  ( acumulador-mensual (qty ?qty) (cuenta 513) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  =>
   ( bind ?monto (- ?haber ?debe))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 513) (valor ?monto) (descripcion "DEBITO DE NOTAS DEBITO EMITIDAS DEL GIRO"  ) (mes ?mes) (ano ?ano) ))
)

(defrule codigos-f29-codigo-515
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
  ( acumulador-mensual (qty ?qty) (cuenta 515) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  =>
   ( bind ?monto (- ?haber ?debe))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 515) (valor ?qty) (descripcion "CANT. FACTURA COMPRA IVA RETENIDO TOTAL"  ) (mes ?mes) (ano ?ano) ))
)


(defrule codigos-f29-codigo-142
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
  ( acumulador-mensual (qty ?qty) (cuenta 586) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  =>
   ( bind ?monto (- ?debe ?haber))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 142) (valor (- 0 ?monto)) (descripcion "Neto Ventas/Servicios Exentos"  ) (mes ?mes) (ano ?ano) ))
)


(defrule codigos-f29-codigo-586
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
  ( acumulador-mensual (qty ?qty) (cuenta 586) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  =>
   ( bind ?monto (- ?debe ?haber))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 586) (valor ?qty) (descripcion "Qty Ventas/Servicios Exentos"  ) (mes ?mes) (ano ?ano) ))
)



(defrule codigos-f29-codigo-587
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
  ( acumulador-mensual (qty ?qty) (cuenta 515) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  =>
   ( bind ?monto (- ?haber ?debe))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 587) (valor ?monto) (descripcion "NETOFACT. COMPRA IVA-RETENIDO TOTAL"  ) (mes ?mes) (ano ?ano) ))
)



(defrule codigos-f29-codigo-758
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
   ( acumulador-mensual (qty ?qty) (cuenta 758) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  =>
   ( bind ?monto (- ?haber ?debe))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 758) (valor ?qty) (descripcion "CANT. RECIBO DE PAGO MEDIOS ELECTRÓNICOS") (mes ?mes) (ano ?ano) ))
   ( assert ( formulario-f29 (partida ?numero) (codigo 759) (valor (round (* 0.19 ?monto))) (descripcion "DÉB. RECIBO DE PAGO MEDIOS ELECTRÓNICOS") (mes ?mes) (ano ?ano) ))

)


(defrule codigos-f29-codigo-759
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
   ( acumulador-mensual (qty ?qty) (cuenta 768) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  =>
   ( bind ?monto (- ?haber ?debe))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 759) (valor (round (* 0.19 ?monto))) (descripcion "DÉB. RECIBO DE PAGO MEDIOS ELECTRÓNICOS") (mes ?mes) (ano ?ano) ))

)





(defrule codigos-f29-debito-notas-de-credito-510
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
   ( acumulador-mensual (cuenta 510) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   (test (< ?haber ?debe))
  =>
   ( bind ?monto (- ?debe ?haber))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 510) (valor ?monto ) (descripcion  "DEBITO N.CREDITO EMITIDAS/Ref FACTURA | NOTA-CREDITO-RECIBIDA-RETENCION-PARCIAL-CAMBIO-SUJETO" ) (mes ?mes) (ano ?ano) ))
)


(defrule codigos-f29-qty-notas-de-credito-509
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
   ( acumulador-mensual (qty ?qty) ( cuenta 509) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  =>
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 509) (valor ?qty) (descripcion  "QtyNOTAS CREDITO EMITIDAS/Ref FACTURA | NOTA-CREDITO-RECIBIDA-RETENCION-PARCIAL-CAMBIO-SUEJETO" ) (mes ?mes) (ano ?ano) ))
)

(defrule codigos-f29-qty-sin-derecho-a-credito-fiscal
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
   ( acumulador-mensual (cuenta intangibles) (qty ?qty) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano) (tipo-de-documento 33))
   (test (> ?debe ?haber))
  =>
   ( bind ?monto (- ?debe ?haber))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 584) (valor ?qty) (descripcion "CANT.INT.EX.NO GRAV.SINDER.CRED.FISCAL *en preparación " ) (mes ?mes) (ano ?ano) ))
)


   
(defrule codigos-f29-montos-sin-derecho-a-credito-fiscal
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
   ( acumulador-mensual (cuenta intangibles) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano) (tipo-de-documento 33))
  ;( cuenta (partida ?partida) (nombre intangibles) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   (test (> ?debe ?haber))
  => 
   ( bind ?monto (- ?debe ?haber))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 562) (valor (round ?monto )) (descripcion "MONTO SINDER A CRED.FISCAL " ) (mes ?mes) (ano ?ano) ))
) 



(defrule codigos-f29-debito-facturas-emitidas
   ( declare (salience -1))
   ( balance (ano ?ano))

 (no) 
   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
   ( acumulador-mensual (cuenta ventas-con-factura-afecta) (tipo-de-documento 33) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  ;( cuenta (partida ?partida) (nombre ventas-con-factura-afecta) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   (test (> ?haber ?debe))
  =>
   ( bind ?monto (- ?haber ?debe))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 502) (valor (round (* ?monto 0.19))) (descripcion  "DEBITOS FACTURAS EMITIDAS "  ) (mes ?mes) (ano ?ano) ))
)



(defrule codigos-f29-codigo-503
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
   ( acumulador-mensual (qty ?qty) (cuenta 503) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  =>
   ( bind ?monto (- ?haber ?debe))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 503) (valor ?qty) (descripcion "CANT. FACTURAS EMITIDAS") (mes ?mes) (ano ?ano) ))
   ( assert ( formulario-f29 (partida ?numero) (codigo 502) (valor (round (* 0.19 ?monto))) (descripcion "DÉB. FACTURAS EMITIDAS") (mes ?mes) (ano ?ano) ))

)



(defrule codigos-f29-qty-facturas-emitidas
   ( declare (salience -1))
   ( balance (ano ?ano))

   (no)
   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
   ( acumulador-mensual (qty ?qty) (cuenta ventas-con-factura-afecta) (tipo-de-documento 33) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano) )
  ;( cuenta (partida ?partida) (nombre ventas-con-factura-afecta) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   (test (> ?haber ?debe))
  =>
   ( bind ?monto (- ?haber ?debe))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 503) (valor ?qty) (descripcion  "CANTIDAD FACTURAS EMITIDAS"  ) (mes ?mes) (ano ?ano) ))
)



(defrule codigos-f29-qty-boletas-emitidas-no
   ( declare (salience -1))
   ( balance (ano ?ano))

   (no)
   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
   ( acumulador-mensual (cuenta ventas-con-eboleta-afecta) (tipo-de-documento 39) (haber ?haber) (qty ?qty) (debe ?debe) (mes ?mes) (ano ?ano) )
;   ( cuenta (partida ?partida) (nombre ventas-con-eboleta-afecta) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   (test (> ?haber ?debe))
  =>
   ( bind ?monto (- ?haber ?debe))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 110) (valor ?qty) (descripcion  "CANT.DE DCTOS.BOLETAS"  ) (mes ?mes) (ano ?ano) ))
)


(defrule codigos-f29-qty-boletas-emitidas
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
   ( acumulador-mensual (cuenta 110) (qty ?qty) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  =>
   ( bind ?monto (- ?haber ?debe))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 110) (valor ?qty ) (descripcion "CANT.DE DCTOS.BOLETAS" ) (mes ?mes) (ano ?ano) ))
)





(defrule codigos-f29-debito-boletas-emitidas
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
   ( acumulador-mensual (cuenta 110) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
;   ( cuenta (partida ?partida) (nombre ventas-con-eboleta-afecta) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  ; (test (> ?haber ?debe))
  =>
   ( bind ?monto (- ?haber ?debe))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 111) (valor (round (* ?monto 0.19))) (descripcion  "DEBITOS BOLETAS EMITIDAS "  ) (mes ?mes) (ano ?ano) ))
) 

(defrule codigos-f29-debito-debito-total
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( no )
   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
   ( acumulador-mensual (cuenta ventas) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
;   ( cuenta (partida ?partida) (nombre ventas) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   (test (> ?haber ?debe))
  =>
   ( bind ?monto (- ?haber ?debe))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 538) (valor (round (* ?monto 0.19))) (descripcion "TOTAL DEBITOS " ) (mes ?mes) (ano ?ano) ))
)


(defrule codigos-f29-debito-debito-538
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
   ( acumulador-mensual (cuenta 538) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   (test (> ?haber ?debe))
  =>
   ( bind ?monto (- ?haber ?debe))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 538) (valor ?monto ) (descripcion "TOTAL DEBITOS " ) (mes ?mes) (ano ?ano) ))
)


(defrule codigos-f29-debito-debito-524
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
   ( acumulador-mensual (qty ?qty) (cuenta 524) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  =>
   ( bind ?monto (- ?haber ?debe))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 524) (valor ?qty ) (descripcion "TOTAL FACTURA ACTIVO FIJO" ) (mes ?mes) (ano ?ano) ))
)

(defrule codigos-f29-debito-debito-525
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
   ( acumulador-mensual (cuenta 525) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  =>
   ( bind ?monto (- ?debe ?haber))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 525) (valor ?monto ) (descripcion "CRÉD. RECUP. Y REINT. FACT. ACTIVO FIJO" ) (mes ?mes) (ano ?ano) ))
)

(defrule codigos-f29-debito-debito-527
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
   ( acumulador-mensual (cuenta 527) (qty ?qty) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  =>
   ( bind ?monto (- ?debe ?haber))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 527) (valor ?qty ) (descripcion "CANT.NOTAS DE CREDITO RECIBIDAS" ) (mes ?mes) (ano ?ano) ))

)


(defrule codigos-f29-debito-debito-528
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
   ( acumulador-mensual (cuenta 528) (qty ?qty) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  =>
   ( bind ?monto (- ?haber ?debe))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 528) (valor ?monto ) (descripcion "CREDITO RECUP.Y REINT/NOTAS DE CRED." ) (mes ?mes) (ano ?ano) ))

)




(defrule codigos-f29-creditos-recibidos-por-codigo-520-antiguo
   ( declare (salience -1))
   ( balance (ano ?ano))

   (no)
   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
   ( acumulador-mensual (cuenta 520) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
;   ( cuenta (partida ?partida) (nombre costos-de-ventas) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
;   (test (> ?debe ?haber))
  =>
   ( bind ?monto (- ?debe ?haber))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 520) (valor (round (* 0.19 ?monto))) (descripcion "CREDITOS REC. REINT/FACT. DEL GIRO " ) (mes ?mes) (ano ?ano) ))
)

(defrule codigos-f29-creditos-recibidos-por-codigo-520
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
   ( acumulador-mensual (cuenta 520) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  =>
   ( bind ?monto (- ?debe ?haber))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 520) (valor ?monto) (descripcion "CREDITOS REC. REINT/FACT. DEL GIRO " ) (mes ?mes) (ano ?ano) ))
)



(defrule codigos-f29-qty-facturas-recibidos-por-codigo-519-antiguo
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( no)
   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
   ( acumulador-mensual (cuenta 520) (qty ?qty) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
;   ( cuenta (partida ?partida) (nombre costos-de-ventas) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
;   (test (> ?debe ?haber))
  =>
   ( bind ?monto (- ?debe ?haber))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 519) (valor ?qty) (descripcion "CANT.DE DCTOS.FACT.RECIB.DEL GIRO") (mes ?mes) (ano ?ano) ))
)

(defrule codigos-f29-qty-facturas-recibidos-por-codigo-519
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
   ( acumulador-mensual (cuenta 519) (qty ?qty) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  =>
   ( bind ?monto (- ?debe ?haber))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 519) (valor ?qty) (descripcion "CANT.DE DCTOS.FACT.RECIB.DEL GIRO") (mes ?mes) (ano ?ano) ))
)


(defrule pagar-iva-debito-v2
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( actual  ( mes ?mes_top))
   ( ticket  ( numero ?numero) )
   ( empresa ( nombre ?empresa ))
   ?imposiciones <- ( pago-de-iva ( mes ?mes ) (ano ?ano) (partida ?numero) (pagado false) (monto ?monto))
   ?c <- ( cuenta (partida ?partida) (empresa ?empresa) (nombre iva-debito) (mes ?mes ) (ano ?ano) (debe ?debe) (haber ?haber))
   ( test (> (mes_to_numero ?mes_top) (mes_to_numero ?mes)))
  =>
   ( bind ?dia 31)
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por pago de impuestos mensuales, mes de " ?mes))(actividad pagar-impuestos-mensuales)))
   ( assert (abono (tipo-de-documento f29) (cuenta banco-estado) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?monto) (glosa (str-cat por-pago-de-impuestos-mensuales ?monto))))
   ( assert (cargo (tipo-de-documento f29) (cuenta iva-debito) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?monto)  (glosa (str-cat por-pago-de-impuestos-mensuales ?monto))))
  ;( printout t "-->piva Pago de IVA " ?numero tab ?mes tab cumulado tab ?monto crlf)
)


(defrule codigos-f29-iva-a-pagar
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( actual  ( mes ?mes_top))
   ( ticket  ( numero ?numero) )
   ( empresa ( nombre ?empresa ))
   ?imposiciones <- ( pago-de-iva (partida ?partida) ( mes ?mes ) (ano ?ano) (pagado false) (monto ?monto))
   ( test (> (mes_to_numero ?mes_top) (mes_to_numero ?mes)))
  ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))

  =>
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
  ( assert ( formulario-f29 (partida ?numero) (codigo 089) (descripcion (str-cat "IMP. DETERM. IVA partida " ?partida) ) (valor (round ?monto)) (mes ?mes) (ano ?ano) ))
)


(defrule codigos-f29-creditos-recibidos-por-codigo-504
   ( declare (salience -1))
   ( balance (ano ?ano))

   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
   ( acumulador-mensual (cuenta 504) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  =>
   ( bind ?monto (- ?debe ?haber))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 504) (valor ?monto) (descripcion "REMANENTE CREDITO MES ANTERIOR" ) (mes ?mes) (ano ?ano) ))
)


(defrule codigos-f29-creditos-recibidos-por-codigo-077
   ( declare (salience -1))
   ( balance (ano ?ano))
   ( empresa (nombre ?empresa))
   ?f <- ( f29 (partida ?numero) (mes ?mes) (ano ?ano))
   ( acumulador-mensual (cuenta 077) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  =>
   ( bind ?monto (- ?debe ?haber))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F29 " ?mes )) (  actividad codigos-f29)))
   ( assert ( formulario-f29 (partida ?numero) (codigo 077) (valor ?monto) (descripcion "REMANENTE DE CREDITO FISC." ) (mes ?mes) (ano ?ano) ))
)


(defrule ordenar-codigos
 =>
  ( bind ?i 1)
  ( while (< ?i 1000) do
    ( assert (codigo-f29 (codigo ?i)))
    ( bind ?i (+ ?i 1))
  )
)


(defrule suma-f22-condicion-inicial
   ( codigo-f29 (codigo ?codigo))
   ( not ( exists  ( formulario-f22 (sumado true) (codigo ?codigo) (ano ?ano) )))
   ( exists ( formulario-f22 (sumado false) (codigo ?codigo ) (ano ?ano )))
   ?f22 <- ( f22 (partida ?numero) (ano ?ano))
  =>
   ( assert ( formulario-f22 (partida ?numero) (sumado true) (codigo ?codigo) (valor 100) (descripcion "Total Anual" ) (ano ?ano) ))
)


(defrule suma-f22
  (no)
   ?mensual <- ( formulario-f22 (sumado false) (codigo ?codigo) (ano ?ano) )
   ?anual   <- ( formulario-f22 (sumado true ) (codigo ?codigo) (descripcion "Total Anual" ) (ano ?ano) )
  =>
   ( modify ( ?mensual ( sumado true)))
   ( modify ( ?anual (valor (+ ?valor ?valor))))
)



(defrule obtencion-de-f22
   ( declare (salience -9000))
   ( balance (ano ?ano))
   ( empresa (nombre ?empresa))
   ( codigo-f29 (codigo ?codigo))
;  ( not  ( exists ( formulario-f29 (mostrado-en-f22 false) (codigo ?inferior&:( and ( numberp ?inferior )  (>= (- ?codigo ?inferior ) 1) )))))
   ?f29 <- ( formulario-f29 (mostrado-en-f22 false) (partida ?partida-f29) (codigo ?codigo) (valor ?valor) (descripcion ?descripcion) (mes ?mes) (ano ?ano) )
   ?f22 <- ( f22 (partida ?numero) (ano ?ano))
  =>
   ( modify ?f29 (mostrado-en-f22 true)  )
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia 31) (mes ?mes) (ano ?ano) (descripcion (str-cat "Formulario F22 " ?ano )) (  actividad codigos-f29)))
   ( assert ( formulario-f22 (partida ?numero) (codigo ?codigo) (valor ?valor) (descripcion ?descripcion ) (ano ?ano) ))
)

