#!/usr/bin/ruby

require 'rubygems'
require 'nokogiri'

@doc = Nokogiri::XML::Document.parse(IO.read(ARGV[0]), nil, 'ISO-8859-1')

@doc.css('xmlns|SetDTE').each do |node|
  node.remove
end

#aratula = @doc.xpath('//xmlns:SetDTE')

html = @doc.to_xhtml(:encoding => 'ISO-8859-1')


puts html
