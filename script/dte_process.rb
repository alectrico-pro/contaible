#!/usr/bin/ruby

require 'rubygems'
require 'nokogiri'

doc = Nokogiri::HTML::Document.parse(IO.read(ARGV[0]), nil, 'ISO-8859-1')
html = doc.to_xhtml(:encoding => 'ISO-8859-1')
puts html
