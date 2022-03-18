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
;   (balance (ano ?ano))
  =>
   (set-strategy breadth)
   (printout t "--------------------- MENSUAL ------------------" crlf)   

)


;esto genera un markdown para que jekyll lo publique en el blog necios
(defrule inicio-kindle-k-mensual-rules
   ( declare (salience 10000))
  (no)
   ( empresa (nombre ?empresa))
   ( balance (mes ?mes))
   ( selecciones (inspect-f29-code ?codigo))
  =>

   ( bind ?archivo (str-cat "./doc/" ?empresa "/codigos-f29-" ?mes ".markdown"))

   ( open ?archivo k "w")

   ( printout k "--- " crlf)
;   ( printout k "title: " ?empresa "-codigos-f29-" ?mes crlf)
;   ( printout k "permalink: /" ?empresa "/codigos-f29-" ?mes  crlf)
   ( printout k "layout: page" crlf)
   ( printout k "--- " crlf)
   ( printout k "" crlf)
   
 ;  ( printout k "Contabilidad para Necios® usa el siguiente código de colores para este documento." crlf)
;   ( printout k "<ul>" crlf)
 ;  ( printout k "<li><span style='background-color: red'>[    ]</span> mensaje de alerta. </li>" crlf)
 ;  ( printout k "<li><span style='background-color: lavender'>[    ]</span> partida revisada y resultado bueno. </li>" crlf)
 ;  ( printout k "<li><span style='background-color: lightyellow'>[    ]</span> cuenta mayor del activo </li>" crlf)
 ;  ( printout k "<li><span style='background-color: azure'>[    ]</span> cuenta mayor del pasivo </li>" crlf)
 ;  ( printout k "<li><span style='color: white; background-color: cornflowerblue'>[    ]</span> cuenta de patrimonio </li>" crlf)
;   ( printout k "<li><span style='background-color: gold'>[    ]</span> ganancia </li>" crlf)
;   ( printout k "<li><span style='color: white; background-color: black'>[    ]</span> pérdida </li>" crlf)
;   ( printout k "<li><span style='background-color: blanchedalmond'>[    ]</span> subtotales de la transacción </li>" crlf)
;   ( printout k "</ul>" crlf)
   ( printout k "<table>" crlf)
   ( printout k "<thead> <th style='background-color: lavender' colspan='10'> CODIGO " ?codigo tab  ?mes " </th></thead>"crlf)
   ( printout k "<tr><th> partida </th> <th> doc </th> <th> mes </th> <th>  cuenta  </th> <th> saldo  </th> <th>   qty </th> <th> debe </th><th> " suma " </th>  <th> haber </th> <th> " suma " </th>  </tr>" crlf)
   ( printout k "<tbody>" crlf)

)


(defrule fin
  ( declare (salience -100) )
 =>
  ( printout k "</tbody>" crlf)
  ( printout k "</table>" crlf)

  ( close k )
)


(defrule fin-de-modulo-mensual
   (declare (salience -10000))
   (empresa (nombre ?empresa ))
;   (balance (ano ?ano))
  =>
   (set-strategy breadth)
   (printout t "-------Resumen----------- MENSUAL ------------------" crlf)
   (assert (resumen ))
)

(defrule resumen
  ( resumen )
  ?acc  <- ( acumulador-mensual (cuenta ?cuenta) (qty ?qty) (debe ?debe) (haber ?haber ) (mes ?mes) (ano ?ano))
 =>
  ( printout t ?qty tab ?debe tab ?haber tab ?ano tab ?mes tab ?cuenta crlf)
)


(defrule banco-estado
  (actual (mes ?mes))
  (cuenta (partida ?partida) (nombre ?nombre) (mes ?mes) (ano ?ano) (debe ?debe))
  (test (eq banco-estado ?nombre))
 =>
 ; (printout t ?partida tab ?mes tab ?debe ------------------------ tab ?nombre crlf)
)

(defrule ventas
  (actual (mes ?mes))
  (cuenta (partida ?partida) (nombre ?nombre) (mes ?mes) (ano ?ano) (haber ?haber))
  (test (eq ventas ?nombre))
 =>
;  (printout t ?partida tab ?mes tab ?haber ------------------------ tab ?nombre crlf)
)

(defrule creando-acumulador
 (declare (salience 9000))
   ( cuenta (partida ?partida) (nombre ?cuenta) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   ( not (exists ( acumulador-mensual (cuenta ?cuenta) (mes ?mes) (ano ?ano))))
   ( test (not (or (eq ?cuenta letras-por-pagar)
              (eq ?cuenta costos-de-ventas)
              (eq ?cuenta compras)
              (eq ?cuenta gastos-en-investigacion-y-desarrollo)
          )
   ))
  ( test (or (> ?haber 0) (> ?debe 0)))

 => 
  ( assert ( acumulador-mensual (cuenta ?cuenta) (debe 0) (haber 0) (mes ?mes) (ano ?ano)))
  ( printout t "Cuenta acumulador mensual " tab ?cuenta tab ?mes crlf)
)

(defrule creando-acumulador-39
   ( declare (salience 9000))
   ( cuenta (nombre retencion-de-iva-articulo-11) (partida ?partida) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   ( not (exists ( acumulador-mensual (cuenta 39) (mes ?mes) (ano ?ano))))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  ( assert ( acumulador-mensual (cuenta 39) (mes ?mes) (ano ?ano) (debe 0) (haber 0)))
  ( printout t "Cuenta acumulador mensual 39 " tab ?mes crlf)

)



(defrule creando-acumulador-151
   ( declare (salience 9000))
   ( cuenta (tipo-de-documento 33) (nombre retenciones-por-pagar) (partida ?partida) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   ( not (exists ( acumulador-mensual (cuenta 151) (mes ?mes) (ano ?ano))))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  ( assert ( acumulador-mensual (cuenta 151) (mes ?mes) (ano ?ano) (debe 0) (haber 0)))
  ( printout t "Cuenta acumulador mensual 151 " tab ?mes crlf)

)

(defrule creando-acumulador-110-afecta
   ( declare (salience 9000))
   ( cuenta (tipo-de-documento 39) (nombre ventas-con-eboleta-afecta) (partida ?partida) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   ( not (exists ( acumulador-mensual (cuenta 110) (mes ?mes) (ano ?ano))))
   ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  ( assert ( acumulador-mensual (cuenta 110) (mes ?mes) (ano ?ano) (debe 0) (haber 0)))
  ( assert ( acumulador-mensual (cuenta 111) (mes ?mes) (ano ?ano) (debe 0) (haber 0)))

  ( printout t "Cuenta acumulador mensual 110 afecta " tab ?mes crlf)
)

(defrule creando-acumulador-110-exenta
   ( declare (salience 9000))
   ( cuenta (tipo-de-documento 39) (nombre ventas-con-eboleta-exenta) (partida ?partida) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   ( not (exists ( acumulador-mensual (cuenta 110) (mes ?mes) (ano ?ano))))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  ( assert ( acumulador-mensual (cuenta 110) (mes ?mes) (ano ?ano) (debe 0) (haber 0)))
  ( assert ( acumulador-mensual (cuenta 111) (mes ?mes) (ano ?ano) (debe 0) (haber 0)))

  ( printout t "Cuenta acumulador mensual 110 exenta  "tab ?mes crlf)

)

(defrule creando-acumulador-503-factura-afecta
   ( declare (salience 9000))
   ( cuenta (tipo-de-documento 33) (nombre ventas-con-factura-afecta) (partida ?partida) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   ( not (exists ( acumulador-mensual (cuenta 503) (mes ?mes) (ano ?ano))))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  ( assert ( acumulador-mensual (cuenta 503) (mes ?mes) (ano ?ano) (debe 0) (haber 0)))
  ( printout t "Cuenta acumulador mensual 503 factura afecta "tab ?mes crlf)

)





(defrule creando-acumulador-509
   ( declare (salience 9000))
   ( cuenta (tipo-de-documento 61) (nombre iva-debito) (partida ?partida) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   ( not (exists ( acumulador-mensual (cuenta 509) (mes ?mes) (ano ?ano))))
  ( test (or (> ?haber 0) (> ?debe 0)))

   ( nota-de-credito-sii (folio-nota ?folio-nota) (folio ?folio) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (archivo ?archivo))

   ?f1 <- ( venta-sii
     (rut ?rut)
     (partida ?numero_2)
     (folio ?folio)
     (unidades ?unidades)
     (costo_unitario ?costo_unitario)
     (dia ?dia_1) (mes ?mes_2) (ano ?ano)
     (credito ?credito)
     (colaborador ?colaborador)
     (material ?material)
     (total ?total)
     (neto ?neto)
     (iva ?iva))


 =>
  ( assert ( acumulador-mensual (cuenta 509) (mes ?mes) (ano ?ano) (debe 0) (haber 0)))
  ( printout t "Cuenta acumulador mensual 509 " tab ?mes crlf)

)

(defrule creando-acumulador-510
   ( declare (salience 9000))
   ( cuenta (nombre iva-debito) (tipo-de-documento 61) (partida ?partida) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   ( not (exists ( acumulador-mensual (cuenta 510) (mes ?mes) (ano ?ano))))
   ( test (or (> ?haber 0) (> ?debe 0)))


;   ( nota-de-credito-sii (folio-nota ?folio-nota) (folio ?folio) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (archivo ?archivo))

 ;  ?f1 <- ( venta-sii
 ;    (rut ?rut)
 ;    (partida ?numero_2)
 ;    (folio ?folio)
 ;    (unidades ?unidades)
 ;    (costo_unitario ?costo_unitario)
 ;    (dia ?dia_1) (mes ?mes_2) (ano ?ano)
  ;   (credito ?credito)
  ;   (colaborador ?colaborador)
  ;   (material ?material)
  ;   (total ?total)
  ;   (neto ?neto)
  ;   (iva ?iva))

 =>
  ( assert ( acumulador-mensual (cuenta 510) (mes ?mes) (ano ?ano) (debe 0) (haber 0)))
  ( printout t "Cuenta acumulador mensual 510 " tab ?mes crlf)

)


(defrule creando-acumulador-511
   ( declare (salience 9000))
   ( cuenta (partida ?partida) (nombre iva-credito) (electronico true) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   ( not (exists ( acumulador-mensual (cuenta 511) (mes ?mes) (ano ?ano))))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  ( assert ( acumulador-mensual (cuenta 511) (mes ?mes) (ano ?ano) (debe 0) (haber 0)))
  ( printout t "Cuenta acumulador mensual 511 " tab ?mes crlf)

)

(defrule creando-acumulador-512
   ( declare (salience 9000))
   ( cuenta (partida ?partida) (tipo-de-documento 56) (nombre banco-estado) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   ( not (exists ( acumulador-mensual (cuenta 512) (mes ?mes) (ano ?ano))))
;  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  ( assert ( acumulador-mensual (cuenta 512) (mes ?mes) (ano ?ano) (debe 0) (haber 0)))
  ( printout t "Cuenta acumulador mensual 512 " tab ?mes crlf)

)

(defrule creando-acumulador-513
   ( declare (salience 9000))
   ( cuenta (partida ?partida) (tipo-de-documento 56) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   ( not (exists ( acumulador-mensual (cuenta 513) (mes ?mes) (ano ?ano))))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  ( assert ( acumulador-mensual (cuenta 513) (mes ?mes) (ano ?ano) (debe 0) (haber 0)))
  ( printout t "Cuenta acumulador mensual 513 " tab ?mes crlf)

)

(defrule creando-acumulador-515
   ( declare (salience 9000))
   ( cuenta (partida ?partida) (tipo-de-documento 45) (nombre retenciones-por-pagar) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   ( not (exists ( acumulador-mensual (cuenta 515) (mes ?mes) (ano ?ano))))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  ( assert ( acumulador-mensual (cuenta 515) (mes ?mes) (ano ?ano) (debe 0) (haber 0)))
  ( printout t "Cuenta acumulador mensual 515" tab ?mes crlf)

)



(defrule creando-acumulador-519
   ( declare (salience 9000)) 
   ( or
     ( cuenta (partida ?partida) (activo-fijo false) (tipo-de-documento 33) (nombre banco-estado) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
     ( cuenta (partida ?partida) (activo-fijo false) (tipo-de-documento 33) (nombre caja) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   )
   ( not (exists ( acumulador-mensual (cuenta 519) (mes ?mes) (ano ?ano))))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  ( assert ( acumulador-mensual (cuenta 519) (mes ?mes) (ano ?ano) (debe 0) (haber 0)))
  ( printout t "Cuenta acumulador mensual 519 "tab ?mes crlf)

)


(defrule creando-acumulador-520
 (declare (salience 9000))
   ( cuenta (partida ?partida) (activo-fijo false) (tipo-de-documento 33) (nombre iva-credito) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   ( not (exists ( acumulador-mensual (cuenta 520) (mes ?mes) (ano ?ano))))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  ( assert ( acumulador-mensual (cuenta 520) (mes ?mes) (ano ?ano)))
  ( printout t "Cuenta acumulador mensual 520 " tab ?mes crlf)

)



(defrule creando-acumulador-524
 (declare (salience 9000))
   ( cuenta (partida ?partida) (activo-fijo true) (tipo-de-documento 33) (nombre banco-estado) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   ( not (exists ( acumulador-mensual (cuenta 524) (mes ?mes) (ano ?ano))))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  ( assert ( acumulador-mensual (cuenta 524) (mes ?mes) (ano ?ano)))
  ( printout t "Cuenta acumulador mensual 524 " tab ?mes crlf)

)

(defrule creando-acumulador-525
 (declare (salience 9000))
   ( cuenta (partida ?partida) (nombre herramientas) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   ( not (exists ( acumulador-mensual (cuenta 525) (mes ?mes) (ano ?ano))))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  ( assert ( acumulador-mensual (cuenta 525) (mes ?mes) (ano ?ano)))
  ( printout t "Cuenta acumulador mensual 525 " tab ?mes crlf)

)


(defrule creando-acumulador-527
 (declare (salience 9000))
   ( cuenta (partida ?partida) (recibida false) (tipo-de-documento 61) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   ( not (exists ( acumulador-mensual (cuenta 527) (mes ?mes) (ano ?ano))))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  ( assert ( acumulador-mensual (cuenta 527) (mes ?mes) (ano ?ano)))
  ( printout t "Cuenta acumulador mensual 527 " tab ?mes crlf)

)


(defrule creando-acumulador-528
 (declare (salience 9000))
   ( cuenta (partida ?partida) (nombre iva-credito) (recibida true) (tipo-de-documento 61) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   ( not (exists ( acumulador-mensual (cuenta 528) (mes ?mes) (ano ?ano))))
;  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  ( assert ( acumulador-mensual (cuenta 528) (mes ?mes) (ano ?ano)))
  ( printout t "Cuenta acumulador mensual 528 " tab ?mes crlf)

)



(defrule creando-acumulador-538
   ( declare (salience 9000))
   ( cuenta (nombre iva-debito) (tipo-de-documento 48) (partida ?partida) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   ( not (exists ( acumulador-mensual (cuenta 538) (mes ?mes) (ano ?ano))))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  ( assert ( acumulador-mensual (cuenta 538) (mes ?mes) (ano ?ano) (debe 0) (haber 0)))
  ( printout t "Cuenta acumulador mensual 538 " tab ?mes crlf)

)


(defrule creando-acumulador-563
   ( declare (salience 9000))
   (no)
   ( cuenta (nombre ventas) (tipo-de-documento ?tipo-de-documento&:(numberp ?tipo-de-documento))  (partida ?partida) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   ( not (exists ( acumulador-mensual (cuenta 563) (mes ?mes) (ano ?ano))))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  ( assert ( acumulador-mensual (cuenta 563) (mes ?mes) (ano ?ano) (debe 0) (haber 0)))
  ( printout t "Cuenta acumulador mensual 563 " tab ?mes crlf)

)



(defrule creando-acumulador-586-factura-exenta
   ( declare (salience 9000))
   ( cuenta (nombre ventas-con-factura-exenta) (tipo-de-documento ?tipo-de-documento) (partida ?partida) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   ( not (exists ( acumulador-mensual (cuenta 586) (mes ?mes) (ano ?ano))))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  ( assert ( acumulador-mensual (cuenta 586) (mes ?mes) (ano ?ano) (debe 0) (haber 0)))
  ( printout t "Cuenta acumulador mensual 586 " tab ?mes crlf)

)


(defrule creando-acumulador-586-eboleta-exenta
   ( declare (salience 9000))
   ( cuenta (nombre ventas-con-eboleta-exenta) (tipo-de-documento ?tipo-de-documento) (partida ?partida) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   ( not (exists ( acumulador-mensual (cuenta 586) (mes ?mes) (ano ?ano))))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  ( assert ( acumulador-mensual (cuenta 586) (mes ?mes) (ano ?ano) (debe 0) (haber 0)))
  ( printout t "Cuenta acumulador mensual 586 " tab ?mes crlf)

)





(defrule creando-acumulador-758
   ( declare (salience 9000))
   ( cuenta (nombre ventas-con-voucher-afecto) (partida ?partida) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   ( not (exists ( acumulador-mensual (cuenta 758) (mes ?mes) (ano ?ano))))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  ( assert ( acumulador-mensual (cuenta 758) (mes ?mes) (ano ?ano) (debe 0) (haber 0)))
  ( printout t "Cuenta acumulador mensual 758 " tab ?mes crlf)

)

(defrule creando-acumulador-759
   ( declare (salience 9000))
   ( cuenta (nombre iva-debito) (tipo-de-documento 61) (partida ?partida) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
   ( not (exists ( acumulador-mensual (cuenta 759) (mes ?mes) (ano ?ano))))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  ( assert ( acumulador-mensual (cuenta 759) (mes ?mes) (ano ?ano) (debe 0) (haber 0)))
  ( printout t "Cuenta acumulador mensual 759 " tab ?mes crlf)

)

(defrule ordenar-incremento
  ( declare (salience 9000))
  ( cuenta (qty ?qty) (tipo-de-documento ?tipo-de-documento) (partida ?partida) (nombre ?cuenta) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
   (assert (sumar (partida ?partida) (qty ?qty) (tipo-de-documento ?tipo-de-documento) (debe ?debe) (haber ?haber) (cuenta ?cuenta) (mes ?mes) (ano ?ano)))
   (printout t "Sumando " ?debe "------------" tab ?haber tipo-de-documento tab ?tipo-de-documento crlf)
)


(defrule ordenar-incremento-codigo-110-exenta
  ( declare (salience 9000))
  ( cuenta (partida ?partida) (qty ?qty) (tipo-de-documento 34) (nombre ventas-con-eboleta-exenta) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  (assert (sumar (partida ?partida) (qty ?qty) (debe ?debe) (haber ?haber) (tipo-de-documento 34) (cuenta 110) (mes ?mes) (ano ?ano)))
  (assert (sumar (partida ?partida) (qty ?qty) (debe ?debe) (haber ?haber) (tipo-de-documento 34) (cuenta 111) (mes ?mes) (ano ?ano)))

)

(defrule ordenar-incremento-codigo-110-boleta
  ( declare (salience 9000))
  ( cuenta (partida ?partida) (qty ?qty) (tipo-de-documento 39) (nombre ventas-con-eboleta-afecta) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  ( test (or (> ?haber 0) (> ?debe 0)))
 =>
  (assert (sumar (partida ?partida) (qty ?qty) (debe ?debe) (tipo-de-documento 39) (haber ?haber) (cuenta 110) (mes ?mes) (ano ?ano)))
  (assert (sumar (partida ?partida) (qty ?qty) (debe ?debe) (tipo-de-documento 39) (haber ?haber) (cuenta 111) (mes ?mes) (ano ?ano)))


  (printout t "Sumando tipo 39 para codigo 110 " tab ?partida tab ?debe "------------" ?haber crlf)
)




(defrule ordenar-incremento-codigo-151
  ( declare (salience 9000))
  ( cuenta (partida ?partida) (qty ?qty) (tipo-de-documento 33) (nombre retenciones-por-pagar) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  (assert (sumar (partida ?partida) (qty ?qty) (debe ?debe) (tipo-de-documento 33) (haber ?haber) (cuenta 151) (mes ?mes) (ano ?ano)))
  (printout t "Sumando tipo 33 para codigo 151 " tab ?partida tab ?debe "------------" ?haber crlf)
)



(defrule ordenar-incremento-509
  ( declare (salience 9000))
  ( cuenta (partida ?partida) (nombre iva-debito) (tipo-de-documento 61) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  ( test (> ?debe 0))
  ( test (or (> ?haber 0) (> ?debe 0)))

  ( nota-de-credito-sii (folio-nota ?folio-nota) (folio ?folio) (partida ?partida) (dia ?dia) (mes ?mes) (ano ?ano) (archivo ?archivo))

   ?f1 <- ( venta-sii
     (rut ?rut)
     (partida ?numero_2)
     (folio ?folio)
     (unidades ?unidades)
     (costo_unitario ?costo_unitario)
     (dia ?dia_1) (mes ?mes_2) (ano ?ano)
     (credito ?credito)
     (colaborador ?colaborador)
     (material ?material)
     (total ?total)
     (neto ?neto)
     (iva ?iva))


 =>
  (assert (sumar (partida ?partida) (debe ?debe) (haber ?haber) (tipo-de-documento 61) (cuenta 509) (mes ?mes) (ano ?ano)))
  (printout t "Sumando notas-de-credito 61 para 509 " tab ?partida tab ?debe "------------" ?haber crlf)
)

(defrule ordenar-incremento-510
  ( declare (salience 9000))
  ( cuenta (partida ?partida) (nombre iva-debito) (tipo-de-documento 61) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  ( test (> ?debe 0))
  ( test (or (> ?haber 0) (> ?debe 0)))

;  ( nota-de-credito-sii (folio-nota ?folio-nota) (folio ?folio) (partida ?partida) (dia ?dia) (mes ?mes) (ano ?ano) (archivo ?archivo))

 ;  ?f1 <- ( venta-sii
 ;   (rut ?rut)
  ;  (partida ?numero_2)
  ;  (folio ?folio)
  ;  (unidades ?unidades)
  ;  (costo_unitario ?costo_unitario)
  ;  (dia ?dia_1) (mes ?mes_2) (ano ?ano)
  ;  (credito ?credito)
  ;  (colaborador ?colaborador)
  ;  (material ?material)
  ;  (total ?total)
  ;  (neto ?neto)
  ;  (iva ?iva))


 =>
  (assert (sumar (partida ?partida) (debe ?debe) (haber ?haber) (tipo-de-documento 61) (cuenta 510) (mes ?mes) (ano ?ano)))
  (printout t "Sumando iva-debito tipo de documento 61 para 510 " tab ?partida tab ?debe "------------" ?haber crlf)
)


(defrule ordenar-incremento-codigo-511-33
  ( declare (salience 9000))
  ( cuenta (partida ?partida) (qty ?qty) (tipo-de-documento 33) (electronico true) (nombre iva-credito) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  (assert (sumar (partida ?partida) (qty ?qty) (debe ?debe) (haber ?haber) (tipo-de-documento 33) (cuenta 511) (mes ?mes) (ano ?ano)))
  (printout t "Sumando iva-credito tipo-de-documento 33 para 511 " tab ?partida tab ?debe "------------" ?haber crlf)
)


(defrule ordenar-incremento-codigo-39
  ( declare (salience 9000))
  ( cuenta (partida ?partida) (qty ?qty) (tipo-de-documento ?tipo-de-documento) (nombre retencion-de-iva-articulo-11) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  (assert (sumar (partida ?partida) (qty ?qty) (debe ?debe) (haber ?haber) (tipo-de-documento ?tipo-de-documento) (cuenta 39) (mes ?mes) (ano ?ano)))
  (printout t "Sumando iva-retenido-articulo-11 para 39 " tab ?partida tab ?debe "------------" ?haber crlf)
)




(defrule ordenar-incremento-codigo-511-61
  ( declare (salience 9000))
;  (no)
  ( cuenta (partida ?partida) (qty ?qty) (tipo-de-documento 61) (electronico true) (nombre iva-credito) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  (assert (sumar (partida ?partida) (qty ?qty) (debe ?debe) (haber ?haber) (tipo-de-documento 61) (cuenta 511) (mes ?mes) (ano ?ano)))
  (printout t "Restando iva-credito tipo-de-documento 61  para 511 " tab ?partida tab ?debe "------------" ?haber crlf)
)

;parece que esto no funciona en febrero de 2021
(defrule ordenar-incremento-codigo-511-56
  ( declare (salience 9000))
  ( cuenta (partida ?partida) (qty ?qty) (tipo-de-documento 56) (electronico true) (nombre iva-credito) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
 ; ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  (assert (sumar (partida ?partida) (qty ?qty) (debe ?debe) (haber ?haber) (tipo-de-documento 56) (cuenta 511) (mes ?mes) (ano ?ano)))
  (printout t "Sumando iva-credito tipo-de-documento 56  para 511 " tab ?qty tab ?partida tab ?debe "------------" ?haber crlf)
)


(defrule ordenar-incremento-codigo-512
  ( declare (salience 9000))
  ( cuenta (partida ?partida) (qty ?qty) (nombre banco-estado) (tipo-de-documento 56) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
;  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  (assert (sumar (partida ?partida) (qty ?qty) (debe ?debe) (tipo-de-documento 56) (haber ?haber) (cuenta 512) (mes ?mes) (ano ?ano)))
  (printout t "Sumando qty de tipo 56 para codigo 512 " tab ?qty tab ?partida tab ?debe "------------" ?haber crlf)
) 

(defrule ordenar-incremento-codigo-513
  ( declare (salience 9000))
  ( cuenta (partida ?partida) (qty ?qty) (tipo-de-documento 56) (nombre iva-debito) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
;  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  (assert (sumar (partida ?partida) (qty ?qty) (debe ?debe) (haber ?haber) (tipo-de-documento 56) (cuenta 513) (mes ?mes) (ano ?ano)))
  (printout t "Sumando tipo 56 para codigo 513 " tab ?qty tab  ?partida tab ?debe "------------" ?haber crlf)
)

(defrule ordenar-incremento-codigo-515
  ( declare (salience 9000))
  ( cuenta (partida ?partida) (qty ?qty) (tipo-de-documento 45) (nombre retenciones-por-pagar) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  (assert (sumar (partida ?partida) (qty 1) (debe ?debe) (haber ?haber) (tipo-de-documento 45) (cuenta 515) (mes ?mes) (ano ?ano)))
  (printout t "Sumando tipo 45 para codigo 515 " tab ?partida tab ?debe "------------" ?haber crlf)
)




(defrule ordenar-incremento-codigo-519
  ( declare (salience 9000))
  ( or
    ( cuenta (partida ?partida) (qty ?qty) (recibida true) (activo-fijo false) (electronico true) (tipo-de-documento 33) (nombre banco-estado) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
    ( cuenta (partida ?partida) (qty ?qty) (recibida true) (activo-fijo false) (electronico true) (tipo-de-documento 33) (nombre caja) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano)) 
  )

  ( test (or (> ?haber 0) (> ?debe 0)))


 =>
  (assert (sumar (partida ?partida) (qty ?qty) (debe ?debe) (haber ?haber) (tipo-de-documento 33) (cuenta 519) (mes ?mes) (ano ?ano)))
  (printout t "Sumando efectivo-y-equivalentes tipo-de-documento 33 para 519" tab ?debe "------------" ?haber crlf)
)

(defrule ordenar-incremento-520
  ( declare (salience 9000))
  ( cuenta (partida ?partida) (activo-fijo false) (recibida true)  (tipo-de-documento 33) (nombre iva-credito) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
; ( test (neq ?tipo-de-documento escritura-empresa))
  ( test (or (> ?haber 0) (> ?debe 0)))
 =>
  (assert (sumar (partida ?partida) (debe ?debe) (haber ?haber) (tipo-de-documento 33) (cuenta 520) (mes ?mes) (ano ?ano)))
  (printout t "Sumando tipo 33 para codigo 520 " tab ?partida tab ?debe "------------" ?haber crlf)

)

(defrule ordenar-incremento-524
  ( declare (salience 9000))
  ( cuenta (partida ?partida) (activo-fijo true) (tipo-de-documento 33) (nombre banco-estado) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  (assert (sumar (partida ?partida) (debe ?debe) (haber ?haber) (tipo-de-documento 33) (cuenta 524) (mes ?mes) (ano ?ano)))
  (printout t "Sumando tipo-de-documento 33 para codigo 524 " tab ?partida tab ?debe "------------" ?haber crlf)

)

(defrule ordenar-incremento-525
  ( declare (salience 9000))
  ( cuenta (partida ?partida) (activo-fijo true) (nombre iva-credito) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  (assert (sumar (partida ?partida) (debe ?debe) (haber ?haber) (tipo-de-documento iva-credito) (cuenta 525) (mes ?mes) (ano ?ano)))
  (printout t "Sumando iva-credito para 525 " tab ?partida tab ?debe "------------" ?haber crlf)
)


(defrule ordenar-incremento-527
  ( declare (salience 9000))
  ( cuenta (partida ?partida) (nombre ingresos-brutos) (tipo-de-documento 61) (recibida false) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  (assert (sumar (partida ?partida) (debe ?debe) (haber ?haber) (tipo-de-documento 61) (cuenta 527) (mes ?mes) (ano ?ano)))
  (printout t "Sumando notas-de-credito tipo-de-documento 61 para 527 " tab ?partida tab ?debe "------------" ?haber crlf)
)


(defrule ordenar-incremento-528-son-notas-de-creditos-recibidas
  ( declare (salience 9000))
  ( cuenta (partida ?partida) (nombre iva-credito)  (recibida true) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
;  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  (assert (sumar (partida ?partida) (debe ?debe) (haber ?haber) (cuenta 528) (mes ?mes) (ano ?ano)))
  (printout t "Sumando iva-debito para 528 " tab ?partida tab ?debe "------------" ?haber crlf)
)


(defrule ordenar-incremento-503-factura-afecta-emitidas
  ( declare (salience 9000))
  ( cuenta (partida ?partida) (nombre ventas-con-factura-afecta) (tipo-de-documento 33) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
 =>
  (assert (sumar (partida ?partida) (debe ?debe) (haber ?haber) (tipo-de-documento 33) (cuenta 503) (mes ?mes) (ano ?ano)))
  (printout t "Sumando 503 " tab ?partida tab ?debe "------------" ?haber crlf)
)

(defrule ordenar-incremento-503-factura-exentas-emitidas
  ( declare (salience 9000))
  (no)
 ;  https://www.sii.cl/preguntas_frecuentes/iva/001_030_1922.htm
  ( cuenta (partida ?partida) (nombre ventas-con-factura-exenta) (tipo-de-documento 38) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
 =>
  (assert (sumar (partida ?partida) (debe ?debe) (haber ?haber) (tipo-de-documento 38) (cuenta 503) (mes ?mes) (ano ?ano)))
  (printout t "Sumando 503 " tab ?partida tab ?debe "------------" ?haber crlf)
)



(defrule ordenar-incremento-503-factura-exenta
  ( declare (salience 9000))
  (no)
  ( cuenta (partida ?partida) (tipo-de-documento ?tipo-de-documento) (nombre ventas-con-factura-exenta) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  (assert (sumar (partida ?partida) (debe ?debe) (haber ?haber) (tipo-de-documento ?tipo-de-documento) (cuenta 503) (mes ?mes) (ano ?ano)))
  (printout t "Sumando tipo-de-documento 38 para 503 " tab ?partida tab ?debe "------------" ?haber crlf)
)



(defrule ordenar-incremento-538
  ( declare (salience 9000))
  ( cuenta (partida ?partida) (tipo-de-documento 48) (nombre iva-debito) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  (assert (sumar (partida ?partida) (debe ?debe) (haber ?haber) (tipo-de-documento 48) (cuenta 538) (mes ?mes) (ano ?ano)))
  (printout t "Sumando iva-debito tipo-de-documento 48 para 538 " tab ?partida tab ?debe "------------" ?haber crlf)
)

(defrule ordenar-incremento-563
  ( declare (salience 9000))
  ( no)
  (or
    ( cuenta (partida ?partida) (nombre ingresos-brutos) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))

 ;  ( cuenta (partida ?partida) (tipo-de-documento ?tipo-de-documento&:(numberp ?tipo-de-documento)) (nombre banco-estado) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
;   ( cuenta (nombre caja)  (tipo-de-documento ?tipo-de-documento&:(numberp ?tipo-de-documento)) (partida ?partida) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  )
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  (assert (sumar (partida ?partida) (debe ?debe) (haber ?haber) (cuenta 563) (mes ?mes) (ano ?ano)))
  (printout t "Sumando ingreos-brutos para 563 " tab ?partida tab ?debe "------------" ?haber crlf)
  ( halt )
)


(defrule ordenar-incremento-586-factura-exenta
  ( declare (salience 9000))
  ( cuenta (partida ?partida) (tipo-de-documento ?tipo-de-documento) (nombre ventas-con-factura-exenta) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  (assert (sumar (partida ?partida) (debe ?debe) (haber ?haber) (tipo-de-documento ?tipo-de-documento) (cuenta 586) (mes ?mes) (ano ?ano)))
  (printout t "Sumando iva-debito tipo-de-documento 38 para 586 " tab ?partida tab ?debe "------------" ?haber crlf)
)


(defrule ordenar-incremento-586-eboleta-exenta
  ( declare (salience 9000))
  ( cuenta (partida ?partida) (tipo-de-documento ?tipo-de-documento) (nombre ventas-con-eboleta-exenta) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  (assert (sumar (partida ?partida) (debe ?debe) (haber ?haber) (tipo-de-documento ?tipo-de-documento) (cuenta 586) (mes ?mes) (ano ?ano)))
  (printout t "Sumando iva-debito tipo-de-documento 38 para 586 " tab ?partida tab ?debe "------------" ?haber crlf)
)





(defrule ordenar-incremento-758
  ( declare (salience 9000))
  ( cuenta  (nombre ventas-con-voucher-afecto) (qty ?qty) (tipo-de-documento 48) (partida ?partida) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  (assert (sumar (partida ?partida) (qty ?qty) (debe ?debe) (tipo-de-documento 48) (haber ?haber) (cuenta 758) (mes ?mes) (ano ?ano)))
  (printout t "Sumando qty ventas-con-voucher-afecto para 758 " tab ?partida tab ?debe "------------" ?haber crlf)
)

(defrule ordenar-incremento-759
  ( declare (salience 9000))
  ( cuenta  (nombre iva-debito) (tipo-de-documento 48) (partida ?partida) (haber ?haber) (debe ?debe) (mes ?mes) (ano ?ano))
  ( test (or (> ?haber 0) (> ?debe 0)))

 =>
  (assert (sumar (partida ?partida) (debe ?debe) (haber ?haber) (tipo-de-documento 48) (cuenta 759) (mes ?mes) (ano ?ano)))
  (printout t "Sumando iva-debito tipo-de-documento 48 para 759 " tab ?partida tab ?debe "------------" ?haber crlf)
)

(defrule sumar-incremento

  ( declare (salience 9000))
  ( balance (mes ?mes-balance))
  ( empresa (nombre ?empresa))
;  ( selecciones (inspect-f29-code ?codigo))
   ?suma <- ( sumar (partida ?partida) (qty ?qty-suma) (tipo-de-documento ?tipo-de-documento) (debe ?debe-suma) (haber ?haber-suma) (cuenta ?cuenta) (mes ?mes) (ano ?ano))
  ?acc  <- ( acumulador-mensual (cuenta ?cuenta) (qty ?qty) (debe ?debe) (haber ?haber ) (mes ?mes) (ano ?ano))
;  ( test (or (> ?haber-suma 0) (> ?debe-suma 0)))

 =>

  ( retract ?suma)
;  ( if (eq ?cuenta ?codigo)
;   then
  ( assert (codigo-de-partida (codigo ?cuenta) (partida ?partida)))
; )
  ( modify ?acc (debe (+ ?debe ?debe-suma)) (tipo-de-documento ?tipo-de-documento) (haber (+ ?haber ?haber-suma)) (qty (+ ?qty-suma ?qty) ))
  ( printout t "SUmado " ?cuenta " partida " ?partida tab ?qty-suma tab ?debe-suma -------- ?haber-suma tab ?tipo-de-documento crlf)
;  ( printout k "SUmado " ?cuenta tab ?qty-suma tab ?debe-suma -------- ?haber-suma tab ?tipo-de-documento crlf)
; ( if (and (eq ?mes ?mes-balance ) (eq ?cuenta ?codigo)) then
 ;  ( printout k "<tr> <td> <a href= '/" ?empresa "/libro-diario#Partida-" ?partida "'>" ?partida "</a> </td> <td> " ?tipo-de-documento "</td> <td> " ?mes " </td> <td>  " ?cuenta " </td> <td> " (- (+ ?debe ?debe-suma) (+ ?haber ?haber-suma))  "</td> <td style='color: white; background-color: cornflowerblue'>  " ?qty-suma " </td> <td> " ?debe " </td> <td style='color: white; background-color: cornflowerblue'> " ?debe-suma "</td> <td> " ?haber "</td> <td style='color: white; background-color: cornflowerblue'>" ?haber-suma "  </td> </tr>" crlf)
 ;)

)



 



