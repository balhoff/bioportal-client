require 'rexml/document'

class Ontology
  
  attr_writer :id, :label
  
  def initialize(xml)
    if xml
      @id = (xml.elements.collect("ontologyId") {|el| el.text}).first
      @label = (xml.elements.collect("displayLabel") {|el| el.text}).first
    end
  end
  
end