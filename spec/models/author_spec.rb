require 'spec_helper'

describe Author do
  
  it "should require last name" do
  	Author.create(:first_name => "Herman").should have(1).error_on(:last_name)
  end

end
