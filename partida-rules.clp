(defmodule PARTIDA
  ( import MAIN deftemplate ?ALL )
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

(defrule inicio-modulo-partida

  ( declare (salience 10000))
 =>
  ( printout t "------------------- PARTIDA --------------------" crlf)
;  ( load-facts "selecciones.txt")

 ; ( matches encabezado-f29)
  ;( halt )
)


;Esto genera un index para queda ser visto en abductor.necios.cl
(defrule inicio-kindle-l-
   ( declare (salience 9000))
  =>
   ( if (neq nil l) then (close l))
   ( printout t "------------------- inicio-kindle-l ------------" crlf)

   ( bind ?archivo (str-cat "./templates/index.html"))

   ( open ?archivo l "w")
 ;  ( printout l "{% extends \"clips.html\" %}" crlf)
 ;  ( printout l "{% load static %}" crlf)
  ; ( printout l "{% block clips %}" crlf)

   ( printout t "------------------- fin-kindle-l ------------" crlf)
)


(defrule fin
  ( declare (salience -100) )
 =>
  ( close k )
)

;esto genera un markdown para que jekyll lo publique en el blog necios
(defrule inicio-kindle-k-partida-rules
   ( declare (salience 10000))
   ( empresa (nombre ?empresa))

  =>  

   ( if (neq nil k) then (close k))
   ( if (neq nil h) then (close h))


   ( bind ?archivo (str-cat "./doc/" ?empresa "/empresa.markdown"))

   ( open ?archivo k "w")
  
   ( printout k "--- " crlf)
;   ( printout k "title: Libro Diaro" crlf)
   ( printout k "permalink: /" ?empresa "/libro-diario " crlf)
   ( printout k "layout: page" crlf)
   ( printout k "--- " crlf)
   ( printout k "" crlf)
   ( printout k "Contabilidad para Necios® usa el siguiente código de colores para este documento." crlf)
   ( printout k "<ul>" crlf)
   ( printout k "<li><span style='background-color: red'>[    ]</span> mensaje de alerta. </li>" crlf)
   ( printout k "<li><span style='background-color: lavender'>[    ]</span> partida revisada y resultado bueno. </li>" crlf)
   ( printout k "<li><span style='background-color: lightyellow'>[    ]</span> cuenta mayor del activo </li>" crlf)
   ( printout k "<li><span style='background-color: azure'>[    ]</span> cuenta mayor del pasivo </li>" crlf)
   ( printout k "<li><span style='color: white; background-color: cornflowerblue'>[    ]</span> cuenta de patrimonio </li>" crlf)
   ( printout k "<li><span style='background-color: gold'>[    ]</span> ganancia </li>" crlf)
   ( printout k "<li><span style='color: white; background-color: black'>[    ]</span> pérdida </li>" crlf)
   ( printout k "<li><span style='background-color: blanchedalmond'>[    ]</span> subtotales de la transacción </li>" crlf)
   ( printout k "</ul>" crlf)
;esta línea genera tablas html que se ven como partidas contables

;   ( printout k "

;{% for resource in site.data.alectrico-2021 %}
;  {% for e in resource %}
;    {% if (e != 'index' %}
;   <table>
;   <th> Partida </th> <th> Documento </th>
;      {%for partida in e.partidas %}
;  <tr> <td>  {{ partida.numero}} </td> <td> <img src='{{partida.archivo }}'>   </td> </tr>
;M      {% endfor %}
;  </table>
;    {% endif %}
;  {% endfor %}
{;% endfor %}" crlf)

   ( bind ?archivo (str-cat "./doc/" ?empresa "/f29.markdown"))
   ( open ?archivo h "w")

   ( printout h "--- " crlf)
;   ( printout h "title: " ?empresa "-f29"  crlf)
;   ( printout h "permalink: /" ?empresa "-f29/ " crlf)
   ( printout h "layout: page" crlf)
   ( printout h "--- " crlf)

)



(defrule fin
  ( declare (salience -100) )
 =>
  ( close k )
; ( printout l "{% endblock %}" crlf)
 ;( close l)
  ( close h)
)



(defrule inicio-de-modulo-partida
  ( declare (salience 8000))
  ( ticket (numero ?numero))
;  ?partida <-  ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))

;  ( balance (dia ?top) (mes ?mes_top) (ano ?ano))
;  ( test (>= (to_serial_date ?top ?mes_top ?ano) (to_serial_date ?dia ?mes ?ano)))
 =>
  ( assert (cabeza ?numero ))
)


(defrule encabezado-con-error-de-old
  (no)
  ( cabeza ?numero )
  ( revision (revisado true) (partida ?numero) (folio ?folio) (descripcion ?descripcion) (legal ?legal) (rcv ?rcv) (ccm ?ccm) (a-corregir ?a-corregir) (old ?old) (tipo ?tipo))
  ( test (neq ?numero ?old))
 =>
 (printout t "Error en old partida " ?numero tab old ?old crlf)
 (halt)
)

;============================== Tabla de la Partida ================================
(defrule encabezado-sin-revision
  ( cabeza ?numero )
  (not ( revision (partida ?numero) ))
  ?partida <-  ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
  ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
  ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  ( not (formulario-f29 (partida ?numero)))
  ;( balance ( dia ?top ) (mes ?mes) (ano ?ano))
 ; ( empresa (nombre ?empresa) (razon ?razon))
  ;( test (>= ?top ?dia))
 =>
  ( printout t crlf crlf crlf)

  ( printout t "------------------  X  -sin-revisar -----------------------------" crlf)
  ( printout t "==================================================================" crlf)
  ( printout t FECHA tab Parcial tab Debe tab Haber tab Descripcion crlf)
  ( printout t "==================================================================" crlf)
  ( printout t "Partida " ?numero crlf)
  ( printout t ".................................................................." crlf)
  ( printout t "Esta partida no tiene un registro de revisión: Vaya al archivo " crlf)
  ( printout t "de revisiones y agregue una línea (revision (partida " ?numero "))" crlf)
  ( printout t "coloque (revision (partida " ?numero ") (revisado false ))  si no " crlf)
  ( printout t "ha podido efectuar la revisión." crlf)
  ( printout t "------------------------------------------------------------------" crlf)

  ( halt )
)

;============================== Tabla de la Partida ================================
(defrule encabezado-f29
  ?c <- ( cabeza ?numero )

  ?partida <-  ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano))
  ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
  ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  ( exists ( formulario-f29 (partida ?numero)))

  ( revision (libro-diario ?libro-diario) (voucher ?voucher) (revisado ?revisado) (partida ?numero) (folio ?folio) (descripcion ?descripcion) (legal ?legal) (rcv ?rcv) (ccm ?ccm) (a-corregir ?a-corregir) (old ?old) (tipo ?tipo))

  ( selecciones (imprimir-detalles ?imprimir-detalles))
  ;( balance ( dia ?top ) (mes ?mes) (ano ?ano))
 ; ( empresa (nombre ?empresa) (razon ?razon))
  ;( test (>= ?top ?dia))
 =>
  ( retract ?c)
  ( printout t crlf crlf crlf)

  ( printout t "------------------  F  -F29 -----------------------------" crlf)
  ( printout t "==================================================================" crlf)
  ( printout t FECHA tab Parcial tab Debe tab Haber tab Descripcion crlf)
  ( printout t "==================================================================" crlf)
  ( printout t "Partida " ?numero crlf)
  ( printout t ".................................................................." crlf)

 ;( printout k crlf crlf )
; ( printout k "<br> <br> <br> <br> <br> <br> " crlf)


  ( printout k "<p style='page-break-before: always;'>&nbsp;</p>" crlf)
  ( printout k "<br>" ?descripcion crlf)
  ( printout k "<br>" ?legal crlf)

  ( printout k "<p style='color: white; background-color: red'> " ?a-corregir "</p>" crlf)

  ( if (eq ?imprimir-detalles true) then
    ( if (neq ?old " ") then ( printout k "- [x] antiguo número de partida: " ?old crlf ) )
    ( if (neq ?voucher " ") then ( printout k "- [x] voucher en ccm: " ?voucher crlf ) )
    ( if (neq ?tipo " ") then ( printout k "- [x] tipo de asiento: " ?tipo crlf ) )
    ( if (neq ?folio " ") then ( printout k "- [x] folio: " ?folio crlf ) )
    ( if (neq ?legal " ") then ( printout k "- [x] notas legales: " ?legal crlf ) )
    ( if (neq ?descripcion " ") then ( printout k "- [x] descripción: " ?descripcion crlf ) )
    ( if (neq ?a-corregir " ") then ( printout k "- [x] a corregir: " ?a-corregir crlf ) )
    ( if (eq ?rcv true) then ( printout k "- [x] rcv" crlf ) else ( printout k "- [ ] rcv" crlf) )
    ( if (eq ?libro-diario true) then ( printout k "- [x] libro-diario" crlf ) else ( printout k "- [ ] libro-diario" crlf) )
    ( if (eq ?ccm true) then ( printout k "- [x] ccm" crlf ) else ( printout k "- [ ] ccm" crlf) )

    ( if (eq ?revisado true)
     then
       ( printout k "- [x] revisado" crlf )
       ( printout k "![](../revisado.png)" crlf)
     else 
        ( printout k "- [ ] revisado" crlf  )
     )
  )



  ( printout k "<p style='page-break-after: always;'>&nbsp;</p>" crlf)
  ( printout k "<table style='background-color:cornsilk'>" crlf)
  ( printout k "<thead><th colspan='6'>Partida " ?numero "</th></thead>"crlf)
  ( printout k " <thead> <th> </th> <th> " Código " </th> <th>  " Valor " </th> <th> " Descripción " </th> </thead>" crlf)
  ( printout k "<tbody>" crlf)


  ( printout l crlf crlf )
  ( printout l "<br> <br> <br> <br> <br> <br> " crlf)
  ( printout l "<table  class='table-bordered' >" crlf)
  ( printout l "<thead><th colspan='6'>Partida " ?numero "</th></thead>"crlf)
  ( printout l " <thead> <th> </th> <th> " Código " </th> <th>  " Valor " </th> <th> " Descripción " </th> </thead>" crlf)
  ( printout l "<tbody>" crlf)


  ( printout h crlf crlf )
  ( printout h "<br> <br> <br> <br> <br> <br> " crlf)
  ( printout h "<table  class='table-bordered' >" crlf)
  ( printout h "<thead><th colspan='6'>Partida " ?numero "</th></thead>"crlf)
  ( printout h " <thead> <th> </th> <th> " Código " </th> <th>  " Valor " </th> <th> " Descripción " </th> </thead>" crlf)
  ( printout h "<tbody>" crlf)


  ( assert (fila ?numero))
)


;============================== Tabla de la Partida ================================
(defrule encabezado-no-f29-rechazado
(no)
; ( partida (numero ?numero_a) (dia ?dia_a) (mes ?mes) (ano ?ano))
 ;( partida (numero ?numero_b) (dia ?dia_b) (mes ?mes) (ano ?ano))
  ( partida (numero ?numero)      (dia ?dia)       (mes ?mes) (ano ?ano) (actividad rechazo ))
  ( revision (rechazado true) (libro-diario ?libro-diario) (voucher ?voucher) (revisado ?revisado) (partida ?numero) (folio ?folio) (descripcion ?descripcion) (legal ?legal) (rcv ?rcv) (ccm ?ccm) (a-corregir ?a-corregir) (old ?old) (tipo ?tipo))
  ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
  ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  ; test (> ?dia ?dia_a))
  ; test (< ?dia ?dia_b))

 ;( test (neq ?numero_a ?numero))
  ; test (> ?numero ?numero_a))
  ; test (> ?numero_b ?numero))
  ; test (neq ?numero_a ?numero_b))

  ( not (formulario-f29 (partida ?numero)))

  ( selecciones (imprimir-detalles ?imprimir-detalles))
 =>
  ( printout t crlf crlf crlf)
  ( printout t voucher-sii tab ?voucher crlf)
  ( printout t ?old "--------------  R -revisado- Folio: " ?folio tab "tipo " ?tipo crlf)
  ( printout t " Legal. " ?legal crlf)
  ( printout t "RCV. "  ?rcv tab "CCM: " ?ccm crlf)
  ( printout t " Descripcion: " ?descripcion crlf)
  ( printout t " A corregir: " ?a-corregir crlf)

  ( printout t "==================================================================" crlf)
  ( printout t FECHA tab Parcial tab Debe tab Haber tab Descripcion crlf)
  ( printout t "==================================================================" crlf)
  ( printout t "Partida " ?numero crlf)
  ( printout t ".................................................................." crlf)


  ( printout k "<p style='page-break-before: always;'>&nbsp;</p>" crlf)
  ( printout k "<br>" ?descripcion crlf)
  ( printout k "<p style='color: white; background-color: red'> " ?a-corregir "</p>" crlf)
  ( printout k "<br>" ?legal crlf)
  ( printout k "dia " ?dia " mes " ?mes " ano " ?ano crlf)

  ( if (eq ?imprimir-detalles true) then
    (printout k "- [x] partida rechazada en SII " crlf ) 
    ( if (neq ?old " ") then ( printout k "- [x] antiguo número de partida: " ?old crlf ) )
    ( if (neq ?voucher " ") then ( printout k "- [x] voucher en ccm: " ?voucher crlf ) )
    ( if (neq ?tipo " ") then ( printout k "- [x] tipo de asiento: " ?tipo crlf ) )
    ( if (neq ?folio " ") then ( printout k "- [x] folio: " ?folio crlf ) )
    ( if (neq ?legal " ") then ( printout k "- [x] notas legales: " ?legal crlf ) )
    ( if (neq ?descripcion " ") then ( printout k "- [x] descripción: " ?descripcion crlf ) )
    ( if (neq ?a-corregir " ") then ( printout k "- [x] a corregir: " ?a-corregir crlf ) )
    ( if (eq ?rcv true) then ( printout k "- [x] rcv" crlf ) else ( printout k "- [ ] rcv" crlf) )
    ( if (eq ?libro-diario true) then ( printout k "- [x] libro-diario" crlf ) else ( printout k "- [ ] libro-diario" crlf) )
    ( if (eq ?ccm true) then ( printout k "- [x] ccm" crlf ) else ( printout k "- [ ] ccm" crlf) )

    ( if (eq ?revisado true)
     then
       ( printout k "- [x] revisado" crlf )
       ( printout k "![](../revisado.png)" crlf)
     else
        ( printout k "- [ ] revisado" crlf  )
     )
  )

  ( printout k "<table>" crlf)

  ( if (eq ?revisado true) then
    ( printout k "<thead> <th style='background-color: lavender' colspan='6'>Partida " ?numero "</th></thead>"crlf)
  else
    ( printout k "<thead > <th colspan='6'>Partida " ?numero "</th></thead>"crlf)
  ) 

  ( printout k "<tbody>" crlf)
    
  ( printout l crlf crlf )
  ( printout l "<br> <br> <br> <br> <br> <br> " crlf)
  ( printout l "<br>" ?descripcion crlf) 
  ( printout l "<br style='background-color: red'>" ?a-corregir crlf)
  ( printout l "<br>" ?legal crlf)
  ( if (neq ?old " ") then ( printout l "- [x] antiguo número de partida: " ?old crlf ) ) 
  ( if (neq ?voucher " ") then ( printout l "- [x] voucher en ccm: " ?voucher crlf ) ) 
  ( if (neq ?tipo " ") then ( printout l "- [x] tipo de asiento: " ?tipo crlf ) )
  ( if (neq ?folio " ") then ( printout l "- [x] folio: " ?folio crlf ) )
  ( if (neq ?legal " ") then ( printout l "- [x] notas legales: " ?legal crlf ) )
  ( if (neq ?descripcion " ") then ( printout l "- [x] descripción: " ?descripcion crlf ) )
  ( if (neq ?a-corregir " ") then ( printout l "- [x] a corregir: " ?a-corregir crlf ) )

  ( if (eq ?rcv true) then ( printout l "- [x] rcv" crlf ) else ( printout l "- [ ] rcv" crlf) )
  ( if (eq ?libro-diario true) then ( printout l "- [x] libro-diario" crlf ) else ( printout l "- [ ] libro-diario" crlf) )

  ( if (eq ?ccm true) then ( printout l "- [x] ccm" crlf ) else ( printout l "- [ ] ccm" crlf) )
  ( printout l "- [x] revisado" crlf )
  ( printout l "![](../revisado.png)" crlf)
  ( printout l "<table style='background-color:aqua' >" crlf)
  ( printout l "<thead><th colspan='6'>Partida " ?numero "</th></thead>"crlf)
  ( printout l "<tbody>" crlf)

  ( assert (fila ?numero))
)

;============================== Tabla de la Partida ================================
(defrule encabezado-no-f29
  ?c <- ( cabeza ?numero ) 
  ( empresa (nombre ?empresa))

  ?partida <-  ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (referencia ?referencia) )
 ( revision (rechazado ?rechazado) (libro-diario ?libro-diario) (voucher ?voucher) (revisado ?revisado) (partida ?numero) (folio ?folio) (descripcion ?descripcion) (legal ?legal) (rcv ?rcv) (ccm ?ccm) (a-corregir ?a-corregir) (old ?old) (tipo ?tipo))

  ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
  ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

  ( not (formulario-f29 (partida ?numero)))

  ( selecciones (imprimir-detalles ?imprimir-detalles))
  ( selecciones (ejercicio-anterior ?ejercicio-anterior))

 =>
  ( retract ?c )

  ( printout t crlf crlf crlf)
  ( printout t voucher-sii tab ?voucher crlf)
  ( printout t ?old "--------------  R -revisado- Folio: " ?folio tab "tipo " ?tipo crlf)
  ( printout t " Legal. " ?legal crlf)
  ( printout t "RCV. "  ?rcv tab "CCM: " ?ccm crlf)
  ( printout t " Descripcion: " ?descripcion crlf)
  ( printout t " A corregir: " ?a-corregir crlf)

  ( printout t "==================================================================" crlf)
  ( printout t FECHA tab Parcial tab Debe tab Haber tab Descripcion crlf)
  ( printout t "==================================================================" crlf)
  ( printout t "Partida " ?numero crlf)
  ( printout t ".................................................................." crlf)



 ; ( printout k crlf crlf )
;  ( printout k "<br> <br> <br> <br> <br> <br> " crlf)
  ( printout k "<p style='page-break-before: always;'>&nbsp;</p>" crlf)
  ( printout k "<br>" ?descripcion crlf)
  ( printout k "<p style='color: white; background-color: red'> " ?a-corregir "</p>" crlf)
  ( printout k "<br>" ?legal crlf)

  ( if (eq ?imprimir-detalles true) then
    ( if (eq ?rechazado true) then ( printout k "- [x] partida rechazada en SII " crlf ) )
    ( if (neq ?old " ") then ( printout k "- [x] antiguo número de partida: " ?old crlf ) )
    ( if (neq ?voucher " ") then ( printout k "- [x] voucher en ccm: " ?voucher crlf ) )
    ( if (neq ?tipo " ") then ( printout k "- [x] tipo de asiento: " ?tipo crlf ) )
    ( if (neq ?folio " ") then ( printout k "- [x] folio: " ?folio crlf ) )
    ( if (neq ?legal " ") then ( printout k "- [x] notas legales: " ?legal crlf ) )
    ( if (neq ?descripcion " ") then ( printout k "- [x] descripción: " ?descripcion crlf ) )
    ( if (neq ?a-corregir " ") then ( printout k "- [x] a corregir: " ?a-corregir crlf ) )
    ( if (eq ?rcv true) then ( printout k "- [x] rcv" crlf ) else ( printout k "- [ ] rcv" crlf) )
    ( if (eq ?libro-diario true) then ( printout k "- [x] libro-diario" crlf ) else ( printout k "- [ ] libro-diario" crlf) )
    ( if (eq ?ccm true) then ( printout k "- [x] ccm" crlf ) else ( printout k "- [ ] ccm" crlf) )

    ( if  ( neq nil ?referencia)
       then
         ( if (< ?referencia 0)
            then
             ( printout k  "- [x] Referencia: <a href= '/" ?ejercicio-anterior "/libro-diario#Partida-" ?referencia "'>" ?referencia " </a>" crlf) 
            else
             ( printout k  "- [x] Referencia: <a href= '/" ?empresa "/libro-diario#Partida-" ?referencia "'>" ?referencia " </a>" crlf))
    )


    ( if (eq ?revisado true) 
     then  
       ( printout k "- [x] revisado" crlf ) 
       ( printout k "![](../revisado.png)" crlf)
     else 
        ( printout k "- [ ] revisado" crlf  )
     )
  )


  ( printout k "<table id='Partida-" ?numero "'>" crlf)

  ( if (eq ?revisado true) then  
    ( printout k "<thead> <th style='background-color: lavender' colspan='6'>Partida " ?numero "</th></thead>"crlf)
  else
    ( printout k "<thead > <th colspan='6'>Partida " ?numero "</th></thead>"crlf)
  )
  
  ( printout k "<tbody>" crlf)

  ( printout l crlf crlf )
  ( printout l "<br> <br> <br> <br> <br> <br> " crlf)
  ( printout l "<br>" ?descripcion crlf)
  ( printout l "<br style='background-color: red'>" ?a-corregir crlf)
  ( printout l "<br>" ?legal crlf)
  ( if (neq ?old " ") then ( printout l "- [x] antiguo número de partida: " ?old crlf ) )
  ( if (neq ?voucher " ") then ( printout l "- [x] voucher en ccm: " ?voucher crlf ) )
  ( if (neq ?tipo " ") then ( printout l "- [x] tipo de asiento: " ?tipo crlf ) )
  ( if (neq ?folio " ") then ( printout l "- [x] folio: " ?folio crlf ) )
  ( if (neq ?legal " ") then ( printout l "- [x] notas legales: " ?legal crlf ) )
  ( if (neq ?descripcion " ") then ( printout l "- [x] descripción: " ?descripcion crlf ) )
  ( if (neq ?a-corregir " ") then ( printout l "- [x] a corregir: " ?a-corregir crlf ) )

  ( if (eq ?rcv true) then ( printout l "- [x] rcv" crlf ) else ( printout l "- [ ] rcv" crlf) )
  ( if (eq ?libro-diario true) then ( printout l "- [x] libro-diario" crlf ) else ( printout l "- [ ] libro-diario" crlf) )

  ( if (eq ?ccm true) then ( printout l "- [x] ccm" crlf ) else ( printout l "- [ ] ccm" crlf) )
  ( printout l "- [x] revisado" crlf )
  ( printout l "![](../revisado.png)" crlf)
  ( printout l "<table style='background-color:aqua' >" crlf)
  ( printout l "<thead><th colspan='6'>Partida " ?numero "</th></thead>"crlf)
  ( printout l "<tbody>" crlf)


  ( assert (fila ?numero))
)




(defrule footer
  ( declare (salience 60))
  ?fila <- ( fila ?numero )
  ( balance ( dia ?top ) (mes ?mes_top) (ano ?ano_top))
  ( empresa (nombre ?empresa) (razon ?razon))

  ( partida (numero ?numero) (proveedor ?proveedor) (archivo ?archivo) (debe ?debe) (haber ?haber) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?descripcion) (actividad ?actividad) )

  ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  ( not (formulario-f29 (partida ?numero)))

 =>
  ( retract ?fila )
  ( printout t "------------------------------------------------------------------" crlf)

  ( printout t tab tab ?debe tab ?haber tab "( " ?dia " de " ?mes tab ?ano tab " )" crlf)
  ( printout t "==================================================================" crlf)
  ( printout t ?razon crlf)
  ( printout t "Partida 00" ?numero ": " ?descripcion crlf)
  ( if  (neq nil ?proveedor) then (  printout t "       efectuado a " ?proveedor crlf ) )
  ( printout t ?actividad crlf)
  ( printout t crlf crlf)

  ( printout k "<tr> <td> </td> <td style='background-color: blanchedalmond'> " ?debe " </td> <td style='background-color: blanchedalmond'> " ?haber "</td> </tr>" crlf)
  ( if (neq ?haber ?debe) 
     then
    ( printout k "<tr> <td> </td> <td colspan='2' style='color: white; background-color: red'> At: No se cumple la igualdad tributaria </td> </tr>" crlf)
    ( printout k "<tr> <td> </td> <td colspan='2' style='background-color: blanchedalmond'> La compilación del kernel está ahora detenida. Corrija posibles errores en las reglas de actividad_rules.clp o corrija ingresos de abonos y cargos a este asiento contable. </td> </tr>" crlf)

    ( halt )
  )
;  ( printout k "</tbody></table><table style='background-color: cornsilk'><tbody>" crlf)
  ( printout k "<tr><td colspan='4'> " ?razon "</td> </tr> " crlf)
  ( printout k "<tr><td colspan='4'> ( " ?dia " de " ?mes tab ?ano tab " ) </td> </tr>" crlf)
  ( printout k "<tr><td colspan='8'> Partida " ?numero ": " ?descripcion " </td></tr>" crlf)
  ( if  (neq nil ?proveedor) then
    (  printout k "<tr> <td colspan='7'>efectuado a " ?proveedor " </td> </tr>" crlf )
  )
  ( printout k "<tr><td colspan = '8'> " ?actividad "</td> </tr>" crlf)
  ( if (neq nil ?archivo) then
   ( printout k "<tr style='background-color: aliceblue'> <td colspan = '8'> <img src='" ?archivo "'></td> </tr>" crlf)
  )
  ( printout k "</tbody>" crlf)
  ( printout k "</table>" crlf)


  ( printout l "<tr> <td> </td> <td> " ?debe " </td> <td> " ?haber "</td> </tr>" crlf)
  ( printout l "<tr><td colspan='4'> " ?razon "</td> </tr> " crlf)
  ( printout l "<tr><td colspan='4'> ( " ?dia " de " ?mes tab ?ano tab " ) </td> </tr>" crlf)
  ( printout l "<tr><td colspan='8'> Partida " ?numero ": " ?descripcion " </td></tr>" crlf)
  ( if  (neq nil ?proveedor) then (  printout l "<tr> <td colspan='7'>efectuado a " ?proveedor " </td> </tr>" crlf ) )
  ( printout l "<tr><td colspan = '8'> " ?actividad "</td> </tr>" crlf)
  ( if (neq nil ?archivo) then
  ( printout l "<tr> <td colspan = '8'> <img src='" ?archivo "'></td> </tr>" crlf))
  ( printout l "</tbody>" crlf)
  ( printout l "</table>" crlf)
)


(defrule footer-f29
  ( declare (salience 60))
  ?fila <- ( fila ?numero )
  ( balance ( dia ?top ) (mes ?mes_top) (ano ?ano_top))
  ( empresa (nombre ?empresa) (razon ?razon))
  ( partida (numero ?numero) (proveedor ?proveedor) (archivo ?archivo) (debe ?debe) (haber ?haber) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?descripcion) (actividad ?actividad))
  ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  ( exists ( formulario-f29 (partida ?numero)))


 =>
  ( retract ?fila )
  ( printout t "------------------------------------------------------------------" crlf)

  ( printout t tab tab ?debe tab ?haber tab "( " ?dia " de " ?mes tab ?ano tab " )" crlf)
  ( printout t "==================================================================" crlf)
  ( printout t ?razon crlf)
  ( printout t "Partida 00" ?numero ": " ?descripcion crlf)
  ( if  (neq nil ?proveedor) then (  printout t "       efectuado a " ?proveedor crlf ) )
  ( printout t ?actividad crlf)
  ( printout t crlf crlf)

  ( printout k "</tbody></table><table>" crlf)
  ( printout k "<tbody>"  crlf)
  ( printout k "<tr> <td> </td> <td> " ?debe " </td> <td> " ?haber "</td> </tr>" crlf)
  ( printout k "<tr><td colspan='4'> " ?razon "</td> </tr> " crlf)
  ( printout k "<tr><td colspan='4'> ( " ?dia " de " ?mes tab ?ano tab " ) </td> </tr>" crlf)
  ( printout k "<tr><td colspan='8'> Partida " ?numero ": " ?descripcion " </td></tr>" crlf)
  ( if  (neq nil ?proveedor) then (  printout k "<tr> <td colspan='7'>efectuado a " ?proveedor " </td> </tr>" crlf ) )
  ( printout k "<tr><td colspan = '8'> " ?actividad "</td> </tr>" crlf)
  ( if (neq nil ?archivo) then
  ( printout k "<tr> <td colspan = '8'> <img src='" ?archivo "'></td> </tr>" crlf))
  ( printout k "</tbody>" crlf)
  ( printout k "</table>" crlf)


  ( printout l "<tr> <td> </td> <td> " ?debe " </td> <td> " ?haber "</td> </tr>" crlf)
  ( printout l "<tr><td colspan='4'> " ?razon "</td> </tr> " crlf)
  ( printout l "<tr><td colspan='4'> ( " ?dia " de " ?mes tab ?ano tab " ) </td> </tr>" crlf)
  ( printout l "<tr><td colspan='8'> Partida " ?numero ": " ?descripcion " </td></tr>" crlf)
  ( if  (neq nil ?proveedor) then (  printout k "<tr> <td colspan='7'>efectuado a " ?proveedor " </td> </tr>" crlf ) )
  ( printout l "<tr><td colspan = '8'> " ?actividad "</td> </tr>" crlf)
  ( if (neq nil ?archivo) then
  ( printout l "<tr> <td colspan = '8'> <img src='" ?archivo "'></td> </tr>" crlf))
  ( printout l "</tbody>" crlf)
  ( printout l "</table>" crlf)

  ( printout h "<tr> <td> </td> <td> " ?debe " </td> <td> " ?haber "</td> </tr>" crlf)
  ( printout h "<tr><td colspan='4'> " ?razon "</td> </tr> " crlf)
  ( printout h "<tr><td colspan='4'> ( " ?dia " de " ?mes tab ?ano tab " ) </td> </tr>" crlf)
  ( printout h "<tr><td colspan='8'> Partida " ?numero ": " ?descripcion " </td></tr>" crlf)
  ( if  (neq nil ?proveedor) then (  printout k "<tr> <td colspan='7'>efectuado a " ?proveedor " </td> </tr>" crlf ) )
  ( printout h "<tr><td colspan = '8'> " ?actividad "</td> </tr>" crlf)
  ( if (neq nil ?archivo) then
    ( printout h "<tr> <td colspan = '8'> <img src='" ?archivo "'></td> </tr>" crlf)
  )
  ( printout h "</tbody>" crlf)
  ( printout h "</table>" crlf)
)



;============================== Registro de Accionistas ================================
(defrule encabezado-de-registro-de-accionistas
  (exists ( registro-de-accionistas))

 =>
  ( printout t "==================================================================" crlf)
  ( printout t "Registro de Acccionistas")
  ( printout t ".................................................................." crlf)
  ( printout t crlf)
)


(defrule muestra-registro-de-accionistas
   ?f <-  ( registro-de-accionistas (nombre ?nombre) (mostrado-en-partida false) )
   ( accionista (nombre ?nombre) (domicilio ?domicilio) (rut ?rut) (mes ?mes) (ano ?ano) (numero-de-acciones ?numero-de-acciones) (valor-nominal ?valor-nominal))
  =>
   ( printout t "Nombre:       " ?nombre crlf)
   ( printout t "RUT:          " ?rut crlf)
   ( printout t "Domicilio:    " ?domicilio crlf)
   ( printout t "Ingreso:      " ?mes tab ?ano crlf)
   ( printout t "# Acciones:   " ?numero-de-acciones crlf)
   ( printout t "Valor Nominal " ?valor-nominal crlf)
   ( printout t "--------------------------------" crlf)
   ( printout t crlf)
   ( modify ?f (mostrado-en-partida true))
)


(defrule muestra-codigo-de-formulario-f29-sin-acumulacion
   ( declare (salience 65))
   ( fila ?numero )
   ?partida <- ( partida (numero ?numero) (debe ?debe) (haber ?haber))

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( empresa (nombre ?empresa))
   ?f <-  ( formulario-f29 (partida ?numero) (descripcion ?descripcion) (codigo ?codigo) (valor ?valor) (mes ?mes) (ano ?ano) (mostrado-en-partida false))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date 1 ?mes ?ano)))
  ; ( test (> ?ano (- ?ano_top 1)))
  =>
   ( printout t  "codigo..." ?codigo tab ?valor tab ?descripcion crlf)

   ( printout k " <tr> <td> </td> <td> " ?codigo " </td> <td align='right'>  " ?valor " </td> <td> " ?descripcion " </td> </tr>" crlf)

   ( printout l " <tr> <td> </td> <td> " ?codigo " </td> <td align='right'>  " ?valor " </td> <td> " ?descripcion " </td> </tr>" crlf)

   ( printout h " <tr> <td> </td> <td> " ?codigo " </td> <td align='right'>  " ?valor " </td> <td> " ?descripcion " </td> </tr>" crlf)


   ( modify ?f (mostrado-en-partida true))

)

;comprobando el remanente con códigos-> 504+511-538-111=77
(defrule muestra-codigo-de-formulario-f29-con-acumulacion-504
   ( declare (salience 66))
   ( fila ?numero )
   ?partida <- ( partida (numero ?numero) (debe ?debe) (haber ?haber))

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( empresa (nombre ?empresa))
   ?f <-  ( formulario-f29 (partida ?numero) (descripcion ?descripcion) (codigo ?codigo&:(eq ?codigo 504)) (valor ?valor) (mes ?mes) (ano ?ano) (mostrado-en-partida false))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date 1 ?mes ?ano)))
  ;( test (> ?ano (- ?ano_top 1)))
  =>
   ( printout t  "codigo..." ?codigo tab ?valor tab ?descripcion crlf)

   ( printout k " <tr> <td> </td> <td> " ?codigo " </td> <td align='right'>  " ?valor " </td> <td> " ?descripcion " </td> </tr>" crlf)

   ( printout l " <tr> <td> </td> <td> " ?codigo " </td> <td align='right'>  " ?valor " </td> <td> " ?descripcion " </td> </tr>" crlf)
   ( printout h " <tr> <td> </td> <td> " ?codigo " </td> <td align='right'>  " ?valor " </td> <td> " ?descripcion " </td> </tr>" crlf)


   ( modify ?partida (debe (+ ?debe ?valor)) (haber (+ ?haber 0)))
   ( modify ?f (mostrado-en-partida true))

)

;comprobando el remanente con códigos-> 504+511-538-111=77
(defrule muestra-codigo-de-formulario-f29-con-acumulacion-511
   ( declare (salience 66))
   ( fila ?numero )
   ?partida <- ( partida (numero ?numero) (debe ?debe) (haber ?haber))

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( empresa (nombre ?empresa))
   ?f <-  ( formulario-f29 (partida ?numero) (descripcion ?descripcion) (codigo ?codigo&:(eq ?codigo 511)) (valor ?valor) (mes ?mes) (ano ?ano) (mostrado-en-partida false))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date 1 ?mes ?ano)))
   ( test (> ?ano (- ?ano_top 1)))
  =>
   ( printout t  "codigo..." ?codigo tab ?valor tab ?descripcion crlf)

   ( printout k " <tr> <td> </td> <td> " ?codigo " </td> <td align='right'>  " ?valor " </td> <td> " ?descripcion " </td> </tr>" crlf)

   ( printout l " <tr> <td> </td> <td> " ?codigo " </td> <td align='right'>  " ?valor " </td> <td> " ?descripcion " </td> </tr>" crlf)
   ( printout h " <tr> <td> </td> <td> " ?codigo " </td> <td align='right'>  " ?valor " </td> <td> " ?descripcion " </td> </tr>" crlf)

   ( modify ?partida (debe (+ ?debe ?valor)) (haber (+ ?haber 0)))
   ( modify ?f (mostrado-en-partida true))

)


;comprobando el remanente con códigos-> 504+511-538-111=77
(defrule muestra-codigo-de-formulario-f29-con-acumulacion-538
   ( declare (salience 66))
   ( fila ?numero )
   ?partida <- ( partida (numero ?numero) (debe ?debe) (haber ?haber))

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( empresa (nombre ?empresa))
   ?f <-  ( formulario-f29 (partida ?numero) (descripcion ?descripcion) (codigo ?codigo&:(eq ?codigo 538)) (valor ?valor) (mes ?mes) (ano ?ano) (mostrado-en-partida false))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date 1 ?mes ?ano)))
;  ( test (> ?ano (- ?ano_top 1)))
  =>
   ( printout t  "codigo..." ?codigo tab ?valor tab ?descripcion crlf)

   ( printout k " <tr> <td> </td> <td> " ?codigo " </td> <td align='right'>  " ?valor " </td> <td> " ?descripcion " </td> </tr>" crlf)

   ( printout l " <tr> <td> </td> <td> " ?codigo " </td> <td align='right'>  " ?valor " </td> <td> " ?descripcion " </td> </tr>" crlf)
   ( printout h " <tr> <td> </td> <td> " ?codigo " </td> <td align='right'>  " ?valor " </td> <td> " ?descripcion " </td> </tr>" crlf)

   ( modify ?partida (debe (- ?debe ?valor)) (haber (+ ?haber 0)))
   ( modify ?f (mostrado-en-partida true))

)

;comprobando el remanente con códigos-> 504+511-538-111=77
(defrule muestra-codigo-de-formulario-f29-con-acumulacion-111
   ( declare (salience 66))
   ( fila ?numero )
   ?partida <- ( partida (numero ?numero) (debe ?debe) (haber ?haber))

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( empresa (nombre ?empresa))
   ?f <-  ( formulario-f29 (partida ?numero) (descripcion ?descripcion) (codigo ?codigo&:(eq ?codigo 111)) (valor ?valor) (mes ?mes) (ano ?ano) (mostrado-en-partida false))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date 1 ?mes ?ano)))
 ;  ( test (> ?ano (- ?ano_top 1)))
  =>
   ( printout t  "codigo..." ?codigo tab ?valor tab ?descripcion crlf)

   ( printout k " <tr> <td> </td> <td> " ?codigo " </td> <td align='right'>  " ?valor " </td> <td> " ?descripcion " </td> </tr>" crlf)

   ( printout l " <tr> <td> </td> <td> " ?codigo " </td> <td align='right'>  " ?valor " </td> <td> " ?descripcion " </td> </tr>" crlf)
   ( printout h " <tr> <td> </td> <td> " ?codigo " </td> <td align='right'>  " ?valor " </td> <td> " ?descripcion " </td> </tr>" crlf)

   ( modify ?partida (debe (- ?debe ?valor)) (haber (+ ?haber 0)))
   ( modify ?f (mostrado-en-partida true))

)

;comprobando el remanente con códigos-> 504+511-538-111=77
(defrule muestra-codigo-de-formulario-f29-con-acumulacion-77
   ( declare (salience 66))
   ( fila ?numero )
   ?partida <- ( partida (numero ?numero) (debe ?debe) (haber ?haber))

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( empresa (nombre ?empresa))
   ?f <-  ( formulario-f29 (partida ?numero) (descripcion ?descripcion) (codigo ?codigo&:(eq ?codigo 77)) (valor ?valor) (mes ?mes) (ano ?ano) (mostrado-en-partida false))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date 1 ?mes ?ano)))
   ;( test (> ?ano (- ?ano_top 1)))
  =>
   ( printout t  "codigo..." ?codigo tab ?valor tab ?descripcion crlf)

   ( printout k " <tr> <td> </td> <td> " ?codigo " </td> <td align='right'>  " ?valor " </td> <td> " ?descripcion " </td> </tr>" crlf)

   ( printout l " <tr> <td> </td> <td> " ?codigo " </td> <td align='right'>  " ?valor " </td> <td> " ?descripcion " </td> </tr>" crlf)
   ( printout h " <tr> <td> </td> <td> " ?codigo " </td> <td align='right'>  " ?valor " </td> <td> " ?descripcion " </td> </tr>" crlf)


   ( modify ?partida (debe (+ ?debe 0)) (haber (+ ?haber ?valor)))
   ( modify ?f (mostrado-en-partida true))

)

(defrule ordenar-codigos
 =>
  ( bind ?i 1)
  ( while (< ?i 1000) do
    ( assert (codigo-f29 (codigo ?i)))
    ( bind ?i (+ ?i 1))
  )
)



(defrule muestra-codigo-de-formulario-f22
   ( declare (salience 65))
;   ( codigo-f29 (codigo ?codigo))
   ( fila ?numero )
   ( balance (ano ?ano))
   ( codigo-f29 (codigo ?codigo))
   ( not  ( exists ( formulario-f22 (presentado-en-f22 false)  (codigo ?inferior&:( and ( numberp ?inferior )  (> (- ?codigo ?inferior ) 0) )))))
   ?formulario <- ( formulario-f22 (presentado-en-f22 false) (partida ?partida-f29) (codigo ?codigo&:(numberp ?codigo) ) (valor ?valor) (descripcion ?descripcion) (mes ?mes) (ano ?ano) )
   ?f22 <- ( f22 (partida ?numero) (ano ?ano))

  =>
   ( modify ?formulario (presentado-en-f22 true) )

   ( printout t  "codigo..." tab ?mes tab ?codigo tab ?valor tab ?descripcion crlf)

   ( printout k " <tr> <td> " ?mes "  </td> <td> " ?codigo " </td> <td align='right' >  " ?valor " </td> <td> " ?descripcion " </td> </tr>" crlf)

   ( printout l " <tr> <td> " ?mes " </td> <td> " ?codigo " </td> <td align='right'>  " ?valor " </td> <td> " ?descripcion " </td> </tr>" crlf)

)


(defrule muestra-libro-mayor-resultados-subcuentas
   ( declare (salience 65))
   ( fila ?numero )
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( empresa (nombre ?empresa))
   ?partida <- ( partida (numero ?numero) (debe ?debe) (haber ?haber) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?descripcion))
   ?padre <- (cuenta (liquidada false) (partida ?numero) (empresa ?empresa) (nombre ?nombre) (dia ?dia) (mes ?mes) (ano ?ano) (debe ?debe1)  (haber ?haber1)  (saldo ?saldo1)  (grupo resultado))
   ?cuenta <- (cuenta (mostrada-en-partida false) (partida ?numero) (empresa ?empresa) (padre ?nombre) (dia ?dia) (mes ?mes) (ano ?ano) (nombre ?nombre2) (debe ?debe2) (haber ?haber2) (saldo ?saldo2) (grupo resultado) (origen ?origen))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ( test (neq 0 (+ ?debe1 ?haber1)))
  =>
   ( modify ?cuenta (mostrada-en-partida true))
   ( printout t tab ?saldo2 tab tab tab ?nombre2 # ?nombre crlf)

   ( printout k "<tr> <td align='right' >" ?saldo2 " </td> <td colspan='7'> " ?nombre2 # ?nombre " </td></tr>" crlf)

   ( printout l "<tr> <td align='right'>" ?saldo2 " </td> <td colspan='7'> " ?nombre2 # ?nombre " </td></tr>" crlf)
) 

(defrule muestra-libro-mayor-activos-subcuentas
   ( declare (salience 65))
   ( fila ?numero )
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( empresa (nombre ?empresa))
   ?partida <- ( partida (numero ?numero) (debe ?debe) (haber ?haber) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?descripcion))
   ?padre <- (cuenta (liquidada false) (partida ?numero) (empresa ?empresa) (nombre ?nombre) (dia ?dia) (mes ?mes) (ano ?ano) (debe ?debe1)  (haber ?haber1)  (saldo ?saldo1)  (grupo activo))
   ?cuenta <- (cuenta (mostrada-en-partida false) (partida ?numero) (empresa ?empresa) (padre ?nombre) (dia ?dia) (mes ?mes) (ano ?ano) (nombre ?nombre2) (debe ?debe2) (haber ?haber2) (saldo ?saldo2) (grupo activo) (origen ?origen))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ( test (neq 0 (+ ?debe1 ?haber1)))

  =>
   ;( modify ?partida (debe (+ ?debe ?debe2)) (haber (+ ?haber ?haber2)))
   ( modify ?cuenta (mostrada-en-partida true))
;   ( printout t ?debe " | " ?haber " --" partida  crlf)
   ( printout t tab ?saldo2 tab tab tab ?nombre2 # ?nombre crlf)

   ( printout k "<tr><td align='right'>" ?saldo2 "</td> <td colspan='7'>" ?nombre2 # ?nombre "</td> </tr>" crlf)
   ( printout l "<tr><td align='right'>" ?saldo2 "</td> <td colspan='7'>" ?nombre2 # ?nombre "</td> </tr>" crlf)


)

(defrule muestra-libro-mayor-pasivos-subcuentas
   ( declare (salience 64))
   ( fila ?numero)
   ( empresa (nombre ?empresa))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ?partida <- ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (debe ?debe) (haber ?haber))
   ?padre <- (cuenta (liquidada false) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (nombre ?nombre) (debe ?debe1)  (haber ?haber1)  (saldo ?saldo1)  (grupo pasivo))
   ?cuenta <- (cuenta  (mostrada-en-partida false) (partida ?numero) (empresa ?empresa) (padre ?nombre)  (nombre ?nombre2) (dia ?dia) (mes ?mes) (ano ?ano) (debe ?debe2) (haber ?haber2) (saldo ?saldo2) (origen ?origen) )
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ( test (neq 0 (+ ?debe1 ?haber1)))

  =>
  ; ( modify ?partida (debe (+ ?debe ?debe2)) (haber (+ ?haber ?haber2)))
   ( modify ?cuenta (mostrada-en-partida true))
 ;  ( printout t ?debe " | " ?haber " --" partida  crlf)
   ( printout t tab ?saldo2 tab tab tab tab ?nombre2 # ?nombre crlf)

   ( printout k "<tr> <td align='right'> " ?saldo2 " </td> <td> </td> <td colspan='7'> " ?nombre2 # ?nombre " </td> </tr> " crlf)

   ( printout l "<tr> <td align='right'> " ?saldo2 " </td> <td> </td> <td colspan='7'> " ?nombre2 # ?nombre " </td> </tr> " crlf)



) 

(defrule muestra-libro-mayor-activos-mayores
   ( declare (salience 63))
   ( fila ?numero )
   ( empresa (nombre ?empresa))
   ( balance (dia ?top ) (mes ?mes_top) (ano ?ano_top))
   ?partida <- ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (debe ?debe) (haber ?haber))
   ?cuenta <- (cuenta (mostrada-en-partida false) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (nombre ?nombre) (debe ?debe1) (haber ?haber1) (saldo ?saldo) (padre false) (grupo activo))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ( test (neq 0 (+ ?debe1 ?haber1)))
  =>
   ( modify ?partida (debe (+ ?debe ?debe1)) (haber (+ ?haber ?haber1)))
   ( modify ?cuenta (mostrada-en-partida true))
 ;  ( printout t ?debe " | " ?haber " --" partida  crlf)
   ( printout t tab tab ?debe1 tab ?haber1 tab "a<" ?nombre ">" crlf)

   ( printout k "<tr style='background-color: lightyellow'>  <td> </td> <td align='right'> " ?debe1 "</td> <td align='right'> " ?haber1 "</td> <td colspan='2'> a[" ?nombre "] </td> </tr>" crlf)

   ( printout l "<tr>  <td> </td> <td align='right'> " ?debe1 "</td> <td align='right'> " ?haber1 "</td> <td colspan='2'> a[" ?nombre "] </td> </tr>" crlf)

)

(defrule muestra-de-resultados-gold
   ( declare (salience 62))
   ( fila ?numero )
   ( empresa (nombre ?empresa))
   ( balance ( dia ?top ) (mes ?mes_top) (ano ?ano_top))
   ?partida <- ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (debe ?debe) (haber ?haber))
   ?cuenta <- (cuenta (mostrada-en-partida false) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (nombre ?nombre) (debe ?debe1) (haber ?haber1) (saldo ?saldo1) (padre false) (grupo resultado) )
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ( test (> ?haber1 0))
  =>
   ( modify ?partida (debe (+ ?debe ?debe1)) (haber (+ ?haber ?haber1)))
   ( modify ?cuenta (mostrada-en-partida true))
 ;  ( printout t ?debe " | " ?haber " --" partida  crlf)
   ( printout t tab tab ?debe1 tab ?haber1 tab tab "r<" ?nombre ">" crlf)

   ( printout k "<tr style='background-color: gold'>  <td> </td> <td align='right'>" ?debe1 " </td> <td align='right'> " ?haber1 "</td> <td> </td> <td> r[" ?nombre "] </td> </tr>" crlf)

   ( printout l "<tr>  <td> </td> <td align='right'>" ?debe1 " </td> <td align='right'> " ?haber1 "</td> <td> </td> <td> r[" ?nombre "] </td> </tr>" crlf)
)  

(defrule muestra-de-resultados-black
   ( declare (salience 62))
   ( fila ?numero )
   ( empresa (nombre ?empresa)) 
   ( balance ( dia ?top ) (mes ?mes_top) (ano ?ano_top))
   ?partida <- ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (debe ?debe) (haber ?haber))  
   ?cuenta <- (cuenta (mostrada-en-partida false) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (nombre ?nombre) (debe ?debe1) (haber ?haber1) (saldo ?saldo1) (padre false) (grupo resultado) )
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ( test (> ?debe1 0))
  =>
   ( modify ?partida (debe (+ ?debe ?debe1)) (haber (+ ?haber ?haber1)))
   ( modify ?cuenta (mostrada-en-partida true))
 ;  ( printout t ?debe " | " ?haber " --" partida  crlf)
   ( printout t tab tab ?debe1 tab ?haber1 tab tab "r<" ?nombre ">" crlf)

   ( printout k "<tr style='color: white; background-color: black'>  <td> </td> <td align='right'>" ?debe1 " </td> <td align='right'> " ?haber1 "</td> <td> </td> <td> r[" ?nombre "] </td> </tr>" crlf)

   ( printout l "<tr>  <td> </td> <td align='right'>" ?debe1 " </td> <td align='right'> " ?haber1 "</td> <td> </td> <td> r[" ?nombre "] </td> </tr>" crlf)
)  




(defrule muestra-cuentas-tributarias
   ( declare (salience 62))
   ( fila ?numero )
   ( empresa (nombre ?empresa))
   ( balance ( dia ?top ) (mes ?mes_top) (ano ?ano_top))
   ?partida <- ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (debe ?debe) (haber ?haber))
   ?cuenta <- (cuenta (mostrada-en-partida false) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (nombre ?nombre) (debe ?debe1) (haber ?haber1) (saldo ?saldo1) (padre false) (grupo tributario) )
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  =>
;   ( modify ?partida (debe (+ ?debe ?debe1)) (haber (+ ?haber ?haber1)))
   ( modify ?cuenta (mostrada-en-partida true))
 ;  ( printout t ?debe " | " ?haber " --" partida  crlf)
   ( printout t tab extra-contable tab ?debe1 tab ?haber1 tab tab "t<" ?nombre ">" crlf)

   ( printout k "<tr>  <td>extra-contable </td> <td align='right'> " ?debe1 "</td> <td align='right'>" ?haber1 "</td> <td> </td> <td> t[" ?nombre "] </td></tr> " crlf)

   ( printout l "<tr>  <td>extra-contable </td> <td align='right'> " ?debe1 "</td> <td align='right'>" ?haber1 "</td> <td> </td> <td> t[" ?nombre "] </td></tr> " crlf)


)


(defrule muestra-libro-mayor-pasivos-mayores
   ( declare (salience 62))
   ( fila ?numero )
   ( empresa (nombre ?empresa))
   ( balance ( dia ?top ) (mes ?mes_top) (ano ?ano_top))
   ?partida <- ( partida (numero ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (debe ?debe) (haber ?haber))
   ?cuenta <- (cuenta (mostrada-en-partida false) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (nombre ?nombre) (debe ?debe1) (haber ?haber1) (saldo ?saldo1) (padre false) (grupo pasivo))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
   ( test (neq 0 (+ ?debe1 ?haber1)))

  =>
   ( modify ?partida (debe (+ ?debe ?debe1)) (haber (+ ?haber ?haber1)))
   ( modify ?cuenta (mostrada-en-partida true))
 ;  ( printout t ?debe " | " ?haber " --" partida  crlf)
   ( printout t tab tab ?debe1 tab ?haber1 tab tab "p<" ?nombre ">" crlf)

   ( printout k "<tr style='background-color: azure'>  <td> </td> <td align='right'> " ?debe1 " </td> <td align='right'> " ?haber1 " </td> <td> </td><td> p[" ?nombre "] </td> </tr>" crlf)

   ( printout l "<tr>  <td> </td> <td align='right'> " ?debe1 " </td> <td align='right'> " ?haber1 " </td> <td> </td><td> p[" ?nombre "] </td> </tr>" crlf)


)


(defrule muestra-libro-patrimonio
   ( declare (salience 61))
   ( fila ?numero )
   ( empresa (nombre ?empresa))
   ( balance ( dia ?top ) (mes ?mes_top) (ano ?ano_top))
   ?partida <- ( partida (numero ?numero) (debe ?debe) (haber ?haber) (dia ?dia) (mes ?mes) (ano ?ano) (descripcion ?descripcion))
   ?cuenta <- (cuenta (mostrada-en-partida false) (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (empresa ?empresa) (nombre ?nombre) (debe ?debe1) (haber ?haber1) (saldo ?saldo1) (padre false) (grupo patrimonio) (origen real))
   ( test (> ?saldo1 0) )
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

  =>
   ( modify ?partida (debe (+ ?debe ?debe1)) (haber (+ ?haber ?haber1)))
   ( modify ?cuenta (mostrada-en-partida true))
 ;  ( printout t ?debe " | " ?haber " --" partida  crlf)
   ( printout t tab tab ?debe1 tab ?haber1 tab tab "k<" ?nombre ">" crlf)

   ( printout k " <tr style='color: white; background-color: cornflowerblue' > <td> </td> <td align='right'> " ?debe1 " </td> <td align='right'>  " ?haber1 " </td> <td> </td> <td> k[" ?nombre "]</td> </tr>" crlf)

   ( printout l " <tr> <td> </td> <td align='right'> " ?debe1 " </td> <td align='right'>  " ?haber1 " </td> <td> </td> <td> k[" ?nombre "]</td> </tr>" crlf)

)


