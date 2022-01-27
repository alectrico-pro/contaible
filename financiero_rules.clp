(defmodule FINANCIERO (import MAIN deftemplate ?ALL))

(defrule fin-kindle
  ( declare (salience -10000))
 =>
  (printout k "<table><tbody>" crlf)


  ( close k )
)

;esto genera un markdown para que jekyll lo publique en el blog necios
(defrule inicio-kindle-k-financiero-rules
   ( declare (salience 10000))
   ( empresa (nombre ?empresa))
  =>

   ( bind ?archivo (str-cat "./doc/" ?empresa "/financiero.markdown"))
   ( open ?archivo k "w")

   ( printout k "--- " crlf)
;   ( printout k "title: " ?empresa "-financiero" crlf)
;   ( printout k "permalink: /" ?empresa "-financiero/ " crlf)
   ( printout k "layout: page" crlf)
   ( printout k "--- " crlf)
   ( printout k "" crlf)
   ( printout k "Contabilidad para Necios® usa el siguiente código de colores para este documento." crlf)
   ( printout k "<li><span style='background-color: lavender'>[    ]</span> partida revisada y resultado bueno. </li>" crlf)
   ( printout k "<li><span style='background-color: lightyellow'>[    ]</span> cuenta mayor del activo </li>" crlf)
   ( printout k "<li><span style='background-color: azure'>[    ]</span> cuenta mayor del pasivo </li>" crlf)
   ( printout k "<li><span style='color: white; background-color: cornflowerblue'>[    ]</span> cuenta de patrimonio </li>" crlf)
   ( printout k "<li><span style='background-color: gold'>[    ]</span> ganancia </li>" crlf)
   ( printout k "<li><span style='color: white; background-color: black'>[    ]</span> pérdida </li>" crlf)
   (printout k "<table><tbody>" crlf)

 )


(defrule inicio
  (declare (salience 10000))
 =>
  (printout t "============================================================" crlf)
  (printout t "------------------------------- FINANCIERO -----------------" crlf)
  (printout t "============================================================" crlf)

)


(defrule fin
  (declare (salience -1000))
 =>
  (printout t "============================================================" crlf)
  (printout t "-------- FIN ------------------ FINANCIERO -----------------" crlf)
  (printout t "============================================================" crlf)
)


(defrule cuentas-de-resultado-con-ganancias
  (declare (salience 1))
  (subtotales (cuenta ?nombre)  (acreedor ?acreedor&:(neq 0 ?acreedor)) )
  (exists  (cuenta (nombre ?nombre) (grupo resultado) (padre false)))
;  (test (neq ventas ?nombre))
;  (test (neq ingresos-brutos ?nombre))
 =>
  (printout t "|" tab tab ganancias tab ?acreedor tab tab ?nombre crlf)
  (printout k "<tr><td> ganancias </td><td> </td><td>" ?acreedor "</td><td>" ?nombre "</td></tr>" crlf)

)

(defrule cuentas-de-resultado-con-perdidas
  (declare (salience 2))
  (subtotales (cuenta ?nombre) (deber ?deber&:(neq 0 ?deber) ))
  (exists  (cuenta (nombre ?nombre) (grupo resultado) (padre false)))
;  (test (neq ventas ?nombre))
;  (test (neq ingresos-brutos ?nombre))
 =>
  (printout t "|" tab perdida.. tab ?deber tab tab tab ?nombre  crlf)
  (printout k "<tr><td>pérdida</td><td>" ?deber "</td><td></td><td>" ?nombre "</td></tr>" crlf)
)



(defrule cuentas-de-patrimonio-con-minoracion
  (declare (salience 2))
  (subtotales (cuenta ?nombre) (deber ?deber&:(neq 0 ?deber) ))
  (exists  (cuenta (nombre ?nombre) (grupo patrimonio) (padre false)))
 =>
  (printout t "|" tab perdida.. tab ?deber tab tab tab ?nombre  crlf)
  (printout k "<tr><td>pérdida</td><td>" ?deber "</td><td></td><td>" ?nombre "</td></tr>" crlf)
)

(defrule cuentas-de-patrimonio-con-aumento
  (declare (salience 1))
  (subtotales (cuenta ?nombre)  (acreedor ?acreedor&:(neq 0 ?acreedor)) )
  (exists  (cuenta (nombre ?nombre) (grupo patrimonio) (padre false)))
 =>
  (printout t "|" tab tab ganancias tab ?acreedor tab tab ?nombre crlf)
  (printout k "<tr><td> ganancias </td><td> </td><td>" ?acreedor "</td><td>" ?nombre "</td></tr>" crlf)

)






