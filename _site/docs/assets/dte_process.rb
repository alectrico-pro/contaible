#!/usr/bin/ruby

require 'rubygems'
require 'nokogiri'

@doc = Nokogiri::XML::Document.parse(IO.read(ARGV[0]), nil, 'ISO-8859-1')
File.open("dte_process.log", "w") do |f|



	@doc.css('xmlns|Caratula').each do |node|
          f.write( node )
	end



#html = @doc.to_xhtml(:encoding => 'ISO-8859-1')


#puts html
end
