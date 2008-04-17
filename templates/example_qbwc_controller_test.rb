require File.dirname(__FILE__) + '/../test_helper'

#
# Use this section if you're into test_spec...
#

#context 'A QbwcController' do
#  use_controller QbwcController
#  
#  setup do
#  end
#  
#  specify 'should support all versions of the web connector' do
#    result = invoke :clientVersion, '1.2.3.4.5'
#    result.should.be nil
#  end
#  
#end

#
# Use this section if you're into the old style of testing...
#

#require 'qbwc_controller'
#
## Re-raise errors caught by the controller.
#class QbwcController; def rescue_action(e) raise e end; end
#
#class QbwcControllerTest < Test::Unit::TestCase
#
#  def setup
#    @controller = QbwcController.new
#    @request    = ActionController::TestRequest.new
#    @response   = ActionController::TestResponse.new
#  end
#
#  def test_should_support_all_versions_of_qbwc
#    result = invoke :clientVersion, '1.2.3.4.5'
#    assert_equal nil, result
#  end
#
#end