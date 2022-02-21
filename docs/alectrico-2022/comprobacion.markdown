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
<td><small>salarios</small></td> <td align='right'>400000</td> <td align='right'>0</td> <td> | </td> <td align='right'> 400000</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Banco Estado<small>banco-estado</small></td> <td align='right'>274735</td> <td align='right'>0</td> <td> | </td> <td align='right'> 274735</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>PPM (Pago Provisional Mensual)<small>ppm</small></td> <td align='right'>2728</td> <td align='right'>0</td> <td> | </td> <td align='right'> 2728</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Herramientas<small>herramientas</small></td> <td align='right'>232234</td> <td align='right'>0</td> <td> | </td> <td align='right'> 232234</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Intangibles<small>intangibles</small></td> <td align='right'>2402323</td> <td align='right'>0</td> <td> | </td> <td align='right'> 2402323</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>gonzalo-por-cobrar</small></td> <td align='right'>20000</td> <td align='right'>0</td> <td> | </td> <td align='right'> 20000</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>tgr-por-cobrar</small></td> <td align='right'>31203</td> <td align='right'>0</td> <td> | </td> <td align='right'> 31203</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>marca-alectrico</small></td> <td align='right'>252323</td> <td align='right'>0</td> <td> | </td> <td align='right'> 252323</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>plataforma-alectrico</small></td> <td align='right'>2150000</td> <td align='right'>0</td> <td> | </td> <td align='right'> 2150000</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Depreciación Acumulada<small>depreciacion-acumulada-herramientas</small></td> <td align='right'>0</td> <td align='right'>88546</td> <td> | </td> <td align='right'> 0</td> <td align='right'>88546</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Amortización Acumulada<small>amortizacion-acumulada-intangibles</small></td> <td align='right'>0</td> <td align='right'>31858</td> <td> | </td> <td align='right'> 0</td> <td align='right'>31858</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>gastos-administrativos</small></td> <td align='right'>15287</td> <td align='right'>0</td> <td> | </td> <td align='right'> 15287</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Remuneraciones por Pagar<small>salarios-por-pagar</small></td> <td align='right'>0</td> <td align='right'>1067140</td> <td> | </td> <td align='right'> 0</td> <td align='right'>1067140</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>utilidad</small></td> <td align='right'>33109</td> <td align='right'>33109</td> <td> | </td> <td align='right'> 0</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>revalorizacion-del-capital-propio</small></td> <td align='right'>185989</td> <td align='right'>185989</td> <td> | </td> <td align='right'> 0</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Capital pagado<small>capital-social</small></td> <td align='right'>0</td> <td align='right'>2304392</td> <td> | </td> <td align='right'> 0</td> <td align='right'>2304392</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>IVA Créditos<small>iva-credito</small></td> <td align='right'>4709</td> <td align='right'>0</td> <td> | </td> <td align='right'> 4709</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Caja<small>caja</small></td> <td align='right'>114688</td> <td align='right'>18192</td> <td> | </td> <td align='right'> 96496</td> <td align='right'>0</td> </tr>
</tbody>
<tfoot>
<tr> <td></td> <td align='right'> <div>6133966</div></td> <td align='right'> <div>3729226</div></td><td> | </td> <td align='right'> <div>5896676</div></td> <td align='right'> <div>3491936</div></td> </tr>
</tfoot>
</table>
