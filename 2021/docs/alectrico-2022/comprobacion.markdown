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
 


Solo se consideran las transacciones hasta el día 31	enero.
Cifras en pesos.
NO se han practicado liquidaciones, por lo que SÍ se muestran cuentas nominales
<table rules='groups'>
<style> tfoot {  border: 3px solid black;  } </style> 
<thead><th colspan='7'> B A L A N C E  DE COMPROBACION DE SUMAS Y DE SALDOS </th> </thead>
<thead> <th colspan='7'> alectrico-2022</th></thead>
<thead> <th> </th> <th align='center' colspan= '2'>SUMAS</th> <th>|</th> <th align='center' colspan='2'>SALDOS</th> <th rowspan='2' > Errores </th> </thead>
<thead> <th></th>  <th align='center'>DEBE</th> <th align='center'>HABER</th> <th>|</th> <th align='center'>DEBER</th> <th align='center'>ACREEDOR</th> <th>A Corregir </th> </thead>
<tbody>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>amortizacion</small></td> <td align='right'>2417</td> <td align='right'>0</td> <td> | </td> <td align='right'> 2417</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>depreciacion</small></td> <td align='right'>9804</td> <td align='right'>0</td> <td> | </td> <td align='right'> 9804</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>amortizacion-intangibles</small></td> <td align='right'>2417</td> <td align='right'>0</td> <td> | </td> <td align='right'> 2417</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Capital pagado<small>capital-social</small></td> <td align='right'>0</td> <td align='right'>2085294</td> <td> | </td> <td align='right'> 0</td> <td align='right'>2085294</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>utilidades-acumuladas</small></td> <td align='right'>0</td> <td align='right'>633173</td> <td> | </td> <td align='right'> 0</td> <td align='right'>633173</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Remuneraciones por Pagar<small>salarios-por-pagar</small></td> <td align='right'>0</td> <td align='right'>627440</td> <td> | </td> <td align='right'> 0</td> <td align='right'>627440</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Banco Estado<small>banco-estado</small></td> <td align='right'>222625</td> <td align='right'>0</td> <td> | </td> <td align='right'> 222625</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>PPM (Pago Provisional Mensual)<small>ppm</small></td> <td align='right'>2728</td> <td align='right'>0</td> <td> | </td> <td align='right'> 2728</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Herramientas<small>herramientas</small></td> <td align='right'>218470</td> <td align='right'>0</td> <td> | </td> <td align='right'> 218470</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Intangibles<small>intangibles</small></td> <td align='right'>2881912</td> <td align='right'>0</td> <td> | </td> <td align='right'> 2881912</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>retencion-de-iva-articulo-11</small></td> <td align='right'>0</td> <td align='right'>2440</td> <td> | </td> <td align='right'> 0</td> <td align='right'>2440</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>cuentas-por-cobrar</small></td> <td align='right'>51203</td> <td align='right'>0</td> <td> | </td> <td align='right'> 51203</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Depreciación Acumulada<small>depreciacion-acumulada-herramientas</small></td> <td align='right'>0</td> <td align='right'>93840</td> <td> | </td> <td align='right'> 0</td> <td align='right'>93840</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Amortización Acumulada<small>amortizacion-acumulada-intangibles</small></td> <td align='right'>0</td> <td align='right'>33837</td> <td> | </td> <td align='right'> 0</td> <td align='right'>33837</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>IVA Débitos<small>iva-debito</small></td> <td align='right'>0</td> <td align='right'>35946</td> <td> | </td> <td align='right'> 0</td> <td align='right'>35946</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>gastos-administrativos</small></td> <td align='right'>11489</td> <td align='right'>0</td> <td> | </td> <td align='right'> 11489</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>IVA Créditos<small>iva-credito</small></td> <td align='right'>19033</td> <td align='right'>0</td> <td> | </td> <td align='right'> 19033</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Caja<small>caja</small></td> <td align='right'>105961</td> <td align='right'>13672</td> <td> | </td> <td align='right'> 92289</td> <td align='right'>0</td> </tr>
</tbody>
<tfoot>
<tr> <td></td> <td align='right'> <div>6421460</div></td> <td align='right'> <div>3525642</div></td><td> | </td> <td align='right'> <div>6407788</div></td> <td align='right'> <div>3511970</div></td> </tr>
</tfoot>
</table>
