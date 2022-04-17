;Mobi_rules es una alternativa a main_rules, para customizar lo que sea
;diferente si se quiere generar un mobi en kindlegen
;Lo primero que cambia es el archivo de selecciones
;Ahora se puede imprimir una archvo único para el libro diario, el libro mayor, los f29, el estado final, el estado tributario y el f22
;Esto se fija en las selecciones
;Para usar este flujo, hay que llamar a mobi.sh
(defmodule MAIN
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

(defrule MAIN::seleccion-de-empresa
  (declare (salience 10000))
 =>
  ( load-facts "selecciones-mobi.txt")
  ( load-facts "version.txt")
)


(defrule MAIN::inicio-modulo-mobi
  (declare (salience 9000))
  (selecciones (empresa-seleccionada ?empresa))
=>
;  (halt)
 ; ( printout t "¿ Para qué empresa requiere la contabilidad ?"  crlf)
 ;  ( bind ?empresa (read))
  
   ;( bind ?empresa logica-contable)
   ;( bind ?empresa alectrico)
  ; ( bind ?empresa alectrico-2021)
  
 ;  ( load-facts "empresa-seleccionada.txt")

;   ( bind ?empresa 1724 )
   ( printout t crlf crlf "------------- MOBI ----------------------" ?empresa crlf crlf crlf)



  ( bind ?archivo (str-cat ?empresa "-revisiones.txt"))
  ( printout t archivo-revisiones-cuentas tab ?archivo crlf )
  ( load-facts ?archivo)

  ( bind ?archivo (str-cat ?empresa "-facts.txt"))
  ( printout t archivo-facts tab ?archivo crlf )
  ( load-facts ?archivo)


   ( bind ?archivo (str-cat ?empresa "-revisiones.txt"))
   ( printout t archivo-revisiones tab ?archivo crlf )
   ( load-facts ?archivo)

   ( bind ?archivo (str-cat ?empresa "-revisiones-cuentas.txt"))
   ( printout t archivo-revisiones tab ?archivo crlf )
   ( load-facts ?archivo)


   ( bind ?archivo (str-cat ?empresa "-dribble.txt"))
   ( printout t archivo-dribble tab ?archivo crlf )
   ( dribble-on ?archivo)

   ( bind ?archivo (str-cat "tasas.txt"))
   ( printout t archivo-tasas tab ?archivo crlf )
   ( load-facts ?archivo)

   ( bind ?archivo (str-cat "valor-activos.txt"))
   ( printout t archivo-valor-activos tab ?archivo crlf )
   ( load-facts ?archivo)

   ( bind ?archivo (str-cat "proveedores.txt"))
   ( printout t archivo-proveedores tab ?archivo crlf )
   ( load-facts ?archivo)

   ( bind ?archivo (str-cat "trabajadores.txt"))
   ( printout t archivo-trabajadores tab ?archivo crlf )
   ( load-facts ?archivo)

   ( bind ?archivo (str-cat "remuneraciones.txt"))
   ( printout t archivo-remuneraciones tab ?archivo crlf )
   ( load-facts ?archivo)

   ( bind ?archivo (str-cat "afps.txt"))
   ( printout t archivo-afps tab ?archivo crlf )
   ( load-facts ?archivo)

   ( bind ?archivo (str-cat "afc.txt"))
   ( printout t archivo-afc tab ?archivo crlf )
   ( load-facts ?archivo)

   ( bind ?archivo (str-cat "salud.txt"))
   ( printout t archivo-salud tab ?archivo crlf )
   ( load-facts ?archivo)

   ( bind ?archivo (str-cat "tramos-de-impuesto-unico.txt"))
   ( printout t archivo-impuestos tab ?archivo crlf )
   ( load-facts ?archivo)

   ( bind ?archivo (str-cat "contratos.txt"))
   ( printout t archivo-contratos tab ?archivo crlf )
   ( load-facts ?archivo)

   ( bind ?archivo (str-cat "accionistas.txt"))
   ( printout t archivo-accionistas tab ?archivo crlf )
   ( load-facts ?archivo)

   ( bind ?archivo (str-cat "cuentas.txt"))
   ( printout t archivo-cuentas tab ?archivo crlf)
   ( load-facts ?archivo)

   ( load-facts "actividades.txt")
   ( load-facts "f29-f22.txt" )
   ( load-facts "volumenes.txt" )
   ( load-facts "version.txt" )

   ( assert (actual (mes enero     )))
   ( assert (actual (mes febrero   )))
   ( assert (actual (mes marzo     )))
   ( assert (actual (mes abril     )))
   ( assert (actual (mes mayo      )))
   ( assert (actual (mes junio     )))
   ( assert (actual (mes julio     )))
   ( assert (actual (mes agosto    )))
   ( assert (actual (mes septiembre)))
   ( assert (actual (mes octubre   )))
   ( assert (actual (mes noviembre )))
   ( assert (actual (mes diciembre )))

   ( assert (ajustar-para-book))
)


(defrule hacer-ajutar-para-ebook-rule
  ?ajustar <-  ( ajustar-para-book )
  ( version (asin ?asin) (version ?version) (mes ?mes) )
  ?balance <- (balance )
  ?revision-general <- (revision-general)
  (volumen (asin ?asin) (partidas-no-incluidas $?partidas) )
 =>

  (retract ?ajustar)
  (modify ?balance (mes ?mes))
  (modify ?revision-general (partidas $?partidas ))
  (assert (hacer-focos) )
)


(defrule hacer-focos-rule

  ?hacer-focos <- ( hacer-focos)

 =>
  ( retract ?hacer-focos)

;  ( focus TICKET PEDIDO PRIMITIVA ACTIVIDAD PRIMITIVA MENSUAL PRIMITIVA IVA PAGAR VALOR_ACTIVOS PRIMITIVA ECUACION PARTIDA LIBRO-MAYOR TOTAL RESULTADO-SII COMPROBACION FINANCIERO RECUADRO AJUSTE INVENTARIO LIQUIDACION INVENTARIO_FINAL AJUSTE TA TRIBUTARIO AJUSTEC TOTALC FINAL SUBCUENTA CCM RCV REMUNERACIONES BI )


;   prueba los cálculos de idpc
;   ( focus TICKET PRIMITIVA ACTIVIDAD PRIMITIVA PARTIDA LIBRO-MAYOR TOTAL AJUSTE INVENTARIO LIQUIDACION INVENTARIO_FINAL AJUSTE TA TRIBUTARIO )

; ( focus TICKET PRIMITIVA ACTIVIDAD PRIMITIVA PARTIDA VALOR_ACTIVOS PRIMITIVA LIBRO-MAYOR TOTAL AJUSTE INVENTARIO LIQUIDACION AJUSTE TA TRIBUTARIO AJUSTEC TOTALC FINAL SUBCUENTA)

  ( focus PEDIDO TICKET PRIMITIVA ACTIVIDAD PRIMITIVA MENSUAL PRIMITIVA IVA PAGAR VALOR_ACTIVOS PRIMITIVA ECUACION LIBRO-MAYOR TOTAL RESULTADO-SII COMPROBACION FINANCIERO RECUADRO AJUSTE INVENTARIO PARTIDA LIQUIDACION  INVENTARIO_FINAL AJUSTE TA TRIBUTARIO AJUSTEC TOTALC FINAL SUBCUENTA CCM RCV REMUNERACIONES BI )

;   ( focus TICKET PRIMITIVA ACTIVIDAD PRIMITIVA PARTIDA BI )
;   ( focus TICKET PRIMITIVA ACTIVIDAD PRIMITIVA MENSUAL PRIMITIVA IVA PAGAR PRIMITIVA LIBRO-MAYOR TOTAL AJUSTE INVENTARIO PARTIDA LIQUIDACION  INVENTARIO_FINAL AJUSTE TA TRIBUTARIO AJUSTEC  BI )
)




