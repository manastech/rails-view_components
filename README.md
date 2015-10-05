[![Build Status](https://travis-ci.org/manastech/rails-view_components.svg?branch=master)](https://travis-ci.org/manastech/rails-view_components)

# View Components for Rails

Simple library for building view components in Ruby on Rails.

## Example

Declare a component by name, and define its sections and attributes:
```ruby
# app/helpers/components_helper.rb
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

Each component is defined by its structure, sections and attributes. To register a component, first invoke `define_component` in a view helper, such as `components_helper`:
```ruby
# app/helpers/components_helper.rb
define_component :card, sections: [:body, :footer], attributes: [:title]
```

The name of the component must be a valid identifier, as well as the sections and the attributes. This gem will then look for a partial view with defined name in the `components` views folder; `app/views/components/_card.html.haml` in the example.

The partial view will receive a hash as a local variable with the same name as the view (again, `card`), which will contain both the values of the attributes and sections.

`define_component` will also define a method for your views with the specified name, that can be used as a builder for the component. The content of each block will be captured and inserted in the specified location in the partial view.

## Roadmap

Next in the roadmap is adding support for collections, which should act as sections that are inserted multiple times in the component.

## Contributing

1. Fork it ( https://github.com/manastech/rails-view_components/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (with specs!) (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## License

[The MIT License](LICENSE)
