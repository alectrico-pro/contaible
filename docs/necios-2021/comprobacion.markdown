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
<thead> <th colspan='7'> necios-2021</th></thead>
<thead> <th> </th> <th align='center' colspan= '2'>SUMAS</th> <th>|</th> <th align='center' colspan='2'>SALDOS</th> <th rowspan='2' > Errores </th> </thead>
<thead> <th></th>  <th align='center'>DEBE</th> <th align='center'>HABER</th> <th>|</th> <th align='center'>DEBER</th> <th align='center'>ACREEDOR</th> <th>A Corregir </th> </thead>
<tbody>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>correccion-monetaria</small></td> <td align='right'>0</td> <td align='right'>331</td> <td> | </td> <td align='right'> 0</td> <td align='right'>331</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>amortizacion</small></td> <td align='right'>4834</td> <td align='right'>0</td> <td> | </td> <td align='right'> 4834</td> <td align='right'>0</td> </tr>
<tr>
<td><small>amortizacion-intangibles</small></td> <td align='right'>4834</td> <td align='right'>0</td> <td> | </td> <td align='right'> 4834</td> <td align='right'>0</td>
</tr>
<tr>
<td><small>depreciacion</small></td> <td align='right'>8404</td> <td align='right'>0</td> <td> | </td> <td align='right'> 8404</td> <td align='right'>0</td>
</tr>
<tr>
<td>Depreciación Acumulada<small>depreciacion-acumulada-herramientas</small></td> <td align='right'>0</td> <td align='right'>8404</td> <td> | </td> <td align='right'> 0</td> <td align='right'>8404</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Insumos<small>insumos</small></td> <td align='right'>44044</td> <td align='right'>0</td> <td> | </td> <td align='right'> 44044</td> <td align='right'>0</td> </tr>
<tr>
<td>PPM (Pago Provisional Mensual)<small>ppm</small></td> <td align='right'>920</td> <td align='right'>0</td> <td> | </td> <td align='right'> 920</td> <td align='right'>0</td>
</tr>
<tr>
<td>Herramientas<small>herramientas</small></td> <td align='right'>151252</td> <td align='right'>0</td> <td> | </td> <td align='right'> 151252</td> <td align='right'>0</td>
</tr>
<tr>
<td>Intangibles<small>intangibles</small> </td> <td align='right'>290000</td> <td align='right'>0</td> <td> | </td> <td align='right'> 290000</td> <td align='right'>0</td> 
<td colspan='2' style=' background: #faa; border: 1px solid red;'>Subcuenta </td>
</tr>
<tr>
<td>Amortización Acumulada<small>amortizacion-acumulada-intangibles</small></td> <td align='right'>0</td> <td align='right'>7250</td> <td> | </td> <td align='right'> 0</td> <td align='right'>7250</td>
</tr>
<tr>
<td>Capital pagado<small>capital-social</small></td> <td align='right'>0</td> <td align='right'>2000000</td> <td> | </td> <td align='right'> 0</td> <td align='right'>2000000</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>utilidad-del-ejercicio-anterior</small></td> <td align='right'>0</td> <td align='right'>85294</td> <td> | </td> <td align='right'> 0</td> <td align='right'>85294</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>gastos-administrativos</small></td> <td align='right'>3128</td> <td align='right'>0</td> <td> | </td> <td align='right'> 3128</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>gastos-promocionales</small></td> <td align='right'>20992</td> <td align='right'>0</td> <td> | </td> <td align='right'> 20992</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>devolucion-sobre-gastos</small></td> <td align='right'>0</td> <td align='right'>178</td> <td> | </td> <td align='right'> 0</td> <td align='right'>178</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>reintegro-de-devolucion-sobre-ventas-afectas</small></td> <td align='right'>0</td> <td align='right'>29412</td> <td> | </td> <td align='right'> 0</td> <td align='right'>29412</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>reintegro-de-devolucion-sobre-ventas-exentas</small></td> <td align='right'>0</td> <td align='right'>4505</td> <td> | </td> <td align='right'> 0</td> <td align='right'>4505</td> </tr>
<tr>
<td><small>ingresos-brutos</small></td> <td align='right'>0</td> <td align='right'>153324</td> <td> | </td> <td align='right'> 0</td> <td align='right'>153324</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>reintegro-de-devolucion-sobre-ventas</small></td> <td align='right'>0</td> <td align='right'>33917</td> <td> | </td> <td align='right'> 0</td> <td align='right'>33917</td> </tr>
<tr>
<td><small>devolucion-sobre-ventas</small></td> <td align='right'>108379</td> <td align='right'>0</td> <td> | </td> <td align='right'> 108379</td> <td align='right'>0</td>
</tr>
<tr>
<td><small>ventas</small></td> <td align='right'>0</td> <td align='right'>152993</td> <td> | </td> <td align='right'> 0</td> <td align='right'>152993</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>devolucion-sobre-ventas-afectas</small></td> <td align='right'>58824</td> <td align='right'>0</td> <td> | </td> <td align='right'> 58824</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>devolucion-sobre-ventas-exentas</small></td> <td align='right'>49555</td> <td align='right'>0</td> <td> | </td> <td align='right'> 49555</td> <td align='right'>0</td> </tr>
<tr>
<td>IVA Débitos<small>iva-debito</small></td> <td align='right'>34656</td> <td align='right'>34656</td> <td> | </td> <td align='right'> 0</td> <td align='right'>0</td>
</tr>
<tr>
<td>IVA Créditos<small>iva-credito</small></td> <td align='right'>59121</td> <td align='right'>23514</td> <td> | </td> <td align='right'> 35607</td> <td align='right'>0</td>
</tr>
<tr>
<td>Banco Estado<small>banco-estado</small></td> <td align='right'>913605</td> <td align='right'>415922</td> <td> | </td> <td align='right'> 497683</td> <td align='right'>0</td>
</tr>
<tr>
<td>Caja<small>caja</small></td> <td align='right'>1050209</td> <td align='right'>3722</td> <td> | </td> <td align='right'> 1046487</td> <td align='right'>0</td>
</tr>
<tr>
<td><small>costos-de-ventas</small></td> <td align='right'>4576</td> <td align='right'>0</td> <td> | </td> <td align='right'> 4576</td> <td align='right'>0</td>
</tr>
</tbody>
<tfoot>
<tr> <td></td> <td align='right'> <div>3285499</div></td> <td align='right'> <div>3106746</div></td><td> | </td> <td align='right'> <div>2807685</div></td> <td align='right'> <div>2628932</div></td> </tr>
</tfoot>
</table>
