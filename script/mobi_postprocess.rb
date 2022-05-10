#!/usr/bin/ruby

require 'rubygems'
require 'nokogiri'

#doc = Nokogiri::HTML::Document.parse(IO.read(ARGV[0]), nil, 'ISO-8859-1')
begin
 doc = Nokogiri::HTML::Document.parse(IO.read(ARGV[0]), nil, 'utf-8')
rescue
 doc = Nokogiri::HTML::Document.parse(IO.read(ARGV[0]), nil, 'ISO-8859-1')
end

# last row of actual text TABLES seems to contain a single TD with empty whitespace
doc.xpath("//table[count(tr)>1]/tr[count(td)=1]/td[.='']").remove

# last tablas de más de 2 líneas tendrás salto de página previo
#doc.xpath("//table[count(tr)>10]").each do |node|
#  attrs = node.get_atributes
#  node.set_attribute 'style', ' page-break-before: always'
#end

# empty table rows cause some tables to not render at all
doc.xpath("//tr[count(td)=0]").remove

# for some reason figures are wrapped in <div align="center"><table><tr><td>...</td></tr></table></div>
# and this prevents figures that are tables from rendering properly.
doc.xpath("//div[not(@class)]/table[count(tr)=1]/tr[count(td)=1]/td").each do |node|
  topdiv = node.parent.parent.parent
  node.children.each { |child| topdiv.add_previous_sibling(child) }
  topdiv.remove
end


# turn chapter anchors from this:  <h2 class='chapter_name|appendixHead'><i>1. <a name='xx'></a> Chapter Name</i></h2>
#                      into this:  <a name='xx'><h2><i>1. Chapter Name</i></h2></a>

# first wrap each <h2> in the <a>
doc.xpath("//h2/i/a").each do |node|
  anchor_name = node.get_attribute 'name'
  # reparent the <h2> by putting <a> around it
  h2 = node.parent.parent
  h2.swap("<a name=\"#{anchor_name}\">#{h2}</a>")
end

doc.xpath("//h2/i/a").each { |node| node.remove }

#oc.xpath("//h2").each { |node| node.remove} #elimnando los heasders

doc.xpath("//input").each { |node| node.remove} 

doc.xpath("//select").each { |node| node.remove} 

doc.xpath("//meta").each { |node| node.remove}

doc.xpath("//nav").each { |node| node.remove}

doc.xpath("//header[@class='site-header']").each { |node| node.remove}


# same thing for <h3> (section heads)
doc.xpath("//h3/a").each do |node|
  anchor_name = node.get_attribute 'name'
  # reparent the <h3>
  h3 = node.parent
  h3.swap("<a name=\"#{anchor_name}\">#{h3}</a>")
end
# then remove spurious <a></a> inside <h3>
doc.xpath("//h3/a").each { |node| node.remove }


#Agregado por mí, elminina el menún principal pues contiene hreferencias que no he podido
#satisfacer 
doc.xpath("//div[@class='trigger']").each do |node|
  node.remove
end

#Elimina el footer pues agrega espacio antes y después
doc.xpath("//footer").each do |node|
  node.remove
end





#href="/necios-2021/libro-diario#Partida-14333

# elimiinandno las referencias a partidas
#oc.xpath("//link[@href='/necios-2021/libro-diario#Partida-14333']").each do |node|
 #node.remove	
#nd

#La media screen debe aparecer en el epub
#Es una herencia de formatos mobi para diferentes devices del ambiente kindle
doc.xpath("//link[@href='/assets/main.css']").each do |node|
   node.set_attribute 'href', '../mobi.css'
   node.set_attribute 'type', 'text/css'
   node.set_attribute 'media', 'screen'
#  node.remove
end
#href="/assets/main.css">

#probando
#/libro-diario#Partida-" ?partida "
doc.xpath("//link[@href='/libro-diario#Partida-']").each do |node|
#   node.set_attribute 'href', '../mobi.css'
 #  node.set_attribute 'type', 'text/css'
 #  node.set_attribute 'media', 'screen'
    node.remove
end
#href="/assets/mai


# eliminar la referencia al feed 
doc.xpath("//link[@type='application/atom+xml']").each do |node|
  node.remove
end

#Eliminando el link de Contaible ®
doc.xpath("//div/a[@class='site-title']").each do |node|
  node.set_attribute 'href' , '#'
end


#eliminar e markup 
doc.xpath("//script[@type='application/ld+json']").each do |node|
  node.remove
end

# add line numbers to all inline code examples
doc.xpath("//pre[@class='code']").each do |node|
  # ugh - tex4ht puts stray </p> INSIDE <pre>, so nokogiri turns that
  # into <pre> <p> content </p> </pre> - we need to get rid of <p>
  if (inner_par = node.xpath('p'))
    node.inner_html = inner_par.inner_html
    inner_par.remove
  end
  lines = node.inner_text.gsub(/\A\s*\n/m, '').split("\n")
  node.content = "\n" + (1..lines.length).zip(lines).map { |n| sprintf("%2d%s", *n) }.join("\n") + "\n"
end

# generate html
html = doc.to_xhtml(:encoding => 'ISO-8859-1')


# tex4ht outputs an apparently-random-length string of underscores to
#  render \hrule in LaTeX, so if we see >8 of them, replace with <hr> tag
html.gsub!(/_______+/, '<hr>')

# anywhere that we have two <hr> in a row with only an anchor in between,  delete one <hr>
# BEFORE:  <hr><a name="x1-70022"></a><hr>
# AFTER:   <hr><a name="x1-70022"></a>
html.gsub!(/<hr(?: \/)?>\s*(<a[^<]+<\/a>)?\s*(<!--l.\s+\d+--><p>\s*<\/p>)?\s*<hr(?: \/)?>/, '<hr>\1')



# some TeX markup that mistakenly gets included in t4ht output:
# BEFORE: \protect \relax \special {t4ht=<tt>}self.title\relax \special {t4ht=</tt>} 
# AFTER:  <tt>self.title</tt>

html.gsub!(/(?:\\protect)?\s*\\relax\s*\\special\s*\{t4ht=([^}]+)\}/, ' \1 ')

# god only knows where the hell this comes from:
# BEFORE: \protect \unhbox \voidb@x {\unhbox \voidb@x \special {t4ht@95}x}
# AFTER: _
html.gsub!('\protect \unhbox \voidb@x {\unhbox \voidb@x \special {t4ht@95}x}', '_')

# 'nowrap' tag inserted by tex4ht makes tables unrenderable on kindle
html.gsub!(/\s+nowrap>/, '>')

# xml-to-html somehow mangles <mbp:pagebreak> to just <pagebreak>
html.gsub!('<pagebreak></pagebreak>', '<mbp:pagebreak/>')


# get rid of stupid and often incorrect codepoints
bad_codepoints = {
#  '8212' => '|',
}
bad_codepoints.each_pair do |k,v|
  html.gsub!(/&\##{k};/, v)
end

# insert <a name="start"> anchor at top of body
html.gsub!(/<body>/, '<body><a id="start" name="Inicio"/>')
html.gsub!(/<br \/>1/,'')
#html.gsub!(/<body>/, '<body><a name="start">')
#puts escribe en el archivo html. No muestra salida por pantalla.


html.gsub!(/\/\w*\W*\w*\/libro-diario/, './libro-diario.html')

html.gsub!(/alectrico-2021/, '')

#html.gsub!(/\/alectrico-2021\/libro-diario/, './libro-diario.html')


#html.gsub!(/libro-mayor/, '')



#href="/necios-2021/libro-diario#Partida-14333

puts html
