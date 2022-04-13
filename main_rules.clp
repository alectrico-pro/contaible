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

;el archivo markdown aquí generado sirve para 
;evitar que la compilación de Dockerfile sea abortada
(defrule creacion-de-archivo-markdown
   ( declare (salience 10000))
   ( selecciones (archivo-unico-markdown false))

  =>

   ( bind ?archivo (str-cat "./doc/archivo.markdown"))
   ( open ?archivo l "w")
   ( printout l (random ) crlf)
   ( printout t "------------------- fin-archivo-markdown ------------" crlf)
   ( close l)
)   


(defrule creacion-de-archivo-unico-k-markdown
   ( declare (salience 10000))
   ( selecciones (archivo-unico-markdown true) (nombre-de-archivo-k ?archivo))

  =>

;   ( bind ?archivo (str-cat "./doc/" ?archivo ".markdown"))
   ( bind ?archivo (str-cat "./doc/" ?empresa "/" ?archivo ".markdown"))
   ( open ?archivo g "w")
   ( printout g (random ) crlf)
   ( printout t "------------------- fin-archivo-unico-markdown - " tab ?archivo tab "-----------" crlf)
   ( close g)
)

    

(defrule MAIN::inicio-modulo-main
  (declare (salience 9999))
  (selecciones (empresa-seleccionada ?empresa))
=>

 ; ( printout t "¿ Para qué empresa requiere la contabilidad ?"  crlf)
 ; ( bind ?empresa (read))
  
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

;   ( focus PEDIDO TICKET PRIMITIVA ACTIVIDAD REMANENTE PRIMITIVA MENSUAL PRIMITIVA PAGAR IVA PRIMITIVA ECUACION PARTIDA LIBRO-MAYOR TOTAL COMPROBACION FINANCIERO RECUADRO AJUSTE INVENTARIO ACCIONES LIQUIDACION INVENTARIO_FINAL TA TOTALA COMPROBACIONB RESULTADO RESULTADO-KINDLE AJUSTEB TOTALB TRIBUTARIO RESULTADO AJUSTEC TOTALC FINAL AJUSTE SUBCUENTA CCM RCV REMUNERACIONES )
   ; El caculo de remanente se hace ahora en el módulo IVA
;  ( focus PEDIDO TICKET PRIMITIVA ACTIVIDAD PRIMITIVA MENSUAL PRIMITIVA IVA PAGAR VALOR_ACTIVOS PRIMITIVA ECUACION PARTIDA LIBRO-MAYOR TOTAL COMPROBACION FINANCIERO RECUADRO AJUSTE INVENTARIO ACCIONES LIQUIDACION INVENTARIO_FINAL TA TOTALA COMPROBACIONB RESULTADO RESULTADO-KINDLE AJUSTEB TOTALB TRIBUTARIO RESULTADO AJUSTEC TOTALC FINAL AJUSTE SUBCUENTA CCM RCV REMUNERACIONES )

   ;no usar modulo ACCIONES porque ya se hce en inventario-final. No estoy seguro.
;   ( focus PEDIDO TICKET PRIMITIVA ACTIVIDAD PRIMITIVA MENSUAL PRIMITIVA IVA PAGAR VALOR_ACTIVOS PRIMITIVA ECUACION PARTIDA LIBRO-MAYOR TOTAL RESULTADO-SII COMPROBACION FINANCIERO RECUADRO AJUSTE INVENTARIO LIQUIDACION INVENTARIO_FINAL TA RESULTADO-KINDLE TOTALA COMPROBACIONB RESULTADO AJUSTEB TOTALB TRIBUTARIO AJUSTEC TOTALC FINAL AJUSTE SUBCUENTA CCM RCV REMUNERACIONES )


   ;probando por tramos para ver donde se pierden los totales
;   ( PEDIDO da un error en clips 6.4)
   ;el inventario final no es necesario en refimen propyme toda vez que se adminste liquidar las mercancias y los insumos
  ; ( focus PEDIDO TICKET PRIMITIVA ACTIVIDAD PRIMITIVA MENSUAL PRIMITIVA IVA PAGAR VALOR_ACTIVOS PRIMITIVA ECUACION PARTIDA LIBRO-MAYOR TOTAL RESULTADO-SII COMPROBACION FINANCIERO RECUADRO AJUSTE INVENTARIO LIQUIDACION INVENTARIO_FINAL AJUSTE TA TRIBUTARIO AJUSTEC TOTALC FINAL SUBCUENTA)

;CCM RCV REMUNERACIONES BI )

   ;probando en clips shell 6.4

  ;adelantando resultado-kindle para evitar que el proceso de liquidacion desarme los subtotales
; ( focus PEDIDO TICKET PRIMITIVA ACTIVIDAD PRIMITIVA MENSUAL PRIMITIVA IVA PAGAR VALOR_ACTIVOS PRIMITIVA ECUACION PARTIDA LIBRO-MAYOR TOTAL RESULTADO-SII COMPROBACION FINANCIERO RECUADRO AJUSTE INVENTARIO LIQUIDACION INVENTARIO_FINAL RESULTADO-KINDLE TA TOTALA COMPROBACIONB AJUSTEB TOTALB TRIBUTARIO RESULTADO AJUSTEC TOTALC FINAL AJUSTE SUBCUENTA CCM RCV REMUNERACIONES BI)



  ;Eliminando inventari-final pues solamente se usan sus primitivas de cargo y abono, pero no es exclusivo para inventarios.
;  ( focus PEDIDO TICKET PRIMITIVA ACTIVIDAD PRIMITIVA MENSUAL PRIMITIVA IVA PAGAR VALOR_ACTIVOS PRIMITIVA ECUACION PARTIDA LIBRO-MAYOR TOTAL COMPROBACION FINANCIERO RECUADRO AJUSTE INVENTARIO LIQUIDACION TA TOTALA COMPROBACIONB RESULTADO RESULTADO-KINDLE AJUSTEB TOTALB TRIBUTARIO RESULTADO AJUSTEC TOTALC FINAL AJUSTE SUBCUENTA CCM RCV REMUNERACIONES )

  ;PEDIDO consolida las partias para un pedido de un cliente
  ;TICKET ordenas las partidas
  ;PRIMITIVA contiene las reglas básicas
  ;MENSUAL calcula los impuestos mensuales y soporta el F29
  ;IVA y PAGAR trabjan con mensual
  ;VALOR_ACTIVOS es un registro permanente de los activos de la empresa
  ;ECUACION, trata de establecer la igualdas contable
  ;PARTIDA, muestra las partidas
  ;LIBRO-MAYOR, muestra el libro mayor
  ;COMPROBACION, muestra sumas de comprobacion
  ;AJUSTEB,  ajuste de cuentas para evitar mostrar subtotales de cuentas nominativas o desquilibrar los estados
  ;INVENTARIO, genera el inventario físico a partir del compras de inventario
  ;LIQUIDACION, genera liquidaciones financieras y fiscales
  ;INVENTARIO_FINAL, valor el inventario final
  ;REGULATADO-KINDLE, muestra el detalle de las cuentas que leugo serán mostadas en un estado de resultados
  ;TA, genera las cuentas en T
  ;TOTAlA, genar los totales mostrados en los estados
  ;COMPROBACIONb, comprobación  luego de las liquidaciones
  ;TOTALb, total luego de las liquidacions
  ;ESTADO DE RESULTADO
  ;AJUSTEC, TOTALC son procedimientos estándar
  ;SUBCUENTA, muestra las subcuentas
  ;CCM, exporta código para el sistema de contabilidad completa
  ;RCV, exporta código para REgistro de Compra Ventas
  ;REMUNERACIONES, genera las hojas de remuneraciones y liquidaciones
  ;BI muestra algunas comprobaciones de auditoría, con fuerza en el asistente propyme y en el F22 del año siguiente al del ejercicio
 

  ( focus PEDIDO TICKET PRIMITIVA ACTIVIDAD PRIMITIVA MENSUAL PRIMITIVA IVA PAGAR VALOR_ACTIVOS PRIMITIVA ECUACION PARTIDA LIBRO-MAYOR TOTAL RESULTADO-SII COMPROBACION FINANCIERO RECUADRO AJUSTE INVENTARIO LIQUIDACION INVENTARIO_FINAL RESULTADO-KINDLE TA TOTALA COMPROBACIONB AJUSTEB TOTALB TRIBUTARIO RESULTADO AJUSTEC TOTALC FINAL AJUSTE SUBCUENTA CCM RCV REMUNERACIONES BI)


   ( printout t "1. Usar el asistente csm sii f29" crlf "2. Comparar con asistente f29 alectrico" crlf "3. Ver si hay saldo debito y restarlo a saldo credito, hay un procedimiento para ello: pago-de-via." crlf "4. Lo que quede de saldo de iva-credito se coloca en código 77, hay un procedimiento: remanente-iva se debe coloar el iva-credito en este procedimiento" crlf "5. Pagar los ppm si hay monto imponible, se hace con procedimiento pago-ppm" crlf "6. Pagar las retenciones pendientes, se hace junto con la declarion y pago de f29" crlf "7. Cuando se declare f29 anotar los giros como gastos, o sea: anotar un movimiento en ccm." crlf "8. Anotar las multas que se pagan a sii y pasarlas como gastos: o sea, crar un movimiento en ccm" crlf "9. Estar atento a los pagos de proveedores extranjeros, las facturas deben guardarse en directorio de contabilidad" crlf "10. Ir a factura DTE históricos y bajar los pdf de cada DTE y luego guardarlo en el directorio de contabilidad" crlf "11. Revisar que el saldo de iva-credito cuadre con alectrico y los estados de ccm sii y con el código 77 de remanente de iva mes siguiente" crlf "12. Averiguar como se asientan los pagos de la cuenta de retenciones por pagar, creo que no se tocan" crlf "14. Ir a Cartola fiscal del tgr y revisar que no haya deudas fiscales pendientes, a veces las pasarelas dejan la cagá y los pagos aparecen por allá sin pagar" crlf "15. Agregar las tasas en el archivo de tasas" crlf)
;:  ( printout t "Diseñar deprecación instantánea de activo fijo tangible" crlf)
  ; (printout t "Hacerse parte del juicio para que el tribunal declare prescripcon de la deuda" crlf)
  ; (printout t "Requiere pago de honorarios de abogados" crlf)
  ; (printout t "Prescripcion la declara el tribunal, se pide copia certificado y voy a boletin de dicom" crlf)
  ; (printout t "Agregar todos los pagos INAPI en marca alectrico, parece que solo será el pago final" crlf)
  ; (printout t "Anotar valor marca 1$ por depreciación acelerada" crlf)
  ; (printout t "Agregar Renta empresarial para generar costo directo de mano de obra" crlf)
  ; (printout t "Agregar gastos en publicidad o promoción desde google ads" crlf)
  ; (printout t "Verificar que Google Ads genere IVA o no genere IVA pero sea contribuyente de impuesto adicional por publicidad" crlf)
  ; (printout t "Declarar ppm, listo " crlf)
  ; (printout t "Considerar incentivo al ahorro, también hay una resoución para deducir gastos del impuesto por compras de activos" clrf)
  ; (printout t "Visitar https://elrincontributario.blogspot.com" crlf)
  ; (printout t "Determinar el costo de ventas según sii, esto es por el precio más antiguo, o un sistema mixto de contablidad completa, el costo es el costo de la cuenta de mercadería" crlf)

)




