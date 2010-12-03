require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/bioportal-client'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/ontology'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/term'))

include Bioportal

EMAIL = "bioportal-client-tests@example.com"
TAO_ID = "1110"

class TestBioportalClient < Test::Unit::TestCase
  
  should "initialize a new instance" do
    assert client = Bioportal::BioportalClient.new(EMAIL)
  end
  
  should "return an array of all ontologies" do
    client = Bioportal::BioportalClient.new(EMAIL)
    assert client.list_ontologies.size > 0
  end
  
  should "find some matching terms" do
     client = Bioportal::BioportalClient.new(EMAIL)
     assert client.search("basihyal").size > 0
   end
   
   should "find terms only in the TAO" do
     client = Bioportal::BioportalClient.new(EMAIL)
     tao = Ontology.new
     tao.id = TAO_ID
     client.search("basihyal", [tao]).each{|term| assert term.ontology.id == TAO_ID}
   end
   
   should "retrieve info about the basihyal term from TAO" do
     client = Bioportal::BioportalClient.new(EMAIL)
     ontology = Ontology.new
     ontology.id = TAO_ID
     ontology.version_id = "44841"
     term = Term.new
     term.ontology = ontology
     term.id = "http://purl.org/obo/owl/TAO#TAO_0000316"
     rich_term = client.get_rich_term(term)
     assert rich_term.label = "basihyal"
     assert rich_term.definition = "Replacement bone that is median and is the anterior-most bone of the ventral hyoid arch."
     assert rich_term.synonyms.include?("glossohyal")
   end
  
end
