require 'rexml/document'
require 'ontology'

class Term
  
  attr_reader :id, :label, :ontology
  attr_writer :id, :label, :ontology
  
  def initialize(xml=nil)
    if xml
      @id = (xml.elements.collect("conceptId") {|conceptId| conceptId.text}).first
      @label = (xml.elements.collect("preferredName") {|preferredName| preferredName.text}).first
      @ontology = Ontology.new(xml)
    end
  end
  
end

class RichTerm < Term
  
  attr_reader :definition, :synonyms
  attr_writer :definition, :synonyms
  
  def initialize(xml=nil)
      if xml
        @id = (xml.elements.collect("success/data/classBean/fullId") {|definition| definition.text}).first
        @label = (xml.elements.collect("success/data/classBean/label") {|definition| definition.text}).first
        @definition = (xml.elements.collect("success/data/classBean/definitions/string") {|definition| definition.text}).first
        @synonyms = xml.elements.collect("success/data/classBean/synonyms/string") {|definition| definition.text}
      end
  end
  
end