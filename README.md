[![Build Status](https://travis-ci.org/manastech/rails-view_components.svg?branch=master)](https://travis-ci.org/manastech/rails-view_components)

# View Components for Rails

Simple library for building view components in Ruby on Rails.

## Example

Declare a component by name, and define its sections and attributes:
```ruby
# app/helpers/application_helper.rb
define_component :card, sections: [:body, :footer], attributes: [:title]
```

Define its structure using a partial view:
```ruby
# app/views/components/_card.html.haml
.card
  %h1= card[:title]
  .content
    = card[:body]
  .footer
    = card[:footer]
```

Use it in your views:
```haml
-# app/views/welcome/index.html.haml
= card title: 'A value' do |c|
  - c.body do
    A block of HAML
    = link_to 'My page', my_page_path
  - c.footer do
    %span Another block of HAML
```

## Installation

Add `view_components` to your Gemfile:
```ruby
source 'https://rubygems.org'
gem 'view_components'
```

## Usage

Each component is defined by its structure, sections and attributes. To register a component, first invoke `define_component` in your `application_helper`:

```ruby
# app/helpers/application_helper.rb
define_component :card, sections: [:body, :footer], attributes: [:title]
```

Alternatively, a component can be defined using the Component DSL:

```ruby
# app/helpers/application_helper.rb
define_component :card do |c|
  c.render "components/card"
  c.attribute :title
  c.section :body
  c.section :footer
end
```

The name of the component must be a valid identifier, as well as the sections and the attributes. This gem will then look for a partial view with defined name in the `components` views folder; `app/views/components/_card.html.haml` in the example, which can be overridden via the `render` attribute.

The partial view will receive a hash as a local variable with the same name as the view (again, `card`), which will contain both the values of the attributes and sections.

`define_component` will also define a method for your views with the specified name, that can be used as a builder for the component. The content of each block will be captured and inserted in the specified location in the partial view.

If components are to be defined in another helper, extend `::ViewComponents::ComponentsBuilder`.

```ruby
# app/helpers/another_helper.rb
module AnotherHelper
  extend ::ViewComponents::ComponentsBuilder
  define_component :card, sections: [:body, :footer], attributes: [:title]
end
```

### Repeatable sections

A section can be marked as `multiple` if it is to be invoked multiple times in the component. A simple example is a list, where the `item` section is repeated multiple times:

```ruby
define_component :list, sections: [{name: :items, multiple: :item}], attributes: [:title]
```

The partial view with the component layout definition will receive in `items` an array with all instances of the section already rendered:

```haml
%span= list[:title]
%ul
  - list[:items].each do |item|
    %li= item
```

And usage of the component is the same as previously, except that invoking `item` (which is the value of the `multiple` key, or the singularisation of the `name` key) multiple times will add several items, rather than overriding it:

```haml
= list title: "Digits" do |l|
  - (0...10).each do |x|
    - l.li do
      %span= x
```

### Nesting components

A component section may be yet another component. For example, a paired-card composed by two cards can be defined like this:

```ruby
define_component :paired_card do |c|
  c.section :left,  component: :card
  c.section :right, component: :card
end
```

The definition of the component is handled as usual, including the section content in the markup:

```haml
%table
  %tr
    %td= paired_card[:left]
    %td ---
    %td= paired_card[:right]
```

But when invoking the component, each section method yields a component builder for the specified component class, so you can directly do this:

```haml
= paired_card do |p|
  - p.left initial: 'L' do |c|
    - c.body do
      In the lhs
  - p.right initial: 'R' do |c|
    - c.body do
      In the rhs
```

Instead of having to manually setup a new component in each section:

```haml
= paired_card do |p|
  - p.left do
    - card initial: 'L' do |c|
      - c.body do
        I'm in the left side
  - p.right do
    - card initial: 'R' do |c|
      - c.body do
        I'm in the right side
```

## Contributing

1. Fork it ( https://github.com/manastech/rails-view_components/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (with specs!) (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## License

[The MIT License](LICENSE)
