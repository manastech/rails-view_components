require 'rails_helper'

RSpec.describe "welcome/index.html.haml", type: :view do
  it "should render without model" do
    render
    expect(rendered).to match /Welcome#index/
    expect(rendered).to match /A.*Lorem ipsum dolor sit amet/m
    expect(rendered).to match /B.*123456789/m
  end
end
