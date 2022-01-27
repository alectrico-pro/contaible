( defmodule RCV (import MAIN ?ALL ))

(deffunction mes_to_numero_2 ( ?mes )
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



(defrule final
  (declare (salience -10000))
  =>
  (dribble-off)
)

(defrule inicio-de-modulo-csv
   (declare (salience 10000))
   (empresa (nombre ?empresa))
   ( balance (mes ?mes) (ano ?ano ))
  => 
   ( printout t "----- RCV -- esto genera un archivo para complementar el registro de compra venta con documentos manuales-" crlf)
   ( bind ?archivo (str-cat ?empresa "-" ?mes "-complemento-rcv-dribble.csv"))
   ( dribble-on ?archivo)
   ( printout t "Tipo Doc;Folio;Rut Contraparte;Tasa Impuesto;Razon Social Contraparte;Tipo Impuesto[1=IVA:2=LEY 18211];Fecha Emision;Monto Exento;Monto Neto;Monto IVA (Recuperable);Cod IVA no Rec;Monto IVA no Rec;IVA Uso Comun;Cod Otro Imp (Con Credito);Tasa Otro Imp (Con Credito);Monto Otro Imp (Con Credito);Monto Otro Imp Sin Credito;Monto Activo Fijo;Monto IVA Activo Fijo;IVA No Retenido;Tabacos - Puros;Tabacos - Cigarrillos;Tabacos - Elaborados;Codigo sucursal SII;Numero Interno;Emisor/Receptor;Monto Total;Tipo Transaccion" crlf)

)

(defrule filas-csv-extranjero
   ( empresa (nombre ?empresa) )
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top ))
   ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
   ?ccm <- ( ccm (fecha-emision ?fecha&:(neq nil ?fecha)) (folio ?folio) (partida ?numero) (tipo-documento ?tipo) (monto-total ?total) (rut-contraparte ?rut) (razon-social-contraparte ?nombre) (monto-iva-recuperable ?iva) (monto-neto ?neto) (monto-exento ?exento) (tasa-impuesto ?tasa) (numero-interno ?numero-interno) (tasa-iva-retenido ?tasa-iva-retenido))
   (proveedor (nombre ?nombre) (social ?razon-social) (rut ?rut))

   (test (neq nil ?rut))
   (test (neq nil ?razon-social))
   (test (neq na ?folio))
   (test (numberp ?tipo))
   (test (eq ?mes julio))
   (test (eq 45 ?tipo))
  =>
   (printout t (str-cat ?tipo ";" (if (eq ?folio nil) then "" else ?folio) ";" ?rut ";" ?tasa ";" ?razon-social ";1;" ?fecha ";" ?exento ";" ?neto ";" ?iva ";;;;15;19;" ?iva ";;;;;;;;;;;" ?total ";1" ) crlf)
)




(defrule filas-csv
   ( no )
   ( empresa (nombre ?empresa) )
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top ))
   ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
   ?ccm <- ( ccm (fecha-emision ?fecha&:(neq nil ?fecha)) (folio ?folio) (partida ?numero) (tipo-documento ?tipo) (monto-total ?total) (rut-contraparte ?rut) (razon-social-contraparte ?nombre) (monto-iva-recuperable ?iva) (monto-neto ?neto) (monto-exento ?exento) (tasa-impuesto ?tasa) (numero-interno ?numero-interno) (tasa-iva-retenido ?tasa-iva-retenido))
   (proveedor (nombre ?nombre) (rut ?rut) (social ?razon-social) )
   (test (neq nil ?rut))
   (test (neq na ?folio))
   (test (numberp ?tipo))
   (test (neq 45 ?tipo))
   (test (eq ?mes julio))
  =>
   (printout t (str-cat ?tipo ";" (if (eq ?folio nil) then "" else ?folio) ";" ?rut ";" ?tasa ";" ?razon-social ";1;" ?fecha ";" ?exento ";" ?neto ";" ?iva ";;;;;;;" ?total ";;;;;;;;;;;;" ) crlf)
)


(defrule filas-csv-solo-verifica-los-nombres-que-no-hacen-match
   (no)
   ( empresa (nombre ?empresa) )
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top ))
   ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
   ?ccm <- ( ccm (fecha-emision ?fecha&:(neq nil ?fecha)) (folio ?folio) (partida ?numero) (tipo-documento ?tipo) (monto-total ?total) (rut-contraparte ?rut) (razon-social-contraparte ?nombre) (monto-iva-recuperable ?iva) (monto-neto ?neto) (tasa-impuesto ?tasa) (numero-interno ?numero-interno) (tasa-iva-retenido ?tasa-iva-retenido))

   (proveedor (nombre ?nombre2) )
   ( test (neq ?nombre2 ?nombre ))
  =>
   (printout t ?nombre tab ?nombre2 tab ".................." crlf)
)









