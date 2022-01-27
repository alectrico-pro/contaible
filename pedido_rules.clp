(defmodule PEDIDO
  ( import MAIN deftemplate ?ALL )
)  


(defrule inicio-kindle-k-pedido-rules
   ( declare (salience 10000))
   ( empresa (nombre ?empresa))
  =>
   ( bind ?archivo (str-cat "./doc/" ?empresa "/pedidos.markdown"))
   ( open ?archivo k "w")
   ( printout k "--- " crlf)
;  ( printout k "title: " ?empresa "-pedidos" crlf)
;   ( printout k "permalink: /" ?empresa "/pedido " crlf)
   ( printout k "layout: page" crlf)
   ( printout k "--- " crlf)
)


   
(defrule fin-pedido-rules
  ( declare (salience -100) )
 =>
  ( close k ) 
)

(defrule pedidos
  ( declare (salience 10))
  ( pedido (id ?id))
 =>
  ( printout t "Pedido " ?id " encontrado" crlf)
  ( printout k "<p>Pedido " ?id " encontrado </p>" crlf)
)

(defrule materiales
  ( compra-de-materiales (pedido ?id) (partida ?numero))
  ( pedido (id ?id))
 =>
  ( printout t "Materiales de Pedido " ?id " encontrado en partida " ?numero  crlf)
  ( printout k "<p> Materiales de Pedido " ?id " encontrado en partida </p> " ?numero crlf)
)

(defrule compra
  ( compra (pedido ?id) (partida ?numero))
  ( pedido (id ?id))
 =>
  ( printout t "Compra de Pedido " ?id " encontrado en partida " ?numero  crlf)
  ( printout k "<p> Compra de Pedido " ?id " encontrado en partida </p> " ?numero crlf)
)


(defrule insumos
  ( insumos (pedido ?id) (partida ?numero))
  ( pedido (id ?id))
 =>
  ( printout t "Insumo de Pedido " ?id " encontrado en partida " ?numero  crlf)
  ( printout k "<p> Insumo de Pedido " ?id " encontrado en partida </p> " ?numero crlf)
)


(defrule inventario
  ( inventario (pedido ?id) (partida ?numero))
  ( pedido (id ?id))
 =>
  ( printout t "Inventario de Pedido " ?id " encontrado en partida " ?numero crlf)
  ( printout k "<p>Inventario de Pedido " ?id " encontrado en partida </p> " ?numero crlf)
)


