require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/bioportal-client'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/ontology'))

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
  
end
