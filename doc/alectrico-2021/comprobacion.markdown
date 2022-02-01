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
 


Solo se consideran las transacciones hasta el día 31	febrero.
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
<td><small>aumentos-de-capital-aportes</small></td> <td align='right'>0</td> <td align='right'>120000000</td> <td> | </td> <td align='right'> 0</td> <td align='right'>120000000</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>amortizacion</small></td> <td align='right'>2213838</td> <td align='right'>0</td> <td> | </td> <td align='right'> 2213838</td> <td align='right'>0</td> </tr>
<tr>
<td><small>amortizacion-intangibles</small></td> <td align='right'>2213838</td> <td align='right'>0</td> <td> | </td> <td align='right'> 2213838</td> <td align='right'>0</td>
</tr>
<tr>
<td><small>depreciacion</small></td> <td align='right'>103644</td> <td align='right'>0</td> <td> | </td> <td align='right'> 103644</td> <td align='right'>0</td>
</tr>
<tr>
<td>Depreciación Acumulada<small>depreciacion-acumulada-herramientas</small></td> <td align='right'>0</td> <td align='right'>187680</td> <td> | </td> <td align='right'> 0</td> <td align='right'>187680</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Remuneraciones por Pagar<small>salarios-por-pagar</small></td> <td align='right'>950000</td> <td align='right'>0</td> <td> | </td> <td align='right'> 950000</td> <td align='right'>0</td> </tr>
<tr>
<td><small>ventas</small></td> <td align='right'>1393913</td> <td align='right'>2595724</td> <td> | </td> <td align='right'> 0</td> <td align='right'>1201811</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>gastos-promocionales</small></td> <td align='right'>206576</td> <td align='right'>0</td> <td> | </td> <td align='right'> 206576</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>gastos-administrativos</small></td> <td align='right'>287176</td> <td align='right'>46953</td> <td> | </td> <td align='right'> 240223</td> <td align='right'>0</td> </tr>
<tr>
<td>Intangibles<small>intangibles</small> </td> <td align='right'>121427369</td> <td align='right'>52631</td> <td> | </td> <td align='right'> 121374738</td> <td align='right'>0</td> 
<td colspan='2' style=' background: #faa; border: 1px solid red;'>Subcuenta </td>
</tr>
<tr>
<td><small>ingresos-brutos</small></td> <td align='right'>1393913</td> <td align='right'>2596618</td> <td> | </td> <td align='right'> 0</td> <td align='right'>1202705</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>correccion-monetaria</small></td> <td align='right'>0</td> <td align='right'>894</td> <td> | </td> <td align='right'> 0</td> <td align='right'>894</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>cuentas-por-cobrar</small></td> <td align='right'>40000</td> <td align='right'>0</td> <td> | </td> <td align='right'> 40000</td> <td align='right'>0</td> </tr>
<tr>
<td>IVA Débitos<small>iva-debito</small></td> <td align='right'>240481</td> <td align='right'>382077</td> <td> | </td> <td align='right'> 0</td> <td align='right'>141596</td>
</tr>
<tr>
<td>Herramientas<small>herramientas</small></td> <td align='right'>436940</td> <td align='right'>0</td> <td> | </td> <td align='right'> 436940</td> <td align='right'>0</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Insumos<small>insumos</small></td> <td align='right'>922494</td> <td align='right'>44044</td> <td> | </td> <td align='right'> 878450</td> <td align='right'>0</td> </tr>
<tr>
<td>Caja<small>caja</small></td> <td align='right'>2031947</td> <td align='right'>1105170</td> <td> | </td> <td align='right'> 926777</td> <td align='right'>0</td>
</tr>
<tr>
<td>Banco Estado<small>banco-estado</small></td> <td align='right'>4957119</td> <td align='right'>4564203</td> <td> | </td> <td align='right'> 392916</td> <td align='right'>0</td>
</tr>
<tr>
<td>PPM (Pago Provisional Mensual)<small>ppm</small></td> <td align='right'>3702</td> <td align='right'>0</td> <td> | </td> <td align='right'> 3702</td> <td align='right'>0</td>
</tr>
<tr>
<td>IVA Créditos<small>iva-credito</small></td> <td align='right'>216153</td> <td align='right'>123930</td> <td> | </td> <td align='right'> 92223</td> <td align='right'>0</td>
</tr>
<tr>
<td>Amortización Acumulada<small>amortizacion-acumulada-intangibles</small></td> <td align='right'>0</td> <td align='right'>2247674</td> <td> | </td> <td align='right'> 0</td> <td align='right'>2247674</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>retencion-de-iva-articulo-11</small></td> <td align='right'>23608</td> <td align='right'>25108</td> <td> | </td> <td align='right'> 0</td> <td align='right'>1500</td> </tr>
<tr>
<td>Capital pagado<small>capital-social</small></td> <td align='right'>0</td> <td align='right'>4170588</td> <td> | </td> <td align='right'> 0</td> <td align='right'>4170588</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>utilidad-del-ejercicio-anterior</small></td> <td align='right'>85294</td> <td align='right'>128231</td> <td> | </td> <td align='right'> 0</td> <td align='right'>42937</td> </tr>
<tr>
<td><small>costos-de-ventas</small></td> <td align='right'>11417</td> <td align='right'>409</td> <td> | </td> <td align='right'> 11008</td> <td align='right'>0</td>
</tr>
</tbody>
<tfoot>
<tr> <td></td> <td align='right'> <div>263148105</div></td> <td align='right'> <div>141012589</div></td><td> | </td> <td align='right'> <div>252985656</div></td> <td align='right'> <div>130850140</div></td> </tr>
</tfoot>
</table>
