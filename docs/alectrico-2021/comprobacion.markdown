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
 


Solo se consideran las transacciones hasta el día 31	noviembre.
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
<td><small>cuentas-por-cobrar</small></td> <td align='right'>31203</td> <td align='right'>0</td> <td> | </td> <td align='right'> 31203</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>amortizacion</small></td> <td align='right'>26587</td> <td align='right'>0</td> <td> | </td> <td align='right'> 26587</td> <td align='right'>0</td> </tr>
<tr>
<td><small>amortizacion-intangibles</small></td> <td align='right'>26587</td> <td align='right'>0</td> <td> | </td> <td align='right'> 26587</td> <td align='right'>0</td>
</tr>
<tr>
<td><small>depreciacion</small></td> <td align='right'>74232</td> <td align='right'>0</td> <td> | </td> <td align='right'> 74232</td> <td align='right'>0</td>
</tr>
<tr>
<td>Depreciación Acumulada<small>depreciacion-acumulada-herramientas</small></td> <td align='right'>0</td> <td align='right'>74232</td> <td> | </td> <td align='right'> 0</td> <td align='right'>74232</td>
</tr>
<tr>
<td>Amortización Acumulada<small>amortizacion-acumulada-intangibles</small></td> <td align='right'>0</td> <td align='right'>29003</td> <td> | </td> <td align='right'> 0</td> <td align='right'>29003</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>correccion-monetaria</small></td> <td align='right'>0</td> <td align='right'>3025</td> <td> | </td> <td align='right'> 0</td> <td align='right'>3025</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>gastos-promocionales</small></td> <td align='right'>206576</td> <td align='right'>0</td> <td> | </td> <td align='right'> 206576</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Remuneraciones por Pagar<small>salarios-por-pagar</small></td> <td align='right'>1175340</td> <td align='right'>1750000</td> <td> | </td> <td align='right'> 0</td> <td align='right'>574660</td> </tr>
<tr>
<td><small>ventas</small></td> <td align='right'>0</td> <td align='right'>2366118</td> <td> | </td> <td align='right'> 0</td> <td align='right'>2366118</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>salarios</small></td> <td align='right'>1750000</td> <td align='right'>0</td> <td> | </td> <td align='right'> 1750000</td> <td align='right'>0</td> </tr>
<tr>
<td>Herramientas<small>herramientas</small></td> <td align='right'>218470</td> <td align='right'>0</td> <td> | </td> <td align='right'> 218470</td> <td align='right'>0</td>
</tr>
<tr>
<td><small>devolucion-sobre-ventas</small></td> <td align='right'>1241951</td> <td align='right'>0</td> <td> | </td> <td align='right'> 1241951</td> <td align='right'>0</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Insumos<small>insumos</small></td> <td align='right'>362503</td> <td align='right'>0</td> <td> | </td> <td align='right'> 362503</td> <td align='right'>0</td> </tr>
<tr>
<td>Intangibles<small>intangibles</small> </td> <td align='right'>290000</td> <td align='right'>52631</td> <td> | </td> <td align='right'> 237369</td> <td align='right'>0</td> 
<td colspan='2' style=' background: #faa; border: 1px solid red;'>Subcuenta </td>
</tr>
<tr>
<td><small>ingresos-brutos</small></td> <td align='right'>0</td> <td align='right'>2369143</td> <td> | </td> <td align='right'> 0</td> <td align='right'>2369143</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>gastos-administrativos</small></td> <td align='right'>273324</td> <td align='right'>71230</td> <td> | </td> <td align='right'> 202094</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>utilidad-del-ejercicio-anterior</small></td> <td align='right'>85294</td> <td align='right'>85294</td> <td> | </td> <td align='right'> 0</td> <td align='right'>0</td> </tr>
<tr>
<td>Capital pagado<small>capital-social</small></td> <td align='right'>0</td> <td align='right'>2085294</td> <td> | </td> <td align='right'> 0</td> <td align='right'>2085294</td>
</tr>
<tr>
<td>IVA Débitos<small>iva-debito</small></td> <td align='right'>295076</td> <td align='right'>353480</td> <td> | </td> <td align='right'> 0</td> <td align='right'>58404</td>
</tr>
<tr>
<td>Caja<small>caja</small></td> <td align='right'>1097841</td> <td align='right'>188686</td> <td> | </td> <td align='right'> 909155</td> <td align='right'>0</td>
</tr>
<tr>
<td>Banco Estado<small>banco-estado</small></td> <td align='right'>3457810</td> <td align='right'>3701432</td> <td> | </td> <td align='right'> 0</td> <td align='right'>243622</td>
</tr>
<tr>
<td>PPM (Pago Provisional Mensual)<small>ppm</small></td> <td align='right'>3688</td> <td align='right'>0</td> <td> | </td> <td align='right'> 3688</td> <td align='right'>0</td>
</tr>
<tr>
<td>IVA Créditos<small>iva-credito</small></td> <td align='right'>220852</td> <td align='right'>183475</td> <td> | </td> <td align='right'> 37377</td> <td align='right'>0</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>retencion-de-iva-articulo-11</small></td> <td align='right'>23608</td> <td align='right'>25108</td> <td> | </td> <td align='right'> 0</td> <td align='right'>1500</td> </tr>
<tr>
<td><small>costos-de-ventas</small></td> <td align='right'>11417</td> <td align='right'>409</td> <td> | </td> <td align='right'> 11008</td> <td align='right'>0</td>
</tr>
</tbody>
<tfoot>
<tr> <td></td> <td align='right'> <div>11772152</div></td> <td align='right'> <div>15760334</div></td><td> | </td> <td align='right'> <div>6185962</div></td> <td align='right'> <div>10174144</div></td> </tr>
</tfoot>
</table>
