( defmodule CCM ( import MAIN ?ALL ))

(deffunction mes_to_numero_v ( ?mes )
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
   ( printout t "-------------------- CCM -----------------------------------------------------------" crlf)
   ( bind ?archivo (str-cat ?empresa "-" ?mes "-complemento-ccm-dribble.csv"))
   ( dribble-on ?archivo)

   ( printout t "Tipo Doc;Folio;Rut Contraparte;Tasa Impuesto;Razón Social Contraparte;Tipo Impuesto[1=IVA:2=LEY 18211];Fecha Emisión;Anulado[A];Monto Exento;Monto Neto;Monto IVA (Recuperable);Cod IVA no Rec;Monto IVA no Rec;IVA Uso Común;Cod Otro Imp (Con Crédito);Tasa Otro Imp (Con Crédito);Monto Otro Imp (Con Crédito);Monto Total;Monto Otro Imp Sin Crédito;Monto Activo Fijo;Monto IVA Activo Fijo;IVA No Retenido;Tabacos - Puros;Tabacos - Cigarrillos;Tabacos - Elaborados;Impuesto a Vehiculos Automóviles;Codigo sucursal SII;Numero Interno;Emisor/Receptor" crlf)

)

(defrule filas-csv-extranjero
   ( empresa (nombre ?empresa) )
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top ))
   ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
   ?ccm <- ( ccm (fecha-emision ?fecha&:(neq nil ?fecha)) (folio ?folio) (partida ?numero) (tipo-documento ?tipo) (monto-total ?total) (rut-contraparte ?rut) (razon-social-contraparte ?nombre) (monto-iva-recuperable ?iva) (monto-neto ?neto) (tasa-impuesto ?tasa) (numero-interno ?numero-interno) (tasa-iva-retenido ?tasa-iva-retenido))
   (proveedor (nombre ?nombre) (social ?razon-social) (rut ?rut))

   (test (neq nil ?rut))
   (test (neq nil ?razon-social))
   (test (neq na ?folio))
   (test (numberp ?tipo))
   (test (eq ?mes julio))
   (test (eq 45 ?tipo))
  =>
   (printout t (str-cat ?tipo ";" (if (eq ?folio nil) then "" else ?folio) ";" ?rut ";" ?tasa ";" ?razon-social ";1;" ?fecha ";;;" ?neto ";" ?iva ";;;;15;19;" ?iva ";" ?total ";;;;;;;;;;;;" ) crlf)
)




(defrule filas-csv
   ( empresa (nombre ?empresa) )
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top ))
   ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
   ?ccm <- ( ccm (fecha-emision ?fecha&:(neq nil ?fecha)) (folio ?folio) (partida ?numero) (tipo-documento ?tipo) (monto-total ?total) (rut-contraparte ?rut) (razon-social-contraparte ?nombre) (monto-iva-recuperable ?iva) (monto-neto ?neto) (monto-exento ?exento) (tasa-impuesto ?tasa) (numero-interno ?numero-interno) (tasa-iva-retenido ?tasa-iva-retenido))
   (proveedor (nombre ?nombre) (social ?razon-social) (rut ?rut))
   (test (neq nil ?rut))
   (test (neq na ?folio))
   (test (numberp ?tipo))
   (test (neq 45 ?tipo))
   (test (eq ?mes julio))
  =>
   (printout t (str-cat ?tipo ";" (if (eq ?folio nil) then "" else ?folio) ";" ?rut ";" ?tasa ";" ?razon-social ";1;" ?fecha ";;" ?exento ";" ?neto ";" ?iva ";;;;;;;" ?total ";;;;;;;;;;;;" ) crlf)
)




(defrule filas-ccm
   ( empresa (nombre ?empresa) )
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top ))
   ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
   ?ccm <- ( ccm (fecha-emision nil) (folio ?folio) (partida ?numero) (tipo-documento ?tipo-documento) (monto-total ?monto-total) (rut-contraparte ?rut) (razon-social-contraparte ?razon-social) (monto-iva-recuperable ?iva) (monto-neto ?neto))
   ?ccm-existente <- (ccm (partida ?numero ) (tipo-documento nil))
;   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   (test (neq nil ?tipo-documento))
  =>
   (modify ?ccm (fecha-emision (str-cat (if (> ?dia 9) then "" else "0") ?dia "-" (if (< (mes_to_numero ?mes) 10) then "0" else "") (mes_to_numero ?mes) "-" ?ano)))
  ; (printout t crlf (str-cat ?dia "-" ?mes) crlf)
  ; (printout t (str-cat " tipo de documento: " ?tipo-documento) crlf)
  ; (printout t (str-cat " razón social: "  ?razon-social) crlf)
 ;  (printout t (str-cat " rut: " ?rut) crlf)
  ; (printout t (str-cat " partida: " ?numero) crlf)
  ; (printout t (str-cat  " folio: " ?folio) crlf)
  ; (printout t (str-cat " monto: " ?monto-total) crlf )
  ; (printout t (str-cat " iva: " ?iva ) crlf)
  ; (printout t (str-cat " neto: " ?neto ) crlf)
)

(defrule filas-ccm-que-faltan
   (no)
   ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
   (not (exists ( ccm (partida ?numero) (tipo-documento ?tipo-documento&:(neq nil ?tipo-documento)))))
   ?ccm-existente <- (ccm (partida ?numero ) (tipo-documento nil))
  =>
   (printout t ?numero tab ?dia tab ?mes --------------------------- crlf)
)

(defrule filas-ccm-nil
   (no)
   ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
   ( ccm (partida ?numero) (tipo-documento nil))
  =>
;  (printout t ?numero tab ----nil----------------------- crlf)
)




