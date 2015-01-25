x = 'Norge'  # Se, jeg er en tekst-streng (String).
x = [1,2,3]  # Øh, jeg mener en Array.
x = 5        # Ups, nå er jeg en Fixnum.

# Tilordninger kan lenkes
a = b = c = d = 5

# Du trenger ikke ekstra variable for å bytte to verdier
x = 5
y = 3
x, y = y, x  # Nå er x = 3 og y = 5

# Denne er kjekk å ha når en metode vil returnere flere verdier
a,b,c = ['a','b','c']

# Ruby bruker prefiks for å angi variabel skop
$global_variabel   = 'alle kan se meg!'
lokal_variabel     = 'sånn som x, y, a, b, c etc.'
@instans_attributt = 'jeg tilhører det gjeldende objekt.'
@@klasse_attributt = 'jeg er felles for mange objekter.'
KONSTANT_VARIABEL  = 'en selvmotsigelse?'
