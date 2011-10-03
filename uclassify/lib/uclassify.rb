require 'rubygems'
require 'nokogiri'
require File.join(File.dirname(__FILE__), 'uclassify_write_call.rb')
require File.join(File.dirname(__FILE__), 'uclassify_create_id.rb')
class UClassify
  def initialize
    puts "UClassify initialized"
    @write_calls = Array.new
  end
  
  def create_classifier(write_api_key,classifier_name,create_id)
    write_call = UClassifyWriteCall.new(write_api_key,classifier_name)
    id = UClassifyCreateID.new(create_id)
    write_call.add_create_id(id)
    @write_calls << write_call
  end
  
  def generate_request_string
    document = Nokogiri::XML::Document.new("1.0")
    document.encoding="utf-8"
    uclassify_root_node =  Nokogiri::XML::Node.new('uclassify',document)
    uclassify_root_node['xmlns']="http://api.uclassify.com/1/RequestSchema"
    uclassify_root_node['version']="1.0.1"
    document.root=uclassify_root_node
    
    #add all the write calls
    @write_calls.each do |write_call|
      node=write_call.to_xml_node(document)
      uclassify_root_node.add_child(node)
    end
    document.to_xml
  end
  
end