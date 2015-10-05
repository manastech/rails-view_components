require 'rails_helper'

RSpec.describe ApplicationHelper, :type => :helper do
  describe "#card" do
    it "displays the title, and formatted date" do
      rendered = helper.card initial: 'A' do |c|
        c.body do
          "Lorem ipsum dolor sit amet"
        end
      end

      expect(rendered).to eq %(<h1>A</h1>
<p>Lorem ipsum dolor sit amet</p>
)
    end
  end
end
