(defmodule ACTIVIDAD
  ( import MAIN deftemplate ?ALL )
)

(defglobal ?*partidas* = "")
(defglobal ?*iva_divisor* = 1.19 )
(defglobal ?*iva_factor*  = 1.19)


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



(defrule guardar-partidas
  (declare (salience 10000))
  (no)
  (selecciones ( origen-de-subcuentas ?origen))
  ;estas actividades están en activiaades.txt
  ;mas adelante hay que hacer algo al respecto
  ;pero, de momento, hay que agregarlas dos veces
  ;aquí y allá
  ;son los hechos economicos
  (or (gasto-administrativo             (partida ?numero))
      (gasto-proveedor                  (partida ?numero))
      (gasto-promocional                (partida ?numero))
      (venta                            (partida ?numero))
      (compra                           (partida ?numero))
      (costo-ventas                     (partida ?numero))
      (deposito                         (partida ?numero))
      (honorario                        (partida ?numero))
      (salario                          (partida ?numero))
      (devolucion                       (partida ?numero))
      (gasto-ventas                     (partida ?numero))
      (gasto-afecto                     (partida ?numero))
      (amortizacion                     (partida ?numero))
      (depreciacion                     (partida ?numero))
      (gasto-sobre-compras              (partida ?numero))
      (gasto-afecto                     (partida ?numero))
      (despago                          (partida ?numero))
      (pago                             (partida ?numero))
      (venta-anticipada                 (partida ?numero))
      (venta-sii                        (partida ?numero))
      (nota-de-credito-sii              (partida ?numero))
      (nota-de-credito                  (partida ?numero))
      (nota-de-credito-de-subcuenta-existente (partida ?numero))
      (nota-de-debito-sii               (partida ?numero))
      (nota-de-debito-manual            (partida ?numero))
      (rendicion-de-eboletas-sii        (partida ?numero))
      (rendicion-de-vouchers-sii        (partida ?numero))
      (ajuste-de-iva-contra-credito     (partida ?numero))
      (ajuste-de-iva-contra-debito      (partida ?numero))
      (pago-de-iva                      (partida ?numero))
      (pago-de-retenciones-de-honorarios (partida ?numero))
      (gasto-investigacion-y-desarrollo (partida ?numero))
      (f29                              (partida ?numero))
      (distribucion-de-utilidad         (partida ?numero))
      (constitucion-de-spa              (partida ?numero))
      (compra-de-acciones               (partida ?numero))
      (compra-de-materiales             (partida ?numero))
      (anulacion-de-vouchers            (partida ?numero))
      (nota-de-credito-de-factura-reclamada (partida ?numero))
      (cobro-de-cuentas-por-cobrar      (partida ?numero))
      (pago-de-salarios                 (partida ?numero))
      (traspaso                         (partida ?numero))
      (pedido                           (partida ?numero))
      (ajuste-anual                     (partida ?numero))
)
  

=>
  ( assert (ccm (partida ?numero)))
  ( bind ?*partidas* (str-cat *partidas* ?numero) )
  ( assert ( subcuenta (origen ?origen))) ;si real para ver las subcuentas, el balance se descuadrará
; ( printout t " partida ingresada " ?numero crlf)
)



;para cada partida que generen las reglas,
;econtar el hecho que asociado a estas
;y anotarlas con esos hechos
(defrule anotando-partidas
  (no)
  (actividad (nombre ?nombre))
  ?partida <-  (partida (numero ?numero) (hecho nil))
  =>
  (printout t seleccionando tab ?nombre crlf)
  (do-for-all-facts ((?f ?nombre)) (eq ?f:partida ?numero) 
    (printout t "Partida " ?f:partida  " responde al hecho " tab ?nombre crlf)
    (modify ?partida (hecho ?nombre))

  )    
)

(defrule anotando-partidas-compra
  ?partida <-  (partida (numero 10) (hecho nil))
  =>
   (printout t "================================================================" crlf)
   (do-for-all-facts ((?f compra)) (eq ?f:partida 10) 
    (printout t "Partida " ?f:partida  " responde al hecho compra" crlf)
    (halt)
   )
)


(defrule hechos-economicos-admitidos-como-actividad
(no)
  (actividad (nombre ?nombre))
 =>
  (do-for-all-facts ((?f ?nombre)) TRUE
;    (printout t ?f:partida crlf)
    (assert (ccm (partida ?f:partida)))
  )
)



(defrule revision-general
  (revision-general
    (partidas $?partidas))
 =>
  (printout t "Revision general hallada en el archivo <empresa>-revisiones.txt" crlf)
  (progn$  (?i ?partidas)
    (do-for-all-facts
        ((?f revision))     (eq ?i ?f:partida)
        (modify ?f ( rechazado true  ))
        (printout t "Revisión " ?f:partida " ahora indica rechazo." crlf)) )
)


(defrule inicio-actividad

  (declare (salience 10000))
  (selecciones ( origen-de-subcuentas ?origen))

  =>

  ( assert ( subcuenta (origen ?origen)))
  ( set-strategy breadth)
;  ( printout t "----- PARADO EN ACTIVIDAD -----------------------------" crlf)
 ; ( matches declarar-remuneraciones )
 ; ( halt )
)


(defrule inicio-de-los-dias
  (declare (salience 10000))
 (no)
=>
  ( set-strategy breadth)
  ( printout t "----------------- ACTIVIDAD ------------------" crlf)
 ; ( bind ?numeros ?*partidas* )
  ;estos numeros deben coincidier con los números de partida de las actividades, pero no las que estsan en la biblioteca de liquidaciones, pues estas usan una forma diferente y no hay que revisarlas, por
 ;lo que no es necesario incluir una revision en el archivo de revisiones
  ( bind ?numeros 001 01222 001111 00111 002 002111 002112 002113 003 004 005 006 007 008 009 010 011 012 013 0131 0132 014 014333 0141 01421 014111 014222 0142 0143 014444 144 015 016 017 018 019 0191 01911 0192 0193 0194 020 021 021 022 023 024 025 0251 026 0261 02612 0262 0263 027 028 0281 029 030 0301 0302 03021 0303 0304 0305 031 032 033 034 035 036 037 0371 03712 0372 0373 038 039 040 04011 04012 041 042 043 044 045 046 047 048 049 050 051 052 053 054 055 056 057 058 059 060 0601 061 062 063 064 065 066 067 068 069 070 071 072 073 074 075 076 077 078 079 080 081 082 083 084 085 086 0862 0861 0867 0868 087 088 089 090 091 092 093 094 095 096 097 098 099 100 101 102 103 104 105 106 107 108 109 110 113 114 115 116 117 118 119 120 120,1 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021 2022  2023 2024 2025 1040 1041 1042 1043 1044 1045 1046 1047 1048 1049 1050 1051 1052 1053 1054 90000 90001 90002 90003 90004 ) ;no usar 000

;NOTA: Los números del 1040-1054 no pueden falta pues son los f29 y tampoco los 9000 90001 90002
;1 120 2 3 301 4 5 6 7 8 9 10 11 12 13 14 15 151 152 153 16 17 171 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 ) ;no llega a las liquidaciones
;  ( watch facts ticket)
  ( while (> (length$ ?numeros) 0)  do
     ( bind ?numero (nth$ 1 ?numeros))
     ( assert (ticket (numero ?numero)))
     ( assert (nonce (ticket ?numero))) ;algunas reglas de actividad se disparan
                                        ;dos veces en clips 6.4
              ;hacer retract en nonce esas actividades
              ;detectada solo una:
              ;dar-cuenta-de-nota-de-credito-de-factura-reclamada
              ;la cual se puede disparar por:
              ;nota-de-credito-de-factura-reclamada
     ( bind ?numeros (rest$ ?numeros))
  )
)



(defrule abrir-pedido
   ( declare (salience 1000))
   ( actual  (mes ?mes))
   ( balance (ano ?ano))
   ?ticket <- ( ticket  (numero ?numero))
   ( pedido (partida ?numero) (id ?id) (dia ?dia) (mes ?mes) (ano ?ano))
=>
   ( printout t "Se abrió el pedido " ?id crlf)
   ( assert (partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Pedido " ?id "Abierto"  )) (actividad apertura-de-pedido) ))
)


(defrule partidas-con-gastos-promocionales-que-han-sido-rechazadas-por-sii
   ( declare (salience 1000))
   ( actual  (mes ?mes))
   ( balance (ano ?ano))
   ?ticket <- ( ticket  (numero ?numero))
   ( gasto-promocional (archivo ?archivo) (folio ?folio) (rut ?rut) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (credito ?credito) (proveedor ?proveedor) (material ?material) (total ?total) (neto ?neto) (iva ?iva) (glosa ?glosa) (iva-retenido ?iva-retenido))
   ( revision (partida ?numero) (rechazado true) (dia ?dia) (mes ?mes) (ano ?ano))
=>
   ( printout t "Partida Promocional " ?numero " Rechazado" crlf)
   ( assert (partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Gasto Promocional Rechazado"  )) (actividad rechazo) (archivo ?archivo)))
)


(defrule partidas-que-han-sido-rechazadas-por-sii-que-no-son-gastos-administrativos-o-promocionales
   ( declare (salience 1000))
   ( actual  (mes ?mes))
   ( balance (ano ?ano))
   ?ticket <- ( ticket  (numero ?numero))

   (not ( gasto-administrativo (partida ?numero) ) )
   (not ( gasto-promocional    (partida ?numero) ) )

   ( revision (partida ?numero) (rechazado true) (dia ?dia) (mes ?mes) (ano ?ano))
=>
   ( printout t "Partida " ?numero " Rechazada" crlf)
   ( assert (partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Partida rechazada"  )) (actividad rechazo) ))
)



(defrule partidas-con-gastos-administrativos-que-han-sido-rechazadas-por-sii
   ( declare (salience 1000))
   ( actual  (mes ?mes))
   ( balance (ano ?ano))
   ?ticket <- ( ticket  (numero ?numero))

   ( gasto-administrativo (archivo ?archivo) (folio ?folio) (rut ?rut) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (credito ?credito) (proveedor ?proveedor) (material ?material) (total ?total) (neto ?neto) (iva ?iva) (glosa ?glosa) (iva-retenido ?iva-retenido))
   ( revision (partida ?numero) (rechazado true) (dia ?dia) (mes ?mes) (ano ?ano))
=>
   ( printout t "Gasto Administrativo " ?numero " Rechazado" crlf)
   ( assert (partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Gasto Administrativo Rechazado"  )) (actividad rechazo) (archivo ?archivo)))
)



(defrule determinacion-perdida-ejercicio-anterior-pea
   ( revision
    (partida ?numero) 
    (rechazado false)
   )

   ( actual  (mes ?mes))
   ( balance (ano ?ano_top))
   ( ticket  (numero ?numero))
   ( pea     (partida ?numero ))
   ( empresa (nombre ?empresa ))
   ( cuenta  (nombre utilidad ) (haber ?haber) (debe ?pea) (dia ?dia) (mes ?mes) (ano ?ano))
   ( test (> ?pea 0))
   ( test (= ?haber 0))
=>
   ( assert (partida (numero ?numero) (mes ?mes) (dia ?dia) (ano ?ano) (descripcion (str-cat "Por traspaso de utilidad a Pérdida del Ejercicio Anterior "  ?pea)) (actividad determinacion-pea)))
   ( assert (cargo (electronico false) (tipo-de-documento traspaso) (cuenta perdidas-ejercicios-anteriores) (partida ?numero) (empresa ?empresa) (monto ?pea) (dia ?dia) (mes ?mes) (ano ?ano) (glosa (str-cat pea- ?pea)) ))
   ( assert (abono (electronico false) (tipo-de-documento traspaso) (cuenta utilidad) (partida ?numero) (empresa ?empresa) (monto ?pea) (dia ?dia) (mes ?mes) (ano ?ano) (glosa (str-cat pea- ?pea))))
   ( printout t "Determinando la Pérdida del Ejercicio Anterior "  ?pea crlf )
)

(defrule distribucion-de-utilidades-del-ejercicio-anterior-a-cuenta-destino
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( actual  (mes ?mes))
   ( balance (ano ?ano_top))
   ( ticket  (numero ?numero))
    ?d <-   ( distribucion-de-utilidad (dia ?dia) (mes ?mes) (ano ?ano) (monto ?monto) (partida ?numero ) (cuenta-de-destino ?cuenta-de-destino) (archivo ?archivo))
   ( empresa (nombre ?empresa ))
;   ( cuenta  (nombre utilidad ) (haber ?utilidad) ) ;esto interfiere con las liquidaciones
   ( cuenta  (nombre utilidad-del-ejercicio-anterior)  (haber ?utilidad))
   ( cuenta  (nombre ?cuenta-de-destino) (haber ?haber))
  ; ( test (> ?utilidad 0))
 ;  ( test (= ?haber 0))
;   ( test (> ?utilidad ?monto))
=>
   ( retract ?d )
   ( assert (partida (archivo ?archivo) (numero ?numero) (mes ?mes) (dia ?dia) (ano ?ano) (descripcion (str-cat "Por traspaso de utilidad a Capital Social "  ?monto)) (actividad distribucion-utilidad)))
   ( assert (abono (electronico false) (tipo-de-documento traspaso) (cuenta ?cuenta-de-destino) (partida ?numero) (empresa ?empresa) (monto ?monto) (dia ?dia) (mes ?mes) (ano ?ano) (glosa (str-cat distribucion-utilidad- ?monto)) ))
   ( assert (cargo (electronico false) (tipo-de-documento traspaso) (cuenta utilidad-del-ejercicio-anterior) (partida ?numero) (empresa ?empresa) (monto ?monto) (dia ?dia) (mes ?mes) (ano ?ano) (glosa (str-cat distribucion-utilidad- ?monto))))
   ( assert (ccm (folio na) (partida ?numero) (tipo-documento traspaso) (monto-total ?monto)))
   ( printout t "Distribución Utilidad del Ejercicio Anterior "  ?monto crlf )
)

;La cuenta de origen se carga y la de destino se abona
(defrule traspasar-deudor
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( actual  (mes ?mes))
   ( balance (ano ?ano_top))
   ( ticket  (numero ?numero))
   ( traspaso (partida ?numero ) (dia ?dia) (mes ?mes) (ano ?ano) (cuenta-de-origen ?cuenta-de-origen) (cuenta-de-destino ?cuenta-de-destino))
   ( empresa (nombre ?empresa ))
   ( cuenta  (nombre ?cuenta-de-origen ) (debe ?debe_o) (haber ?haber_o))
   ( cuenta  (nombre ?cuenta-de-destino) )
   ( test (> ?debe_o ?haber_o))
=>
   ( bind ?saldo (- ?debe_o ?haber_o))
   ( assert (partida (numero ?numero) (mes ?mes) (dia ?dia) (ano ?ano) (descripcion (str-cat "Por traspaso de " ?saldo " de: " ?cuenta-de-origen " a: " ?cuenta-de-destino )) (actividad traspaso-deudor)))
   ( assert (cargo (electronico false) (tipo-de-documento traspaso) (cuenta ?cuenta-de-destino) (partida ?numero) (empresa ?empresa) (monto ?saldo) (dia ?dia) (mes ?mes) (ano ?ano) (glosa (str-cat traspaso- ?saldo)) ))
   ( assert (abono (electronico false) (tipo-de-documento traspaso) (cuenta ?cuenta-de-origen) (partida ?numero) (empresa ?empresa) (monto ?saldo) (dia ?dia) (mes ?mes) (ano ?ano) (glosa (str-cat traspaso- ?saldo))))
   ( assert (ccm (folio na) (partida ?numero) (tipo-documento traspaso) (monto-total ?saldo)))
   ( printout t "Traspaso de " ?saldo " de: " ?cuenta-de-origen " a: " ?cuenta-de-destino  crlf )
)



(defrule traspasar-acreedor
   ( revision
    (partida ?numero)
    (rechazado false)
   )

   ( actual  (mes ?mes))
   ( balance (ano ?ano_top))
   ( ticket  (numero ?numero))
   ( traspaso (partida ?numero ) (dia ?dia) (mes ?mes) (ano ?ano) (cuenta-de-origen ?cuenta-de-origen) (cuenta-de-destino ?cuenta-de-destino))
   ( empresa (nombre ?empresa ))
   ( cuenta  (nombre ?cuenta-de-origen ) (debe ?debe_o) (haber ?haber_o))
   ( cuenta  (nombre ?cuenta-de-destino) )
   ( test (< ?debe_o ?haber_o))
=>
   ( bind ?saldo (- ?haber_o ?debe_o))
   ( assert (partida (numero ?numero) (mes ?mes) (dia ?dia) (ano ?ano) (descripcion (str-cat "Por traspaso de " ?saldo " de: " ?cuenta-de-origen " a: " ?cuenta-de-destino )) (actividad traspaso-acreedor)))
   ( assert (abono (electronico false) (tipo-de-documento traspaso) (cuenta ?cuenta-de-destino) (partida ?numero) (empresa ?empresa) (monto ?saldo) (dia ?dia) (mes ?mes) (ano ?ano) (glosa (str-cat traspaso- ?saldo)) ))
   ( assert (cargo (electronico false) (tipo-de-documento traspaso) (cuenta ?cuenta-de-origen) (partida ?numero) (empresa ?empresa) (monto ?saldo) (dia ?dia) (mes ?mes) (ano ?ano) (glosa (str-cat traspaso- ?saldo))))
   ( assert (ccm (folio na) (partida ?numero) (tipo-documento traspaso) (monto-total ?saldo)))
   ( printout t "Traspaso de " ?saldo " de: " ?cuenta-de-origen " a: " ?cuenta-de-destino  crlf )
)





(defrule gastos-en-movilizacion
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( actual  (mes ?mes))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( ticket ( numero ?numero))
   ( empresa (nombre ?empresa ))
   ?f1 <- (movilizacion (folio ?folio) (proveedor ?proveedor) (partida ?numero) (monto ?monto ) (mes ?mes) (dia ?dia) (ano ?ano)) 
   ( test (> ?monto 0))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
=>
   ( retract ?f1 )
   ( assert (partida (numero ?numero) (mes ?mes) (dia ?dia) (ano ?ano) (actividad gastos-en-movizacion) (descripcion (str-cat "Gastos en Movilización Día " ?ano " de " ?mes " " ?dia ))))
   ( assert (abono (tipo-de-documento caja-chica) (cuenta banco-estado) (partida ?numero) (empresa ?empresa) (monto ?monto) (dia ?dia) (mes ?mes) (ano ?ano) (glosa (str-cat gasto-de-movilizacion-pagado-a ?proveedor))) )
   ( assert (cargo (tipo-de-documento caja-chica) (cuenta gastos-en-movilizacion) (partida ?numero) (empresa ?empresa) (monto ?monto) (dia ?dia) (mes ?mes) (ano ?ano) (glosa (str-cat (str-cat gasto-en-movilizacion-pagado-a-) ?proveedor))))

   ( printout t "Gastando en Movilizacion correspondiente a:" ?monto crlf )
)


(defrule depositar-en-cuenta-corriente
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( actual  (mes ?mes))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( ticket ( numero ?numero))
   ( empresa (nombre ?empresa ))
   ?f1 <- (deposito (partida ?numero) (banco ?banco) (monto ?monto ) (mes ?mes) (dia ?dia) (ano ?ano) (glosa ?glosa))
   ( test (> ?monto 0))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
=>
   ( retract ?f1 )
   ( assert (partida (numero ?numero) (mes ?mes) (dia ?dia) (ano ?ano) (descripcion ?glosa) (actividad depositar-en-cuenta-corriente)))
   ( assert (cargo (tipo-de-documento deposito-banco) (cuenta ?banco) (partida ?numero) (empresa ?empresa) (monto ?monto) (dia ?dia) (mes ?mes) (ano ?ano) (glosa (str-cat (str-cat (str-cat deposito-en-banco- ?banco) -por-) ?monto))))
   ( assert (abono (tipo-de-documento deposito-banco) (cuenta caja) (partida ?numero) (empresa ?empresa) (monto ?monto) (dia ?dia) (mes ?mes) (ano ?ano) (glosa (str-cat (str-cat (str-cat deposito-en-banco- ?banco) -por-) ?monto))))
   ( assert (ccm (folio na) (partida ?numero) (tipo-documento deposito-en-banco) (monto-total ?monto)))

   ( printout t "Depositando en " ?banco " por un valor de $" ?monto crlf )
)

(defrule cobrar-cuentas-por-cobrar
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( actual  (mes ?mes))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( ticket ( numero ?numero))
   ( empresa (nombre ?empresa ))
   ?f1 <- (cobro-de-cuentas-por-cobrar (partida ?numero) (monto ?monto ) (mes ?mes) (dia ?dia) (ano ?ano) (glosa ?glosa))
   ( test (> ?monto 0))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  => 
   ( retract ?f1 )
   ( assert (partida (proveedor cuentas-por-cobrar) (numero ?numero) (mes ?mes) (dia ?dia) (ano ?ano) (descripcion ?glosa) (actividad pagar-monto)))
   ( assert (abono (tipo-de-documento abono-transbank) (cuenta clientes) (partida ?numero) (empresa ?empresa) (monto ?monto) (dia ?dia) (mes ?mes) (ano ?ano) (glosa cobro-de-cuenta-por-cobrar)))
   ( assert (cargo (tipo-de-documento abono-transbank) (cuenta cuentas-por-cobrar) (partida ?numero) (empresa ?empresa) (monto ?monto) (dia ?dia) (mes ?mes) (ano ?ano) (glosa cobro-de-cuentas-por-cobrar)))
   ( printout t crlf crlf "Cobrando a cuentas-por-cobrar por un valor de $" ?monto crlf)
)


(defrule pagar-monto
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( actual  (mes ?mes))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( ticket ( numero ?numero))
   ( empresa (nombre ?empresa ))
   ?f1 <- (pago (partida ?numero) (cliente ?proveedor) (servicio ?servicio) (monto ?monto ) (mes ?mes) (dia ?dia) (ano ?ano) (glosa ?glosa))
   ( test (> ?monto 0))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  =>
   ( retract ?f1 )
   ( assert (partida (proveedor ?proveedor) (numero ?numero) (mes ?mes) (dia ?dia) (ano ?ano) (descripcion ?glosa) (actividad pagar-monto)))
   ( assert (cargo (cuenta banco-estado) (partida ?numero) (empresa ?empresa) (monto ?monto) (dia ?dia) (mes ?mes) (ano ?ano) (glosa (str-cat (str-cat (str-cat pago-a- ?proveedor) -por-) ?servicio))))
   ( assert
   ( cuenta (nombre ?proveedor)
       (empresa ?empresa )
       (partida ?numero)
       (dia ?dia)
       (mes ?mes)
       (ano ?ano)
       (descripcion deudas-con-este-proveedor)
       (tipo acreedora)
       (grupo pasivo)
       (circulante true)
       (padre clientes)
       (naturaleza acreedora)
       (origen nominativo))
   )
   ( assert (abono (cuenta ?proveedor) (partida ?numero) (empresa ?empresa) (monto ?monto) (dia ?dia) (mes ?mes) (ano ?ano) (glosa (str-cat (str-cat (str-cat pago-a- ?proveedor) -por-) ?servicio))))
   ( assert (ccm (folio na) (partida ?numero) (tipo-documento pago) (monto-total ?monto)))
   ( printout t crlf crlf "Pagando a  " ?proveedor " por un valor de $" ?monto crlf) 
)


(defrule pagar-honorarios
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( actual  (mes ?mes))
  
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
  
   ( ticket  ( numero ?numero) )
   ( empresa (nombre ?empresa ))
   ?honorario <- (honorario (partida ?numero) (dia ?dia) (profesional ?profesional) (servicio ?servicio) (bruto ?bruto ) (mes ?mes) (ano ?ano) (glosa ?glosa))
   ( tasas (honorarios ?tasa-honorario) (mes ?mes) (ano ?ano))
   ( test (> ?bruto 0))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  =>
   ( retract ?honorario )
   ( assert (dia ?dia))
   ( bind ?impuesto (round (* ?tasa-honorario ?bruto) ))
   ( bind ?neto (- ?bruto ?impuesto))
   ( assert  (partida (proveedor ?profesional) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad pagar-honorarios)))

   ( assert (abono (tipo-de-documento pago-de-honorarios) (cuenta banco-estado) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?neto) (glosa (str-cat pago-a- ?profesional -por- ?servicio))))

   ( assert (cargo (tipo-de-documento pago-de-honorarios) (cuenta honorarios) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?bruto) (glosa (str-cat pago-a- ?profesional -por- ?servicio))))

   ( assert (abono (tipo-de-documento pago-de-honorarios) (cuenta retenciones-por-pagar) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?impuesto) (glosa (str-cat pago-a- ?profesional -por- ?servicio))))

   ( assert (ccm (folio na) (partida ?numero) (tipo-documento honorario) (monto-total ?bruto)))
   ( printout t "--> salario-- Pagando a " ?profesional " por un valor bruto de $" ?bruto crlf )     
)



(defrule declarar-remuneraciones
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))
   ( ticket  ( numero ?numero) )
   ( empresa (nombre ?empresa ))

   ?salario <- (salario (nombre ?nombre) (partida ?numero) (dia ?dia) (departamento ?departamento) (servicio ?servicio) (efectivo ?efectivo ) (mes ?mes) (ano ?ano) (glosa ?glosa))

   ( exists (contrato (trabajador ?nombre)))

   ( remuneracion
     ( trabajador ?nombre)
     ( mes ?mes)
     ( ano ?ano)
     ( monto ?imponible)
     ( dias-trabajados ?dias-trabajados)
     ( semana-corrida ?semana-corrida)
     ( declarada ?declarada )
     ( pagada ?pagada)
     ( impuesta ?impuesta)  )

   ( trabajador
     ( diaria ?diaria)
     ( mes-inicio ?mes-inicio)
     ( ano-inicio ?ano-inicio)
     ( mes-fin ?mes-fin)
     ( ano-fin ?ano-fin)
     ( nombre ?nombre)
     ( afp ?afp)
     ( salud ?salud)
     ( duracion ?duracion)  )

   ( afp
      (mes ?mes)
      (ano ?ano)
      (nombre ?afp )
      (comision ?comision)
      (sis ?sis)  )

   ( salud
      (nombre ?salud)
      (cotizacion ?cotizacion)  )

   ( afc
     (duracion ?duracion)
     (aporte-empleador  ?aporte-empleador)
     (aporte-trabajador ?aporte-trabajador))

   ( tasas (utm ?utm)
     (mes ?mes_top)
     (ano ?ano_top))

   ( tramo-impuesto-unico
     (exento-en-utm ?exento-en-utm)
     (tasa ?tasa-unico))

   ( test (> ?efectivo 0))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

   ( and
    ( test (<= (to_serial_date 31 ?mes-inicio ?ano-inicio) (to_serial_date 31 ?mes ?ano)))
    ( test (>= (to_serial_date 31 ?mes-fin ?ano-fin)       (to_serial_date 31 ?mes ?ano)))
   )


  =>
   ( bind ?afc (+ ?aporte-empleador ?aporte-trabajador))
   ( assert (dia ?dia))
   ( bind ?sueldo (* ?diaria (+ ?dias-trabajados ?semana-corrida)))
   ( if (neq ?sueldo ?efectivo)
     then
   (printout t "El efectivo en el pago de salarios en partida " ?numero " debe ser igual al sueldo: " ?sueldo  crlf)
   (halt )
   )
   ( printout t crlf)
   ( printout t "======= " ?mes " ============================" crlf)
   ( printout t "---- " ?mes tab ?nombre " -----" crlf )
   ( printout t d.trabajados: tab ?dias-trabajados crlf)
   ( printout t sem.-corrida: tab ?semana-corrida crlf)
   ( printout t sueldo bruto: tab ?sueldo crlf)


   (bind ?tramo-exento (* ?exento-en-utm ?utm 1000))
   ( if (> ?sueldo ?tramo-exento)
    then
     ( bind ?imponible (- ?sueldo ?tramo-exento))
     ( bind ?monto-unico (* ?tramo-exento ?tasa-unico))
     ( printout t "El sueldo es mayor que el tramo exento, hay impuesto único" crlf)
       else
     ( bind ?monto-unico 0)
     
   )

   ( assert (partida (proveedor ?departamento) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Declaración de Remuneraciones de " ?nombre " días trabajados: " ?dias-trabajados " Tramo Exento: " ?tramo-exento " Sueldo Bruto de: " ?sueldo " Tasa de Impuesto Único: " ?tasa-unico " Monto de Impuesto Único: " ?monto-unico)) (actividad declarar-remuneraciones)))


   ( printout t previsio-afp: tab tab (round (* ?sueldo 0.10)) crlf)
   ( printout t comision-afp: tab tab (round (* ?sueldo ?comision)) crlf)
   ( printout t .....oblig.":" tab (round (* ?sueldo (+ 0.10 ?comision))) crlf)
   ( printout t comision-afc: tab (round (* ?sueldo ?afc)) crlf)
   ( printout t cotizac.sis.: tab (round (* ?sueldo ?sis)) crlf)
   ( printout t cotiza.salud: tab (round (* ?sueldo ?cotizacion)) crlf)
   ( printout t "-------------------------" crlf)
   ( printout t AFP:   tab (round (* ?sueldo (+ 0.10 ?comision ?sis ?afc))) crlf)F
   ( printout t SALUD: tab (round (* ?sueldo ?cotizacion)) crlf)
   ( printout t TOTAL: tab (round (* ?sueldo (+ 0.10 ?comision ?sis ?cotizacion ?afc))) crlf)
   ( printout t LIQUI: tab (round (- ?sueldo (round ?monto-unico) (* ?sueldo (+ 0.10 ?comision ?sis ?cotizacion ?afc)))) crlf)

   ( bind ?afp (round (* ?sueldo (+ 0.10 ?comision ?sis ?afc))) )
   ( bind ?salud (round (* ?sueldo ?cotizacion)))
   ( bind ?total (round (* ?sueldo (+ 0.10 ?comision ?sis ?cotizacion ?afc)))) 
   ( bind ?liquido (round (- ?sueldo (round ?monto-unico) (* ?sueldo (+ 0.10 ?comision ?sis ?cotizacion ?afc)))) )

   ( bind ?entidades (+ ?afp ?salud ))

   ( printout t "========" ?mes "===========================" crlf)
   ( printout t "EN FORMATO DE PLANILLAS PREVIRED: " crlf)
   ( printout t " PLANILLA AFP " crlf)
   ( printout t " Cotización. Obligatoria " tab (round (* ?sueldo (+ 0.10 ?comision))) crlf)
   ( printout t " Seguro Invalidez y Sobrevivencia (SIS) " tab ?sis crlf)
   ( printout t " SubTotal a Pagar Fondo de Pensiones (AFP) " tab (round (* ?sueldo (+ 0.10 ?comision ?sis ))) crlf)
   ( printout t " Comisión AFP " (* ?comision 100) "%" tab (* ?comision ?sueldo) crlf)
   ( printout t " ---- " crlf)
   ( printout t " Resumen Cotizaciones Fondo de Cesantía (AFC" crlf)
   ( printout t "  Cotizacion afiliado " crlf)
   ( printout t "  Cotizacion Empleador " crlf)
   ( printout t "Total a Pagar al Fondo de Cesantía" tab (* ?afc 100) "%" tab  (* ?sueldo ?afc) crlf)
   ( printout t " PLANILLA SALUD " crlf)
   ( printout t " Cotización Legal " tab ?salud crlf)
   ( printout t (if (eq ?declarada true ) then DECLARADA else NO-DECLARADA ) tab )
   ( printout t (if (eq ?pagada true ) then PAGADA else NO-PAGADA ) tab )
   ( printout t (if (eq ?impuesta true ) then IMPUESTA else NO-IMPUESTA ) crlf)


   ( printout t crlf)



  ( assert (abono (tipo-de-documento declaracion*remuneraciones) (cuenta entidades-previsionales-por-pagar) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?entidades) (glosa (str-cat (str-cat (str-cat pago-a- ?departamento) -por-) ?servicio))))


  ;atencion: si coloco tipo-de-documento en declaracion-remuneraciones, el abono no se propaga a salarios-por-pagar
  ( assert (abono (tipo-de-documento declaracion°remuneraciones) (cuenta remuneraciones-por-pagar) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?liquido) (glosa (str-cat (str-cat (str-cat pago-a- ?departamento) -por-) ?servicio))))


  ( assert (cargo (tipo-de-documento declaracion-remuneraciones) (cuenta salarios) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?sueldo) (glosa (str-cat (str-cat (str-cat pago-a- ?departamento) -por-) ?servicio))))

  ( assert (abono (tipo-de-documento declaracion-remuneraciones) (cuenta impuesto-unico-por-pagar) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?monto-unico) (glosa (str-cat (str-cat (str-cat pago-a- ?departamento) -por-) ?servicio))))

   ( assert (ccm (folio na) (partida ?numero) (tipo-documento decl-de-remuner.) (monto-total ?efectivo)))
   ( printout t "-->salario -- Declarando Salarios " ?departamento " por un valor de $" ?efectivo crlf) 
)


(defrule pagar-solo-imposiciones
   ( revision
    (partida ?numero)
    (rechazado false)
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))
   ( ticket  ( numero ?numero) )
   ( empresa (nombre ?empresa ))

   ( pago-de-salarios (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano)
     (referencia ?referencia)
     (remuneraciones false)
     (imposiciones true)
     (trabajador ?trabajador)
     (remuneracion ?remuneracion)
     (folio-prevision ?folio)
     (salud ?salud)
     (afp   ?afp)
     (afc   ?afc)
     (unico ?impuesto-unico)
   )
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  =>
   ( bind ?prevision (+ ?salud ?afc ?afp))

   ( assert (partida (referencia ?referencia) (proveedor ?trabajador) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion pagando-imposiciones) (actividad pagar-solo-imposiciones) ))

   ( assert (cargo (tipo-de-documento previred) (cuenta entidades-previsionales-por-pagar) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?prevision) ))

   ( assert (abono (tipo-de-documento traspaso) (cuenta banco-estado) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?prevision) (glosa (str-cat "Pago-de-" ?trabajador "-por-" ?prevision))))
   ( assert (ccm (folio na) (partida ?numero) (tipo-documento traspaso) (monto-total ?prevision)))
  ( printout t "-->pago-de-imposiciones -- Pagando imposiciones de " ?trabajador " por "  ?prevision crlf)
)





(defrule pagar-solo-remuneraciones
   ( revision
    (partida ?numero)
    (rechazado false)
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))
   ( ticket  ( numero ?numero) )
   ( empresa (nombre ?empresa ))

   ( pago-de-salarios (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano)
     (referencia ?referencia)
     (remuneraciones true)
     (imposiciones false)
     (trabajador ?trabajador)
     (remuneracion ?remuneracion)
     (folio-prevision ?folio)
     (salud ?salud)
     (afp   ?afp)
     (afc   ?afc)
     (unico ?impuesto-unico)
   )
  ; ( test (> ?haber_previsionales ?debe_previsionales))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

  =>
   ( bind ?prevision (+ ?salud ?afc ?afp))
   ( bind ?total ( + ?remuneracion ?impuesto-unico))
   ( assert (partida (referencia ?referencia) (proveedor ?trabajador) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion pagando-remuneraciones) (actividad pagar-solo-remuneraciones) ))


   ( assert (cargo (tipo-de-documento previred°remuneraciones) (cuenta remuneraciones-por-pagar ) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?remuneracion) (glosa (str-cat "Pago-a-" ?trabajador "-por-" ?remuneracion))))

   ( assert (cargo (tipo-de-documento previred°impuesto-unico) (cuenta impuesto-unico-por-pagar) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?impuesto-unico) (glosa (str-cat "Pago-a-" ?trabajador "-por-" ?impuesto-unico))))

   ( assert (abono (tipo-de-documento (str-cat previred° ?trabajador)) (cuenta banco-estado) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?total) (glosa (str-cat "Pago-a-" ?trabajador "-por-" ?total))))

   ( assert (ccm (folio na) (partida ?numero) (tipo-documento previred) (monto-total ?total)))
  ( printout t "-->pago-de-remuneraciones -- Pagando solo remuneraciones de " ?trabajador " por "  ?total crlf)
)



(defrule pagar-salarios
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))
   ( ticket  ( numero ?numero) )
   ( empresa (nombre ?empresa ))

   ( pago-de-salarios (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano)
     (referencia ?referencia)
     (remuneraciones true)
     (imposiciones true)
     (trabajador ?trabajador)
     (remuneracion ?remuneracion)
     (folio-prevision ?folio)
     (salud ?salud)
     (afp   ?afp)
     (afc   ?afc)
     (unico ?impuesto-unico)
   )

  ; ( test (> ?haber_previsionales ?debe_previsionales))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

  =>
   ( bind ?prevision (+ ?salud ?afc ?afp))
   ( bind ?total ( + ?prevision ?remuneracion ?impuesto-unico))

   ( assert (partida (referencia ?referencia) (proveedor ?trabajador) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion pagando-salarios) (actividad pagar-salarios) (archivo (str-cat "../previred-prevision-" ?folio ".png" ))))

   ( assert (cargo (tipo-de-documento previred°salarios) (cuenta entidades-previsionales-por-pagar) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?prevision) ))

   ( assert (cargo (tipo-de-documento previred°salarios) (cuenta remuneraciones-por-pagar ) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?remuneracion) (glosa (str-cat "Pago-a-" ?trabajador "-por-" ?remuneracion))))

   ( assert (cargo (tipo-de-documento previred°salarios) (cuenta impuesto-unico-por-pagar) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?impuesto-unico) (glosa (str-cat "Pago-a-" ?trabajador "-por-" ?impuesto-unico))))


   ( assert (abono (tipo-de-documento previred°salarios) (cuenta banco-estado) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?total) (glosa (str-cat "Pago-a-" ?trabajador "-por-" ?total))))

   ( assert (ccm (folio na) (partida ?numero) (tipo-documento previred°salarios) (monto-total ?total)))
  ( printout t "-->pago-de-salario -- Pagando salarios de " ?trabajador " por "  ?total crlf)
)





(defrule comprar-intangible
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))

   ( ticket ( numero ?numero))
   ( empresa (nombre ?empresa))
   
?f1 <- (compra 
            (folio ?folio)
            (archivo ?archivo)
            (rut ?rut)
            (qty ?qty)
            (tipo-de-documento ?tipo-de-documento)
            (partida ?numero)
            (credito ?credito)
            (dia ?dia)
            (mes ?mes)
            (ano ?ano)
            (neto ?neto)
            (total ?total)
            (iva ?iva)
            (proveedor ?proveedor)
            (material ?material)
            (intangible true)
            (glosa ?glosa) )
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

  =>
   ( retract ?f1 )
   ( assert
    ( cuenta (nombre ?material)
       (partida ?numero) 
       (empresa ?empresa )
       (dia ?dia)
       (mes ?mes) 
       (ano ?ano)
       (descripcion ?material)
       (tipo deudor) 
       (grupo activo)
       (circulante false)
       (padre intangibles)
       (origen nominativo))
   )

   ( if (neq nil ?archivo)
     then
     ( assert (partida (archivo ?archivo) (proveedor ?proveedor) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad comprar-intangible) ))
     else
     ( assert (partida (archivo (str-cat "../factura-" ?proveedor "-" ?folio ".png")) (proveedor ?proveedor) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad comprar-intangible) ))
   )


   ( assert (cargo (tipo-de-documento ?tipo-de-documento) (qty ?qty) (cuenta ?material) (partida ?numero) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (monto ?total) (glosa (str-cat (str-cat  ?material -<<-) ?proveedor) )))
   ( assert (abono (qty ?qty) (tipo-de-documento ?tipo-de-documento) (cuenta banco-estado)  (partida ?numero)   (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (monto ?total) (glosa (str-cat (str-cat (str-cat compra-al-contado-de- ?material) -a-) ?proveedor) )))
   ( assert (ccm (folio na) (partida ?numero) (tipo-documento ?tipo-de-documento) (monto-total ?total) (rut-contraparte ?rut) (monto-neto ?neto)))
   ( printout t "-->ci comprando intangible " ?material " por un valor total de " ?total crlf  )
)


(defrule comprar-activos-fijos-al-contado
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))

   ( ticket ( numero ?numero))
   ( empresa (nombre ?empresa))
   ?f1 <- (compra
            (archivo ?archivo)
            (folio ?folio)
            (rut ?rut)
            (tipo-de-documento ?tipo-de-documento)
            (partida ?numero)
            (credito ?credito)
            (unidades ?unidades)
            (costo_unitario ?costo_unitario)
            (dia ?dia)
            (mes ?mes)
            (ano ?ano)
            (proveedor ?proveedor)
            (material ?material)
            (activo-fijo true)
            (total ?total)
            (neto ?neto)
            (iva ?iva)
            (glosa ?glosa) )
   (test (not (eq nil ?material)))
   (test (and (not (eq nil ?total)) (> ?total 0)))
   (test (and (not (eq nil ?neto)) (> ?neto 0)))
   (test (and (not (eq nil ?iva)) (> ?iva 0)))
   (test (eq ?credito 0))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
 =>
   ( retract ?f1 )

   ( assert (partida (proveedor ?proveedor) (numero ?numero) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad comprar-activos-fijos-al-contado) (archivo ?archivo)  ))
   ( assert (cargo (recibida true)  (activo-fijo true) (tipo-de-documento ?tipo-de-documento) (cuenta herramientas) (partida ?numero) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (monto ?neto) (glosa (str-cat (str-cat  ?material -<<-) ?proveedor) )))
   ( assert (abono (recibida true) (activo-fijo true) (tipo-de-documento ?tipo-de-documento) (cuenta banco-estado)  (partida ?numero)   (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (monto ?total) (glosa (str-cat (str-cat (str-cat compra-al-contado-de-activo-fijo ?material) -a-) ?proveedor) )))
   ( assert (cargo (recibida true) (activo-fijo true) (tipo-de-documento ?tipo-de-documento) (cuenta iva-credito) (partida ?numero) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (monto ?iva)  (glosa (str-cat por-compra-de-activo-fijo-de- ?material)) ) )
   ( assert (cargo (recibida true) (cuenta depreciacion-instantanea-de-activos-fijos-propyme) (partida ?numero) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (monto ?neto) (glosa 'depreciacion-instantanea-de-activo-fijo')))

;   ( assert (inventario (operacion compra) (empresa ?empresa) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (ct ?neto) (u ?unidades) (cu ?costo_unitario) (material ?material)(proveedor ?proveedor) (glosa (str-cat por-compra-de-activo-fijo-de- ?material)) ) )

   ( assert (ccm (folio ?folio) (partida ?numero) (tipo-documento ?tipo-de-documento) (monto-total ?total) (monto-iva-recuperable ?iva) (rut-contraparte ?rut) (razon-social-contraparte ?proveedor) (monto-neto ?neto)  ) )


   ( printout t "-->cafc comprando activo-fijo al contado " ?material " por un valor total de " ?total crlf  )
   ( printout t "       pagado a " ?proveedor crlf)

)


(defrule comprar-acciones
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))
   ( ticket ( numero ?numero))
   ( empresa (nombre ?empresa))

   ?cede <- ( accionista
     (nombre ?cedente)
     (numero-de-acciones ?acciones-cedente)
   )

   ?compra <- ( accionista
     (nombre ?comprador)
     (numero-de-acciones ?acciones-comprador)
   ) 

  ?c <- (compra-de-acciones
    (dia ?dia)
    (mes ?mes)
    (ano ?ano)
    (partida ?numero)
    (comprador ?comprador)
    (cedente ?cedente)
    (numero-de-acciones ?numero-de-acciones)
    (valor-nominal ?valor-nominal)
    (realizada false)
   )

   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ( test (>= ?acciones-cedente ?numero-de-acciones))
 =>
   ( modify ?c (realizada true))
   ( assert (partida (proveedor ?cedente) (numero ?numero) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat  "ca -> " ?comprador " Compra " ?numero-de-acciones " acciones a " ?cedente " por un valor nominal de " ?valor-nominal  )) (actividad comprar-acciones)))

   ( assert
    ( cuenta (nombre ?cedente)
       (partida ?numero)
       (empresa ?empresa )
       (dia ?dia)
       (mes ?mes)
       (ano ?ano)
       (descripcion ?cedente)
       (tipo acreedora)
       (grupo resultado)
       (circulante true)
       (padre acciones)
       (origen nominativo))
   )


   ( assert
    ( cuenta (nombre ?comprador)
       (partida ?numero)
       (empresa ?empresa )
       (dia ?dia)
       (mes ?mes)
       (ano ?ano)
       (descripcion ?comprador)
       (tipo acreedora)
       (grupo resultado)
       (circulante true)
       (padre acciones)
       (origen nominativo))
   )

   ( modify ?cede (numero-de-acciones (- ?acciones-cedente ?numero-de-acciones)  ) (valor-nominal ?valor-nominal))

   ( modify ?compra (numero-de-acciones (+ ?acciones-comprador ?numero-de-acciones) ) (valor-nominal ?valor-nominal))

   ( assert (abono (tipo-de-documento contrato-de-compraventa-de-acciones) (cuenta ?cedente) (partida ?numero) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (monto (* ?numero-de-acciones ?valor-nominal)) (glosa (str-cat (str-cat  acciones -<<-) ?cedente) )))

   ( assert (cargo (tipo-de-documento contrato-de-compraventa-de-acciones) (cuenta ?comprador) (partida ?numero) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (monto (* ?numero-de-acciones ?valor-nominal)) (glosa (str-cat (str-cat  acciones -<<-) ?cedente) )))

   ( printout t "ca -> " ?comprador " Compra " ?numero-de-acciones " acciones a " ?cedente " por un valor nominal de " ?valor-nominal crlf)

   ( assert (accionario (operacion compra) (empresa ?empresa) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (ct (* ?numero-de-acciones ?valor-nominal)) (u ?numero-de-acciones) (cu ?valor-nominal) (material (str-cat acciones-de- ?comprador )) (proveedor ?cedente) (cliente nil) (glosa (str-cat por-compra-de-acciones-a- ?cedente)) ) )

   ( assert (accionario (operacion venta) (empresa ?empresa) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (ct (* ?numero-de-acciones ?valor-nominal)) (u ?numero-de-acciones) (cu ?valor-nominal) (material (str-cat acciones-de- ?cedente )) (proveedor ?cedente) (cliente nil) (glosa (str-cat por-compra-de-acciones-a- ?cedente)) ) )
)

(defrule comprar-inventario-revision
   ( revision
    (partida ?numero)
    (rechazado false)
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))

   ( ticket ( numero ?numero))
   ( empresa (nombre ?empresa))
   ?f1 <- (compra
            (archivo ?archivo)
            (rut ?rut)
            (activo-fijo false)
            (tipo-de-documento ?tipo-de-documento)
            (partida ?numero)
            (credito ?credito)
            (unidades ?unidades)
            (costo_unitario ?costo_unitario)
            (dia ?dia)
            (mes ?mes)
            (ano ?ano)
            (proveedor ?proveedor)
            (material ?material)
            (total ?total)
            (neto ?neto)
            (iva ?iva)
            (glosa ?glosa) )
   (test (not (eq nil ?material)))
   (test (and (not (eq nil ?total)) (> ?total 0)))
   (test (and (not (eq nil ?neto)) (> ?neto 0)))
   (test (and (not (eq nil ?iva)) (> ?iva 0)))
   (test (eq ?credito 0))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   (not ( proveedor (nombre ?proveedor) (padre materiales)))

 =>
   (printout t "==================== W A R N I N G ==============================" crlf)
   (printout t ?proveedor " NO es un proveedor de materiales. Modifíque el padre de la cuenta en el archivo proveedores.txt si cree que esto es un error" crlf)
   (printout t "También puede registrar el proveedor en dos cuentas, una de las cuales tenga el nombre proveedor-materiales cuyo padres sea materiales" crlf)
   (printout t "Error encontrado en la partida " ?numero crlf)
   (printout t "==================================================================" clrf)
)





(defrule comprar-inventario
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))

   ( ticket ( numero ?numero))
   ( empresa (nombre ?empresa))
   ?f1 <- (compra
            (archivo ?archivo)
            (rut ?rut)
            (activo-fijo false)
            (tipo-de-documento ?tipo-de-documento)
            (partida ?numero)
            (credito ?credito)
            (unidades ?unidades)
            (costo_unitario ?costo_unitario)
            (dia ?dia)
            (mes ?mes)
            (ano ?ano)
            (proveedor ?proveedor)
            (material ?material)
            (total ?total)
            (neto ?neto)
            (iva ?iva)
            (glosa ?glosa) )
   (test (not (eq nil ?material)))
   (test (and (not (eq nil ?total)) (> ?total 0)))
   (test (and (not (eq nil ?neto)) (> ?neto 0)))
   (test (and (not (eq nil ?iva)) (> ?iva 0)))
   (test (eq ?credito 0))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
;   (proveedor (nombre (sym-cat ?proveedor -materiales)) (padre materiales))

  =>
   ( retract ?f1 )

   ( assert
    ( cuenta
       (nombre (sym-cat  ?proveedor -materiales))
       (descripcion compra-de-materiales)
       (tipo deudor)
       (grupo activo)
       (circulante true)
       (padre materiales)
       (origen real)
    )
   )
   ( assert (partida (proveedor ?proveedor) (numero ?numero) (empresa ?empresa) (dia ?dia) (mes ?mes) (archivo ?archivo) (ano ?ano) (descripcion ?glosa) (actividad comprar-inventario)))

   ( assert (cargo (tipo-de-documento ?tipo-de-documento) (cuenta (sym-cat ?proveedor -materiales)) (partida ?numero) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (monto ?neto) (glosa (str-cat (str-cat  ?material -<<-) ?proveedor) )))

   ( assert (abono (tipo-de-documento ?tipo-de-documento) (cuenta banco-estado)  (partida ?numero)   (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (monto ?total) (glosa (str-cat (str-cat (str-cat compra-de-inventario-de- ?material) -a-) ?proveedor) )))

   ( assert (cargo (tipo-de-documento ?tipo-de-documento) (cuenta iva-credito) (partida ?numero) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (monto ?iva)  (glosa (str-cat por-compra-de-inventario-de- ?material)) ) )

   ( assert (inventario (operacion compra) (empresa ?empresa) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (ct ?neto) (u ?unidades) (cu ?costo_unitario) (material ?material)(proveedor ?proveedor) (glosa (str-cat por-compra-de-inventario-de- ?material)) ) )

   ( assert (ccm (folio na) (partida ?numero) (tipo-documento ?tipo-de-documento) (monto-total ?total) (rut-contraparte ?rut) (monto-neto ?neto)))

   ( printout t "-->cc comprando al contado " ?material " por un valor total de " ?total crlf  )
   ( printout t "      pagado a " ?proveedor crlf)
)


(defrule comprar-insumos-al-contado
   ( revision
    (partida ?numero)
    (rechazado false)
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))

   ( ticket ( numero ?numero))
   ( empresa (nombre ?empresa))
   ?f1 <- (insumos
            (folio ?folio)
            (archivo ?archivo)
            (rut ?rut)
            (activo-fijo false)
            (tipo-de-documento ?tipo-de-documento)
            (partida ?numero)
            (credito ?credito)
            (unidades ?unidades)
            (costo_unitario ?costo_unitario)
            (dia ?dia)
            (mes ?mes)
            (ano ?ano)
            (proveedor ?proveedor)
            (material ?material)
            (total ?total)
            (neto ?neto)
            (iva ?iva)
            (glosa ?glosa) )
   (test (not (eq nil ?material)))
   (test (and (not (eq nil ?total)) (> ?total 0)))
   (test (and (not (eq nil ?neto)) (> ?neto 0)))
   (test (and (not (eq nil ?iva)) (> ?iva 0)))
   (test (eq ?credito 0))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
;   ( proveedor (nombre (str-cat ?proveedor "-insumos")) (padre insumos))

  =>

   ( retract ?f1 ) ;este fact es transformado en un insumo asignado a un proveedor. Es extraño, no sé por qué hice eso. Tal vez quiera llevar una cuenta de los proveedores para evaluarlos.
   ( assert (partida (proveedor ?proveedor) (numero ?numero) (empresa ?empresa) (dia ?dia) (mes ?mes) (archivo (str-cat "../factura-afecta-" ?proveedor "-" ?folio ".png")) (ano ?ano) (descripcion ?glosa) (actividad comprar-insumos-al-contado)))

   ( assert
    ( cuenta
       (nombre (str-cat ?proveedor "-insumos"))
       (descripcion compra-de-insumos)
       (tipo deudor)
       (grupo activo)
       (circulante true)
       (padre insumos)
       (origen real)
    )
   )
   ( assert (cargo (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta (str-cat ?proveedor "-insumos")) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?neto) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))

  ; ( assert (cargo (tipo-de-documento ?tipo-de-documento) (cuenta materiales) (partida ?numero) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (monto ?neto) (glosa (str-cat (str-cat  ?material -<<-) ?proveedor) )))

   ( assert (abono (tipo-de-documento ?tipo-de-documento) (cuenta banco-estado)  (partida ?numero)   (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (monto ?total) (glosa (str-cat (str-cat (str-cat compra-al-contado-de- ?material) -a-) ?proveedor) )))

   ( assert (cargo (tipo-de-documento ?tipo-de-documento) (cuenta iva-credito) (partida ?numero) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (monto ?iva)  (glosa (str-cat por-compra-al-contado-de- ?material)) ) )

;   ( assert (inventario (operacion compra) (empresa ?empresa) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (ct ?neto) (u ?unidades) (cu ?costo_unitario) (material ?material)(proveedor ?proveedor) (glosa (str-cat por-compra-al-credito-de- ?material)) ) )

   ( assert (ccm (folio na) (partida ?numero) (tipo-documento ?tipo-de-documento) (monto-total ?total) (rut-contraparte ?rut) (monto-neto ?neto)))

   ( printout t "-->cc comprando al contado " ?material " por un valor total de " ?total crlf  )
   ( printout t "      pagado a " ?proveedor crlf)
)



(defrule comprar-materiales-al-contado 
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))

   ( ticket ( numero ?numero))
   ( empresa (nombre ?empresa))
   ?f1 <- (compra-de-materiales
            (archivo ?archivo)
            (rut ?rut)
            (activo-fijo false)
            (tipo-de-documento ?tipo-de-documento)
            (partida ?numero)
            (credito ?credito)
            (unidades ?unidades)
            (costo_unitario ?costo_unitario)
            (dia ?dia)
            (mes ?mes)
            (ano ?ano)
            (proveedor ?proveedor)
            (material ?material)
            (total ?total)
            (neto ?neto)
            (iva ?iva)
            (glosa ?glosa) )
   (test (not (eq nil ?material)))
   (test (and (not (eq nil ?total)) (> ?total 0)))
   (test (and (not (eq nil ?neto)) (> ?neto 0)))
   (test (and (not (eq nil ?iva)) (> ?iva 0)))
   (test (eq ?credito 0))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  ; ( proveedor (nombre (sym-cat ?proveedor -materiales)) (padre materiales))


  =>
   ( retract ?f1 )
   ( assert (partida (proveedor ?proveedor) (numero ?numero) (empresa ?empresa) (dia ?dia) (mes ?mes) (archivo ?archivo) (ano ?ano) (descripcion ?glosa) (actividad comprar-materiales-al-contado)))

   ( assert
    ( cuenta
       (nombre (sym-cat ?proveedor -materiales))
       (descripcion compra-de-materiales)
       (tipo deudor)
       (grupo activo)
       (circulante true)
       (padre materiales)
       (origen reales)
    )
   )
   ( assert (cargo (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta (sym-cat ?proveedor -materiales)) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?neto) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))

  ; ( assert (cargo (tipo-de-documento ?tipo-de-documento) (cuenta materiales) (partida ?numero) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (monto ?neto) (glosa (str-cat (str-cat  ?material -<<-) ?proveedor) )))

   ( assert (abono (tipo-de-documento ?tipo-de-documento) (cuenta banco-estado)  (partida ?numero)   (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (monto ?total) (glosa (str-cat (str-cat (str-cat compra-al-contado-de- ?material) -a-) ?proveedor) )))

   ( assert (cargo (tipo-de-documento ?tipo-de-documento) (cuenta iva-credito) (partida ?numero) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (monto ?iva)  (glosa (str-cat por-compra-al-contado-de- ?material)) ) )

;   ( assert (inventario (operacion compra) (empresa ?empresa) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (ct ?neto) (u ?unidades) (cu ?costo_unitario) (material ?material)(proveedor ?proveedor) (glosa (str-cat por-compra-al-credito-de- ?material)) ) )

   ( assert (ccm (folio na) (partida ?numero) (tipo-documento ?tipo-de-documento) (monto-total ?total) (rut-contraparte ?rut) (monto-neto ?neto)))

   ( printout t "-->cc comprando al contado " ?material " por un valor total de " ?total crlf  )
   ( printout t "      pagado a " ?proveedor crlf)
)




(defrule comprar-con-letras
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))

   ( ticket ( numero ?numero))
   ( empresa (nombre ?empresa))
   ?f1 <- (compra (rut ?rut) (activo-fijo false) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (proveedor ?proveedor) (material ?material) (total ?total) (efectivo ?efectivo) (letras ?letras) (glosa ?glosa) )
   ( test (not (eq nil ?material)))
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (and (not (eq nil ?letras)) (> ?letras 0)))
   ( test (and (not (eq nil ?efectivo)) (> ?efectivo 0)))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

 =>
   ( retract ?f1 )
   ( assert (partida (proveedor ?proveedor) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad comprar-con-letras)))

   ( assert (abono (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta letras-por-pagar) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (monto ?letras) (glosa (str-cat (str-cat (str-cat compra-al-credito-de- ?material) -a-) ?proveedor) )))
   ( assert
    ( cuenta (nombre ?proveedor)
       (partida ?numero)
       (empresa ?empresa )
       (dia ?dia)
       (mes ?mes)
       (ano ?ano)
       (descripcion ?proveedor)
       (tipo acreedora)
       (grupo pasivo)
       (circulante true)
       (padre proveedores)
       (origen nominativo))
   )
   ( assert (cargo (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta ?proveedor) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (monto ?total) (glosa (str-cat (str-cat (str-cat compra-al-credito-de- ?material) -a-) ?proveedor) )))
   ( assert (abono (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta caja) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (monto ?efectivo) (glosa (str-cat por-compra-al-credito-de- ?material)) ) )
   ( assert (ccm (folio na) (partida ?numero) (tipo-documento ?tipo-de-documento) (monto-total ?total) (rut-contraparte ?rut)))
   ( printout t "compra-- Comprando a " ?proveedor " con letras " ?material " por un valor de $" ?letras " y en efectivo $" ?efectivo " con un total de $" ?total crlf )
)



(defrule comprar-al-credito
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))

   ( ticket ( numero ?numero))
   ( empresa (nombre ?empresa))
   ?f1 <- (compra (folio ?folio) (activo-fijo false) (rut ?rut) (tipo-de-documento ?tipo-de-documento) (costo_unitario ?costo_unitario) (unidades ?unidades) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (credito ?credito) (proveedor ?proveedor) (material ?material) (total ?total) (neto ?neto) (iva ?iva) (glosa ?glosa) )
   ( test (not (eq nil ?material)))
   ( test (and (not (eq nil ?credito )) (> ?credito 0) ))
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (and (not (eq nil ?neto)) (> ?neto 0)))
   ( test (and (not (eq nil ?iva)) (> ?iva 0)))
   ( test (> ?credito 0))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
;   ( test (eq ?total (round (* ?neto ?*iva_factor*))))
  =>

   ( printout t  ?*iva_factor* crlf  )
   ( retract ?f1 )
   ( assert (partida (proveedor ?proveedor) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad comprar-al-credito) ))

   ( assert (cargo (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta compras) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?neto) (glosa (str-cat (str-cat  ?material -<<-) ?proveedor) )))
   ( assert
    ( cuenta (nombre ?proveedor)
       (partida ?numero)
       (empresa ?empresa )
       (dia ?dia)
       (mes ?mes)
       (ano ?ano)
       (descripcion ?proveedor)
       (tipo acreedora)
       (grupo pasivo)
       (circulante true)
       (padre proveedores)
       (origen nominativo))
   )
   ( assert (abono (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta ?proveedor) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (monto ?credito) (glosa (str-cat (str-cat (str-cat compra-al-credito-de- ?material) -a-) ?proveedor) )))
   ( assert (cargo (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta iva-credito) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (monto ?iva) (glosa (str-cat por-compra-al-credito-de- ?material)) ) )


   ( assert (inventario (operacion compra) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (ct ?neto) (u ?unidades) (cu ?costo_unitario) (material ?material)(proveedor ?proveedor) (glosa (str-cat por-compra-al-credito-de- ?material)) ) )

   ;( assert (cargo (cuenta ppm)         (monto (round (* ?total 0.25))) (glosa (str-cat ppm-de- ?material)) ) )

   ( assert (ccm (folio ?folio) (partida ?numero) (tipo-documento ?tipo-de-documento) (monto-total ?total) (monto-iva-recuperable ?iva) (rut-contraparte ?rut) (razon-social-contraparte ?proveedor) (monto-neto ?neto)  ) )

  ( printout t "compra-- Comprando al crédito " ?material " por un valor de $" ?credito " de un valor total de " ?total crlf )
)



(defrule devolver
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))

   ( ticket ( numero ?numero))
   ( empresa (nombre ?empresa))
   ?f1 <- (devolucion (rut ?rut) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (costo_unitario ?costo_unitario) (unidades ?unidades) (dia ?dia) (mes ?mes) (ano ?ano) (cliente ?cliente) (material ?material) (total ?total) (neto ?neto) (iva ?iva) (glosa ?glosa) )
   ( test (not (eq nil ?material)))
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  =>
   ( retract ?f1 )
   ;( assert (dia ?dia))
   ( assert (inventario (operacion devolucion) (u ?unidades) (cu ?costo_unitario) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (cliente ?cliente) (material ?material) (ct (* ?unidades ?costo_unitario)) ))
   ( assert (partida (proveedor ?cliente) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa ) (actividad devolver)))
   ( assert (abono (tipo-de-documento ?tipo-de-documento) (cuenta banco-estado) (empresa ?empresa) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (monto ?total ) (glosa (str-cat (str-cat (str-cat devolucion-de- ?material) -a-) ?cliente) )))
   ( assert (cargo (tipo-de-documento ?tipo-de-documento) (cuenta iva-debito) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (partida ?numero) (monto ?iva) (glosa (str-cat devolucion-de- ?material)) ) )
   ( assert (cargo (tipo-de-documento ?tipo-de-documento) (cuenta devolucion-sobre-ventas) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (partida ?numero) (monto (round ?neto) ) (glosa (str-cat (str-cat (str-cat devolucion-de- ?material) -a-) ?cliente) )))
   ( assert (abono (tipo-de-documento ?tipo-de-documento) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?empresa) (cuenta costos-de-ventas) (monto (round (* ?unidades ?costo_unitario))) (glosa (str-cat devolucion-de- ?material) )))
   ( assert (ccm (folio na) (partida ?numero) (tipo-documento ?tipo-de-documento) (monto-total ?total) (rut-contraparte ?rut) (monto-neto ?neto)))
   ( printout t "-->d Devolviendo con nota de crédito " ?material " por un valor total de " ?total crlf )
)

;lo mismo que gasto-administrativo pero se usa banco-estado en vez de caja
(defrule gastar-proveedor-no-afecto 
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( subcuenta (origen ?origen))

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))

   ( ticket ( numero ?numero))
   ( empresa (nombre ?empresa))

   ?f1 <- (gasto-proveedor (archivo ?archivo) (rut ?rut) (tipo-de-documento ?tipo-de-documento) (electronico ?electronico) (folio ?folio) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (credito ?credito) (proveedor ?proveedor) (material ?material) (monto ?monto) (glosa ?glosa))

   ( test (not (eq nil ?material)))
   ( test (and (not (eq nil ?monto)) (> ?monto 0)))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  =>
   ( retract ?f1 )

   ( assert (partida (archivo ?archivo) (proveedor ?proveedor) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad gastar-proveedor-no-afecto)))

   ( assert
    ( cuenta
       (nombre ?proveedor)
       (descripcion pagos-a-este-proveedor)
       (tipo deudor)
       (grupo resultado)
       (circulante true)
       (padre gastos-administrativos)
       (origen ?origen)
    )
   )
   ( assert (cargo (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta ?proveedor) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?monto) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))

   ( assert (abono (tipo-de-documento ?tipo-de-documento ) (partida ?numero) (cuenta banco-estado) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?monto) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
   ( assert (ccm (folio ?folio) (partida ?numero) (tipo-documento ?tipo-de-documento) (monto-total ?monto) (rut-contraparte ?rut) (razon-social-contraparte ?proveedor)))
   ( printout t "-->ga gasto-proveedor-no-afecto- " ?material " por un valor total de " ?monto crlf )
)




(defrule gastar-administrativo-no-afecto
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( subcuenta (origen ?origen))

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))

   ( ticket ( numero ?numero))
   ( empresa (nombre ?empresa))

   ?f1 <- (gasto-administrativo (archivo ?archivo) (tipo-de-documento ?tipo-de-documento) (electronico ?electronico) (folio ?folio) (rut ?rut) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (credito ?credito) (proveedor ?proveedor) (material ?material) (monto ?monto) (glosa ?glosa)) 

   ( test (not (eq nil ?material)))
   ( test (and (not (eq nil ?monto)) (> ?monto 0)))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  =>
   ( retract ?f1 )

   ( assert (partida (proveedor ?proveedor) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad gastar-administrativo-no-afecto) (archivo (str-cat "../factura-exenta-" ?proveedor "-" ?folio ".png"))))

   ( assert
    ( cuenta
       (nombre ?proveedor)
       (descripcion pagos-a-este-proveedor)
       (tipo deudor)
       (grupo activo)
       (circulante true)
       (padre gastos-administrativos)
       (origen ?origen)
    )
   )
   ( assert (cargo (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta ?proveedor) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?monto) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))

   ( assert (abono (tipo-de-documento ?tipo-de-documento ) (partida ?numero) (cuenta caja) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?monto) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))

   ( assert (ccm (folio na) (partida ?numero) (tipo-documento ?tipo-de-documento) (monto-total ?monto)(rut-contraparte ?rut)))
   ( printout t "-->ga gasto-administrativo-no-afecto- " ?material " por un valor total de " ?monto crlf )
)






(defrule gastar-en-departamento-ventas-no-afecto
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( subcuenta (origen ?origen))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))

   ( ticket ( numero ?numero))
   (empresa (nombre ?empresa))
   ?f1 <- (gasto-ventas (rut ?rut) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (credito ?credito) (proveedor ?proveedor) (material ?material) (monto ?monto) (glosa ?glosa) )
   ( test (not (eq nil ?material)))
   ( test (and (not (eq nil ?monto)) (> ?monto 0)))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  =>
   ( retract ?f1 )
  ;( assert (dia ?dia))
   ( assert (partida (proveedor ?proveedor) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad gastar-en-departamento-ventas-no-afecto)))
   ( assert
    ( cuenta
       (nombre ?proveedor)
       (descripcion gastos-a-este-departamento)
       (tipo deudor)
       (grupo activo)
       (circulante true)
       (padre gastos-ventas)
       (origen ?origen) ) )
   ( assert (cargo (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta ?proveedor) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?monto) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
   ( assert (abono (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta caja) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?monto) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))

   ( assert (ccm (folio na) (partida ?numero) (tipo-documento ?tipo-de-documento) (monto-total ?monto) (rut-contraparte ?rut)))
   ( printout t "-->gav gasto-de-Dpto-ventas- " ?material " por un valor total de " ?monto crlf  )
   ( printout t "       pagado a " ?proveedor crlf)

)


(defrule costar-directo-ventas-revision
   ( revision
    (partida ?numero)
    (rechazado false)
   )
   ( subcuenta (origen ?origen))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))

   ( ticket ( numero ?numero))
   (empresa (nombre ?empresa))
   ?f1 <- (costo-ventas (folio ?folio) (rut ?rut) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (credito ?credito) (proveedor ?proveedor) (material ?material) (monto ?monto) (glosa ?glosa) (iva ?iva) (neto ?neto) (total ?total) (archivo ?archivo) )
   (not   (proveedor (nombre ?proveedor) (padre costos-ventas)))
 =>
   (halt)
   (printout t "==================== W A R N I N G ==============================" crlf)
   (printout t ?proveedor " NO es un proveedor de costos ventas. Modifíque el padre de la cuenta en el archivo proveedores.txt si cree que esto es un error" crlf)

   (printout t "Error encontrado en la partida " ?numero crlf)
   (printout t "==================================================================" clrf)
)


(defrule costar-directo-ventas
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )
   ( subcuenta (origen ?origen))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))

   ( ticket ( numero ?numero))
   (empresa (nombre ?empresa))
   ?f1 <- (costo-ventas (folio ?folio) (rut ?rut) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (credito ?credito) (proveedor ?proveedor) (material ?material) (monto ?monto) (glosa ?glosa) (iva ?iva) (neto ?neto) (total ?total) (archivo ?archivo) )
   ( test (not (eq nil ?material)))
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (and (not (eq nil ?neto)) (> ?neto 0)))
   ( test (and (not (eq nil ?iva)) (> ?iva 0)))

   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ( proveedor (nombre ?proveedor) (padre costos-ventas))
  =>
   ( retract ?f1 )
   ( assert (partida (proveedor ?proveedor) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad costar-directo-ventas) (archivo (str-cat "../factura-afecta-" ?proveedor "-" ?folio ".png"))))
   ( assert
    ( cuenta
       (nombre ?proveedor)
       (recibida true) 
       (tipo-de-documento ?tipo-de-documento)
       (descripcion gastos-a-este-departamento)
       (tipo deudor)
       (grupo resultado)
       (circulante true)
       (padre costos-de-ventas)
       (origen ?origen) ) )


   ( assert (cargo (recibida true) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta ?proveedor) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?neto) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
   ( assert (cargo (recibida true) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta iva-credito) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?iva) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
   ( assert (abono (recibida true) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta banco-estado) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?total) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
   ( assert (ccm (folio ?folio) (partida ?numero) (tipo-documento ?tipo-de-documento) (monto-total ?total) (monto-iva-recuperable ?iva) (rut-contraparte ?rut) (razon-social-contraparte ?proveedor) (monto-neto ?neto)  ) )

   ( printout t "-->cd costo directo de ventas, por " ?material " por un valor total de " ?total crlf )
   ( printout t "       pagado a " ?proveedor crlf)
)


(defrule gastar-promocional-afecto-iva-retenido
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( subcuenta (origen ?origen))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))

   ( ticket ( numero ?numero))
   ( empresa (nombre ?empresa))
   ?f1 <- (gasto-promocional (archivo ?archivo) (folio ?folio) (rut ?rut) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (credito ?credito) (proveedor ?proveedor) (material ?material) (total ?total) (neto ?neto) (iva ?iva) (glosa ?glosa) (iva-retenido ?iva-retenido))
   ( test (not (eq nil ?material)))
  ; ( test (and (not (eq nil ?credito )) (> ?credito 0) ))
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (and (not (eq nil ?neto)) (> ?neto 0)))
   ( test (and (not (eq nil ?iva)) (> ?iva 0)))
   ( test (and (not (eq nil ?iva-retenido)) (> ?iva-retenido 0)))

   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  =>
   ( retract ?f1 )

   ( if (neq nil ?archivo) 
     then
     ( assert (partida (archivo ?archivo) (proveedor ?proveedor) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad gastar-promocional-afecto-iva-retenido) ))
     else
     ( assert (partida (archivo (str-cat "../factura-" ?proveedor "-" ?folio ".png")) (proveedor ?proveedor) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad gastar-promocional-afecto-iva-retenido) ))
   )


   ( assert
    ( cuenta
       (qty 1)
       (recibida true) 
       (nombre ?proveedor)
       (descripcion compras-promocionales)
       (tipo deudor)
       (grupo resultado)
       (circulante true)
       (padre gastos-promocionales)
       (origen ?origen)
    )
   )
   ( assert (cargo (qty 1)  (recibida true)  (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta ?proveedor) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?neto) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
   ( assert (abono (qty 1) (recibida true)  (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta banco-estado) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?total) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
   ( assert (cargo (qty 1) (recibida true)  (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta iva-credito) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?iva) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
   ( assert (abono (qty 1) (recibida true) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta retencion-de-iva-articulo-11) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?iva-retenido) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))

   ( assert (ccm (folio ?folio) (partida ?numero) (tipo-documento ?tipo-de-documento) (monto-total ?total) (monto-iva-recuperable ?iva) (rut-contraparte ?rut) (razon-social-contraparte ?proveedor) (monto-neto ?neto) (numero-interno 15)  (emisor-receptor ?iva) ) )
   ( printout t "-->ga gasto-promocional- " ?material " por un valor total de " ?total crlf  )
)


(defrule gastar-proveedores-afecto-iva-retenido
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( subcuenta (origen ?origen))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))

   ( ticket ( numero ?numero))
   ( empresa (nombre ?empresa))
   ?f1 <- (gasto-proveedor (archivo ?archivo) (folio ?folio) (rut ?rut) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (credito ?credito) (proveedor ?proveedor) (material ?material) (total ?total) (neto ?neto) (iva ?iva) (glosa ?glosa) (iva-retenido ?iva-retenido))
   ( test (not (eq nil ?material)))
  ; ( test (and (not (eq nil ?credito )) (> ?credito 0) ))
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (and (not (eq nil ?neto)) (> ?neto 0)))
   ( test (and (not (eq nil ?iva)) (> ?iva 0)))
   ( test (and (not (eq nil ?iva-retenido)) (> ?iva-retenido 0)))

   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  =>
   ( retract ?f1 )/
   ; assert (dia ?dia))

   ( if (neq nil ?archivo)
     then
     ( assert (partida (archivo ?archivo) (proveedor ?proveedor) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad gastar-promocional-afecto-iva-retenido) ))
     else
     ( assert (partida (archivo (str-cat "../factura-" ?proveedor "-" ?folio ".png")) (proveedor ?proveedor) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad gastar-promocional-afecto-iva-retenido) ))
   )



;  ( assert (cargo (partida ?numero) (cuenta gastos-administrativo) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?neto) (glosa (str-cat (str-cat  ?material -<<-) ?proveedor) )))
   ( assert
    ( cuenta
       (nombre ?proveedor)
       (recibida true) 
       (descripcion compras-Dpto-Administracion)
       (tipo deudor)
       (grupo resultado)
       (circulante true)
       (padre gastos-administrativos)
       (origen ?origen)
    )
   )
   ( assert (cargo (recibida true) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta ?proveedor) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?neto) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
   ( assert (abono (recibida true) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta banco-estado) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?total) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
   ( assert (cargo (recibida true) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta iva-credito) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?iva) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
 ;  ( assert (abono (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta iva-debito) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?iva-retenido) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
   ( assert (abono (recibida true) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta retencion-de-iva-articulo-11) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?iva-retenido) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))

   ( assert (ccm (folio ?folio) (partida ?numero) (tipo-documento ?tipo-de-documento) (monto-total ?total) (rut-contraparte ?rut ) (razon-social-contraparte ?proveedor) (monto-neto ?neto)))
   ( printout t "-->ga proveedores- " ?material " por un valor total de " ?total crlf  )
)



(defrule gastar-administrativo-afecto-iva-retenido
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( subcuenta (origen ?origen))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))

   ( ticket ( numero ?numero))
   ( empresa (nombre ?empresa))
   ?f1 <- (gasto-administrativo (archivo ?archivo) (folio ?folio) (rut ?rut) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (credito ?credito) (proveedor ?proveedor) (material ?material) (total ?total) (neto ?neto) (iva ?iva) (glosa ?glosa) (iva-retenido ?iva-retenido))
   ( test (not (eq nil ?material)))
  ; ( test (and (not (eq nil ?credito )) (> ?credito 0) ))
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (and (not (eq nil ?neto)) (> ?neto 0)))
   ( test (and (not (eq nil ?iva)) (> ?iva 0)))
   ( test (and (not (eq nil ?iva-retenido)) (> ?iva-retenido 0)))

   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  =>
   ( retract ?f1 )
   ; assert (dia ?dia))
   ( if (neq nil ?archivo)
     then
     ( assert (partida (archivo ?archivo) (proveedor ?proveedor) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad gastar-administrativo-afecto-iva-retenido) ))
     else
     ( assert (partida (archivo (str-cat "../factura-afecta-" ?proveedor "-" ?folio ".png")) (proveedor ?proveedor) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad gastar-administrativo-afecto-iva-retenido) ))
   )



;  ( assert (cargo (partida ?numero) (cuenta gastos-administrativo) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?neto) (glosa (str-cat (str-cat  ?material -<<-) ?proveedor) )))
   ( assert
    ( cuenta
       (nombre ?proveedor)
       (recibida true) 
       (descripcion compras-Dpto-Administracion)
       (tipo deudor)
       (grupo resultado)
       (circulante true)
       (padre gastos-administrativos)
       (origen ?origen)
    )
   )
   ( assert (cargo (recibida true)  (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta ?proveedor) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?neto) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
   ( assert (abono (recibida true) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta caja) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?total) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
   ( assert (cargo (recibida true) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta iva-credito) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?iva) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
 ;  ( assert (abono (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta iva-debito) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?iva-retenido) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
   ( assert (abono (recibida true) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta retencion-de-iva-articulo-11) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?iva-retenido) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))

   ( assert (ccm (folio ?folio) (partida ?numero) (tipo-documento ?tipo-de-documento) (monto-total ?total) (rut-contraparte ?rut) (razon-social-contraparte ?proveedor) (monto-neto ?neto) (monto-iva-recuperable ?iva)))
   ( printout t "-->ga gasto-administrativo- " ?material " por un valor total de " ?total crlf  )
)




(defrule gastar-en-investigacion-y-desarrollo-sin-retencion
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))

   ( ticket ( numero ?numero))
   ( empresa (nombre ?empresa))
   ?f1 <- (gasto-investigacion-y-desarrollo (folio ?folio) (rut ?rut) (archivo ?archivo) (tipo-de-documento ?tipo-de-documento) (electronico ?electronico) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (credito ?credito) (proveedor ?proveedor) (material ?material) (total ?total) (neto ?neto) (iva ?iva) (glosa ?glosa) (iva-retenido ?iva-retenido))
   ( test (not (eq nil ?material)))
  ; ( test (and (not (eq nil ?credito )) (> ?credito 0) ))
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (and (not (eq nil ?neto)) (> ?neto 0)))
;   ( test (and (not (eq nil ?iva)) (> ?iva 0)))
   ( test (eq nil ?iva-retenido))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  =>
   ( retract ?f1 )

   ( if (neq nil ?archivo)
     then
     ( assert (partida (archivo ?archivo) (proveedor ?proveedor) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad gastar-en-investigacion-y-desarrollo) ))
     else
     ( assert (partida (archivo (str-cat "../factura-" ?proveedor "-" ?folio ".png")) (proveedor ?proveedor) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad gastar-en-investigacion-y-desarrollo) ))
   )

   ( assert (cargo (recibida true) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta gastos-en-investigacion-y-desarrollo) (electronico ?electronico) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?neto) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
   ( assert (abono (recibida true) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta banco-estado) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?total) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
   ( assert (cargo (recibida true) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta iva-credito) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?iva) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
   ( assert (ccm (folio na) (partida ?numero) (tipo-documento ?tipo-de-documento) (monto-total ?total) (rut-contraparte ?rut) (razon-social-contraparte ?proveedor) (monto-neto ?neto)))
   ( printout t "-->gid gasto-i-d- " ?material " por un valor total de " ?total crlf  )
   ( printout t "       pagado a " ?proveedor crlf)

)




(defrule gastar-en-investigacion-y-desarrollo-con-retencion
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))

   ( ticket ( numero ?numero))
   ( empresa (nombre ?empresa))
   ?f1 <- (gasto-investigacion-y-desarrollo (folio ?folio) (rut ?rut) (archivo ?archivo) (tipo-de-documento ?tipo-de-documento) (electronico ?electronico) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (credito ?credito) (proveedor ?proveedor) (material ?material) (total ?total) (neto ?neto) (iva ?iva) (glosa ?glosa) (iva-retenido ?iva-retenido))
   ( test (not (eq nil ?material)))
  ; ( test (and (not (eq nil ?credito )) (> ?credito 0) ))
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (and (not (eq nil ?neto)) (> ?neto 0)))
   ( test (and (not (eq nil ?iva)) (> ?iva 0)))
   ( test (neq nil ?iva-retenido))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  =>
   ( retract ?f1 )

   ( if (neq nil ?archivo)
     then
     ( assert (partida (archivo ?archivo) (proveedor ?proveedor) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad gastar-en-investigacion-y-desarrollo) ))
     else
     ( assert (partida (archivo (str-cat "../factura-" ?proveedor "-" ?folio ".png")) (proveedor ?proveedor) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad gastar-en-investigacion-y-desarrollo) ))
   )


   ( assert (cargo (recibida true) (tipo-de-documento ?tipo-de-documento) (electronico ?electronico) (partida ?numero) (cuenta gastos-en-investigacion-y-desarrollo) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?neto) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
   ( assert (abono (recibida true) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta banco-estado) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?total) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
   ( assert (cargo (recibida true) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta iva-credito) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?iva) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
   ( assert (ccm (folio na) (partida ?numero) (tipo-documento ?tipo-de-documento) (monto-total ?total) (rut-contraparte ?rut) (razon-social-contraparte ?proveedor) (monto-neto ?neto)))
   ( printout t "-->gid gasto-i-d- " ?material " por un valor total de " ?total crlf  )
   ( printout t "       pagado a " ?proveedor crlf)

)


(defrule gastar-en-promocion
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( subcuenta (origen ?origen))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))

   ( ticket ( numero ?numero))
   ( empresa (nombre ?empresa))
   ?f1 <- (gasto-promocional (archivo ?archivo) (folio ?folio) ( rut ?rut) (tipo-de-documento ?tipo-de-documento) (electronico ?electronico) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (credito ?credito) (proveedor ?proveedor) (material ?material) (total ?total) (neto ?neto) (iva ?iva) (glosa ?glosa) (iva-retenido ?iva-retenido))
   ( test (not (eq nil ?material)))
  ; ( test (and (not (eq nil ?credito )) (> ?credito 0) ))
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (and (not (eq nil ?neto)) (> ?neto 0)))
   ( test (and (not (eq nil ?iva)) (> ?iva 0)))
   ( test (eq nil ?iva-retenido))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  =>
   ( retract ?f1 )
   ; assert (dia ?dia))

   ( if (neq nil ?archivo)
     then
     ( assert (partida (archivo ?archivo) (proveedor ?proveedor) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad gastar-en-promocion) ))
     else
     ( assert (partida (archivo (str-cat "../factura-" ?proveedor "-" ?folio ".png")) (proveedor ?proveedor) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad gastar-en-promocion) ))
   )

   ( assert
    ( cuenta
       (recibida true) 
       (nombre ?proveedor)
       (descripcion ?proveedor)
       (tipo deudor)
       (grupo resultado)
       (circulante true)
       (padre gastos-promocionales)
       (origen ?origen)

    )
   )
   ( assert (cargo (recibida true) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (electronico ?electronico) (cuenta ?proveedor) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?neto) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
   ( assert (abono (recibida true) (tipo-de-documento ?tipo-de-documento)  (partida ?numero) (cuenta banco-estado) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?total) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
   ( assert (cargo (recibida true) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta iva-credito) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?iva) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
   ( assert (ccm (folio ?folio) (partida ?numero) (tipo-documento ?tipo-de-documento) (monto-total ?total) (monto-iva-recuperable ?iva) (rut-contraparte ?rut) (razon-social-contraparte ?proveedor) (monto-neto ?neto)  ) )

   ( printout t "-->gp gasto-promocinal- " ?material " por un valor total de " ?total crlf  )
   ( printout t "       pagado a " ?proveedor crlf)

)



(defrule gastar-proveedor-afecto
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( subcuenta (origen ?origen))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))

   ( ticket ( numero ?numero))
   ( empresa (nombre ?empresa))
   ?f1 <- (gasto-proveedor (archivo ?archivo) (folio ?folio) (rut ?rut) (tipo-de-documento ?tipo-de-documento) (electronico ?electronico) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (credito ?credito) (proveedor ?proveedor) (material ?material) (total ?total) (neto ?neto) (iva ?iva) (glosa ?glosa) (iva-retenido ?iva-retenido))
  ( test (not (eq nil ?material)))
  ; ( test (and (not (eq nil ?credito )) (> ?credito 0) ))
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (and (not (eq nil ?neto)) (> ?neto 0)))
   ( test (and (not (eq nil ?iva)) (> ?iva 0)))
   ( test (eq nil ?iva-retenido))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  =>
   ;( halt )
   ;( retract ?f1 )
   ; assert (dia ?dia))

   ( if (neq nil ?archivo)
     then
     ( assert (partida (archivo ?archivo) (proveedor ?proveedor) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad gastar-proveedor-afecto) ))
     else
     ( assert (partida (archivo (str-cat "../factura-afecta-" ?proveedor "-" ?folio ".png")) (proveedor ?proveedor) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad gastar-proveedor-afecto) ))
   )

;  ( assert (cargo (partida ?numero) (cuenta gastos-administrativo) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?neto) (glosa (str-cat (str-cat  ?material -<<-) ?proveedor) )))
   ( assert
    ( cuenta
       (nombre ?proveedor)
       (recibida true) 
       (descripcion compras-Dpto-Administracion)
       (tipo deudor)
       (grupo resultado)
       (circulante true)
       (padre gastos-administrativos)
       (origen ?origen)
    )
   )
   ( assert (cargo (recibida true) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (electronico ?electronico) (cuenta ?proveedor) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?neto) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
   ( assert (abono (recibida true) (tipo-de-documento ?tipo-de-documento)  (partida ?numero) (cuenta banco-estado) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?total) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
   ( assert (cargo (recibida true) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta iva-credito) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?iva) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
   ( assert (ccm (folio ?folio) (partida ?numero) (tipo-documento ?tipo-de-documento) (monto-total ?total) (rut-contraparte ?rut ) (monto-iva-recuperable ?iva) (razon-social-contraparte ?proveedor ) (monto-neto ?neto)))
   ( printout t "-->ga gasto-proveedor-afecto- " ?material " por un valor total de " ?total crlf  )
   ( printout t "       pagado a " ?proveedor crlf)

)




(defrule gastar-en-depto-administracion-afecto
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( subcuenta (origen ?origen))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))

   ( ticket ( numero ?numero))
   ( empresa (nombre ?empresa))
   ?f1 <- (gasto-administrativo (archivo ?archivo) (folio ?folio) (rut ?rut) (tipo-de-documento ?tipo-de-documento) (electronico ?electronico) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (credito ?credito) (proveedor ?proveedor) (material ?material) (total ?total) (neto ?neto) (iva ?iva) (glosa ?glosa) (iva-retenido ?iva-retenido))
   ( test (not (eq nil ?material)))
  ; ( test (and (not (eq nil ?credito )) (> ?credito 0) ))
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (and (not (eq nil ?neto)) (> ?neto 0)))
   ( test (and (not (eq nil ?iva)) (> ?iva 0)))
   ( test (eq nil ?iva-retenido))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  =>
   ( retract ?f1 )
   ; assert (dia ?dia))
   ( if (neq nil ?archivo)
     then
     ( assert (partida (archivo ?archivo) (proveedor ?proveedor) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad gastar-en-administracion-afecto) ))
     else
     ( assert (partida (archivo (str-cat "../factura-afecta-" ?proveedor "-" ?folio ".png")) (proveedor ?proveedor) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad gastar-en-administracion-afecto) ))
   )


;  ( assert (cargo (partida ?numero) (cuenta gastos-administrativo) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?neto) (glosa (str-cat (str-cat  ?material -<<-) ?proveedor) )))
   ( assert
    ( cuenta
       (nombre ?proveedor)
       (recibida true) 
       (descripcion compras-Dpto-Administracion)
       (tipo deudor)
       (grupo resultado)
       (circulante true)
       (padre gastos-administrativos)
       (origen ?origen)
    )
   )
   ( assert (cargo (recibida true)  (tipo-de-documento ?tipo-de-documento) (partida ?numero) (electronico ?electronico) (cuenta ?proveedor) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?neto) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
   ( assert (abono (recibida true) (tipo-de-documento ?tipo-de-documento)  (partida ?numero) (cuenta caja) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?total) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
   ( assert (cargo (recibida true) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta iva-credito) (empresa ?empresa)  (dia ?dia) (mes ?mes) (ano ?ano) (monto ?iva) (glosa (str-cat (str-cat  ?material " por ") ?proveedor) )))
   ( assert (ccm (folio ?folio) (partida ?numero) (tipo-documento ?tipo-de-documento) (monto-total ?total) (monto-iva-recuperable ?iva) (rut-contraparte ?rut) (razon-social-contraparte ?proveedor) (monto-neto ?neto)  ) )

   ( printout t "-->ga gasto-administrativo- " ?material " por un valor total de " ?total crlf  )
   ( printout t "       pagado a " ?proveedor crlf)
)



(defrule gastar-afecto
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))

   ( ticket ( numero ?numero))
   ( empresa (nombre ?empresa))
   ?f1 <- (gasto-afecto (archivo ?archivo) (folio ?folio) (rut ?rut) (ano ?ano) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (dia ?dia) (mes ?mes) (credito ?credito) (proveedor ?proveedor) (material ?material) (total ?total) (neto ?neto) (iva ?iva) (glosa ?glosa) )
   ( test (not (eq nil ?material)))
   ( test (and (not (eq nil ?credito )) (> ?credito 0) ))
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (and (not (eq nil ?neto)) (> ?neto 0)))
   ( test (and (not (eq nil ?iva)) (> ?iva 0)))
   ( test (> ?credito 0))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  =>
   ( halt )
   ( printout t "No revisado" crlf)

   ( retract ?f1 )
   ( assert (dia ?dia))

   ( if (neq nil ?archivo)
     then
     ( assert (partida (archivo ?archivo) (proveedor ?proveedor) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad gastar-afecto) ))
     else
     ( assert (partida (archivo (str-cat "../factura-" ?proveedor "-" ?folio ".png")) (proveedor ?proveedor) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad gastar-afecto) ))
   )


   ( assert (cargo (recibida true)  (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta compras) (empresa ?empresa)  (dia ?dia) (mes ?mes) (monto ?neto) (glosa (str-cat (str-cat  ?material -<<-) ?proveedor) )))
   ( assert (abono (recibida true)  (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta proveedores) (empresa ?empresa) (dia ?dia) (mes ?mes) (monto ?credito) (glosa (str-cat (str-cat (str-cat compra-fiada-de- ?material) -a-) ?proveedor) )))
   ( assert
    ( cuenta (nombre ?proveedor)
       (partida ?numero)
       (dia ?dia)
       (recibida true) 
       (descripcion cobro-realizados-a-proveedor-comex)
       (tipo acreedora)
       (grupo pasivo)
       (circulante true)
       (padre proveedores)
       (origen nominativo))
   )
   ( assert (cargo (recibida true) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (cuenta iva-credito) (empresa ?empresa) (dia ?dia) (mes ?mes) (monto ?iva) (glosa (str-cat por-compra-fiada-de- ?material)) ) )
   ( assert (ccm (folio ?folio) (partida ?numero) (tipo-documento ?tipo-de-documento) (monto-total ?credito) (rut-contraparte ?rut) (monto-iva-recuperable ?iva) (razon-social-contraparte ?proveedor) (monto-neto ?neto)))
   ( printout t "-->cf comprando fiado " ?material " por un valor de $" ?credito " de un valor total de " ?total crlf )
   ( printout t "       pagado a " ?proveedor crlf)


)



(defrule amortizar-credito-de-atencion-a-colaborador
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )


   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))
   ( ticket ( numero ?numero))
   ( empresa (nombre ?nombre))

   ?f1 <- ( venta-anticipada
     ( rut ?rut)
     ( tipo-de-documento ?tipo-de-documento)
     ( partida ?numero_1)
     ( folio ?folio)
     ( unidades ?unidades)
     ( costo_unitario ?costo_unitario)
     ( dia ?dia_1) (mes ?mes_1) (ano ?ano_1)
     ( credito ?credito)
     ( colaborador ?colaborador) 
     ( material ?material)
     ( total ?total) 
     ( neto ?neto) 
     ( iva ?iva))

   ( amortizacion
     ( folio ?folio)
     ( partida ?numero)
     ( dia ?dia) (mes ?mes) (ano ?ano))

   ( test (neq nil ?material))
   ( test (neq nil ?colaborador))
   ( test (eq nil ?credito ))
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (and (not (eq nil ?neto)) (> ?neto 0)))
   ( test (and (not (eq nil ?iva)) (> ?iva 0)))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

  =>
   ( assert (partida (proveedor ?colaborador) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por amortizacion de Folio: " ?folio " colaborador: " ?colaborador " " ?material " total: " ?total )) (actividad amortizar-credito-de-atencion-a-colaborador)))

   ( assert (abono (tipo-de-documento ?tipo-de-documento) (empresa ?nombre) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (cuenta ventas) (monto ?neto) (glosa (str-cat por-amortizacion-de- ?material)) ) )

   ( assert (abono (tipo-de-documento ?tipo-de-documento) (empresa ?nombre) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (cuenta iva-debito) (monto ?iva) (glosa (str-cat por-amortizacion-de- ?material)) ) )

   ( assert (cargo (tipo-de-documento ?tipo-de-documento) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta ingresos-percibidos-por-adelantado) (monto ?total) (glosa (str-cat " Por amortización de Folio: " ?folio " material: " ?material))))
   ( assert (ccm (folio ?folio) (partida ?numero) (tipo-documento ?tipo-de-documento) (monto-total ?total) (rut-contraparte ?rut) (razon-social-contraparte ?colaborador) (monto-neto ?neto)))
   ( printout t "-->am Amortizando Factura " tab ?folio tab ?material tab ?colaborador crlf)

)

(defrule rendir-vouchers-exentos-sii
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))
   ( ticket ( numero ?numero))
   ( empresa (nombre ?nombre))
     
   ?f1 <- ( rendicion-de-vouchers-sii
     (partida ?numero)
     (unidades ?unidades)
     (mes ?mes) (ano ?ano)
     (total ?total)
     (neto ?neto)
     (iva ?iva))
   
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (and (not (eq nil ?neto)) (= ?neto 0))) 
   ( test (and (not (eq nil ?iva)) (= ?iva 0)))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date 1 ?mes ?ano)))

  => 
   ( bind ?dia 31)
   ( assert (partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por rendición de vouchers de " ?mes " de " ?ano)) (actividad rendir-vouchers-exentos-sii)))

   ( assert (cargo (qty ?unidades) (electronico true) (partida ?numero) (tipo-de-documento 48 ) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta banco-estado) (monto ?total) (glosa (str-cat " vouchers de " ?mes " de " ?ano))))

   ( assert (abono (qty ?unidades) (electronico true) (partida ?numero) (tipo-de-documento 48 ) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta ventas-con-voucher-exento) (monto (round ?total)) (glosa (str-cat " vouchers de " ?mes " de " ?ano ))))

;   ( assert (abono (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta iva-debito) (monto ?iva) (glosa (str-cat " boletas de " ?mes " de " ?ano))))
  ( assert (ccm (folio na) (partida ?numero) (tipo-documento 48) (monto-total ?total)))
  ( printout t "-->rv Rendición Mensual de Vouchers Exentos Válidos como Boleta Electrónica SII $" ?total crlf  )
)


(defrule rendir-vouchers-afectos-sii
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))
   ( ticket ( numero ?numero))
   ( empresa (nombre ?nombre))
     
   ?f1 <- ( rendicion-de-vouchers-sii
     (partida ?numero)
     (unidades ?unidades)
     (mes ?mes) (ano ?ano)
     (total ?total)
     (neto ?neto)
     (iva ?iva))
   
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (and (not (eq nil ?neto)) (> ?neto 0))) 
   ( test (and (not (eq nil ?iva)) (> ?iva 0)))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date 1 ?mes ?ano)))

  => 
   ( bind ?dia 31)
   ( assert (partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por rendición de vouchers de " ?mes " de " ?ano)) (actividad rendir-vouchers-afectos-sii)))

   ( assert (cargo (qty ?unidades) (electronico true) (partida ?numero) (tipo-de-documento 48 ) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta banco-estado) (monto ?total) (glosa (str-cat " vouchers de " ?mes " de " ?ano))))

   ( assert (abono (qty ?unidades) (electronico true) (partida ?numero) (tipo-de-documento 48 ) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta ventas-con-voucher-afecto) (monto ?neto) (glosa (str-cat " vouchers de " ?mes " de " ?ano ))))

   ( assert (abono (qty ?unidades) (partida ?numero) (electronico true) (tipo-de-documento 48 ) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta iva-debito) (monto ?iva) (glosa (str-cat " vouchers de " ?mes " de " ?ano))))

  ( assert (ccm (folio na) (partida ?numero) (tipo-documento 48) (monto-total ?total) (monto-iva-recuperable ?iva) (monto-neto ?neto) ))
  ( printout t "-->rv Rendición Mensual de Vouchers Afectos Válidos como Boleta Electrónica SII $" ?total crlf  )
)



(defrule rendir-eboletas-exenta-sii
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))
   ( ticket ( numero ?numero))
   ( empresa (nombre ?nombre))
     
   ?f1 <- ( rendicion-de-eboletas-sii
     (folio ?folio)
     (partida ?numero)
     (unidades ?unidades)
     (mes ?mes) (ano ?ano)
     (total ?total)
     (neto ?neto)
     (iva ?iva))
   
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (and (not (eq nil ?neto)) (= ?neto 0))) 
   ( test (and (not (eq nil ?iva)) (= ?iva 0)))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date 1 ?mes ?ano)))

  => 
   ( bind ?dia 31)
   ( assert (partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por rendición de e-boletas exentas de " ?mes " de " ?ano)) (actividad rendir-eboletas-sii)))

   ( assert (cargo (tipo-de-documento 39) (qty ?unidades) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta banco-estado) (monto ?total) (glosa (str-cat " e-boletas exentas de " ?mes " de " ?ano))))
   ( assert (abono (tipo-de-documento 39) (qty ?unidades) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta ventas-con-eboleta-exenta) (monto ?total) (glosa (str-cat " e- boletas exentas de " ?mes " de " ?ano ))))
  ; ( assert (abono (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta iva-debito) (monto ?iva) (glosa (str-cat " boletas de " ?mes " de " ?ano))))

  ( assert (ccm (folio na) (partida ?numero) (tipo-documento 39) (monto-total ?total) (monto-neto ?neto)))
  ( printout t "-->rv Rendición Mensual de e-Boletas Electrónicas Exentas en SII $" ?total crlf  )
)



(defrule rendir-eboletas-afecta-sii
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))
   ( ticket ( numero ?numero))
   ( empresa (nombre ?nombre))

   ?f1 <- ( rendicion-de-eboletas-sii
     (folio ?folio)
     (partida ?numero)
     (unidades ?unidades)
     (mes ?mes) (ano ?ano)
     (total ?total)
     (neto ?neto)
     (iva ?iva))

   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (and (not (eq nil ?neto)) (> ?neto 0)))
   ( test (and (not (eq nil ?iva)) (> ?iva 0)))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date 1 ?mes ?ano)))

  =>
   ( bind ?dia 31)
   ( assert (partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por rendición de e-boletas afectas de " ?mes " de " ?ano)) (actividad rendir-boletas-sii)))

   ( assert (cargo (qty ?unidades)  (tipo-de-documento 39) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta banco-estado) (monto ?total) (glosa (str-cat " e-boletas afectas de " ?mes " de " ?ano))))

   ( assert (abono (qty ?unidades) (tipo-de-documento 39) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta ventas-con-eboleta-afecta) (monto ?neto) (glosa (str-cat " e-boletas afectas de " ?mes " de " ?ano ))))

   ( assert (abono (qty ?unidades) (tipo-de-documento 39) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta iva-debito) (monto ?iva) (glosa (str-cat " e-boletas afectas de " ?mes " de " ?ano))))

  ( assert (ccm (folio na) (partida ?numero) (tipo-documento 39) (monto-total ?total) (monto-iva-recuperable ?iva) (monto-neto ?neto)))
  ( printout t "-->rv Rendición Mensual de e-Boletas Electrónicas Afectas Emitidas en SII $" ?total crlf  )
)



(defrule vender-en-registro-compra-venta-no-afecto-sii
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))
   ( ticket ( numero ?numero))
   ( empresa (nombre ?nombre))

   ?f1 <- ( venta-sii
     (archivo ?archivo)
     (rut ?rut)
     (qty ?qty)
     (partida ?numero)
     (folio ?folio)
     (unidades ?unidades)
     (costo_unitario ?costo_unitario)
     (dia ?dia) (mes ?mes) (ano ?ano)
     (credito ?credito)
     (colaborador ?colaborador)
     (material ?material)
     (total ?total)
     (neto ?neto)
     (iva ?iva))


   ( test (neq nil ?material))
   ( test (neq nil ?colaborador))
   ( test (eq nil ?credito ))
   ( test (and (not (eq nil ?total)) (eq ?total 0)))
   ( test (and (not (eq nil ?neto)) (> ?neto 0)))
;   ( test (and (not (eq nil ?iva)) (eq ?iva 0)))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

  =>
   ( assert (partida (proveedor ?colaborador) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por venta en registro de compra-ventas del SII folio: " ?folio " de "  ?material " a " ?colaborador)) (actividad vender-en-registro-de-compra-venta-sii) (archivo (str-cat "../factura-propia-exenta-" ?folio ".png"))))

   ( assert (cargo (tipo-de-documento 34) (electronico true) (qty ?qty) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta banco-estado) (monto ?neto) (glosa (str-cat "-" ?material))))

   ( assert (abono (tipo-de-documento 34) (electronico true) (qty ?qty) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta ventas-con-factura-exenta) (monto ?neto) (glosa (str-cat "-" ?material))))



  ( assert (ccm (folio ?folio) (partida ?numero) (tipo-documento 34) (monto-total ?neto) (razon-social-contraparte ?colaborador) (rut-contraparte ?rut) (monto-exento ?neto) ))

  ( printout t "-->vsii Venta SII No Afecta " ?folio " de " ?material " por un valor de $" ?total crlf  )
)




(defrule vender-en-registro-compra-venta-sii
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))
   ( ticket ( numero ?numero))
   ( empresa (nombre ?nombre))

   ?f1 <- ( venta-sii
     (rut ?rut)
     (qty ?qty)
     (partida ?numero)
     (folio ?folio) 
     (unidades ?unidades) 
     (costo_unitario ?costo_unitario) 
     (dia ?dia) (mes ?mes) (ano ?ano) 
     (credito ?credito)
     (colaborador ?colaborador)
     (material ?material)
     (total ?total) 
     (neto ?neto) 
     (iva ?iva)
     (archivo ?archivo)
)

   ( test (neq nil ?material))
   ( test (neq nil ?colaborador))
   ( test (eq nil ?credito ))
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (and (not (eq nil ?neto)) (> ?neto 0)))
   ( test (and (not (eq nil ?iva)) (> ?iva 0))) 
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

  =>
   ( assert (partida (proveedor ?colaborador) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por venta en registro de compra-ventas del SII folio: " ?folio " de "  ?material " a " ?colaborador)) (actividad vender-en-registro-de-compra-venta-sii)  (archivo (str-cat "../factura-propia-afecta-" ?folio ".png"))))

   ( assert (cargo (tipo-de-documento 33) (electronico true) (qty ?qty) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta banco-estado) (monto ?total) (glosa (str-cat "-" ?material))))

  ;( assert (abono (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta ventas) (monto ?neto) (glosa (str-cat "-" ?material))))

   ( assert (abono (tipo-de-documento 33) (electronico true) (qty ?qty) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta ventas-con-factura-afecta) (monto ?neto) (glosa (str-cat "-" ?material))))

   ( assert (abono (tipo-de-documento 33) (electronico true) (qty ?qty) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta iva-debito) (monto ?iva) (glosa (str-cat "-" ?material))))

  ( assert (ccm (folio ?folio) (partida ?numero) (tipo-documento 33) (monto-total ?total) (razon-social-contraparte ?colaborador) (rut-contraparte ?rut) (monto-iva-recuperable ?iva) (monto-neto ?neto) ))

  ( printout t "-->vsii Venta SII " ?folio " de " ?material " por un valor de $" ?total crlf  )
)



(defrule ingreso-anticipado-de-credito-de-atencion-a-colaborador
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))
   ( ticket ( numero ?numero))
   ( empresa (nombre ?nombre))

   ?f1 <- ( venta-anticipada
     (rut ?rut)
     (partida ?numero)
     (folio ?folio)
     (unidades ?unidades) 
     (costo_unitario ?costo_unitario)
     (dia ?dia) (mes ?mes) (ano ?ano) 
     (credito ?credito)
     (colaborador ?colaborador) 
     (material ?material)
     (total ?total) 
     (neto ?neto) 
     (iva ?iva))

   ( test (neq nil ?material))
   ( test (neq nil ?colaborador))
   ( test (neq nil ?credito ))
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (and (not (eq nil ?neto)) (> ?neto 0)))
   ( test (and (not (eq nil ?iva)) (> ?iva 0)))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

  =>

   ( assert (partida (proveedor ?colaborador) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por ingreso anticipado en folio: " ?folio " de "  ?material " a " ?colaborador)) (actividad ingreso-anticipado-de-credito-de-atencion-a-colaborador)))

   ( assert (cargo (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta banco-estado) (monto ?total) (glosa (str-cat "-" ?material))))

   ( assert (abono (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta ingresos-percibidos-por-adelantado) (monto ?total) (glosa (str-cat "-" ?material))))

  ( assert (ccm (folio ?folio) (partida ?numero) (tipo-documento ingreso-anticipado-colaborador) (monto-total ?total) (razon-social-contraparte ?colaborador) (rut-contraparte ?rut) (monto-iva-recuperable ?iva) (monto-neto ?neto)))
  ( printout t "-->ia Ingreso Anticipado Factura " ?folio " de " ?material " por un valor de $" ?total crlf  )
)


(defrule anular-vouchers
   (no funciona)
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))
   ( ticket ( numero ?numero))
   ( empresa (nombre ?nombre))
   ( anulacion-de-vouchers
     (rut ?rut)
     (subcuenta ?subcuenta)
     (recibida true)
     (folio-nota ?folio-nota)
     (glosa ?glosa)
     (total ?total)
     (neto ?neto)
     (iva ?iva)
     (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano)
   )
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (and (not (eq nil ?neto)) (> ?neto 0)))
;   ( test (and (not (eq nil ?iva)) (> ?iva 0)))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
 =>
   ( assert (partida (proveedor subcuenta) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat  "Devolución a subcuenta " ?subcuenta " por " ?glosa " mes " ?mes)) (actividad anular-vouchers)))
   ( assert (cargo (tipo-de-documento 61) (recibida true) (electronico true) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta banco-estado) (monto ?total) (glosa (str-cat nota-credito ?subcuenta) )))

   ( assert (abono (tipo-de-documento 61) (recibida true) (electronico true) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta ?subcuenta) (monto ?neto) (glosa ?glosa)))


   ( assert (abono (tipo-de-documento 61) (recibida true) (electronico true) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta iva-credito) (monto ?iva) (glosa (str-cat nota-credito ?subcuenta))))

   ( assert (ccm (folio ?folio-nota) (partida ?numero) (tipo-documento 61) (monto-total ?total) (razon-social-contraparte ?subcuenta) (rut-contraparte ?rut) (monto-neto ?neto)))
   ( printout t "-->avouchers Anula Vouchers " ?subcuenta " por " ?total crlf  )
   ( halt )
)



(defrule dar-cuenta-de-nota-de-credito-de-factura-reclamada-de-proveedor
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))
   ( ticket ( numero ?numero))
   ?nonce <- ( nonce (ticket ?numero) )
   ( empresa (nombre ?nombre))
   ( nota-de-credito-de-factura-reclamada
     (cuenta-de-pago ?cuenta-de-pago)
     (folio-factura ?folio-factura)
     (folio-nota ?folio-nota)
     (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano)
   )
   ?f1 <- (gasto-proveedor (folio ?folio-factura) (rut ?rut) (tipo-de-documento ?tipo-de-documento) (electronico ?electronico) (partida ?partida-factura) (dia ?dia-factura) (mes ?mes-factura) (ano ?ano-factura) (credito ?credito) (proveedor ?proveedor) (material ?material) (total ?total) (neto ?neto) (iva ?iva) (glosa ?glosa) (iva-retenido ?iva-retenido))
   ( cuenta (nombre ?proveedor) (padre ?padre))
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (and (not (eq nil ?neto)) (> ?neto 0)))
   ( test (and (not (eq nil ?iva)) (> ?iva 0)))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
 =>
;  ( if (eq ?folio-factura 43342312) then (halt;)
;  ( printout t partida tab ?numero crlf ?dia tab ?mes crlf tab total tab ?total crlf neto tab ?neto crlf iva tab ?iva crlf)
  ( retract ?nonce)
  ( assert (partida (proveedor subcuenta) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat  "Devolución a subcuenta " ?proveedor " por " ?glosa " mes " ?mes)) (actividad dar-cuenta-de-nota-de-credito-de-factura-reclamada-de-proveedor) (archivo (str-cat "../nota-de-credito-" ?proveedor "-" ?folio-nota ".png" ))))
  ( assert (cargo (tipo-de-documento 61) (recibida true) (electronico true) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta ?cuenta-de-pago) (monto ?total) (glosa (str-cat nota-credito ?proveedor) )))
  ( assert (abono (tipo-de-documento 61) (recibida true) (electronico true) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta ?proveedor) (monto ?neto) (glosa ?glosa)))

  ( assert (abono (tipo-de-documento 61) (recibida true) (electronico true) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta iva-credito) (monto ?iva) (glosa (str-cat nota-credito ?proveedor))))
  ( assert (ccm (folio ?folio-nota) (partida ?numero) (tipo-documento 61) (monto-total ?total) (razon-social-contraparte ?proveedor) (rut-contraparte ?rut) (monto-neto ?neto)))
  ( printout t "-->nct Nota de Crédito de Factura Reclamada " ?folio-factura " a subcuenta " ?proveedor crlf  )
)

(defrule recibir-nota-de-credito-recibida-de-subcuenta-existente
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))
   ( ticket ( numero ?numero))
   ( empresa (nombre ?nombre))
   ( nota-de-credito-de-subcuenta-existente
     (proveedor ?proveedor)
     (rut ?rut)
     (subcuenta ?subcuenta)
     (recibida true)
     (folio-nota ?folio-nota)
     (glosa ?glosa)
     (total ?total)
     (neto ?neto)
     (iva ?iva)
     (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano)
     (archivo ?archivo)
   )
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (and (not (eq nil ?neto)) (> ?neto 0)))
;   ( test (and (not (eq nil ?iva)) (> ?iva 0)))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
 =>

   ( assert (partida (proveedor subcuenta) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat  "Devolución a subcuenta " ?subcuenta " por " ?glosa " mes " ?mes)) (actividad dar-nota-de-credito-recibida-subcuenta-existente) (archivo (str-cat "../nota-de-credito-" ?proveedor "-" ?folio-nota ".png") )))

   ( assert (cargo (tipo-de-documento 61) (recibida true) (electronico true) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta banco-estado) (monto ?total) (glosa (str-cat nota-credito ?subcuenta) )))

   ( assert (abono (tipo-de-documento 61) (recibida true) (electronico true) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta ?subcuenta) (monto ?neto) (glosa ?glosa)))

   ( assert (abono (tipo-de-documento 61) (recibida true) (electronico true) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta iva-credito) (monto ?iva) (glosa (str-cat nota-credito ?subcuenta))))

;  ( assert (abono (tipo-de-documento 61) (recibida true) (electronico true) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta iva-debito) (monto ?iva) (glosa (str-cat nota-credito ?subcuenta))))


   ( assert (ccm (folio ?folio-nota) (partida ?numero) (tipo-documento 61) (monto-total ?total) (razon-social-contraparte ?subcuenta) (rut-contraparte ?rut) (monto-neto ?neto)))

   ( printout t "-->nct Nota de Crédito Recibida " ?subcuenta " por " ?total crlf  )
)




(defrule dar-nota-de-credito-emitida-de-subcuenta-existente
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))
   ( ticket ( numero ?numero))
   ( empresa (nombre ?nombre))
   ( nota-de-credito-de-subcuenta-existente
     (proveedor ?proveedor)
     (archivo ?archivo)
     (rut ?rut)
     (subcuenta ?subcuenta)
     (emitida true)
     (folio-nota ?folio-nota)
     (glosa ?glosa)
     (total ?total)
     (neto ?neto)
     (iva ?iva)
     (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano)
   )
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (and (not (eq nil ?neto)) (> ?neto 0)))
;   ( test (and (not (eq nil ?iva)) (> ?iva 0)))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

 =>
   ( assert (partida (proveedor subcuenta) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat  "Devolución a subcuenta " ?subcuenta " por " ?glosa " mes " ?mes)) (actividad dar-nota-de-credito-emitida-subcuenta-existente) (archivo (str-cat "../nota-de-credito-propia-" ?folio-nota ".png")  )  ))

   ( assert (abono (tipo-de-documento 61) (electronico true) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta banco-estado) (monto ?total) (glosa (str-cat nota-credito ?subcuenta) )))

  ; ( assert (cargo (tipo-de-documento 61) (electronico true) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta notas-de-credito) (monto ?neto) (glosa ?glosa)))

   ( assert (cargo (tipo-de-documento 61) (electronico true) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta ?subcuenta) (monto ?neto) (glosa ?glosa)))

;   ( assert (cargo (tipo-de-documento 61) (electronico true) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta iva-credito) (monto ?iva) (glosa (str-cat nota-credito ?subcuenta))))

;Nota: Cuando vendo aumento iva-credito, como iva-credito es cuenta de activo-
;se carga al debe-así que se aumenta el debe
;Pero cuando anulo una venta, debiese disminuir el iva-credito anotándolo al haber, pero en f29 se considera una dismunición del debitdo, así que debe anotarse al deber del debtido. Eso es un cargo en la cuenta iva-debito.

   ( assert (cargo (tipo-de-documento 61) (electronico true) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta iva-debito) (monto ?iva) (glosa (str-cat nota-credito ?subcuenta))))


  ( assert (ccm (folio ?folio-nota) (partida ?numero) (tipo-documento 61) (monto-total ?total) (rut-contraparte ?rut) (monto-iva-recuperable ?iva) (razon-social-contraparte ?subcuenta) (monto-neto ?neto)))

   ( printout t "-->nct Nota de Crédito Emitida " ?subcuenta " por " ?total crlf  )
)




(defrule dar-nota-de-credito-anonima-con-monto
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))
   ( ticket ( numero ?numero))
   ( empresa (nombre ?nombre))
   ( nota-de-credito
     (rut ?rut)
     (folio-nota ?folio-nota)
     (folio ?folio)
     (total ?total)
     (neto ?neto)
     (iva ?iva)
     (colaborador ?colaborador)
     (material ?material)
     (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano)
   )
;  ( test (neq nil ?material))
;  ( test (neq nil ?colaborador))
;  ( test (eq nil ?credito ))
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (and (not (eq nil ?neto)) (> ?neto 0)))
 ; ( test (and (not (eq nil ?iva)) (> ?iva 0)))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
 =>
   ( assert (partida (proveedor ?colaborador) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Nota de Crédito SII: " ?folio-nota " que anula Factura SII " ?folio " de "  ?material " a " ?colaborador)) (actividad dar-nota-de-credito-anomina-con-monto)))

   ( assert (cargo (tipo-de-documento 56) (electronico true) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta banco-estado) (monto ?total) (glosa (str-cat " nota-credito " ?material))))

;:   ( assert (cargo (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta devolucion-sobre-ventas) (monto ?neto) (glosa (str-cat " nota-credito " ?material))))

   ( assert (abono (tipo-de-documento 56) (electronico true) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta notas-de-credito) (monto ?neto) (glosa (str-cat " nota-credito " ?material))))

   ( assert (abono (tipo-de-documento 56) (electronico true) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta iva-debito) (monto ?iva) (glosa (str-cat " nota-credito " ?material))))
  ( assert (ccm (folio ?folio) (partida ?numero) (tipo-documento 56) (monto-total ?total) (razon-social-contraparte ?colaborador) (rut-contraparte ?rut) (monto-neto ?neto)))
  ( printout t "-->nc Nota de Crédito SII" ?folio-nota " de la Factura SII " ?folio " de " ?material " por un valor de $" ?total crlf  )
)

(defrule dar-nota-de-debito-manual
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))
   ( ticket ( numero ?numero))
   ( empresa (nombre ?nombre))
   ( nota-de-debito-manual
    (archivo ?archivo)
    (rut ?rut)
    (subcuenta ?subcuenta)
    (neto ?neto)
    (iva  ?iva)
    (total ?total)
    (folio-debito ?folio-debito)
    (folio-credito ?folio-credito)
    (partida ?numero) 
    (dia ?dia) (mes ?mes) (ano ?ano)
   )

   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (and (not (eq nil ?neto)) (> ?neto 0)))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  =>
   ( assert (partida (archivo ?archivo) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Nota de Débito Manual: " ?folio-debito " que anula a Nota de Crédito SII " ?folio-credito )) (actividad dar-nota-de-debito-manual)))

   ( assert (cargo (tipo-de-documento 56) (electronico true) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta banco-estado) (monto ?total) (glosa (str-cat " nota-debito " ?folio-debito))))

;  ( assert (abono (tipo-de-documento 56) (electronico true) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta iva-credito) (monto ?iva) (glosa nota-debito )))

   ( assert (abono (tipo-de-documento 56) (electronico true) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta iva-debito) (monto ?iva) (glosa nota-debito )))


   ( assert (abono (tipo-de-documento 56) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta ?subcuenta) (monto ?neto) (glosa (str-cat " nota-debito " ?folio-debito))))

   ( assert (ccm (folio ?folio-debito) (partida ?numero) (tipo-documento 56) (monto-total ?neto) (razon-social-contraparte ?subcuenta) (rut-contraparte ?rut) (monto-neto ?neto)))
)


(defrule dar-nota-de-debito-sii
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))
   ( ticket ( numero ?numero))
   ( empresa (nombre ?nombre))


   ( nota-de-credito-de-subcuenta-existente
     ( rut ?rut)
     ( subcuenta ?subcuenta )
     ( folio-nota ?folio-credito)
     ( total ?total)
     ( neto ?neto)
     ( iva ?iva))
   

   ( nota-de-debito-sii (archivo ?archivo) (folio-debito ?folio-debito) (folio-credito ?folio-credito) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano))

   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (and (not (eq nil ?neto)) (> ?neto 0)))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
 =>
   ( assert (partida (archivo ?archivo) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Nota de Débito SII: " ?folio-debito " que anula a Nota de Crédito SII " ?folio-credito )) (actividad dar-nota-de-debito-sii)))

   ( assert (cargo (tipo-de-documento 56) (electronico true) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta banco-estado) (monto ?total) (glosa (str-cat " nota-debito " ?folio-debito))))

   ( assert (abono (tipo-de-documento 56) (electronico true) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta iva-credito) (monto ?iva) (glosa nota-debito )))

  ( assert (abono (tipo-de-documento 56) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta ?subcuenta) (monto ?neto) (glosa (str-cat " nota-debito " ?folio-debito))))

   ( assert (ccm (folio ?folio-credito) (partida ?numero) (tipo-documento 56) (monto-total ?neto) (rut-contraparte ?rut) (monto-neto ?neto)))

)


(defrule dar-nota-de-credito-sii
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))
   ( ticket ( numero ?numero))
   ( empresa (nombre ?nombre))

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

   ( nota-de-credito-sii (folio-nota ?folio-nota) (folio ?folio) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (archivo ?archivo))
   ;( exists ( cuenta (nombre ?colaborador)))

   ( test (neq nil ?material))
   ( test (neq nil ?colaborador))
   ( test (eq nil ?credito ))
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (and (not (eq nil ?neto)) (> ?neto 0)))
   ( test (and (not (eq nil ?iva)) (> ?iva 0)))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

 =>

  ; ( assert
  ;  ( cuenta
  ;     (nombre ?colaborador)
  ;     (descripcion (str-cat creditos-otorgados-a- ?colaborador))
  ;     (tipo acreedora)
  ;     (grupo pasivo)
  ;     (circulante true)
  ;     (padre colaboradores)
 ;      (origen nominativo) ) )
;
   ( assert (partida (proveedor ?colaborador) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Nota de Crédito SII: " ?folio-nota " que anula Factura SII " ?folio " de "  ?material " a " ?colaborador)) (actividad dar-nota-de-credito-sii) (archivo (str-cat "../nota-de-credito-propia-" ?folio ".png"))))

   ( assert (abono (tipo-de-documento 61) (electronico true) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta banco-estado) (monto ?total) (glosa (str-cat " nota-credito " ?material))))

   ( assert (cargo (tipo-de-documento 61) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta ventas-con-factura-afecta) (monto ?neto) (glosa (str-cat " nota-credito " ?material))))

;   ( assert (cargo (tipo-de-documento 61) (electronico true) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta notas-de-credito) (monto ?neto) (glosa (str-cat " nota-credito " ?material))))

   ( assert (cargo (tipo-de-documento 61) (electronico true) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta iva-debito) (monto ?iva) (glosa (str-cat " nota-credito " ?material))))

  ( assert (ccm (folio ?folio) (partida ?numero) (tipo-documento 61) (monto-total ?total) (rut-contraparte ?rut) (monto-iva-recuperable ?iva) (razon-social-contraparte ?colaborador) (monto-neto ?neto)))

  ( printout t "-->nc Nota de Crédito SII" ?folio-nota " de la Factura SII " ?folio " de " ?material " por un valor de $" ?total crlf  )
)



(defrule dar-nota-de-credito-a-venta
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))
   ( ticket ( numero ?numero))
   ( empresa (nombre ?nombre))

   ?f1 <- ( venta
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

   ( nota-de-credito (folio-nota ?folio-nota) (folio ?folio) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
   ;( exists ( cuenta (nombre ?colaborador)))

   ( test (neq nil ?material))
   ( test (neq nil ?colaborador))
   ( test (eq nil ?credito ))
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (and (not (eq nil ?neto)) (> ?neto 0)))
   ( test (and (not (eq nil ?iva)) (> ?iva 0)))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

   =>
   ( assert
    ( cuenta
       (nombre ?colaborador)
       (descripcion (str-cat creditos-otorgados-a- ?colaborador))
       (tipo acreedora)
       (grupo pasivo)
       (circulante true)
       (padre colaboradores)
       (origen nominativo) ) )

   ( assert (partida (proveedor ?colaborador) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Nota de Crédito : " ?folio-nota " que anula Factura " ?folio " de "  ?material " a " ?colaborador)) (actividad dar-nota-de-credito)))

   ( assert (abono (tipo-de-documento 61) (electronico true) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta ?colaborador) (monto ?total) (glosa (str-cat " nota-credito " ?material))))

;   ( assert (cargo (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta ventas) (monto ?neto) (glosa (str-cat " nota-credito " ?material))))

   ( assert (cargo (tipo-de-documento 61) (electronico true) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta ventas-con-factura-afecta) (monto ?neto) (glosa (str-cat " nota-credito " ?material))))


   ( assert (cargo (tipo-de-documento 61) (electronico true) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta iva-debito) (monto ?iva) (glosa (str-cat " nota-credito " ?material))))
  ( assert (ccm (folio ?folio) (partida ?numero) (tipo-documento 61) (monto-total ?total) (rut-contraparte ?rut) (monto-iva-recuperable ?iva) (razon-social-contraparte ?colaborador) (monto-neto ?neto)))

  ( printout t "-->nc Nota de Crédito " ?folio-nota " de la Factura " ?folio " de " ?material " por un valor de $" ?total crlf )
)


(defrule vender-a-cliente-al-contado
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))
   ( ticket ( numero ?numero))
   ( empresa (nombre ?nombre))
   ?f1 <- ( venta (rut ?rut) (folio ?folio) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (unidades ?unidades) (costo_unitario ?costo_unitario) (dia ?dia) (mes ?mes) (ano ?ano) (cliente ?cliente) (material ?material) (total ?total) (neto ?neto) (iva ?iva) (credito ?credito))
   ( test (not (eq nil ?material)))
   ( test (eq nil ?credito )) 
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (and (not (eq nil ?neto)) (> ?neto 0)))
   ( test (and (not (eq nil ?iva)) (> ?iva 0)))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

=>
   ( retract ?f1 )
   ( assert (partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por venta a contado a " ?cliente)) (actividad vender-a-cliente-al-contado)))
  ; ( assert (abono (empresa ?nombre) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (cuenta ventas) (monto ?neto) (glosa (str-cat (str-cat  ?material ->>-) ?cliente) )))
   ( assert (abono (tipo-de-documento ?tipo-de-documento) (empresa ?nombre) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (cuenta ventas-con-factura-afecta) (monto ?neto) (glosa (str-cat (str-cat  ?material ->>-) ?cliente) )))

   ( assert (cargo (tipo-de-documento ?tipo-de-documento) (empresa ?nombre) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (cuenta caja)  (monto ?total ) (glosa (str-cat venta-al-contado-de- ?material -a- ?cliente) )))
   ( assert (abono (tipo-de-documento ?tipo-de-documento) (empresa ?nombre) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (cuenta iva-debito) (monto ?iva) (glosa (str-cat por-venta-al-contado-de- ?material)) ) )
   ;( assert (inventario (partida ?numero) (operacion venta) (mes ?mes) (ano ?ano) (dia ?dia) (material ?material) (ct (* ?unidades ?costo_unitario)) (u ?unidades) (cu ?costo_unitario)) (glosa (str-cat por-compra-al-credito-de- ?material)) )

   ( assert (ccm (folio ?folio) (partida ?numero) (tipo-documento ?tipo-de-documento) (monto-total ?total) (rut-contraparte ?rut) (monto-iva-recuperable ?iva) (razon-social-contraparte ?cliente) (monto-neto ?neto)))

   ( printout t "****************************************************************************************" crlf)
   ( printout t " -->vc Vendiendo a cliente: " ?cliente crlf)
   ( printout t "      "  ?material " por un valor de $ " ?total crlf  )
   ( printout t "****************************************************************************************" crlf )
)

(defrule vender-al-credito-y-efectivo-exento
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))

   ( ticket ( numero ?numero))
   ( empresa (nombre ?nombre))
   ?f1 <- ( venta (folio ?folio) (rut ?rut) (tipo-de-documento 34) (partida ?numero) (unidades ?unidades) (costo_unitario ?costo_unitario) (dia ?dia) (mes ?mes) (ano ?ano) (credito ?credito) (cliente ?cliente) (material ?material) (total ?total) (neto ?neto) (iva ?iva) (exento ?exento) (efectivo ?efectivo))
   ( test (not (eq nil ?material)))
   ( test (and (not (eq nil ?credito )) (> ?credito 0) ))
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (neq nil ?efectivo))
;   ( test (and (not (eq nil ?neto)) (> ?neto 0)))
;   ( test (eq nil ?iva))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
=>
   ( bind ?proporcion (/ ?credito ?total))
   ( retract ?f1 )
   ( assert (partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por venta a " ?cliente)) (actividad vender-al-credito-y-efectivo-exento) (archivo (str-cat "../factura-propia-exenta-" ?folio ".png"))))
   
   ( assert (abono (tipo-de-documento 34) (empresa ?nombre) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (cuenta ventas-con-factura-exenta) (monto ?total) (glosa (str-cat (str-cat  ?material ->>-) ?cliente) )))

   ( assert (cargo (tipo-de-documento 34) (empresa ?nombre) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (cuenta caja)  (monto ?efectivo) (glosa (str-cat (str-cat (str-cat venta-fiada-de- ?material) -a-) ?cliente) )))

   ( assert
    ( cuenta (nombre ?cliente)
       (tipo-de-documento 34)
       (partida ?numero)
       (empresa ?nombre)
       (dia ?dia)
       (mes ?mes)
       (ano ?ano)
       (descripcion ?cliente)
       (tipo acreedora)
       (grupo pasivo)
       (circulante true)
       (padre cuentas-por-cobrar)
       (origen real))
   )

;  ( assert (abono (tipo-de-documento 34) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta ?cliente) (monto (round ?credito)) (glosa (str-cat credito-otorgado-a-este-cliente-cuando-la-venta-de- ?material))))
   ( assert (cargo (tipo-de-documento 34) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta cuentas-por-cobrar) (monto (round ?credito)) (glosa (str-cat credito-otorgado-a-este-cliente-cuando-la-venta-de- ?material))))


  ; ( assert (inventario (partida ?numero) (operacion venta) (mes ?mes) (ano ?ano) (dia ?dia) (material ?material) (ct (* ?unidades ?costo_unitario)) (u ?unidades) (cu ?costo_unitario)) (glosa (str-cat por-compra-al-credito-de- ?material)) )
   ( assert (ccm (folio ?folio) (partida ?numero) (tipo-documento 34) (rut-contraparte ?rut) (razon-social-contraparte ?cliente) (monto-neto 0) (monto-exento ?exento) (monto-total ?total)  ) )

  ( printout t "****************************************************************************************" crlf)
  ( printout t crlf "****** -->vexento Vendiendo exento al crédito y efectivo " ?material " por un valor de $" ?credito " de un valor total de " ?total crlf  )
  ( printout t "****************************************************************************************" crlf)
)





(defrule vender-al-credito-y-efectivo-afecto
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))

   ( ticket ( numero ?numero))
   ( empresa (nombre ?nombre))
   ?f1 <- ( venta (folio ?folio) (rut ?rut) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (unidades ?unidades) (costo_unitario ?costo_unitario) (dia ?dia) (mes ?mes) (ano ?ano) (credito ?credito) (cliente ?cliente) (material ?material) (total ?total) (neto ?neto) (iva ?iva) (efectivo ?efectivo)
(archivo ?archivo) (glosa ?glosa))
   ( test (not (eq nil ?material)))
   ( test (and (not (eq nil ?credito )) (> ?credito 0) ))
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (neq nil ?efectivo))
 ;  ( test (and (not (eq nil ?neto)) (> ?neto 0)))
   ( test (and (not (eq nil ?iva)) (> ?iva 0)))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

=>
   ( bind ?proporcion (/ ?credito ?total))
   ( retract ?f1 )
   ( assert (partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad vender-al-credito-y-efectivo-afecto) (archivo ?archivo) ))
  ;( assert (abono (empresa ?nombre) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (cuenta ventas) (monto ?neto) (glosa (str-cat (str-cat  ?material ->>-) ?cliente) )))

   ( assert (abono (tipo-de-documento ?tipo-de-documento) (empresa ?nombre) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (cuenta ventas-con-factura-afecta) (monto ?neto) (glosa (str-cat (str-cat  ?material ->>-) ?cliente) )))

   ( assert (cargo (tipo-de-documento ?tipo-de-documento) (empresa ?nombre) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (cuenta caja)  (monto ?efectivo) (glosa (str-cat (str-cat (str-cat venta-fiada-de- ?material) -a-) ?cliente) )))

   ( assert (abono (tipo-de-documento ?tipo-de-documento) (empresa ?nombre) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (cuenta iva-debito) (monto ?iva) (glosa (str-cat por-venta-fiada-de- ?material)) ) )

   ( assert
    ( cuenta (nombre ?cliente)
       (tipo-de-documento ?tipo-de-documento)
       (partida ?numero)
       (empresa ?nombre)
       (dia ?dia)
       (mes ?mes)
       (ano ?ano)
       (descripcion ?cliente)
       (tipo deudor)
       (grupo activo)
       (circulante true)
       (padre cuentas-por-cobrar)
       (origen real))
   )

   ( assert (cargo (tipo-de-documento ?tipo-de-documento) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta ?cliente) (monto (round ?credito)) (glosa (str-cat credito-otorgado-a-este-cliente-cuando-la-venta-de- ?material))))

 ;  ( assert (cargo (tipo-de-documento ?tipo-de-documento) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta cuentas-por-cobrar) (monto (round ?credito)) (glosa (str-cat credito-otorgado-a-este-cliente-cuando-la-venta-de- ?material))))

  ;: ( assert (cargo (tipo-de-documento ?tipo-de-documento) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta costos-de-ventas) (monto (round (* ?unidades ?costo_unitario))) (glosa (str-cat credito-otorgado-a-este-cliente-cuando-la-venta-de- ?material)) ))
   ( assert (inventario (partida ?numero) (operacion venta) (mes ?mes) (ano ?ano) (dia ?dia) (material ?material) (ct (* ?unidades ?costo_unitario)) (u ?unidades) (cu ?costo_unitario)) (glosa (str-cat por-compra-al-credito-de- ?material)) )
   ( assert (ccm (folio ?folio) (partida ?numero) (tipo-documento ?tipo-de-documento) (monto-total ?total) (monto-iva-recuperable ?iva) (rut-contraparte ?rut) (razon-social-contraparte ?cliente) (monto-neto ?neto)  ) )
  ( printout t "****************************************************************************************" crlf)
  ( printout t crlf "****** -->v Vendiendo al crédito y efectivo " ?material " por un valor de $" ?credito " de un valor total de " ?total crlf  )
  ( printout t "****************************************************************************************" crlf)
)




(defrule vender-al-credito
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))

   ( ticket ( numero ?numero))
   ( empresa (nombre ?nombre))
   ?f1 <- ( venta (folio ?folio) (rut ?rut) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (unidades ?unidades) (costo_unitario ?costo_unitario) (dia ?dia) (mes ?mes) (ano ?ano) (credito ?credito) (cliente ?cliente) (material ?material) (total ?total) (neto ?neto) (iva ?iva) (efectivo ?efectivo))
   ( test (not (eq nil ?material)))
   ( test (and (not (eq nil ?credito )) (> ?credito 0) ))
   ( test (and (not (eq nil ?total)) (> ?total 0)))
   ( test (eq nil ?efectivo))
 ;  ( test (and (not (eq nil ?neto)) (> ?neto 0)))
   ( test (and (not (eq nil ?iva)) (> ?iva 0)))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  =>
   ( bind ?proporcion (/ ?credito ?total))
   ( retract ?f1 )
   ( assert (partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por venta a " ?cliente)) (actividad vender-al-credito)))
   ;( assert (abono (empresa ?nombre) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (cuenta ventas) (monto ?neto) (glosa (str-cat (str-cat  ?material ->>-) ?cliente) )))
   ( assert (abono (tipo-de-documento ?tipo-de-documento) (empresa ?nombre) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (cuenta ventas-con-factura-afecta) (monto ?neto) (glosa (str-cat (str-cat  ?material ->>-) ?cliente) )))

   ( assert (cargo (tipo-de-documento ?tipo-de-documento) (empresa ?nombre) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (cuenta caja)  (monto  ?efectivo) (glosa (str-cat (str-cat (str-cat venta-fiada-de- ?material) -a-) ?cliente) )))
   ( assert (abono (tipo-de-documento ?tipo-de-documento) (empresa ?nombre) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (cuenta iva-debito) (monto ?iva) (glosa (str-cat por-venta-fiada-de- ?material)) ) )
   ( assert
    ( cuenta (nombre ?cliente)
       (partida ?numero)
       (empresa ?nombre)
       (dia ?dia)
       (mes ?mes)
       (ano ?ano)
       (descripcion ?cliente)
       (tipo acreedora)
       (grupo pasivo)
       (circulante true)
       (padre clientes)
       (origen nominativo))
   ) 
   ( assert (cargo (tipo-de-documento ?tipo-de-documento) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta ?cliente) (monto (round ?credito)) (glosa (str-cat credito-otorgado-a-este-cliente-cuando-la-venta-de- ?material))))
  ;( assert (cargo (tipo-de-documento ?tipo-de-documento) (partida ?numero) (dia ?dia) (mes ?mes ) (ano ?ano) (empresa ?nombre) (cuenta costos-de-ventas) (monto (round (* ?unidades ?costo_unitario))) (glosa (str-cat credito-otorgado-a-este-cliente-cuando-la-venta-de- ?material)) ))
   ( assert (inventario (partida ?numero) (operacion venta) (mes ?mes) (ano ?ano) (dia ?dia) (material ?material) (ct (* ?unidades ?costo_unitario)) (u ?unidades) (cu ?costo_unitario)) (glosa (str-cat por-compra-al-credito-de- ?material)) ) 
   ( assert (ccm (folio ?folio) (partida ?numero) (tipo-documento ?tipo-de-documento) (monto-total ?total) (rut-contraparte ?rut) (razon-social-contraparte ?cliente) (monto-neto ?neto)))
   ( printout t "****************************************************************************************" crlf )
   ( printout t crlf "****** -->v Vendiendo al crédito " ?material " por un valor de $" ?credito " de un valor total de " ?total crlf )
   ( printout t "****************************************************************************************" crlf )


)



(defrule gastar-al-comprar
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))

   ( ticket ( numero ?numero))
   ( empresa (nombre ?nombre))
   ?f1 <- (gasto-sobre-compras
              (folio ?folio)
              (rut ?rut)
              (tipo-de-documento ?tipo-de-documento)
              (unidades ?unidades )
              (costo_unitario ?costo-unitario)
              (partida ?numero) 
              (dia ?dia) (mes ?mes) (ano ?ano)
              (proveedor ?proveedor) (servicio ?servicio)
              (neto ?neto)
              (total ?total)
              (iva ?iva)
              (glosa ?glosa) (material ?material))
   ( test (> ?iva 0))
   ( test (> ?neto 0))
   ( test (> ?total 0))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  =>
   ( retract ?f1 )
   ( assert (partida (proveedor ?proveedor) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad gastar-al-comprar)))
   ( assert (abono (tipo-de-documento ?tipo-de-documento) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?nombre) (cuenta caja) (monto ?total) (glosa (str-cat (str-cat (str-cat a- ?proveedor) -por-pago-en-efectivo-de-) ?servicio))))
   ( assert (cargo (tipo-de-documento ?tipo-de-documento) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?nombre) (cuenta gastos-sobre-compras) (monto ?neto) (glosa (str-cat (str-cat (str-cat pago-a- ?proveedor) -por-perdida-de-gastos-en-) ?servicio))))
   ( assert (cargo (tipo-de-documento ?tipo-de-documento) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?nombre) (cuenta iva-credito) (monto ?iva) (glosa (str-cat credito-fiscal-por-compra-afecta- ?servicio)) ) )
   ( assert (inventario (partida ?numero) (operacion gasto-sobre-compra) (u ?unidades) (cu ?costo-unitario) (mes ?mes) (dia ?dia) (ano ?ano) (ct (round (* ?unidades ?costo-unitario))) (material ?material ) ))
   ( assert (ccm (folio ?folio) (partida ?numero) (tipo-documento ?tipo-de-documento) (monto-total ?total) (rut-contraparte ?rut) (monto-iva-recuperable ?iva) (razon-social-contraparte ?proveedor) (monto-neto ?neto)))
   ( printout t "-->p Pagando un gasto sobre compras de $" ?total " a" ?proveedor crlf )
)



(defrule despagar-con-cheque
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))

   ( ticket ( numero ?numero))
   ( empresa (nombre ?nombre))
   ?f1 <- (despago (folio ?folio) (rut ?rut) (partida ?numero) (dia ?dia) (proveedor ?proveedor) (servicio ?servicio) (neto ?neto ) (total ?total) (iva ?iva) (mes ?mes) (ano ?ano) (glosa ?glosa))
   ( test (neq nil ?proveedor ))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  =>
   ( retract ?f1 )
;  ( assert (dia ?dia))
   ( assert (partida (proveedor ?proveedor) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad despagar-con-cheque)))
   ( assert (abono (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?nombre) (cuenta banco-estado) (monto ?total) (glosa (str-cat (str-cat (str-cat proveedor- ?proveedor) -por-servicio-afecto-de-) ?servicio))))
  ; ( assert (cargo (partida ?numero) (dia ?dia) (mes ?mes) (empresa ?nombre) (cuenta compras) (monto ?neto) (glosa (str-cat (str-cat (str-cat proveedor- ?proveedor) -por-servicio-afecto-de-) ?servicio))))
  ;( assert (cargo (partida ?numero) (dia ?dia) (mes ?mes) (empresa ?nombre) (cuenta iva-credito) (monto ?iva) (glosa (str-cat por-servicio-afecto-de- ?servicio)) ) )
   ( assert
    ( cuenta (nombre ?proveedor)
       (partida ?numero)
       (dia ?dia)
       (mes ?mes)
       (ano ?ano)
       (descripcion ?proveedor)
       (tipo acreedora)
       (grupo pasivo)
       (circulante true)
       (padre proveedores)
       (origen nominativo))
   )
   ( assert (cargo (partida ?numero) (mes ?mes) (dia ?dia) (ano ?ano) (empresa ?nombre) (cuenta ?proveedor) (monto (round ?total)) (glosa (str-cat gastos-de-una-compra-pagados-a- ?servicio)) ))
   ( assert (ccm (folio ?folio) (partida ?numero) (tipo-documento despago) (monto-total ?total) (rut-contraparte ?rut) (monto-iva-recuperable ?iva) (razon-social-contraparte ?proveedor) (monto-neto ?neto)))
   (  printout t "despago- Pagando cheque debido a proveedor " ?proveedor " por un valor total de $" ?total crlf)
)



(defrule pagar-neto-mas-iva-a-proveedor
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( actual  (mes ?mes))

   ( ticket ( numero ?numero) )
   ( partida (dia ?dia) (numero ?numero))
   ( empresa (nombre ?nombre))
   ?f1 <- (pago (folio ?folio) (rut ?rut) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (proveedor ?proveedor) (servicio ?servicio) (neto ?neto ) (total ?total) (iva ?iva) (mes ?mes) (ano ?ano) (glosa ?glosa))
   ( test (> ?iva 0))
   ( test (> ?neto 0))
   ( test (> ?total 0))
   ( test (neq nil ?proveedor ))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  =>
   ( halt )
   ( printout t "No revisado" crlf)

   ( retract ?f1 )
   ( assert (partida (proveedor ?proveedor) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?glosa) (actividad pagar-neto-mas-iva-a-proveedor)))

   ( assert (cargo (tipo-de-documento ?tipo-de-documento) (partida ?numero) (dia ?dia) (mes ?mes) (empresa ?nombre) (cuenta caja) (monto ?total) (glosa (str-cat (str-cat (str-cat proveedor- ?proveedor) -por-servicio-afecto-de-) ?servicio))))

   ( assert (cargo (tipo-de-documento ?tipo-de-documento) (partida ?numero) (dia ?dia) (mes ?mes) (empresa ?nombre) (cuenta compras) (monto ?neto) (glosa (str-cat (str-cat (str-cat proveedor- ?proveedor) -por-servicio-afecto-de-) ?servicio))))

   ( assert (cargo (tipo-de-documento ?tipo-de-documento) (partida ?numero) (dia ?dia) (mes ?mes) (empresa ?nombre) (cuenta iva-credito) (monto ?iva) (glosa (str-cat por-servicio-afecto-de- ?servicio)) ) )
   ( assert
    ( cuenta (nombre ?proveedor)
       (partida ?numero)
       (dia ?dia)
       (descripcion pagos-realizados-a-proveedor-pinsal)
       (tipo acreedora)
       (grupo pasivo)
       (circulante true)
       (padre proveedores)
       (origen nominativo))
   )
   ( assert (abono (tipo-de-documento ?tipo-de-documento) (partida ?numero) (dia ?dia) (empresa ?nombre) (cuenta ?proveedor) (monto (round ?total)) (glosa (str-cat gastos-de-una-compra-pagados-a- ?servicio)) ))
  ( assert (ccm (folio ?folio) (partida ?numero) (tipo-documento ?tipo-de-documento) (monto-total ?total) (rut-contraparte ?rut) (monto-iva-recuperable ?iva) (razon-social-contraparte ?proveedor) (monto-neto ?neto)))
  ( printout t "-->p Pagando a proveedor " ?proveedor " por un valor total de $" ?total crlf )

)


(defrule pagar-retenciones-de-honorarios
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( actual  ( mes ?mes))
   ( ticket  ( numero ?numero) )
   ( empresa ( nombre ?empresa ))
   ?p <-  ( pago-de-retenciones-de-honorarios (folio ?folio) (rut ?rut) ( mes ?mes ) (ano ?ano) (partida ?numero) (pagado false) (monto ?retenciones))
  =>
  ( bind ?dia 31)
  ( modify ?p (pagado true))
  ( assert (partida (empresa ?empresa) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por pago de retenciones de honorarios " ?mes)) (actividad pagar-retenciones-de-honorarios)))
   ( assert (cargo (tipo-de-documento pago-de-retenciones-de-honorarios) (cuenta retenciones-por-pagar) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?retenciones) (glosa (str-cat por-pago-de-retenciones-de-honorarios ?retenciones))))
   ( assert (abono (tipo-de-documento pago-de-retenciones-de-honorarios) (cuenta banco-estado) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?retenciones) (glosa (str-cat por-pago-de-retenciones-de-honorarios ?retenciones))))
   ( assert (ccm (folio ?folio) (partida ?numero) (tipo-documento pagar-retenciones-honorarios) (monto-total ?retenciones) (rut-contraparte ?rut)))
   ( printout t "-->rh-pago " tab ?retenciones tab ?mes crlf)
)


(defrule depreciar-herramienta
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( actual  ( mes ?mes))
   ( ticket  ( numero ?numero) )
   ( empresa ( nombre ?empresa ))
;certificado-digital-sii

   ?p <-  ( depreciacion
     ( herramienta ?herramienta)
     ( mes ?mes )
     ( ano ?ano)
     ( partida ?numero)
     ( pagado false)
     ( monto ?monto))
  =>
   ( bind ?dia 31)
   ( modify ?p (pagado true))
   ( assert (partida (empresa ?empresa) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por depreciacion en " ?mes " de " ?herramienta)) (actividad depreciacion-herramienta)))
   ( assert (cargo (tipo-de-documento depreciacion) (cuenta depreciacion) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?monto) (glosa (str-cat por-depreciacion-de-herramienta- ?herramienta))))
   ( assert (abono (tipo-de-documento depreciacion-de-herramienta) (cuenta depreciacion-acumulada-herramientas) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?monto) (glosa (str-cat por-reconocimiento-de-depreciacion-de- ?herramienta))))
   ( assert (ccm (folio na) (partida ?numero) (tipo-documento depreciacion-herramienta) (monto-total ?monto)))
   ( printout t "-->dep-activo-fijo " tab ?monto tab ?mes crlf)
)



(defrule amortizar-intangible
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( actual  ( mes ?mes))
   ( ticket  ( numero ?numero) )
   ( empresa ( nombre ?empresa ))
;certificado-digital-sii

   ?p <-  ( amortizacion
     ( intangible ?intangible)
     ( mes ?mes )
     ( ano ?ano)
     ( partida ?numero)
     ( pagado false)
     ( monto ?monto))
  =>
  ( bind ?dia 31)
  ( modify ?p (pagado true))
  ( assert (partida (empresa ?empresa) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por amortizacion en " ?mes " de " ?intangible)) (actividad amortizacion)))
  ( assert (cargo (tipo-de-documento amortizacion) (cuenta amortizacion-intangibles) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?monto) (glosa (str-cat por-amortizacion-de-intangible- ?intangible))))
  ( assert (abono (tipo-de-documento amortizacion-de-intangible) (cuenta amortizacion-acumulada-intangibles) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?monto) (glosa (str-cat por-pago-de-amortizacion-de- ?intangible))))
  ( assert (ccm (folio na) (partida ?numero) (tipo-documento amortizacion-intangible) (monto-total ?monto)))
  ( printout t "-->am-intangible " tab ?monto tab ?mes crlf)
)

(defrule amortizar-instantanea-de-intangible
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( actual  ( mes ?mes))
   ( ticket  ( numero ?numero) )
   ( empresa ( nombre ?empresa ))
?p <-  ( amortizacion-instantanea-extracontable
     ( intangible ?intangible)
     ( mes ?mes )
     ( ano ?ano)
     ( partida ?numero)
     ( pagado false)
     ( monto ?monto))
  =>
  ( bind ?dia 31)
  ( modify ?p (pagado true))
  ( assert (partida (empresa ?empresa) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por amortizacion en " ?mes " de " ?intangible)) (actividad amortizacion)))
  ( assert (cargo (tipo-de-documento amortizacion) (cuenta amortizacion-instantanea-de-intangibles) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?monto) (glosa (str-cat por-amortizacion-instantanea-de-intangible- ?intangible))))
  ( assert (abono (tipo-de-documento amortizacion) (cuenta amortizacion-acumulada-instantanea) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?monto) (glosa (str-cat por-amortizacion-instantanea-de-intangible- ?intangible))))
  ( assert (ccm (folio na) (partida ?numero) (tipo-documento amortizacion-instantanea-extracontable) (monto-total ?monto)))
  ( printout t "-->ai-intangible " tab ?monto tab ?mes crlf)
)


(defrule pagar-ppv
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

   ( actual  ( mes ?mes))
   ( ticket  ( numero ?numero) )
   ( empresa ( nombre ?empresa ))
   ?p <-  ( pago-de-ppv ( mes ?mes ) (ano ?ano) (partida ?numero) (pagado false) (monto ?ppv))
  =>
  ( bind ?dia 31)
  ( modify ?p (pagado true))
  ( assert (partida (empresa ?empresa) (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion (str-cat "Por pago del ppv " ?mes)) (actividad pagar-ppv)))
   ( assert (cargo (tipo-de-documento pago-de-ppv) (cuenta ppv) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?ppv) (glosa (str-cat por-pago-de-ppm ?ppv))))
   ( assert (abono (tipo-de-documento pago-de-ppv) (cuenta banco-estado) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (monto ?ppv) (glosa (str-cat por-pago-de-ppm ?ppv))))
   ( assert (ccm (folio na) (partida ?numero) (tipo-documento pagar-ppv) (monto-total ?ppv)))
   ( printout t "-->ppv-pago " tab ?ppv tab ?mes crlf)
)


;   Don Cangrejo constituyó la empresa «Compumundo Hipermegared SpA» el 9 de octubre de 2020, con un capital de $5.000.000 divididas en 5000 acciones de serie única nominativas y sin valor nominal.

(defrule constituir-spa
   ( revision 
    (partida ?numero)
    (rechazado false) 
   )

  ( constitucion-de-spa ( mes ?mes) (ano ?ano) (partida ?numero) (capital ?capital) (numero-de-acciones ?numero-de-acciones) (serie ?serie) (nominativa ?nominativa) (valor-nominal ?valor-nominal) )
 =>
  (halt)
)





