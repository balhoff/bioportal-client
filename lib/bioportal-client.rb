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
      return xml_doc.elements.collect("success/data/list/ontologyBean") {|ontology_bean| Ontology.new(ontology_bean) }
    end
    
    def search(search_text, ontology_ids=[])
      params = {"email" => @email, "query" => search_text}
      params["ontologyids"] = ontology_ids.join(",") if !ontology_ids.empty?
      url = SERVICE_URI + "search?" + params.to_url_params
      xml_doc = REXML::Document.new(Net::HTTP.get_response(URI.parse(url)).body)
      return xml_doc.elements.collect("success/data/page/contents/searchResultList/searchBean") {|search_bean| Term.new(search_bean) }
    end
    
    def get_rich_term_for_term(term)
      return get_rich_term(term.id, term.ontology.id)
    end
    
    def get_rich_term(term_id, ontology_id)
      params = {"email" => @email, "light" => "0", "norelations" => "0"}
      params["conceptid"] = term_id
      ontology = get_latest_ontology_version(ontology_id)
      url = SERVICE_URI + "concepts/#{ontology.version_id}?" + params.to_url_params
      xml_doc = REXML::Document.new(Net::HTTP.get_response(URI.parse(url)).body)
      rich_term = RichTerm.new(xml_doc)
      rich_term.ontology = ontology
      return rich_term
    end
    
    def get_latest_ontology_version(ontology_id)
      params = {"email" => @email}
      url = SERVICE_URI + "virtual/ontology/#{ontology_id}?" + params.to_url_params
      xml_doc = REXML::Document.new(Net::HTTP.get_response(URI.parse(url)).body)
      return (xml_doc.elements.collect("success/data/ontologyBean"){|ontology_bean| Ontology.new(ontology_bean)}).first
    end
    
  end
  
end