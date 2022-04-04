--- 
permalink: /alectrico-2021/bi 
layout: page
--- 

<ul>
<li><span style='background-color: red'>[    ]</span> mensaje de alerta. </li>
<li><span style='background-color: lavender'>[    ]</span> partida revisada y resultado bueno. </li>
<li><span style='background-color: lightyellow'>[    ]</span> cuenta mayor del activo </li>
<li><span style='background-color: azure'>[    ]</span> cuenta mayor del pasivo </li>
<li><span style='color: white; background-color: cornflowerblue'>[    ]</span> cuenta de patrimonio </li>
<li><span style='background-color: gold'>[    ]</span> ganancia </li>
<li><span style='color: white; background-color: black'>[    ]</span> pérdida </li>
<li><span style='background-color: blanchedalmond'>[    ]</span> subtotales de la transacción </li>
</ul>
<table>
<thead><tr> <th> Código</th><th> Valor</th><th> Saldo </th><th> Resultado</th><th> Cuenta</th></tr> </thead>  
<tr><td>-510</td><td>28873</td><td>904358</td><td>171828</td><td>'fail-d'</td><td>devolucion-sobre-ventas-afectas</td></tr>
<tr><td>510</td><td>142954</td><td>904358</td><td>171828</td><td>'fail-d'</td><td>devolucion-sobre-ventas-afectas</td></tr>
<table>
<thead> <tr> <th colspan='8' align='center'> Consolidación 2X Deudoras </th> </tr>
<tr> <th></th> <th> cuenta </th><th> debe </th> <th> haber </th><th colspan='3'>  iva </th> </tr> 
</thead>
<tr> <td> a): </td> <td>devolucion-sobre-ventas-afectas</td> <td align='right'> 904358 </td> <td align='right'> 0 </td> <td></td><td></td> <td align='right'> 171828 </td> </tr> 
<tr>  <td> F29 </td> <td> código </td> <td> </td> <td>  </td><td> valor <small> b): </small> </td> <td> ajuste por transacciones rechazadas <small> c): </small> </td> </tr> 
<tr> <td> </td> <td> 510 </td> <td></td><td></td> <td align='right'> 142954 </td> <td align='right'>28873</td></tr>
<thead>
<tr> <th> </th> <th></th> <th></th> <th></th><th></th> <th></th><th style='background-color:gold'> Meta </th> </tr> 
</thead> 
<tr> <td> b): <td></td><td></td> </td> <td> (=) </td> <td align='right'> 142954</td> </tr>
<tr> <td> c): </td> <td></td><td></td> <td> (+) </td> <td align='right'> 28873</td>  </tr>
<tr><td></td><td> </td><td></td> <td> (=) </td> <td align='right'> 171827</td><td></td><td> 171828</td> </tr>
<tr style='background-color:lightgreen'> <td> </td> <td></td><td></td><td> </td> <td></td><td></td> <td></td><td> PASA </td> </tr>

<tr><td>111</td><td>14001</td><td>73695</td><td>14002</td><td>'pass-a'</td><td>ventas-con-eboleta-afecta</td></tr>
<tr><td>759</td><td>69100</td><td>363692</td><td>69101</td><td>'pass-a'</td><td>ventas-con-voucher-afecto</td></tr>
<tr><td>142</td><td>573330</td><td>35000</td><td>6650</td><td>'fail-a'</td><td>ventas-con-eboleta-exenta</td></tr>
<tr><td>-142</td><td>-6666</td><td>35000</td><td>6650</td><td>'fail-a'</td><td>ventas-con-eboleta-exenta</td></tr>
<table>
<thead> 
<tr><th align='center' colspan=7> Consolidación 3X --- Acreedora </th></tr> 
<tr><th> caso </th> <th> cuenta </th><th style='background-color:gold'> Meta </th><th> </th> <th> debe </th> <th> haber </th> </tr> 
<tr> <td> a):  </td> <td> ventas-con-eboleta-exenta</td><td></td><td> </td><td align='right' > 0</td> <td align='right'>  35000</td> </tr> 
<tr><td> b): </td><td> ventas-con-factura-exenta </td> <td> </td><td></td><td align='right'> 0</td> <td align='right'> 544996 </td> </tr>
<tr><td> c): </td> <td> 142 </td><td> 573330 </td> <td> </td><td align='right' > 6666 </td><td> </td> </tr> 
<tr><td></td><td></td><td></td><td> a </td><td> (=) </td><td align='right'>  35000 </td></tr>
<tr><td></td><td></td><td></td><td> b </td><td> (+) </td><td align='right'>  544996 </td></tr>
<tr><td></td><td></td><td></td><td>  </td><td>  (=) </td><td align='right'> 579996 </td></tr>
<tr><td></td><td></td><td></td><td>   c </td><td> (-) </td> <td align='right'> -6666</td> </tr>
<tr><td></td><td></td><td> 573330</td><td> </td><td>  (=) </td><td align='right'> 573330 </td></tr> 
<tr style='background-color:lightgreen' ><td> </td><td></td><td></td><td></td><td></td><td>   PASA OK </td><td></td></tr> 
</thead>
<tr><td>502</td><td>304172</td><td>1600907</td><td>304172</td><td>'pass-a'</td><td>ventas-con-factura-afecta</td></tr>
<tr><td>513</td><td>5588</td><td>29412</td><td>5588</td><td>'pass-a'</td><td>reintegro-de-devolucion-sobre-ventas-afectas</td></tr>
</table>
