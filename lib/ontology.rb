require 'rexml/document'

class Ontology
  
  attr_reader :id, :label, :version_id
  attr_writer :id, :label, :version_id
  
  def initialize(xml=nil)
    if xml
      @id = (xml.elements.collect("ontologyId") {|el| el.text}).first
      @label = (xml.elements.collect("displayLabel|ontologyDisplayLabel") {|el| el.text}).first
      @version_id = (xml.elements.collect("id") {|el| el.text}).first
    end
  end
  
end