(defmodule MAIN
 (export ?ALL)
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
 =>
  ( load-facts "selecciones.txt")
)



(defrule MAIN::inicio-modulo-main
  (declare (salience 10000))
  (selecciones (empresa-seleccionada ?empresa))
=>

  ;( printout t "¿ Para qué empresa requiere la contabilidad ?"  crlf)
   ;( bind ?empresa (read))
  
   ;( bind ?empresa logica-contable)
   ;( bind ?empresa alectrico)
  ; ( bind ?empresa alectrico-2021)
  
 ;  ( load-facts "empresa-seleccionada.txt")

;   ( bind ?empresa 1724 )
   ( printout t crlf crlf "------------- MAIN ----------------------" ?empresa crlf crlf crlf)

   ( bind ?archivo (str-cat ?empresa "-facts.txt"))
   ( printout t archivo-facts tab ?archivo crlf )
   ( load-facts ?archivo)

   ( bind ?archivo (str-cat ?empresa "-revisiones.txt"))
   ( printout t archivo-revisiones tab ?archivo crlf )
   ( load-facts ?archivo)


   ( bind ?archivo (str-cat ?empresa "-revisiones-cuentas.txt"))
   ( printout t archivo-revisiones-cuentas tab ?archivo crlf )
   ( load-facts ?archivo)

   ( bind ?archivo (str-cat ?empresa "-dribble.txt"))
   ( printout t archivo-dribble tab ?archivo crlf )
   ( dribble-on ?archivo)

   ( bind ?archivo (str-cat ?empresa "-tasas.txt"))
   ( printout t archivo-tasas tab ?archivo crlf )
   ( load-facts ?archivo)

   ( bind ?archivo (str-cat ?empresa "-valor-activos.txt"))
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

;   ( focus PEDIDO PRIMITIVA ACTIVIDAD PRIMITIVA MENSUAL PRIMITIVA IVA PAGAR VALOR_ACTIVOS PRIMITIVA ECUACION PARTIDA T TOTAL RESULTADO-SII COMPROBACION FINANCIERO RECUADRO AJUSTE INVENTARIO LIQUIDACION INVENTARIO_FINAL AJUSTE TA TRIBUTARIO AJUSTEC TOTALC FINAL SUBCUENTA CCM RCV REMUNERACIONES BI )

    ( focus PRIMITIVA ACTIVIDAD PRIMITIVA BI )



)




