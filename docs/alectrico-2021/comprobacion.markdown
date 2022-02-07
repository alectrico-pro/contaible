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
<td><small>correccion-monetaria</small></td> <td align='right'>0</td> <td align='right'>3626</td> <td> | </td> <td align='right'> 0</td> <td align='right'>3626</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Remuneraciones por Pagar<small>salarios-por-pagar</small></td> <td align='right'>1215040</td> <td align='right'>1750000</td> <td> | </td> <td align='right'> 0</td> <td align='right'>534960</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>gastos-promocionales</small></td> <td align='right'>206576</td> <td align='right'>0</td> <td> | </td> <td align='right'> 206576</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>gastos-administrativos</small></td> <td align='right'>278276</td> <td align='right'>40027</td> <td> | </td> <td align='right'> 238249</td> <td align='right'>0</td> </tr>
<tr>
<td><small>ventas</small></td> <td align='right'>1393913</td> <td align='right'>2338450</td> <td> | </td> <td align='right'> 0</td> <td align='right'>944537</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>salarios</small></td> <td align='right'>1750000</td> <td align='right'>0</td> <td> | </td> <td align='right'> 1750000</td> <td align='right'>0</td> </tr>
<tr>
<td>Herramientas<small>herramientas</small></td> <td align='right'>218470</td> <td align='right'>0</td> <td> | </td> <td align='right'> 218470</td> <td align='right'>0</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Insumos<small>insumos</small></td> <td align='right'>406547</td> <td align='right'>44044</td> <td> | </td> <td align='right'> 362503</td> <td align='right'>0</td> </tr>
<tr>
<td>Intangibles<small>intangibles</small> </td> <td align='right'>290000</td> <td align='right'>52631</td> <td> | </td> <td align='right'> 237369</td> <td align='right'>0</td> 
<td colspan='2' style=' background: #faa; border: 1px solid red;'>Subcuenta </td>
</tr>
<tr>
<td><small>ingresos-brutos</small></td> <td align='right'>1393913</td> <td align='right'>2342076</td> <td> | </td> <td align='right'> 0</td> <td align='right'>948163</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>utilidad-del-ejercicio-anterior</small></td> <td align='right'>85294</td> <td align='right'>85294</td> <td> | </td> <td align='right'> 0</td> <td align='right'>0</td> </tr>
<tr>
<td>Capital pagado<small>capital-social</small></td> <td align='right'>0</td> <td align='right'>2085294</td> <td> | </td> <td align='right'> 0</td> <td align='right'>2085294</td>
</tr>
<tr>
<td>IVA Débitos<small>iva-debito</small></td> <td align='right'>346685</td> <td align='right'>342687</td> <td> | </td> <td align='right'> 3998</td> <td align='right'>0</td>
</tr>
<tr>
<td>Caja<small>caja</small></td> <td align='right'>1097841</td> <td align='right'>193638</td> <td> | </td> <td align='right'> 904203</td> <td align='right'>0</td>
</tr>
<tr>
<td>Banco Estado<small>banco-estado</small></td> <td align='right'>3426144</td> <td align='right'>3920720</td> <td> | </td> <td align='right'> 0</td> <td align='right'>494576</td>
</tr>
<tr>
<td>PPM (Pago Provisional Mensual)<small>ppm</small></td> <td align='right'>2441</td> <td align='right'>0</td> <td> | </td> <td align='right'> 2441</td> <td align='right'>0</td>
</tr>
<tr>
<td>IVA Créditos<small>iva-credito</small></td> <td align='right'>215598</td> <td align='right'>206211</td> <td> | </td> <td align='right'> 9387</td> <td align='right'>0</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>retencion-de-iva-articulo-11</small></td> <td align='right'>23608</td> <td align='right'>26048</td> <td> | </td> <td align='right'> 0</td> <td align='right'>2440</td> </tr>
<tr>
<td><small>costos-de-ventas</small></td> <td align='right'>11417</td> <td align='right'>409</td> <td> | </td> <td align='right'> 11008</td> <td align='right'>0</td>
</tr>
</tbody>
<tfoot>
<tr> <td></td> <td align='right'> <div>15323188</div></td> <td align='right'> <div>16013577</div></td><td> | </td> <td align='right'> <div>5835163</div></td> <td align='right'> <div>6525552</div></td> </tr>
</tfoot>
</table>
