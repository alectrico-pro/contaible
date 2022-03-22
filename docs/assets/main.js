const miTitulo = document.querySelector('h1');
var highlightedItems = document.querySelectorAll('td, #Debe');

highlightedItems.forEach(function(userItem) {
  userItem.textContent = "hu";
});


miTitulo.textContent = 'alectrico SpA. Ejercicio 2021.';
// Create our number formatter.
var formatter = new Intl.NumberFormat('el-ES', {
  style: 'currency',
  currency: 'CLP',

  // These options are needed to round to whole numbers if that's what you want.
  //minimumFractionDigits: 0, // (this suffices for whole numbers, but will print 2500.10 as $2,500.1)
  //maximumFractionDigits: 0, // (causes 2500.99 to be printed as $2,501)
});

//miTitulo.textContent = formatter.format(500);
//miDebe.textContent = formatter.format(2500);
//miHaber.textContent = formatter.format(1500);

