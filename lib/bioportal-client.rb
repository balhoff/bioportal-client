require 'cgi'
require 'rexml/document'
require 'ontology'

class Hash
   
   def to_url_params
     elements = []
     keys.size.times do |i|
       elements << "#{CGI::escape(keys[i])}=#{CGI::escape(values[i])}"
     end
     elements.join('&')
   end
   
 end

module Bioportal
  
  SERVICE_URI = "http://rest.bioontology.org/bioportal/"
  
  class BioportalClient
    
    def initialize(client_identification_email)
      @email = client_identification_email
    end
    
    def list_ontologies
      url = SERVICE_URI + "ontologies?" + {"email" => @email}.to_url_params
      xml_doc = REXML::Document.new(Net::HTTP.get_response(URI.parse(url)).body)
      xml_doc.elements.collect("success/data/list/ontologyBean") { |ontology_bean| Ontology.new(ontology_bean) }
    end
    
  end
  
end