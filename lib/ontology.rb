require 'rexml/document'

class Ontology
  
  attr_reader :id, :label
  attr_writer :id, :label
  
  def initialize(xml=nil)
    if xml
      @id = (xml.elements.collect("ontologyId") {|el| el.text}).first
      @label = (xml.elements.collect("displayLabel|ontologyDisplayLabel") {|el| el.text}).first
    end
  end
  
end