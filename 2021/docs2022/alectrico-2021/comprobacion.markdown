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
<thead> <th colspan='7'> alectrico-2021</th></thead>
<thead> <th> </th> <th align='center' colspan= '2'>SUMAS</th> <th>|</th> <th align='center' colspan='2'>SALDOS</th> <th rowspan='2' > Errores </th> </thead>
<thead> <th></th>  <th align='center'>DEBE</th> <th align='center'>HABER</th> <th>|</th> <th align='center'>DEBER</th> <th align='center'>ACREEDOR</th> <th>A Corregir </th> </thead>
<tbody>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>correccion-monetaria</small></td> <td align='right'>0</td> <td align='right'>780</td> <td> | </td> <td align='right'> 0</td> <td align='right'>780</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>amortizacion</small></td> <td align='right'>121421</td> <td align='right'>0</td> <td> | </td> <td align='right'> 121421</td> <td align='right'>0</td> </tr>
<tr>
<td><small>amortizacion-intangibles</small></td> <td align='right'>121421</td> <td align='right'>0</td> <td> | </td> <td align='right'> 121421</td> <td align='right'>0</td>
</tr>
<tr>
<td><small>depreciacion</small></td> <td align='right'>93840</td> <td align='right'>0</td> <td> | </td> <td align='right'> 93840</td> <td align='right'>0</td>
</tr>
<tr>
<td>Depreciación Acumulada<small>depreciacion-acumulada-herramientas</small></td> <td align='right'>0</td> <td align='right'>93840</td> <td> | </td> <td align='right'> 0</td> <td align='right'>93840</td>
</tr>
<tr>
<td>Amortización Acumulada<small>amortizacion-acumulada-intangibles</small></td> <td align='right'>0</td> <td align='right'>123837</td> <td> | </td> <td align='right'> 0</td> <td align='right'>123837</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Remuneraciones por Pagar<small>salarios-por-pagar</small></td> <td align='right'>1522560</td> <td align='right'>2150000</td> <td> | </td> <td align='right'> 0</td> <td align='right'>627440</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>gastos-promocionales</small></td> <td align='right'>206576</td> <td align='right'>0</td> <td> | </td> <td align='right'> 206576</td> <td align='right'>0</td> </tr>
<tr>
<td><small>ventas</small></td> <td align='right'>1393913</td> <td align='right'>2568056</td> <td> | </td> <td align='right'> 0</td> <td align='right'>1174143</td>
</tr>
<tr>
<td>Intangibles<small>intangibles</small> </td> <td align='right'>2934543</td> <td align='right'>52631</td> <td> | </td> <td align='right'> 2881912</td> <td align='right'>0</td> 
<td colspan='2' style=' background: #faa; border: 1px solid red;'>Subcuenta </td>
</tr>
<tr>
<td><small>ingresos-brutos</small></td> <td align='right'>1393913</td> <td align='right'>2568836</td> <td> | </td> <td align='right'> 0</td> <td align='right'>1174923</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>gastos-administrativos</small></td> <td align='right'>296691</td> <td align='right'>71230</td> <td> | </td> <td align='right'> 225461</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>salarios</small></td> <td align='right'>2150000</td> <td align='right'>2150000</td> <td> | </td> <td align='right'> 0</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>utilidad-del-ejercicio-anterior</small></td> <td align='right'>85294</td> <td align='right'>85294</td> <td> | </td> <td align='right'> 0</td> <td align='right'>0</td> </tr>
<tr>
<td>Capital pagado<small>capital-social</small></td> <td align='right'>0</td> <td align='right'>2085294</td> <td> | </td> <td align='right'> 0</td> <td align='right'>2085294</td>
</tr>
<tr>
<td>IVA Débitos<small>iva-debito</small></td> <td align='right'>240449</td> <td align='right'>378079</td> <td> | </td> <td align='right'> 0</td> <td align='right'>137630</td>
</tr>
<tr>
<td>Caja<small>caja</small></td> <td align='right'>1107841</td> <td align='right'>1115552</td> <td> | </td> <td align='right'> 0</td> <td align='right'>7711</td>
</tr>
<tr>
<td>Banco Estado<small>banco-estado</small></td> <td align='right'>4561142</td> <td align='right'>4236757</td> <td> | </td> <td align='right'> 324385</td> <td align='right'>0</td>
</tr>
<tr>
<td><small>materiales</small></td> <td align='right'>167689</td> <td align='right'>167689</td> <td> | </td> <td align='right'> 0</td> <td align='right'>0</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Insumos<small>insumos</small></td> <td align='right'>414942</td> <td align='right'>538587</td> <td> | </td> <td align='right'> 0</td> <td align='right'>123645</td> </tr>
<tr>
<td>PPM (Pago Provisional Mensual)<small>ppm</small></td> <td align='right'>968</td> <td align='right'>0</td> <td> | </td> <td align='right'> 968</td> <td align='right'>0</td>
</tr>
<tr>
<td>IVA Créditos<small>iva-credito</small></td> <td align='right'>217846</td> <td align='right'>99975</td> <td> | </td> <td align='right'> 117871</td> <td align='right'>0</td>
</tr>
<tr>
<td>Herramientas<small>herramientas</small></td> <td align='right'>218470</td> <td align='right'>0</td> <td> | </td> <td align='right'> 218470</td> <td align='right'>0</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>retencion-de-iva-articulo-11</small></td> <td align='right'>23608</td> <td align='right'>26048</td> <td> | </td> <td align='right'> 0</td> <td align='right'>2440</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>cuentas-por-cobrar</small></td> <td align='right'>51203</td> <td align='right'>0</td> <td> | </td> <td align='right'> 51203</td> <td align='right'>0</td> </tr>
<tr>
<td><small>costos-de-ventas</small></td> <td align='right'>11417</td> <td align='right'>409</td> <td> | </td> <td align='right'> 11008</td> <td align='right'>0</td>
</tr>
</tbody>
<tfoot>
<tr> <td></td> <td align='right'> <div>22673430</div></td> <td align='right'> <div>21174797</div></td><td> | </td> <td align='right'> <div>8685797</div></td> <td align='right'> <div>7187164</div></td> </tr>
</tfoot>
</table>
