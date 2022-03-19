(defmodule PRIMITIVA
  ( import MAIN deftemplate ?ALL )
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



(defrule inicio-primitiva
  (declare (salience 10000))
=>
  ( printout t "----------------- PRIMITIVA ------------------" crlf)
)


(defrule warning-partida-sin-cargo
   (no) ;provision de idpc cae en esa categoria
  (partida (numero ?numero) (dia ?dia) (mes ?mes) (descripcion ?descripcion))
  (not (cargo (partida ?numero) ))
=>
  (printout t crlf crlf crlf )
  (printout t "°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°" crlf)
  (printout t "Warning: Hay una partida sin cargo" crlf)
  (printout t "---------------------------------------------------------" crlf)
  (printout t ?descripcion tab dia tab ?dia tab mes tab ?mes tab partida tab  ?numero crlf crlf crlf )
  (printout t "°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°" crlf)
  ( halt )
)

(defrule warning-partida-sin-abono
  (no)
  (partida (numero ?numero) (dia ?dia) (mes ?mes) (descripcion ?descripcion))
  (not (abono (partida ?numero) ))
=>
  (printout t crlf crlf )
  (printout t "°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°" crlf)
  (printout t "Warning: Hay una partida sin abono" crlf)
  (printout t "----------------------------------------------------------" crlf)
  (printout t ?descripcion tab dia tab ?dia tab mes tab ?mes tab partida tab ?numero crlf crlf crlf )
  (printout t "°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°" crlf)
  ( halt )
)

(defrule warning-abono-sin-partida
  (not (partida (numero ?numero) ))
  (abono (partida ?numero) (cuenta ?cuenta) (dia ?dia) (mes ?mes ) (glosa ?glosa ))
=>
  (printout t crlf crlf "°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°" crlf)
  (printout t "Warning: Hay un abono sin partida" crlf)
  (printout t "°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°" crlf) 
  (printout t ?glosa tab cuenta tab ?cuenta tab dia tab ?dia tab mes tab ?mes tab partida tab ?numero crlf crlf crlf )
  (printout t "°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°" crlf)
  ( halt )
)


(defrule warning-partida-repetida
  ?p1 <- (partida (numero ?numero) (mes ?mes) (descripcion ?descripcion1))
  ?p2 <- (partida (numero ?numero) (mes ?mes) (descripcion ?descripcion2))
  (test (neq ?descripcion1 ?descripcion2))
=>
  (printout t crlf crlf "°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°" crlf)
  (printout t "Warning: Hay partidas con el mismo número" crlf)
  (printout t "°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°" crlf)
  (printout t "--- PARTIDA 1 ------" crlf )
  (printout t ?descripcion1 tab "numero " ?numero crlf )
  (printout t "--- PARTIDA 2 ------" crlf )
  (printout t ?descripcion2 tab "numero " ?numero crlf )
  (printout t "°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°" crlf)
  ( printout t "Ambas partidas serán fusionadas en una sola, con una descripción compuesta por mezcla de las descripciones originales. " crlf)
; ( bind ?seguir (read)) 
  (modify ?p1 (descripcion (str-cat ?descripcion1  "-" ?descripcion2 )))
  ( retract ?p2 )
  ;( modify ?p2 (descripcion (str-cat ?descripcion1  "-" ?descripcion2 )))

; ( halt )
)


(defrule warning-cargando-cuenta-acreedora
  ( selecciones (cargar-acreedoras false))
  ( cargo (cuenta ?nombre ) (partida ?partida ))
  ( cuenta (nombre ?nombre) (naturaleza acreedora ))
 =>
  (printout t "Warning: Está intentando cargar una cuenta de saldo acreedor" crlf)
  (printout t "Cuenta: " ?nombre crlf)
  (printout t "Partida: " ?partida crlf)
  (halt)
)

(defrule debug-partida-5
   ( declare (salience 10000))
(no)
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top ))
   ( empresa (nombre ?empresa))
   ( partida (dia ?dia) (mes ?mes) (ano ?ano) (numero ?numero))

   ( revision
    (partida ?numero)
    (no-incluir false)
   )

  ?cargo <- (cargo (recibida ?recibida) (activo-fijo ?activo-fijo) (qty ?qty-cargo) (tipo-de-documento ?tipo-de-documento) (electronico ?electronico) (partida ?numero) (realizado false) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (cuenta ?nombre) (monto ?monto) (glosa ?glosa) )
   ?cuenta <- (cuenta (partida ?numero) (qty ?qty) (nombre ?nombre) (debe ?debe) (haber ?haber)  )
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

  ; cargo (cuenta ?nombre ) (partida ?numero) (realizado false) )
 ; ( cuenta (nombre ?nombre) )
  ( test (eq ?numero 5))
  =>
  (printout t "---------- debug partida - 5 " crlf)
  (printout t "Cuenta: " ?nombre crlf)
  (printout t "Partida: " ?numero crlf)
  (halt )
)

(defrule warning-abonando-cuenta-deudor
  ( selecciones (abonar-deudoras false))
  ( abono (cuenta ?nombre ) (partida ?partida))
  ( cuenta (nombre ?nombre) (naturaleza deudor))
 =>
  (printout t "Warning: Está intentando abonar una cuenta de saldo deudor" crlf)
  (printout t "Cuenta: " ?nombre crlf)
  (printout t "Partida: " ?partida crlf)
  (halt)
)


;------------------------ primitivas ---------------------------
(defrule cargar-cuenta-existente
   ( declare (salience 9800))

   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top ))
   ( empresa (nombre ?empresa))
   ( partida (dia ?dia) (mes ?mes) (ano ?ano) (numero ?numero))

   ( revision
    (partida ?numero)
    (no-incluir false)
   )


   ( correccion-monetaria-anual
     (mes ?mes)
     (ano ?ano)
     (factor ?factor) )


   ?cargo <- (cargo (recibida ?recibida) (activo-fijo ?activo-fijo) (qty ?qty-cargo) (tipo-de-documento ?tipo-de-documento) (electronico ?electronico) (partida ?numero) (realizado false) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (cuenta ?nombre) (monto ?monto) (glosa ?glosa) )
   ?cuenta <- (cuenta (partida ?numero) (qty ?qty) (nombre ?nombre) (debe ?debe) (haber ?haber)  )
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  =>
   ( bind ?c (+ ?qty ?qty-cargo))
   ( modify ?cuenta (factor-de-correccion-monetaria ?factor) (recibida ?recibida) (activo-fijo ?activo-fijo) (qty ?c) (tipo-de-documento ?tipo-de-documento) (electronico ?electronico) (partida ?numero) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (debe ( round (+ ?debe ?monto)) ))
   ( modify ?cargo (realizado true))
   ( printout t "c-->" tab ?monto tab "|" tab 0 tab ?nombre tab ?dia " de " ?mes tab ?glosa crlf)
)


(defrule cargar-cuenta-nueva
   ( declare (salience 9800))
   ( empresa (nombre ?empresa))
   ( balance (mes ?mes_top) (dia ?top) (ano ?ano_top) )
   ( partida (dia ?dia) (mes ?mes) (ano ?ano) (numero ?numero))
   ?cargo <-  (cargo (recibida ?recibida) (activo-fijo ?activo-fijo) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (realizado false) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (cuenta ?nombre) (monto ?monto) (glosa ?glosa) )
   ?cuenta <- (cuenta (partida nil) (dia nil) (mes nil) (ano nil) (nombre ?nombre ) (tipo ?tipo) (grupo ?grupo) (padre ?padre) (circulante ?circulante) (naturaleza ?naturaleza) (descripcion ?descripcion) (origen ?origen))


   ( correccion-monetaria-anual
     (mes ?mes)
     (ano ?ano)
     (factor ?factor) )


   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  =>
   ( assert (cuenta  (factor-de-correccion-monetaria ?factor)  (tipo-de-documento ?tipo-de-documento) (partida ?numero) (descripcion ?descripcion) (dia ?dia) (mes ?mes) (ano ?ano) (nombre ?nombre) (grupo ?grupo) (empresa ?empresa) (padre ?padre) (circulante ?circulante) (naturaleza ?naturaleza) (tipo ?tipo) (origen ?origen)))
   ( printout t "n-->" tab ?nombre tab ?dia " de " ?mes tab ?glosa crlf)
)


(defrule abonar-cuenta-existente
   ( declare (salience 9800))
   ( empresa (nombre ?empresa))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( partida (dia ?dia) (mes ?mes) (ano ?ano) (numero ?numero))
   ( revision
    (partida ?numero)
    (no-incluir false)
   )

   ( correccion-monetaria-anual
     (mes ?mes)
     (ano ?ano)
     (factor ?factor) )


   ?abono  <- (abono (recibida ?recibida) (activo-fijo ?activo-fijo) (tipo-de-documento ?tipo-de-documento) (qty ?qty) (electronico ?electronico) (partida ?numero) (realizado false) (empresa ?empresa) (dia ?dia) (cuenta ?nombre) (monto ?monto) (glosa ?glosa) (mes ?mes) (ano ?ano))
   ?cuenta <- (cuenta (partida ?numero) (nombre ?nombre) (debe ?debe) (haber ?haber) (tipo ?tipo) (circulante ?circulante))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

  =>

   ( modify ?cuenta (factor-de-correccion-monetaria ?factor) (recibida ?recibida) (activo-fijo ?activo-fijo) (tipo-de-documento ?tipo-de-documento) (qty ?qty) (electronico ?electronico) (partida ?numero) (empresa ?empresa) (dia ?dia) (mes ?mes) (ano ?ano) (haber ( round (+ ?haber ?monto) ) ))
   ( modify ?abono (realizado true))
   ( printout t "a<--" tab 0 tab "|" tab ?monto  tab ?nombre tab ?dia " de " ?mes tab ?glosa crlf)
)

(defrule abonar-cuenta-nueva
   ( declare (salience 9800))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( empresa (nombre ?empresa))
   ( partida (dia ?dia) (mes ?mes) (ano ?ano) (numero ?numero))
   ( revision
    (partida ?numero)
    (no-incluir false)
   )


   ?abono <-  (abono (recibida ?recibida) (activo-fijo ?activo-fijo) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (realizado false) (empresa ?empresa) (dia ?dia) (ano ?ano) (cuenta ?nombre) (monto ?monto) (glosa ?glosa) (mes ?mes))
   ?cuenta <- (cuenta (nombre ?nombre) (mes nil) (partida nil) (dia nil) (circulante ?circulante) (naturaleza ?naturaleza) (padre ?padre) (tipo ?tipo) (grupo ?grupo) (descripcion ?descripcion) (origen ?origen))


   ( correccion-monetaria-anual
     (mes ?mes)
     (ano ?ano)
     (factor ?factor) )


   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

  =>
   ( assert (cuenta (factor-de-correccion-monetaria ?factor) (recibida ?recibida) (activo-fijo ?activo-fijo) (tipo-de-documento ?tipo-de-documento) (partida ?numero) (empresa ?empresa) (nombre ?nombre) (grupo ?grupo) (tipo ?tipo) (padre ?padre) (circulante ?circulante) (naturaleza ?naturaleza) (descripcion ?descripcion) (origen ?origen ) (mes ?mes) (dia ?dia) (ano ?ano) ))
  ;( printout t "abono partida " ?numero " cuenta " ?nombre tab ?mes crlf)
  ( printout t "n<--"  tab ?nombre tab ?dia " de " ?mes tab ?glosa crlf)
)


(defrule totalizar-saldo-deudor
   ( declare (salience 9700))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( empresa (nombre ?empresa))
   ( partida (dia ?dia) (mes ?mes) (ano ?ano) (numero ?numero))

   ?f1 <- (cuenta (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (nombre ?nombre) (debe ?debe) (haber ?haber) (saldo 0) )

   ( correccion-monetaria-anual
     (mes ?mes)
     (ano ?ano)
     (factor ?factor) )

   ( test (and (or (> ?debe 0) (> ?haber 0))  (> ?debe ?haber) ) )          
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

  =>

   ( bind ?s (- (round ?debe) (round ?haber)))
   ( modify ?f1 (saldo ?s) (factor-de-correccion-monetaria ?factor) )
   ( printout t "t-->" tab ?s tab "|" tab ?nombre crlf)
)


(defrule totalizar-saldo-acreedor
   ( declare (salience 9700))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( empresa (nombre ?empresa))
   ( partida (dia ?dia) (mes ?mes) (ano ?ano) (numero ?numero))
   ?f1 <- (cuenta (partida ?numero) (dia ?dia) (mes ?mes) (ano ?ano) (nombre ?nombre) (debe ?debe) (haber ?haber) (saldo 0) )

   ( correccion-monetaria-anual
     (mes ?mes)
     (ano ?ano)
     (factor ?factor) )

   ( test (and (or (> ?debe 0) (> ?haber 0))  (< ?debe ?haber) ))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

  =>
   ( bind ?s (- (round ?haber) (round ?debe)))
   ( modify ?f1 (saldo ?s) (factor-de-correccion-monetaria ?factor) )
   ( printout t "t<--" tab ?s  tab "|" tab ?nombre crlf)
)

(defrule creando-padre-de-un-hijo-deudor
   ( declare ( salience 8000))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( empresa (nombre ?empresa))
   ( partida (dia ?dia) (mes ?mes) (ano ?ano) (numero ?numero))

   ?hijo <- (cuenta
                    (electronico ?electronico)
                    (activo-fijo ?activo-fijo)
                    (tipo-de-documento ?tipo-de-documento)
                    (partida    ?numero)
                    (dia        ?dia )
                    (mes        ?mes )
                    (ano        ?ano )
                    (empresa    ?empresa)
                    (nombre     ?nombre1)
                    (saldo      ?saldo )
                    (mayoreado  false)
                    (padre      ?nombre)
                    (tipo       deudor)
   )

   ?padre<- (cuenta
                    (descripcion ?descripcion)
                    (partida    ?otro_numero)
                    (nombre     ?nombre)
                    (saldo      ?saldo2)
                    (grupo      ?grupo)
                    (tipo       ?tipo)
                    (circulante ?circulante)
                    (naturaleza ?naturaleza)
                    (origen     ?origen) )


   ( correccion-monetaria-anual
     (mes ?mes)
     (ano ?ano)
     (factor ?factor) )


   ( test (neq ?numero ?otro_numero))
   ( test (> ?saldo 0))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

  =>

   ( assert (cuenta (factor-de-correccion-monetaria ?factor) (activo-fijo ?activo-fijo) (tipo-de-documento ?tipo-de-documento) (electronico ?electronico) (empresa ?empresa) (descripcion ?descripcion) (dia ?dia) (mes ?mes) (ano ?ano) (nombre ?nombre) (partida ?numero) (grupo ?grupo) (tipo ?tipo) (circulante ?circulante) (naturaleza ?naturaleza ) (origen ?origen)))
  ( printout t "p--> Creado padre " ?nombre " grupo " ?grupo " tipo " ?tipo " para un hijo " ?nombre1 " tipo " deudor crlf)
)

(defrule sumando-hijo-deudor-a-su-padre
   ( declare ( salience 8000))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( empresa (nombre ?empresa))
   ( partida (dia ?dia) (mes ?mes) (ano ?ano) (numero ?numero))

   ?hijo <- (cuenta
                    (electronico ?electronico)
                    (activo-fijo ?activo-fijo)
                    (tipo-de-documento ?tipo-de-documento)
                    (tipo       deudor)
                    (haber      ?haber_hijo)
                    (debe       ?debe_hijo)
                    (partida    ?numero)
                    (empresa    ?empresa)
                    (nombre     ?nombre1)
                    (saldo      ?saldo )
                    (mayoreado  false)
                    (padre      ?nombre))

   ?padre<- (cuenta
                    (haber      ?haber_padre)
                    (debe       ?debe_padre)
                    (partida    ?numero)
                    (nombre     ?nombre)
                    (grupo      ?grupo)
                    (tipo       ?tipo)
                    (saldo      ?saldo2))

   ( correccion-monetaria-anual
     (mes ?mes)
     (ano ?ano)
     (factor ?factor) )


   ( test (> ?saldo 0))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

  =>

   ( bind ?haber (+ ?haber_hijo ?haber_padre))
   ( bind ?debe  (+ ?debe_hijo  ?debe_padre))

   ( modify ?padre
      (factor-de-correccion-monetaria ?factor)
      (activo-fijo ?activo-fijo)
      (tipo-de-documento ?tipo-de-documento)
      (partida ?numero )
      (grupo ?grupo)
      (tipo ?tipo)
      (dia ?dia)
      (mes ?mes)
      (ano ?ano)
      (debe ?debe)
      (saldo 0)
      (haber ?haber)
      (empresa ?empresa)
      (verificada false)
      (mayoreado false))
   ( modify ?hijo (mayoreado true))
   ( printout t "h--> Desde " ?nombre1 " debe " ?debe  " haber " ?haber "  a su padre "  ?nombre ".  >---" crlf )
)


   
(defrule sumando-hijo-deudor-a-su-padre-deudor
   ( declare ( salience 8000))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( empresa (nombre ?empresa))
   ( partida (dia ?dia) (mes ?mes) (ano ?ano) (numero ?numero))

   ?hijo <- (cuenta
                    (electronico ?electronico)
                    (activo-fijo ?activo-fijo)
                    (tipo-de-documento ?tipo-de-documento)
                    (tipo       deudor)
                    (haber      ?haber_hijo)
                    (debe       ?debe_hijo)
                    (partida    ?numero)
                    (empresa    ?empresa)
                    (nombre     ?nombre1)
                    (saldo      ?saldo )
                    (mayoreado  false)
                    (padre      ?nombre))
   
   ?padre<- (cuenta
                    (haber      ?haber_padre)
                    (debe       ?debe_padre)
                    (tipo       deudor)
                    (partida    ?numero)
                    (nombre     ?nombre)
                    (saldo      ?saldo2))


   ( correccion-monetaria-anual
     (mes ?mes)
     (ano ?ano)
     (factor ?factor) )



   ( test (> ?saldo 0))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

  => 

   ( bind ?haber (+ ?haber_hijo ?haber_padre))
   ( bind ?debe  (+ ?debe_hijo  ?debe_padre))

   ( modify ?padre  (factor-de-correccion-monetaria ?factor) (activo-fijo ?activo-fijo) (tipo-de-documento ?tipo-de-documento) (partida ?numero ) (dia ?dia) (mes ?mes) (ano ?ano) (debe ?debe) (saldo 0) (haber ?haber) (empresa ?empresa) (verificada false) (mayoreado false))
   ( modify ?hijo (mayoreado true))
   ( printout t "h--> Desde " ?nombre1 " debe " ?debe  " haber " ?haber "  a su padre "  ?nombre ".  >---" crlf )
)  


(defrule creando-padre-de-un-hijo-acreedora
   ( declare ( salience 8000))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( empresa (nombre ?empresa))
   ( partida (dia ?dia) (numero ?numero) (ano ?ano) (mes ?mes))

   ?hijo <- (cuenta
                    (electronico ?electronico)
                    (activo-fijo ?activo-fijo)
                    (tipo-de-documento ?tipo-de-documento)
                    (partida    ?numero)
                    (dia        ?dia )
                    (mes        ?mes )
                    (ano        ?ano )
                    (empresa    ?empresa)
                    (nombre     ?nombre1)
                    (saldo      ?saldo )
                    (mayoreado  false)
                    (tipo       acreedora)
                    (padre      ?nombre))

   ?padre<- (cuenta
                    (descripcion ?descripcion)
                    (partida    ?otro_numero )
                    (nombre     ?nombre)
                    (saldo      ?saldo2)
                    (tipo       ?tipo)
                    (padre      ?nombre-abuelo)
                    (grupo      ?grupo)
                    (circulante ?circulante)
                    (origen     ?origen) )


   ( correccion-monetaria-anual
     (mes ?mes)
     (ano ?ano)
     (factor ?factor) )


   (test (neq ?numero ?otro_numero))
   (test (> ?saldo 0))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

  =>

   ( assert (cuenta (factor-de-correccion-monetaria ?factor) (activo-fijo ?activo-fijo) (tipo-de-documento ?tipo-de-documento) (empresa ?empresa) (electronico ?electronico) (descripcion ?descripcion) (dia ?dia) (mes ?mes) (ano ?ano) (nombre ?nombre) (partida ?numero) (grupo ?grupo) (tipo ?tipo ) (origen ?origen) (circulante ?circulante) (padre ?nombre-abuelo)))
   ( printout t "p<-- Creado padre " ?nombre " para un hijo acreedor " ?nombre1 crlf)
)

(defrule sumando-hijos-acreedora-a-su-padre-acreedora-con-abuelo
   ( declare ( salience 7000))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( empresa (nombre ?empresa))
   ( partida (dia ?dia) (mes ?mes) (ano ?ano) (numero ?numero))

   ?hijo <- (cuenta
                    (tipo-de-documento ?tipo-de-documento)
                    (activo-fijo ?activo-fijo)
                    (debe       ?debe-hijo)
                    (haber      ?haber-hijo) 
                    (partida    ?numero)
                    (tipo       acreedora)
                    (electronico ?electronico)
                    (empresa    ?empresa)
                    (nombre     ?nombre1)
                    (saldo      ?saldo )
                    (mayoreado  true)
                    (padre      ?nombre))

   ?padre <- (cuenta
                    (mayoreado  false)
                    (debe       ?debe-padre)
                    (haber      ?haber-padre)
                    (partida    ?numero )
                    
                    (nombre     ?nombre)
                    (padre      ?nombre-abuelo)
                    (tipo       acreedora )
                    (saldo      ?saldo2))

   ?abuelo <- (cuenta
                    (debe       ?debe-abuelo)
                    (haber      ?haber-abuelo)
                    (partida    ?numero )
                    (nombre     ?nombre-abuelo)
                    (padre      false)
                    (tipo       acreedora )
                    (saldo      ?saldo3))


   ( correccion-monetaria-anual
     (mes ?mes)
     (ano ?ano)
     (factor ?factor) )

   ( test (neq nil ?nombre-abuelo))
   ( test (> ?saldo 0))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

  =>

   ( bind   ?debe  (+ ?debe-hijo  ?debe-padre ))
   ( bind   ?haber (+ ?haber-hijo ?haber-padre))
   ( assert ( cuenta (factor-de-correccion-monetaria ?factor) (activo-fijo ?activo-fijo) (tipo-de-documento ?tipo-de-documento) ( nombre ?nombre-abuelo) (electronico ?electronico) (partida ?numero) (mes ?mes) (ano ?ano) (debe ?debe) (haber ?haber) (empresa ?empresa) ))
  ; ( modify ?abuelo (dia ?dia) (mes ?mes) (ano ?ano) (saldo 0) (debe ?debe) (haber ?haber) (empresa ?empresa) (verificada false) (mayoreado false))
   ( modify ?padre (mayoreado true)  )
   ( printout t "h<-- Desde " ?nombre1 " haber " ?haber " debe " ?debe " a su abuelo acreedor "  ?nombre-abuelo ">---" partida-abuelo crlf )
 ;  ( halt )
)


(defrule sumando-padre-acreedora-a-su-padre-acreedora
   ( declare ( salience 8000))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( empresa (nombre ?empresa))
   ( partida (dia ?dia) (mes ?mes) (ano ?ano) (numero ?numero))
 
   ;venta-con-facturas
   ?hijo <- (cuenta
                    (activo-fijo ?activo-fijo)
                    (tipo-de-documento ?tipo-de-documento)
                    (partida    ?numero)
                    (debe       ?debe-hijo)
                    (haber      ?haber-hijo)
                    (tipo       acreedora)
                    (electronico ?electronico)
                    (empresa    ?empresa)
                    (nombre     ?nombre1)
                    (saldo      ?saldo )
                    (mayoreado  false) 
                    (padre      ?nombre))
   ;ventas
   ?padre <- (cuenta
                    (debe       ?debe-padre)
                    (haber      ?haber-padre)
                    (partida    ?numero )
                    (nombre     ?nombre)
                    (tipo       acreedora )
                    (saldo      ?saldo2)) 


   ( correccion-monetaria-anual
     (mes ?mes)
     (ano ?ano)
     (factor ?factor) )


   ( test (> ?saldo 0))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))
  => 
   ( bind   ?debe  (+ ?debe-hijo  ?debe-padre ))
   ( bind   ?haber (+ ?haber-hijo ?haber-padre))

   ( modify ?padre (factor-de-correccion-monetaria ?factor) (activo-fijo ?activo-fijo) (tipo-de-documento ?tipo-de-documento) (electronico ?electronico) (dia ?dia) (mes ?mes) (ano ?ano) (saldo 0) (debe ?debe) (haber ?haber) (empresa ?empresa) (verificada false) (mayoreado false) (partida ?numero))

   ( modify ?hijo (mayoreado true)  )
   ( printout t "h<-- Desde " ?nombre1 " haber " ?haber " debe " ?debe " a su padre acreedor "  ?nombre ">---" crlf )
   
)



(defrule sumando-hijos-acreedora-a-su-padre-deudor
   ( declare ( salience 8000))
   ( balance (dia ?top) (mes ?mes_top) (ano ?ano_top))
   ( empresa (nombre ?empresa))
   ( partida (dia ?dia) (mes ?mes) (ano ?ano) (numero ?numero))

   ?hijo <- (cuenta
                    (activo-fijo ?activo-fijo)
                    (tipo-de-documento ?tipo-de-documento)
                    (debe       ?debe-hijo)
                    (haber      ?haber-hijo)
                    (partida    ?numero)
                    (tipo       acreedora)
                    (empresa    ?empresa)
                    (nombre     ?nombre1)
                    (electronico ?electronico)
                    (saldo      ?saldo )
                    (mayoreado  false)
                    (padre      ?nombre))

   ?padre <- (cuenta
                    (debe       ?debe-padre)
                    (haber      ?haber-padre)
                    (partida    ?numero )
                    (nombre     ?nombre)
                    (tipo       deudor )
                    (saldo      ?saldo2))

   ( correccion-monetaria-anual
     (mes ?mes)
     (ano ?ano)
     (factor ?factor) )


   ( test (> ?saldo 0))
   ( test (>= (to_serial_date ?top ?mes_top ?ano_top) (to_serial_date ?dia ?mes ?ano)))

  =>

   ( bind   ?debe  (+ ?debe-hijo  ?debe-padre ))
   ( bind   ?haber (+ ?haber-hijo ?haber-padre))

   ( modify ?padre (factor-de-correccion-monetaria ?factor) (activo-fijo ?activo-fijo) (tipo-de-documento ?tipo-de-documento) (dia ?dia) (mes ?mes ) (saldo 0) (debe ?debe) (haber ?haber) (empresa ?empresa) (verificada false) (mayoreado false) (electronico ?electronico))
   ( modify ?hijo (mayoreado true)  )
   ( printout t "h<-- Desde " ?nombre1 " haber " ?haber " debe " ?debe " a su padre acreedor "  ?nombre ">---" crlf )
)




