--- 
layout: page
--- 
<script>

$('* div').each(function () {   
    var item = $(this).text();
    var num = Number(item).toLocaleString('en');

    if (Number(item) < 0) {
        num = num.replace('-', '');
        $(this).addClass('negMoney');
    } else {
        $(this).addClass('enMoney');
    }

    $(this).text(num);
});
</script>
 


Solo se consideran las transacciones hasta el día 31	diciembre.
Cifras en pesos.
NO se han practicado liquidaciones, por lo que SÍ se muestran cuentas nominales
<table rules='groups'>
<style> tfoot {  border: 3px solid black;  } </style> 
<thead><th colspan='7'> B A L A N C E  DE COMPROBACION DE SUMAS Y DE SALDOS </th> </thead>
<thead> <th colspan='7'> alectrico-2021</th></thead>
<thead> <th> </th> <th align='center' colspan= '2'>SUMAS</th> <th>|</th> <th align='center' colspan='2'>SALDOS</th> <th rowspan='2' > Errores </th> </thead>
<thead> <th></th>  <th align='center'>DEBE</th> <th align='center'>HABER</th> <th>|</th> <th align='center'>DEBER</th> <th align='center'>ACREEDOR</th> <th>A Corregir </th> </thead>
<tbody>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>amortizacion</small></td> <td align='right'>29004</td> <td align='right'>0</td> <td> | </td> <td align='right'> 29004</td> <td align='right'>0</td> </tr>
<tr>
<td><small>amortizacion-intangibles</small></td> <td align='right'>29004</td> <td align='right'>0</td> <td> | </td> <td align='right'> 29004</td> <td align='right'>0</td>
</tr>
<tr>
<td><small>depreciacion</small></td> <td align='right'>84036</td> <td align='right'>0</td> <td> | </td> <td align='right'> 84036</td> <td align='right'>0</td>
</tr>
<tr>
<td>Depreciación Acumulada<small>depreciacion-acumulada-herramientas</small></td> <td align='right'>0</td> <td align='right'>84036</td> <td> | </td> <td align='right'> 0</td> <td align='right'>84036</td>
</tr>
<tr>
<td>Amortización Acumulada<small>amortizacion-acumulada-intangibles</small></td> <td align='right'>0</td> <td align='right'>31420</td> <td> | </td> <td align='right'> 0</td> <td align='right'>31420</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>correccion-monetaria</small></td> <td align='right'>0</td> <td align='right'>3025</td> <td> | </td> <td align='right'> 0</td> <td align='right'>3025</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>gastos-promocionales</small></td> <td align='right'>206576</td> <td align='right'>0</td> <td> | </td> <td align='right'> 206576</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Remuneraciones por Pagar<small>salarios-por-pagar</small></td> <td align='right'>1482860</td> <td align='right'>2150000</td> <td> | </td> <td align='right'> 0</td> <td align='right'>667140</td> </tr>
<tr>
<td><small>ventas</small></td> <td align='right'>0</td> <td align='right'>2595724</td> <td> | </td> <td align='right'> 0</td> <td align='right'>2595724</td>
</tr>
<tr>
<td>Herramientas<small>herramientas</small></td> <td align='right'>218470</td> <td align='right'>0</td> <td> | </td> <td align='right'> 218470</td> <td align='right'>0</td>
</tr>
<tr>
<td><small>devolucion-sobre-ventas</small></td> <td align='right'>1241951</td> <td align='right'>0</td> <td> | </td> <td align='right'> 1241951</td> <td align='right'>0</td>
</tr>
<tr>
<td>Intangibles<small>intangibles</small> </td> <td align='right'>2440000</td> <td align='right'>52631</td> <td> | </td> <td align='right'> 2387369</td> <td align='right'>0</td> 
<td colspan='2' style=' background: #faa; border: 1px solid red;'>Subcuenta </td>
</tr>
<tr>
<td><small>ingresos-brutos</small></td> <td align='right'>0</td> <td align='right'>2598749</td> <td> | </td> <td align='right'> 0</td> <td align='right'>2598749</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>cuentas-por-cobrar</small></td> <td align='right'>51203</td> <td align='right'>0</td> <td> | </td> <td align='right'> 51203</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>gastos-administrativos</small></td> <td align='right'>280250</td> <td align='right'>71230</td> <td> | </td> <td align='right'> 209020</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>salarios</small></td> <td align='right'>2150000</td> <td align='right'>2150000</td> <td> | </td> <td align='right'> 0</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>utilidad-del-ejercicio-anterior</small></td> <td align='right'>85294</td> <td align='right'>85294</td> <td> | </td> <td align='right'> 0</td> <td align='right'>0</td> </tr>
<tr>
<td>Capital pagado<small>capital-social</small></td> <td align='right'>0</td> <td align='right'>2085294</td> <td> | </td> <td align='right'> 0</td> <td align='right'>2085294</td>
</tr>
<tr>
<td>IVA Débitos<small>iva-debito</small></td> <td align='right'>295076</td> <td align='right'>417107</td> <td> | </td> <td align='right'> 0</td> <td align='right'>122031</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Insumos<small>insumos</small></td> <td align='right'>370898</td> <td align='right'>530147</td> <td> | </td> <td align='right'> 0</td> <td align='right'>159249</td> </tr>
<tr>
<td>Caja<small>caja</small></td> <td align='right'>1107841</td> <td align='right'>996928</td> <td> | </td> <td align='right'> 110913</td> <td align='right'>0</td>
</tr>
<tr>
<td>Banco Estado<small>banco-estado</small></td> <td align='right'>4492808</td> <td align='right'>4019229</td> <td> | </td> <td align='right'> 473579</td> <td align='right'>0</td>
</tr>
<tr>
<td>PPM (Pago Provisional Mensual)<small>ppm</small></td> <td align='right'>3975</td> <td align='right'>0</td> <td> | </td> <td align='right'> 3975</td> <td align='right'>0</td>
</tr>
<tr>
<td>IVA Créditos<small>iva-credito</small></td> <td align='right'>251998</td> <td align='right'>183475</td> <td> | </td> <td align='right'> 68523</td> <td align='right'>0</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>retencion-de-iva-articulo-11</small></td> <td align='right'>23608</td> <td align='right'>25108</td> <td> | </td> <td align='right'> 0</td> <td align='right'>1500</td> </tr>
<tr>
<td><small>costos-de-ventas</small></td> <td align='right'>541564</td> <td align='right'>409</td> <td> | </td> <td align='right'> 541155</td> <td align='right'>0</td>
</tr>
</tbody>
<tfoot>
<tr> <td></td> <td align='right'> <div>18444604</div></td> <td align='right'> <div>20731186</div></td><td> | </td> <td align='right'> <div>8660335</div></td> <td align='right'> <div>10946917</div></td> </tr>
</tfoot>
</table>
