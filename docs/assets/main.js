const miTitulo = document.querySelector('h1');
const miDebe   = document.querySelectorAll('#Debe');
const miHaber  = document.querySelectorAll('#Haber');


miTitulo.textContent = '¡Hola mund!';
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

