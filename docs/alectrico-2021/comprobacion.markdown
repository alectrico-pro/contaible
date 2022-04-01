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
 


Solo se consideran las transacciones hasta el día 31	julio.
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
<td><small>salarios</small></td> <td align='right'>300000</td> <td align='right'>0</td> <td> | </td> <td align='right'> 300000</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>cuentas-por-cobrar</small></td> <td align='right'>31203</td> <td align='right'>0</td> <td> | </td> <td align='right'> 31203</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>reintegro-de-devolucion-sobre-ventas-afectas</small></td> <td align='right'>0</td> <td align='right'>29412</td> <td> | </td> <td align='right'> 0</td> <td align='right'>29412</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>reintegro-de-devolucion-sobre-ventas-exentas</small></td> <td align='right'>0</td> <td align='right'>4505</td> <td> | </td> <td align='right'> 0</td> <td align='right'>4505</td> </tr>
<tr>
<td>Intangibles<small>intangibles</small> </td> <td align='right'>290000</td> <td align='right'>0</td> <td> | </td> <td align='right'> 290000</td> <td align='right'>0</td> 
<td colspan='2' style=' background: #faa; border: 1px solid red;'>Subcuenta </td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>correccion-monetaria</small></td> <td align='right'>0</td> <td align='right'>1592</td> <td> | </td> <td align='right'> 0</td> <td align='right'>1592</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>amortizacion</small></td> <td align='right'>16919</td> <td align='right'>0</td> <td> | </td> <td align='right'> 16919</td> <td align='right'>0</td> </tr>
<tr>
<td><small>amortizacion-intangibles</small></td> <td align='right'>16919</td> <td align='right'>0</td> <td> | </td> <td align='right'> 16919</td> <td align='right'>0</td>
</tr>
<tr>
<td><small>depreciacion</small></td> <td align='right'>35016</td> <td align='right'>0</td> <td> | </td> <td align='right'> 35016</td> <td align='right'>0</td>
</tr>
<tr>
<td>Depreciación Acumulada<small>depreciacion-acumulada-herramientas</small></td> <td align='right'>0</td> <td align='right'>35016</td> <td> | </td> <td align='right'> 0</td> <td align='right'>35016</td>
</tr>
<tr>
<td>PPM (Pago Provisional Mensual)<small>ppm</small></td> <td align='right'>2082</td> <td align='right'>0</td> <td> | </td> <td align='right'> 2082</td> <td align='right'>0</td>
</tr>
<tr>
<td>Amortización Acumulada<small>amortizacion-acumulada-intangibles</small></td> <td align='right'>0</td> <td align='right'>19335</td> <td> | </td> <td align='right'> 0</td> <td align='right'>19335</td>
</tr>
<tr>
<td><small>ingresos-brutos</small></td> <td align='right'>0</td> <td align='right'>1083169</td> <td> | </td> <td align='right'> 0</td> <td align='right'>1083169</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>gastos-promocionales</small></td> <td align='right'>203635</td> <td align='right'>0</td> <td> | </td> <td align='right'> 203635</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Remuneraciones por Pagar<small>salarios-por-pagar</small></td> <td align='right'>0</td> <td align='right'>300000</td> <td> | </td> <td align='right'> 0</td> <td align='right'>300000</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>reintegro-de-devolucion-sobre-ventas</small></td> <td align='right'>0</td> <td align='right'>33917</td> <td> | </td> <td align='right'> 0</td> <td align='right'>33917</td> </tr>
<tr>
<td><small>devolucion-sobre-ventas</small></td> <td align='right'>819164</td> <td align='right'>0</td> <td> | </td> <td align='right'> 819164</td> <td align='right'>0</td>
</tr>
<tr>
<td><small>ventas</small></td> <td align='right'>0</td> <td align='right'>1081577</td> <td> | </td> <td align='right'> 0</td> <td align='right'>1081577</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>devolucion-sobre-gastos</small></td> <td align='right'>0</td> <td align='right'>505</td> <td> | </td> <td align='right'> 0</td> <td align='right'>505</td> </tr>
<tr>
<td>Herramientas<small>herramientas</small></td> <td align='right'>218470</td> <td align='right'>0</td> <td> | </td> <td align='right'> 218470</td> <td align='right'>0</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>devolucion-sobre-ventas-afectas</small></td> <td align='right'>769609</td> <td align='right'>0</td> <td> | </td> <td align='right'> 769609</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>devolucion-sobre-ventas-exentas</small></td> <td align='right'>49555</td> <td align='right'>0</td> <td> | </td> <td align='right'> 49555</td> <td align='right'>0</td> </tr>
<tr>
<td>IVA Débitos<small>iva-debito</small></td> <td align='right'>197787</td> <td align='right'>197787</td> <td> | </td> <td align='right'> 0</td> <td align='right'>0</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Insumos<small>insumos</small></td> <td align='right'>46178</td> <td align='right'>0</td> <td> | </td> <td align='right'> 46178</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>gastos-administrativos</small></td> <td align='right'>168903</td> <td align='right'>31203</td> <td> | </td> <td align='right'> 137700</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>utilidad-del-ejercicio-anterior</small></td> <td align='right'>85294</td> <td align='right'>85294</td> <td> | </td> <td align='right'> 0</td> <td align='right'>0</td> </tr>
<tr>
<td>Capital pagado<small>capital-social</small></td> <td align='right'>0</td> <td align='right'>2085294</td> <td> | </td> <td align='right'> 0</td> <td align='right'>2085294</td>
</tr>
<tr>
<td>Banco Estado<small>banco-estado</small></td> <td align='right'>2005709</td> <td align='right'>1685830</td> <td> | </td> <td align='right'> 319879</td> <td align='right'>0</td>
</tr>
<tr>
<td>Caja<small>caja</small></td> <td align='right'>1050209</td> <td align='right'>73607</td> <td> | </td> <td align='right'> 976602</td> <td align='right'>0</td>
</tr>
<tr>
<td>IVA Créditos<small>iva-credito</small></td> <td align='right'>127088</td> <td align='right'>75266</td> <td> | </td> <td align='right'> 51822</td> <td align='right'>0</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>retencion-de-iva-articulo-11</small></td> <td align='right'>23608</td> <td align='right'>23608</td> <td> | </td> <td align='right'> 0</td> <td align='right'>0</td> </tr>
<tr>
<td><small>costos-de-ventas</small></td> <td align='right'>10892</td> <td align='right'>0</td> <td> | </td> <td align='right'> 10892</td> <td align='right'>0</td>
</tr>
</tbody>
<tfoot>
<tr> <td></td> <td align='right'> <div>6999766</div></td> <td align='right'> <div>7930086</div></td><td> | </td> <td align='right'> <div>4827171</div></td> <td align='right'> <div>5757491</div></td> </tr>
</tfoot>
</table>
