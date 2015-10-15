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

    it "displays card without block" do
      rendered = helper.card initial: 'A'

      expect(rendered).to eq %(<h1>A</h1>
<p></p>
)
    end
  end

  describe "#card_alt" do
    it "displays the title, and formatted date" do
      rendered = helper.card_alt initial: 'A' do |c|
        c.body do
          "Lorem ipsum dolor sit amet"
        end
      end

      expect(rendered).to eq %(<h1>A</h1>
<p>Lorem ipsum dolor sit amet</p>

)
    end
  end

  describe "#paired_card" do
    it "displays two cards" do
      rendered = helper.paired_card do |p|
        p.left initial: 'L' do |c|
          c.body do
            "In the lhs"
          end
        end
        p.right initial: 'R' do |c|
          c.body do
            "In the rhs"
          end
        end
      end

      expect(rendered).to eq %(<table>
<tr>
<td><h1>L</h1>
<p>In the lhs</p>
</td>
<td>---</td>
<td><h1>R</h1>
<p>In the rhs</p>
</td>
</tr>
</table>
)
    end

    it "displays two cards without block" do
      rendered = helper.paired_card do |p|
        p.left initial: 'L'
        p.right initial: 'R'
      end

      expect(rendered).to eq %(<table>
<tr>
<td><h1>L</h1>
<p></p>
</td>
<td>---</td>
<td><h1>R</h1>
<p></p>
</td>
</tr>
</table>
)
    end
  end
end
