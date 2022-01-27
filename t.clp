(deftemplate subcuenta
  (slot origen)
)


(deftemplate pago-impuestos-mensuales
  (slot pagado (default false))
  (slot mes-de-pago)
  (slot folio)
  (slot partida)
  (slot dia)
  (slot mes)
  (slot ano)
)



(deftemplate resumen-de-boletas-sii
  (slot partida)
  (slot unidades)
  (slot mes)
  (slot ano)
  (slot neto)
  (slot total)
  (slot iva)
)


(deftemplate revision
  (slot rcv)
  (slot ccm)
  (slot legal)
  (slot tipo)
  (slot folio)
  (slot revisado)
  (slot partida)
  (slot descripcion)
)


(deftemplate nota-de-credito-sii
  (slot folio-nota)
  (slot folio)
  (slot partida)
  (slot dia)
  (slot mes)
  (slot ano)
)

(deftemplate nota-de-credito
  (slot folio-nota)
  (slot folio)
  (slot partida)
  (slot dia)
  (slot mes)
  (slot ano)
)

(deftemplate amortizacion
  (slot folio)
  (slot partida)
  (slot dia)
  (slot mes)
  (slot ano)
)

(deftemplate actual
  (slot mes)
)

( deftemplate imposiciones
  (slot dia )
  (slot mes )
  (slot ano )
  (slot mes-de-pago)
  (slot pagadas (default false))
)


( deftemplate deposito
  (slot partida)
  (slot banco )
  (slot monto )
  (slot mes)
  (slot dia)
  (slot ano)
  (slot glosa))

( deftemplate ticket
   (slot numero)
)

(deftemplate partida-inventario-final
   (slot partida)
   (slot hecho )
)

(deftemplate footer
   ( slot empresa)
   ( slot dia)
   ( slot mes)
   ( slot ano)
   ( slot partida)
   ( slot mostrado-en-partida (default false))
   ( slot debe (default 0))
   ( slot haber (default 0)))

;subtotales de las tablas T
(deftemplate subtotales
   ( slot rut )
   ( slot cuenta)
   ( slot mes)
   ( slot mostrar-en-comprobacion (default true))
   ( slot mostrado-en-resumen (default false))
   ( slot anotado (default false))
   ( slot debe (default 0))
   ( slot haber (default 0))
   ( slot deber (default 0))
   ( slot acreedor (default 0))
   ( slot totalizado (default false))
   ( slot mostrado (default false))
)

;totales generales
(deftemplate totales
   ( slot empresa )
   ( slot debe (default 0))
   ( slot haber (default 0))
   ( slot deber (default 0))
   ( slot acreedor (default 0))
   ( slot totalizado (default false))
   ( slot pasivos    (default 0))
   ( slot pasivo-circulante (default 0))
   ( slot pasivo-fijo (default 0))
   ( slot activos    (default 0))
   ( slot activo-circulante (default 0))
   ( slot activo-fijo (default 0))
   ( slot resultados (default 0))
   ( slot patrimonio (default 0))
)



(deftemplate MAIN::comando
   (slot nombre)
   (slot realizado (default false))
)

(deftemplate MAIN::inventario
   (slot cliente)
   (slot proveedor)
   (slot material)
   (slot dia )
   (slot mes )
   (slot ano)
   (slot operacion )
   (slot debe (default 0))
   (slot haber (default 0))
   (slot saldo (default 0))
   (slot fecha)
   (slot u)
   (slot cu)
   (slot ct)
   (slot partida)
   (slot glosa)
)

(deftemplate MAIN::encabezado
   (slot partida)
)

(deftemplate MAIN::ejercicio
   (slot desde (default 1))
   (slot hasta (default 1))
)

(deftemplate MAIN::partida
   (slot empresa)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot numero)
   (slot debe (default 0))
   (slot haber (default 0))
   (slot actividad)
   (slot descripcion))


(deftemplate MAIN::partida-mensual
   (slot empresa)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot numero)
   (slot debe (default 0))
   (slot haber (default 0))
   (slot descripcion))



(deftemplate MAIN::empresa
   (slot nombre)
   (slot razon))

(deftemplate MAIN::cuenta 
   (slot codigo-sii)
   (slot nombre-sii)
   (slot nombre (default "N/D"))
   (slot parte)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot de-resultado (default false))
   (slot liquidada (default false))
   (slot circulante  (default false))
   (slot totalizado-como-activo (default false))
   (slot mostrado-en-t (default false))
   (slot partida)
   (slot mostrada-en-partida  (default false))
   (slot traspasado-a-inventario (default false))
   (slot totalizada-como-activo (default false))
   (slot totalizada-como-activo-circulante (default false))
   (slot totalizada-como-activo-fijo (default false))
   (slot totalizada-como-pasivo (default false))
   (slot totalizada-como-pasivo-circulante (default false))
   (slot totalizada-como-pasivo-fijo (default false))
   (slot totalizada-como-patrimonio (default false))
   (slot reseteada   (default false))
   (slot empresa     (default false))
   (slot mayoreado   (default false))
   (slot padre       (default false))
   (slot balanceado  (default false))
   (slot descripcion (default "N/D"))
   (slot verificada  (default false))
   (slot codigo      (default "N/D"))
   (slot debe        (default 0))
   (slot haber       (default 0))
   (slot saldo       (default 0))
   (slot tipo        (default false))
   (slot grupo       (default false))
   (slot naturaleza  (default false))
   (slot origen      (default false)))

(deftemplate MAIN::cargo
   (slot partida)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot realizado (default false))
   (slot empresa)
   (slot cuenta)
   (slot monto (default 0))
   (slot glosa))

(deftemplate MAIN::abono 
   (slot partida)
   (slot dia )
   (slot mes )
   (slot ano)
   (slot realizado (default false))
   (slot empresa)
   (slot cuenta)
   (slot monto (default 0))
   (slot glosa))

(deftemplate MAIN::gasto-sobre-compras
   (slot partida)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot unidades)
   (slot costo_unitario)
   (slot finalidad)
   (slot material)
   (slot credito)
   (slot neto (default 0))
   (slot iva (default 0))
   (slot total (default 0))
   (slot proveedor (default nil))
   (slot servicio (default servicio))
   (slot glosa (default nil))
   (slot monto (default 0)))



(deftemplate MAIN::costo-ventas
   (slot rut)
   (slot folio)
   (slot archivo)
   (slot partida)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot finalidad)
   (slot material)
   (slot credito)
   (slot neto (default 0))
   (slot iva (default 0))
   (slot total (default 0))
   (slot proveedor (default nil))
   (slot cliente)
   (slot servicio (default servicio))
   (slot glosa (default nil))
   (slot monto (default 0)))






(deftemplate MAIN::gasto-ventas
   (slot rut)
   (slot folio)
   (slot archivo)
   (slot partida)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot finalidad)
   (slot material)
   (slot credito)
   (slot neto (default 0))
   (slot iva (default 0))
   (slot total (default 0))
   (slot proveedor (default nil))
   (slot cliente)
   (slot servicio (default servicio))
   (slot glosa (default nil))
   (slot monto (default 0)))




(deftemplate MAIN::gasto-afecto
   (slot partida)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot finalidad)
   (slot material)
   (slot credito)
   (slot neto (default 0))
   (slot iva (default 0))
   (slot total (default 0))
   (slot proveedor (default nil))
   (slot servicio (default servicio))
   (slot glosa (default nil))
   (slot monto (default 0)))


(deftemplate MAIN::gasto-investigacion-y-desarrollo
   (slot iva-retenido)
   (slot archivo)
   (slot folio)
   (slot rut)
   (slot partida)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot finalidad)
   (slot material)
   (slot credito)
   (slot neto (default 0))
   (slot iva (default 0))
   (slot total (default 0))
   (slot proveedor (default nil))
   (slot servicio (default servicio))
   (slot glosa (default nil))
   (slot monto (default 0)))





(deftemplate MAIN::gasto-administrativo
   (slot iva-retenido)
   (slot archivo)
   (slot folio)
   (slot rut)
   (slot partida)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot finalidad)
   (slot material)
   (slot credito)
   (slot neto (default 0))
   (slot iva (default 0))
   (slot total (default 0))
   (slot proveedor (default nil))
   (slot servicio (default servicio))
   (slot glosa (default nil))
   (slot monto (default 0)))


(deftemplate MAIN::despago
   (slot partida)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot finalidad)
   (slot neto (default 0))
   (slot iva (default 0))
   (slot total (default 0))
   (slot proveedor (default nil))
   (slot servicio (default servicio))
   (slot glosa (default nil))
   (slot monto (default 0)))


(deftemplate MAIN::pago
   (slot partida)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot cliente)
   (slot finalidad)
   (slot neto (default 0))
   (slot iva (default 0))
   (slot total (default 0))
   (slot proveedor (default nil))
   (slot servicio (default servicio))
   (slot glosa (default nil))
   (slot monto (default 0)))


(deftemplate MAIN::salario
   (slot partida)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot finalidad)
   (slot departamento (default nil))
   (slot servicio (default servicio))
   (slot glosa (default nil))
   (slot efectivo (default 0)))


(deftemplate MAIN::honorario
   (slot partida)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot finalidad)
   (slot departamento (default nil))
   (slot servicio (default servicio))
   (slot glosa (default nil))
   (slot efectivo (default 0)))


(deftemplate MAIN::compra-mercaderia
   (slot intangible)
   (slot partida)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot unidades)
   (slot costo_unitario)
   (slot finalidad)
   (slot glosa)
   (slot herramienta)
   (slot material)
   (slot afecto (default true))
   (slot credito)
   (slot letras )
   (slot efectivo)
   (slot proveedor)
   (slot iva    (default 0))
   (slot neto   (default 0))
   (slot total  (default 0)))





(deftemplate MAIN::compra  
   (slot intangible)
   (slot partida)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot unidades)
   (slot costo_unitario)
   (slot finalidad)
   (slot glosa)
   (slot herramienta)
   (slot material)
   (slot afecto (default true))
   (slot credito)
   (slot letras )
   (slot efectivo)
   (slot proveedor)
   (slot iva    (default 0))
   (slot neto   (default 0))
   (slot total  (default 0)))



(deftemplate MAIN::venta-sii
   (slot folio)
   (slot rut)
   (slot partida)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot costo_unitario)
   (slot unidades)
   (slot finalidad)
   (slot herramienta)
   (slot material)
   (slot afecta (default true))
   (slot credito)
   (slot efectivo)
   (slot cliente)
   (slot colaborador)
   (slot iva    (default 0))
   (slot neto   (default 0))
   (slot total  (default 0)))





(deftemplate MAIN::venta-anticipada
   (slot folio)
   (slot rut)
   (slot partida)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot costo_unitario)
   (slot unidades)
   (slot finalidad)
   (slot herramienta)
   (slot material)
   (slot afecta (default true))
   (slot credito)
   (slot efectivo)
   (slot cliente)
   (slot colaborador)
   (slot iva    (default 0))
   (slot neto   (default 0))
   (slot total  (default 0)))





(deftemplate MAIN::venta
   (slot folio)
   (slot rut)
   (slot partida)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot costo_unitario)
   (slot unidades)
   (slot finalidad)
   (slot herramienta)
   (slot material)
   (slot afecta (default true))
   (slot credito)
   (slot efectivo)
   (slot cliente)
   (slot colaborador)
   (slot iva    (default 0))
   (slot neto   (default 0))
   (slot total  (default 0)))

(deftemplate MAIN::devolucion
   (slot partida)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot costo_unitario)
   (slot unidades (default 0))
   (slot finalidad)
   (slot glosa)
   (slot material)
   (slot afecta (default true))
   (slot cliente)
   (slot iva    (default 0))
   (slot neto   (default 0))
   (slot total  (default 0)))

(deftemplate MAIN::gasto 
   (slot partida)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot finalidad)
   (slot intangible (default nil))
   (slot material (default nil))
   (slot monto (default 0)))

(deftemplate MAIN::merma
   (slot partida)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot finalidad)
   (slot material (default nil))
   (slot monto (default 0)))

(deftemplate MAIN::reparacion
   (slot partida)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot finalidad)
   (slot material)
   (slot costo  (default 0))
   (slot precio (default 0)))

(deftemplate MAIN::ecuacion
   (slot partida)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot empresa )
   (slot pasivos    (default 0))
   (slot pasivo-circulante (default 0))
   (slot pasivo-fijo (default 0))
   (slot activos    (default 0))
   (slot activo-circulante (default 0))
   (slot activo-fijo (default 0))
   (slot resultados (default 0))
   (slot patrimonio (default 0)))

(deftemplate MAIN::liquidacion
   (slot tipo-de-saldo)
   (slot partida)
   (slot dia )
   (slot mes )
   (slot ano)
   (slot liquidadora)
   (slot cuenta))

(deftemplate MAIN::reposicion
   (slot partida)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot finalidad)
   (slot cuenta)
   (slot monto))

(deftemplate MAIN::comision
   (slot partida)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot finalidad)
   (slot pasarela (default efectivo))
   (slot colaborador)
   (slot servicio)
   (slot monto))

(deftemplate MAIN::prestamo
   (slot partida)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot finalidad)
   (slot banco)
   (slot monto)
   (slot interes))

(deftemplate MAIN::balance
   (slot dia (default 1))
   (slot mes )
   (slot ano)
)
              
