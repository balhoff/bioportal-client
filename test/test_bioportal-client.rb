require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../lib/bioportal-client'))

include Bioportal

EMAIL = "bioportal-client-tests@example.com"

class TestBioportalClient < Test::Unit::TestCase
  
  should "initialize a new instance" do
    assert client = Bioportal::BioportalClient.new(EMAIL)
  end
  
  should "return an array of all ontologies" do
    client = Bioportal::BioportalClient.new(EMAIL)
    assert client.list_ontologies.size > 0
  end
  
end
