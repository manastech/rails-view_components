require 'rails_helper'

include ViewComponents::ComponentsBuilder

RSpec.describe ComponentDsl do
  it "initialize attributes" do
    c = ComponentDsl.new(attributes: [:title])
    expect(c.options[:attributes]).to include(a_hash_including(name: :title))
  end

  it "initialize sections" do
    c = ComponentDsl.new(sections: [:body])
    expect(c.options[:sections]).to include(a_hash_including(name: :body))
  end

  it "add attribute by dsl" do
    c = ComponentDsl.new
    c.attribute :title

    expect(c.options[:attributes]).to include(a_hash_including(name: :title))
  end

  it "has default section options" do
    c = ComponentDsl.new
    c.section :body
    expect(c.options[:sections]).to include(a_hash_including(name: :body, multiple: false, component: nil))
  end

  it "can define multiple section" do
    c = ComponentDsl.new
    c.section :bodies, multiple: true
    expect(c.options[:sections]).to include(a_hash_including(name: :bodies, multiple: true))
  end

  it "can define subcomponent section" do
    c = ComponentDsl.new
    c.section :body, component: :other
    expect(c.options[:sections]).to include(a_hash_including(name: :body, component: :other))
  end

  it "can define section options from initialize" do
    c = ComponentDsl.new(sections: [{name: :body, multiple: true, component: :other}, :other])
    expect(c.options[:sections]).to include(a_hash_including(name: :body, multiple: true, component: :other))
    expect(c.options[:sections]).to include(a_hash_including(name: :other, multiple: false, component: nil))
  end
end
