
(deftemplate version
  (slot id)
  (slot version)
  (slot asin)
  (slot dia)
  (slot mes)
)

(deftemplate volumen
  (slot cubierta) 
  (slot autor)
  (slot id)
  (slot isbn)
  (slot asin)
  (slot precio)
  (slot dimensiones)
  (slot formato) 
  (slot titulo)
  (slot paginas)
  (slot subtitulo)
  (slot contenido)
  (slot serie)
  (slot orden)
  (multislot partidas-no-incluidas)
  (multislot capitulos)
)


(deftemplate inicio-de-los-dias
  (multislot partidas (default 0) (type NUMBER)) 
)

(deftemplate ajuste-anual-de-resultado-financiero
  (slot dia)
  (slot mes)
  (slot ano)
  (slot partida)
)

(deftemplate ajuste-anual-de-resultado-tributario
  (slot dia)
  (slot mes)
  (slot ano)
  (slot partida)
)

(deftemplate ajuste-anual
   (slot dia)
   (slot mes)
   (slot ano)
   (slot partida)
   (slot liquidacion)
   (slot efecto)
)

(deftemplate reglas
  (multislot lista (type STRING))
)

(deftemplate actividad
    (slot nombre)
)

(deftemplate hecho
    (slot nombre)
    (slot gravado (default false))
    (slot id)
    (slot partida)
    (slot regla)
)
 
(deftemplate nonce
    (slot ticket))

(deftemplate ajustes-mensuales
    (slot dia )
    (slot mes )
    (slot ano)
    (slot partida))

(deftemplate registro-de-depreciacion
  (slot liquidado (default false))
  (slot metodo-tributario)
  (slot metodo )
  (slot nombre-del-activo)
  (slot cuenta-del-activo)
  (slot cuenta-del-pasivo)
  (slot cuenta-acumuladora)
  (slot dia-de-adquisicion)
  (slot mes-de-adquisicion)
  (slot ano-de-adquisicion)
  (slot mes-final)
  (slot ano-final )
  (slot valor-de-adquisicion)
  (slot meses-de-vida-util (default 12))
  (slot ultima-cuota (default 0))
  (slot depreciacion-mensual)
)

(deftemplate registro-de-amortizacion
  (slot metodo-tributario)
  (slot metodo )
  (slot nombre-del-activo)
  (slot cuenta-del-activo)
  (slot cuenta-del-pasivo)
  (slot cuenta-acumuladora)
  (slot dia-de-adquisicion)
  (slot mes-de-adquisicion)
  (slot ano-de-adquisicion)
  (slot mes-final)
  (slot ano-final)
  (slot valor-de-adquisicion)
  (slot meses-de-vida-util (default 12))
  (slot ultima-cuota (default 0))
  (slot amortizacion-mensual)
)



(deftemplate remanente-de-iva
  ( slot emitido (default false))
  ( slot partida )
  ( slot determinado (default false))
  ( slot ajustado (default false))
  ( slot valor  (default 0) )
  ( slot valor-ajustado (default 0))
  ( slot mes )
  ( slot mes-de-ajuste)
  ( slot ano-de-ajuste)
  ( slot ano )
  ( slot utm )
)

(deftemplate acarreo-de-iva
  ( slot valor  (default 0) )
  ( slot ajustado (default false))
)


(deftemplate selecciones
 (slot renumerar (default false))
 (slot remuneraciones-aparte (default false))
 (slot nombre-de-archivo-k (default ""))
 (slot archivo-unico-markdown (default false))
 (slot abonar-deudoras (default false))
 (slot cargar-acreedoras (default false))
 (slot devolver-a-devolucion-sobre-ventas (default false))
 (slot incentivo-al-ahorro (default false))
 (slot regimen)
 (slot ejercicio-anterior)
 (slot liquidar (default paternas))
 (slot origen-de-subcuentas )
 (slot empresa-seleccionada)
 (slot imprimir-detalles)
 (slot cargar-imagenes-de-dte (default true))
 (slot inspect-f29-code)
)

(deftemplate contrato
 (slot trabajador)
 (slot jornada)
 (slot dedicacion)
 (slot diaria)
 (slot duracion)
 (slot tipo-de-duracion)
 (slot funcion)
)

(deftemplate afc
  (slot aporte-empleador)
  (slot aporte-trabajador)
  (slot duracion)
  (slot comision)
)

(deftemplate tramo-impuesto-unico
  (slot exento-en-utm)
  (slot tasa)
)

(deftemplate remuneracion
  (slot servicio)
  (slot trabajador)
  (slot bruto)
  (slot monto)
  (slot mes)
  (slot ano)
  (slot dias-trabajados)
  (slot semana-corrida)
  (slot pagada)
  (slot declarada)
  (slot impuesta)
  (slot procesada (default false))
)

(deftemplate afp
 (slot mes)
 (slot ano)
 (slot nombre)
 (slot comision)
 (slot sis)
 (slot afc)
)

(deftemplate salud
 (slot nombre)
 (slot cotizacion)
)

(deftemplate pago-de-salarios
  (slot referencia)
  (slot remuneraciones (default false))
  (slot imposiciones (default false))
  (slot partida)
  (slot salud (default 0))
  (slot afp (default 0))
  (slot afc (default 0))
  (slot unico (default 0))
  (slot folio-prevision)
  (slot folio-salud)
  (slot remuneracion (default 0))
  (slot trabajador)
  (slot dia)
  (slot mes)
  (slot ano)
  (slot multa)
  (slot archivo)
  (slot folio)
  (slot glosa)
)

(deftemplate cobro-de-cuentas-por-cobrar
  (slot partida )
  (slot monto )
  (slot dia)
  (slot mes)
  (slot ano)
  (slot glosa)
)



(deftemplate movilizacion
  (slot proveedor)
  (slot folio)
  (slot partida)
  (slot dia)
  (slot mes)
  (slot ano)
  (slot monto)
)



(deftemplate compra-de-acciones
  (slot realizada (default false))
  (slot partida)
  (slot dia)
  (slot mes)
  (slot ano)
  (slot numero-de-acciones (default 0))
  (slot valor-nominal )
  (slot cedente)
  (slot comprador)
)

(deftemplate inicio-de-acciones
  (slot partida)
  (slot dia)
  (slot mes)
  (slot ano)
  (slot numero-de-acciones (default 0))
  (slot valor-nominal )
  (slot accionista)
)



(deftemplate constitucion-de-spa
  (slot mes)
  (slot ano)
  (slot partida)
  (slot capital)
  (slot numero-de-acciones)
  (slot serie)
  (slot nominativa)
  (slot valor-nominal)
)

(deftemplate registro-de-accionistas
  (slot partida)
  (slot nombre)
  (slot dia)
  (slot mes)
  (slot ano)
  (slot mostrado-en-partida (default false) )
)

(deftemplate accionista
  (slot numero-de-acciones (default 0))
  (slot valor-nominal)
  (slot mes)
  (slot ano)
  (slot empresa)
  (slot nombre)
  (slot rut)
  (slot social)
  (slot domicilio)
)


(deftemplate trabajador
  (slot nombre-completo)
  (slot diaria)
  (slot afp)
  (slot salud)
  (slot mes-inicio)
  (slot ano-inicio)
  (slot mes-fin)
  (slot ano-fin)
  (slot empresa)
  (slot nombre)
  (slot rut)
  (slot social)
  (slot domicilio)
  (slot bruto-mensual)
  (slot duracion)
)


(deftemplate proveedor
  (slot nombre)
  (slot rut)
  (slot social)
  (slot padre)
)

(deftemplate ccm
  (slot partida)
  (slot voucher)
  (slot tipo-documento)
  (slot folio (default ''))
  (slot rut-contraparte (default ''))
  (slot tasa-impuesto (default 19))
  (slot razon-social-contraparte (default ''))
  (slot tipo-impuesto (default 1))
  (slot fecha-emision)
  (slot anulado (default ''))
  (slot monto-exento (default 0))
  (slot monto-neto (default 0))
  (slot monto-iva-recuperable (default 0))
  (slot codigo-iva-no-recuperable (default ''))
  (slot monto-iva-no-recuperable (default ''))
  (slot iva-uso-comun (default ''))
  (slot codigo-otro-impuesto-con-credito (default ''))
  (slot tasa-otro-impuesto-con-credito (default ''))
  (slot monto-otro-impuesto-con-credito (default ''))
  (slot monto-total (default ''))
  (slot monto-otro-impuesto-sin-credito (default ''))
  (slot monto-activo-fijo (default ''))
  (slot monto-iva-activo-fijo (default ''))
  (slot iva-no-retenido (default ''))
  (slot tabacos-puros (default ''))
  (slot tabacos-cigarrillos (default ''))
  (slot tabacos-elaborados (default ''))
  (slot impuesto-a-vehiculos-automoviles (default ''))
  (slot codigo-sucursal-sii (default ''))
  (slot numero-interno (default ''))
  (slot emisor-receptor (default ''))
  (slot tasa-iva-retenido (default 19))
)


(deftemplate depreciacion
  (slot partida)
  (slot folio)
  (slot herramienta)
  (slot dia)
  (slot mes)
  (slot ano)
  (slot monto)
  (slot pagado (default false))
)

(deftemplate amortizacion
  (slot partida)
  (slot folio)
  (slot intangible)
  (slot dia)
  (slot mes)
  (slot ano)
  (slot monto)
  (slot pagado (default false))
)


( deftemplate amortizacion-instantanea-extracontable
     ( slot intangible)
     ( slot mes )
     ( slot ano)
     ( slot partida)
     ( slot pagado)
     ( slot monto))


(deftemplate pea
  (slot partida )
)

(deftemplate distribucion-de-utilidad
  (slot partida )
  (slot dia)
  (slot mes)
  (slot ano)
  (slot monto)
  (slot archivo)
  (slot cuenta-de-destino)
)

(deftemplate traspaso
 (slot dia)
 (slot mes)
 (slot ano)
 (slot partida)
 (slot cuenta-de-origen)
 (slot cuenta-de-destino))


(deftemplate tasas
  (slot ano)
  (slot mes)
  (slot utm)
  (slot ppm)
  (slot idpc)
  (slot honorarios)
)

(deftemplate sumar
  (slot partida)
  (slot tipo-de-documento)
  (slot qty (default 1))
  (slot cuenta)
  (slot mes)
  (slot ano)
  (slot debe (default 0))
  (slot haber (default 0))
)


(deftemplate acumulador-mensual
  (slot tipo-de-documento)
  (slot qty (default 0))
  (slot cuenta)
  (slot mes)
  (slot ano)
  (slot debe (default 0))
  (slot haber (default 0))
)


(deftemplate codigo-f29 
 (slot codigo )
)

(deftemplate formulario-f29
  (slot mostrado-en-f22 (default false))
  (slot mostrado-en-partida (default false))
  (slot descripcion)
  (slot codigo)
  (slot valor)
  (slot mes)
  (slot ano)
  (slot partida)
)



(deftemplate codigo-de-partida
  (slot rechazado (default false))
  (slot codigo)
  (slot partida)
)

(deftemplate f29-f22
  (slot cuenta)
  (slot codigo-f29)
  (slot linea-f22)
)

(deftemplate formulario-f22
  (slot anual (default false))
  (slot sumado (default false))
  (slot presentado-en-codigo-de-partida (default false))
  (slot presentado-en-f22 (default false))
  (slot descripcion)
  (slot codigo)
  (slot valor)
  (slot mes (default ""))
  (slot ano)
  (slot partida)
)

(deftemplate codigo-f22
  (slot codigo)
  (slot valor)
  (slot cuenta)
  (slot saldo)
  (slot iva)
)


(deftemplate f22
  (slot partida)
  (slot dia)
  (slot mes)
  (slot ano)
)



(deftemplate f29
  (slot anualizado (default true))
  (slot partida)
  (slot dia)
  (slot mes)
  (slot ano)
)


(deftemplate puede-pagar-iva
  (slot mes)
)

(deftemplate subcuenta
  (slot origen)
)



(deftemplate ajuste-de-remanente-de-iva
  (slot mes-que-se-declara-en-el-f29)
  (slot mes-en-que-se-presenta-el-f29)
  (slot mes-que-genero-remanente)
  (slot mostrar-en)
  (slot ano-anterior)
  (slot mes-anterior)
  (slot antes (default 0))
  (slot ahora (default 0))
  (slot pagado (default false))
  (slot mes-de-pago)
  (slot ano-de-pago)
  (slot folio)
  (slot partida)
  (slot dia)
  (slot mes)
  (slot ano)
)




(deftemplate ajuste-de-iva-contra-debito
  (slot monto (default 0))
  (slot pagado (default false))
  (slot mes-de-pago)
  (slot folio)
  (slot partida)
  (slot dia)
  (slot mes)
  (slot ano)
)

(deftemplate ajuste-de-iva-contra-credito
  (slot monto (default 0))
  (slot pagado (default false))
  (slot mes-de-pago)
  (slot folio)
  (slot partida)
  (slot dia)
  (slot mes)
  (slot ano)
)





(deftemplate pago-de-iva
  (slot monto)
  (slot pagado (default false))
  (slot mes-de-pago)
  (slot folio)
  (slot partida)
  (slot dia)
  (slot mes)
  (slot ano)
)

(deftemplate declaracion-de-ppm
  (slot pagado (default false))
  (slot mes-de-pago)
  (slot folio)
  (slot partida)
  (slot dia)
  (slot mes)
  (slot ano)
)


(deftemplate pago-de-ppm
  (slot pagado (default false))
  (slot mes-de-pago)
  (slot folio)
  (slot partida)
  (slot dia)
  (slot mes)
  (slot ano)
)



(deftemplate pago-de-retenciones-de-honorarios
  (slot rut)
  (slot monto (default 0))
  (slot pagado (default false))
  (slot mes-de-pago)
  (slot folio)
  (slot partida)
  (slot dia)
  (slot mes)
  (slot ano)
)



(deftemplate pago-de-ppv
  (slot monto)
  (slot pagado (default false))
  (slot mes-de-pago)
  (slot folio)
  (slot partida)
  (slot dia)
  (slot mes)
  (slot ano)
)




(deftemplate rendicion-de-eboletas-sii
  (slot folio)
  (slot partida)
  (slot unidades)
  (slot dia)
  (slot mes)
  (slot ano)
  (slot neto)
  (slot total)
  (slot iva)
)


(deftemplate rendicion-de-vouchers-sii
  (slot partida)
  (slot unidades)
  (slot dia)
  (slot mes)
  (slot ano)
  (slot neto)
  (slot total)
  (slot iva)
)

(deftemplate revision-general
  (slot cuenta (default ""))
  (slot voucher (default " "))
  (slot old (default " "))
  (slot a-corregir (default " "))
  (slot rcv (default "no" ))
  (slot ccm (default "no" ))
  (slot libro-diario (default "no"))
  (slot legal (default " "))
  (slot tipo (default " "))
  (slot folio (default " "))
  (slot revisado (default "no"))
  (multislot partidas (type INTEGER) (default 0))
  (slot descripcion (default " "))
  (slot rechazado (default false) )
  (slot ignorado-por-sii (default false))
  (slot reclamado (default false) )
  (slot no-incluir (default false))
  (slot dia)
  (slot mes)
  (slot ano)
)



(deftemplate revision
  (slot cuenta (default ""))
  (slot voucher (default " "))
  (slot old (default " "))
  (slot a-corregir (default " "))
  (slot rcv (default "no" ))
  (slot ccm (default "no" ))
  (slot libro-diario (default "no"))
  (slot legal (default " "))
  (slot tipo (default " "))
  (slot folio (default " "))
  (slot revisado (default "no"))
  (slot partida (default " "))
  (slot descripcion (default " "))
  (slot rechazado (default false) )
  (slot reclamado (default false) )
  (slot no-incluir (default false))
  (slot ignorar (default false))
  (slot dia)
  (slot mes)
  (slot ano)
)



(deftemplate nota-de-credito-sii
  (slot rut)
  (slot folio-nota)
  (slot folio)
  (slot partida)
  (slot dia)
  (slot mes)
  (slot ano)
  (slot archivo)
)

(deftemplate nota-de-debito-sii
  (slot archivo)
  (slot rut)
  (slot folio-credito)
  (slot folio-debito)
  (slot partida)
  (slot dia)
  (slot mes)
  (slot ano)
)

(deftemplate nota-de-debito-manual
  (slot archivo)
  (slot rut)
  (slot subcuenta)
  (slot neto )
  (slot iva)
  (slot total)
  (slot folio-credito)
  (slot folio-debito)
  (slot partida)
  (slot dia)
  (slot mes)
  (slot ano)
)


(deftemplate anulacion-de-vouchers
  (slot rut)
  (slot recibida (default false))
  (slot emitida (default false))
  (slot partida)
  (slot folio-nota)
  (slot subcuenta)
  (slot dia)
  (slot mes)
  (slot ano)
  (slot neto)
  (slot glosa)
  (slot iva)
  (slot total)
)




(deftemplate nota-de-credito-de-subcuenta-existente
  (slot referencia )
  (slot archivo)
  (slot rut)
  (slot proveedor)
  (slot recibida (default false))
  (slot emitida (default false))
  (slot partida)
  (slot folio-nota)
  (slot subcuenta)
  (slot dia)
  (slot mes)
  (slot ano)
  (slot neto)
  (slot glosa)
  (slot iva)
  (slot total)
)

(deftemplate nota-de-credito-de-factura-reclamada
  (slot cuenta-de-pago)
  (slot partida)
  (slot glosa)
  (slot folio-factura)
  (slot folio-nota)
  (slot dia)
  (slot mes)
  (slot ano)
)



(deftemplate nota-de-credito-de-proveedor
  (slot rut)
  (slot folio-nota)
  (slot folio)
  (slot partida)
  (slot dia)
  (slot mes)
  (slot ano)
)




(deftemplate nota-de-credito
  (slot rut)
  (slot colaborador)
  (slot material)
  (slot folio-nota)
  (slot folio)
  (slot iva)
  (slot neto)
  (slot total )
  (slot partida)
  (slot dia)
  (slot mes)
  (slot ano)
)

(deftemplate actual
  (slot mes)
)

( deftemplate imposiciones
  (slot rut)
  (slot dia )
  (slot mes )
  (slot ano )
  (slot mes-de-pago)
  (slot pagadas (default false))
)


( deftemplate deposito
  (slot rut)
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

(deftemplate ajuste-de-iva
   (slot partida)
   (slot haber (default 0))
   (slot debe (default 0))
   (slot dia )
   (slot mes )
   (slot ano)
   (slot hecho (default false) )
)


(deftemplate partida-inventario-final
   (slot dia)
   (slot mes)
   (slot ano)
   (slot partida)
   (slot hecho (default false))
   (slot saldo (default 0))
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
   ( slot debe_corregido (default 0))
   ( slot haber_corregido (default 0))
   ( slot haber (default 0))
   ( slot deber (default 0))
   ( slot deber_corregido (default 0))
   ( slot acreedor_corregido (default 0))
   ( slot acreedor (default 0))
   ( slot totalizado (default false))
   ( slot mostrado (default false))
)

(deftemplate mensuales
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


(deftemplate MAIN::pedido
   (slot id)
   (slot partida)
   (slot dia)
   (slot mes)
   (slot ano)
)

(deftemplate MAIN::inventario
   (slot empresa)
   (slot pedido)
   (slot referencia)
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

(deftemplate MAIN::accionario
   (slot empresa)
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

(deftemplate modificar-revision
   (slot partida-nueva)
   (slot partida-antigua)
)

(deftemplate modificar-partida
   (slot partida-nueva)
   (slot partida-antigua)
)


(deftemplate modificar-cargo
   (slot partida-nueva)
   (slot partida-antigua)
)

(deftemplate modificar-abono
   (slot partida-nueva)
   (slot partida-antigua)
)


(deftemplate modificar-actividad
   (slot hecho)
   (slot partida-nueva)
   (slot partida-antigua)
)

(deftemplate MAIN::partida
   (slot referencia)
   (slot hecho)
   (slot archivo)
   (slot proveedor)
   (slot old)
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

(deftemplate correccion-monetaria-anual
   (slot mes)
   (slot ano)
   (slot factor)
)

(deftemplate MAIN::cuenta 
   (slot factor-de-correccion-monetaria (default 1))
   (slot abono )
   (slot cargo )
   (slot saldo-deudor)
   (slot saldo-acreedor)
   (slot ajustado-iva (default false))
   (slot mostrar-en-comprobacion (default true))
   (slot tributada (default false))
   (slot tributada-en-aportes (default false))
   (slot tributada-en-deducciones (default false))
   (slot recibida (default false))
   (slot activo-fijo (default false))
   (slot tipo-de-documento)
   (slot qty (default 0))
   (slot electronico (default false))
   (slot codigo-sii  (default ""))
   (slot nombre-sii  (default ""))
   (slot nombre (default ""))
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
   (slot mostrada-en-kindle (default false))
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
   (slot descripcion (default ""))
   (slot verificada  (default false))
   (slot codigo      (default ""))
   (slot debe        (default 0))
   (slot haber       (default 0))
   (slot saldo       (default 0))
   (slot tipo        (default false))
   (slot grupo       (default false))
   (slot naturaleza  (default false))
   (slot deducible   (default false))
   (slot origen      (default false)))

(deftemplate MAIN::cargo
   (slot recibida (default false))
   (slot activo-fijo (default false))
   (slot qty (default 1))
   (slot tipo-de-documento)
   (slot electronico (default true))
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
   (slot recibida (default false))
   (slot activo-fijo (default false))
   (slot tipo-de-documento)
   (slot qty (default 1))
   (slot electronico (default true))
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
   (slot folio)
   (slot rut)
   (slot tipo-de-documento)
   (slot qty (default 1))
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
   (slot tipo-de-documento)
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
   (slot tipo-de-documento)
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
   (slot archivo)
   (slot folio)
   (slot rut)
   (slot tipo-de-documento)
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
   (slot tipo-de-documento)
   (slot electronico (default true))
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


(deftemplate MAIN::gasto-promocional
   (slot tipo-de-documento)
   (slot electronico (default true))
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
   (slot tipo-de-documento)
   (slot electronico (default true))
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

(deftemplate MAIN::gasto-proveedor
   (slot tipo-de-documento)
   (slot electronico (default true))
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
   (slot folio)
   (slot rut)
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
   (slot folio)
   (slot rut)
   (slot tipo-de-documento)
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
   (slot rut)
   (slot partida)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot impuesto)
   (slot finalidad)
   (slot departamento (default nil))
   (slot nombre)
   (slot servicio)
   (slot glosa (default nil))
   (slot efectivo (default 0)))


(deftemplate MAIN::honorario
   (slot rut)
   (slot partida)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot finalidad)
   (slot profesional)
   (slot servicio (default servicio))
   (slot glosa (default nil))
   (slot bruto (default 0)))


(deftemplate MAIN::compra-mercaderia
   (slot rut)
   (slot qty (default 1))
   (slot tipo-de-documento)
   (slot electronico (default true))
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
   (slot pedido)
   (slot archivo)
   (slot folio)
   (slot rut)
   (slot activo-fijo (default false))
   (slot descuento)
   (slot qty (default 1))
   (slot tipo-de-documento)
   (slot electronico (default true))
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



(deftemplate MAIN::insumos
   (slot archivo)
   (slot pedido)
   (slot folio)
   (slot rut)
   (slot activo-fijo (default false))
   (slot descuento)
   (slot qty (default 1))
   (slot tipo-de-documento)
   (slot electronico (default true))
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



(deftemplate MAIN::compra-de-materiales
   (slot pedido)
   (slot archivo)
   (slot folio)
   (slot rut)
   (slot activo-fijo (default false))
   (slot descuento)
   (slot qty (default 1))
   (slot tipo-de-documento)
   (slot electronico (default true))
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
   (slot archivo)
   (slot qty (default 1))
   (slot tipo-de-documento)
   (slot electronico (default true))
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
   (slot exento (default 0))
   (slot iva    (default 0))
   (slot neto   (default 0))
   (slot total  (default 0)))





(deftemplate MAIN::venta-anticipada
   (slot tipo-de-documento)
   (slot electronico (default true))
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
   (slot exento (default 0))
   (slot iva    (default 0))
   (slot neto   (default 0))
   (slot total  (default 0)))





(deftemplate MAIN::venta
   (slot tipo-de-documento)
   (slot electronico (default true))
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
   (slot exento (default 0))
   (slot iva    (default 0))
   (slot neto   (default 0))
   (slot total  (default 0))
   (slot glosa)
   (slot archivo )
)

(deftemplate MAIN::devolucion
   (slot rut)
   (slot tipo-de-documento)
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
   (slot rut)
   (slot tipo-de-documento)
   (slot partida)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot finalidad)
   (slot intangible (default nil))
   (slot material (default nil))
   (slot monto (default 0)))

(deftemplate MAIN::merma
   (slot rut)
   (slot partida)
   (slot dia)
   (slot mes)
   (slot ano)
   (slot finalidad)
   (slot material (default nil))
   (slot monto (default 0)))

(deftemplate MAIN::reparacion
   (slot rut)
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
   (slot efecto)
   (slot partida)
   (slot dia )
   (slot mes )
   (slot ano)
   (slot liquidadora)
   (slot cuenta)
   (slot cumplida (default false))
)


(deftemplate MAIN::tributacion
   (slot efecto)
   (slot tipo-de-saldo)
   (slot partida)
   (slot dia )
   (slot mes )
   (slot ano)
   (slot liquidadora)
   (slot cuenta)
   (slot cumplida (default false))
)


(deftemplate MAIN::provision
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
   (slot rut)
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
   (slot rut)
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
              
