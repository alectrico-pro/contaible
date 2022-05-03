#!/usr/bin/ruby

require 'rubygems'
require 'nokogiri'

doc = Nokogiri::HTML::Document.parse(IO.read(ARGV[0]), nil, 'ISO-8859-1')

#doc = Nokogiri::HTML::Document.parse(IO.read(ARGV[0]), nil, 'UTF-8')


#encabezado = doc.css(Caratula)
#
#ncabezado do |node|
 #node.remove
#nd

#tml = doc.to_xhtml(encode
html = doc.to_xhtml(:encoding => 'ISO-8859-1')


puts html
