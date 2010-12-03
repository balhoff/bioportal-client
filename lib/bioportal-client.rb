require 'cgi'
require 'rexml/document'
require 'ontology'
require 'term'

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
      xml_doc.elements.collect("success/data/list/ontologyBean") {|ontology_bean| Ontology.new(ontology_bean) }
    end
    
    def search(search_text, ontologies=[])
      params = {"email" => @email, "query" => search_text}
      params["ontologyids"] = (ontologies.collect{|ontology| ontology.id}).join(",") if !ontologies.empty?
      url = SERVICE_URI + "search?" + params.to_url_params
      xml_doc = REXML::Document.new(Net::HTTP.get_response(URI.parse(url)).body)
      xml_doc.elements.collect("success/data/page/contents/searchResultList/searchBean") {|search_bean| Term.new(search_bean) }
    end
    
    def get_rich_term(term)
      params = {"email" => @email, "light" => "0", "norelations" => "0"}
      params["conceptid"] = term.id
      url = SERVICE_URI + "concepts/#{term.ontology.version_id}?" + params.to_url_params
      xml_doc = REXML::Document.new(Net::HTTP.get_response(URI.parse(url)).body)
      rich_term = RichTerm.new(xml_doc)
      rich_term.ontology = term.ontology
      return rich_term
    end
    
  end
  
end