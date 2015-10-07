require 'rails_helper'

RSpec.describe "welcome/list.html.haml", type: :view do
  it "should render without model" do
    render
    expect(rendered).to match /Welcome#list/
    (0...10).each do |x|
      expect(rendered).to match /\<li\>\s*\<span\>#{x}\<\/span\>\s*\<\/li\>/m
    end
  end
end
