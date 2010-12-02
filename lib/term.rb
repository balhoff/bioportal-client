require 'rexml/document'
require 'ontology'

class Term
  
  attr_reader :id, :label, :ontology
  attr_writer :id, :label, :ontology
  
  def initialize(xml=nil)
    if xml
      @id = (xml.elements.collect("conceptId") {|el| el.text}).first
      @label = (xml.elements.collect("preferredName") {|el| el.text}).first
      @ontology = Ontology.new(xml)
    end
  end
  
end