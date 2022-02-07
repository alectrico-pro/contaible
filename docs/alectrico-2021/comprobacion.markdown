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
 


Solo se consideran las transacciones hasta el día 31	mayo.
Cifras en pesos.
NO se han practicado liquidaciones, por lo que SÍ se muestran cuentas nominales
<table rules='groups'>
<style> tfoot {  border: 3px solid black;  } </style> 
<thead><th colspan='7'> B A L A N C E  DE COMPROBACION DE SUMAS Y DE SALDOS </th> </thead>
<thead> <th colspan='7'> alectrico-2021</th></thead>
<thead> <th> </th> <th align='center' colspan= '2'>SUMAS</th> <th>|</th> <th align='center' colspan='2'>SALDOS</th> <th rowspan='2' > Errores </th> </thead>
<thead> <th></th>  <th align='center'>DEBE</th> <th align='center'>HABER</th> <th>|</th> <th align='center'>DEBER</th> <th align='center'>ACREEDOR</th> <th>A Corregir </th> </thead>
<tbody>
<tr>
<td>Herramientas<small>herramientas</small></td> <td align='right'>151252</td> <td align='right'>0</td> <td> | </td> <td align='right'> 151252</td> <td align='right'>0</td>
</tr>
<tr>
<td>Capital pagado<small>capital-social</small></td> <td align='right'>0</td> <td align='right'>2000000</td> <td> | </td> <td align='right'> 0</td> <td align='right'>2000000</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>utilidad-del-ejercicio-anterior</small></td> <td align='right'>0</td> <td align='right'>85294</td> <td> | </td> <td align='right'> 0</td> <td align='right'>85294</td> </tr>
<tr>
<td>Intangibles<small>intangibles</small> </td> <td align='right'>290000</td> <td align='right'>0</td> <td> | </td> <td align='right'> 290000</td> <td align='right'>0</td> 
<td colspan='2' style=' background: #faa; border: 1px solid red;'>Subcuenta </td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>correccion-monetaria</small></td> <td align='right'>0</td> <td align='right'>1159</td> <td> | </td> <td align='right'> 0</td> <td align='right'>1159</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>amortizacion</small></td> <td align='right'>12085</td> <td align='right'>0</td> <td> | </td> <td align='right'> 12085</td> <td align='right'>0</td> </tr>
<tr>
<td><small>amortizacion-intangibles</small></td> <td align='right'>12085</td> <td align='right'>0</td> <td> | </td> <td align='right'> 12085</td> <td align='right'>0</td>
</tr>
<tr>
<td><small>depreciacion</small></td> <td align='right'>21010</td> <td align='right'>0</td> <td> | </td> <td align='right'> 21010</td> <td align='right'>0</td>
</tr>
<tr>
<td>Depreciación Acumulada<small>depreciacion-acumulada-herramientas</small></td> <td align='right'>0</td> <td align='right'>21010</td> <td> | </td> <td align='right'> 0</td> <td align='right'>21010</td>
</tr>
<tr>
<td>PPM (Pago Provisional Mensual)<small>ppm</small></td> <td align='right'>893</td> <td align='right'>0</td> <td> | </td> <td align='right'> 893</td> <td align='right'>0</td>
</tr>
<tr>
<td>Amortización Acumulada<small>amortizacion-acumulada-intangibles</small></td> <td align='right'>0</td> <td align='right'>14501</td> <td> | </td> <td align='right'> 0</td> <td align='right'>14501</td>
</tr>
<tr>
<td><small>ingresos-brutos</small></td> <td align='right'>108379</td> <td align='right'>243018</td> <td> | </td> <td align='right'> 0</td> <td align='right'>134639</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>gastos-promocionales</small></td> <td align='right'>23933</td> <td align='right'>0</td> <td> | </td> <td align='right'> 23933</td> <td align='right'>0</td> </tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>gastos-administrativos</small></td> <td align='right'>48847</td> <td align='right'>0</td> <td> | </td> <td align='right'> 48847</td> <td align='right'>0</td> </tr>
<tr>
<td><small>ventas</small></td> <td align='right'>108379</td> <td align='right'>241859</td> <td> | </td> <td align='right'> 0</td> <td align='right'>133480</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td><small>retencion-de-iva-articulo-11</small></td> <td align='right'>0</td> <td align='right'>1500</td> <td> | </td> <td align='right'> 0</td> <td align='right'>1500</td> </tr>
<tr>
<td>IVA Débitos<small>iva-debito</small></td> <td align='right'>45034</td> <td align='right'>45034</td> <td> | </td> <td align='right'> 0</td> <td align='right'>0</td>
</tr>
<tr style=' background: #fff; border: 1px solid red;'>
<td>Insumos<small>insumos</small></td> <td align='right'>90222</td> <td align='right'>44044</td> <td> | </td> <td align='right'> 46178</td> <td align='right'>0</td> </tr>
<tr>
<td>IVA Créditos<small>iva-credito</small></td> <td align='right'>74863</td> <td align='right'>33954</td> <td> | </td> <td align='right'> 40909</td> <td align='right'>0</td>
</tr>
<tr>
<td>Banco Estado<small>banco-estado</small></td> <td align='right'>978994</td> <td align='right'>454336</td> <td> | </td> <td align='right'> 524658</td> <td align='right'>0</td>
</tr>
<tr>
<td>Caja<small>caja</small></td> <td align='right'>1050209</td> <td align='right'>57187</td> <td> | </td> <td align='right'> 993022</td> <td align='right'>0</td>
</tr>
<tr>
<td><small>costos-de-ventas</small></td> <td align='right'>6661</td> <td align='right'>178</td> <td> | </td> <td align='right'> 6483</td> <td align='right'>0</td>
</tr>
</tbody>
<tfoot>
<tr> <td></td> <td align='right'> <div>3786236</div></td> <td align='right'> <div>3530314</div></td><td> | </td> <td align='right'> <div>2827194</div></td> <td align='right'> <div>2571272</div></td> </tr>
</tfoot>
</table>
