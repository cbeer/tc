# Tc

Timecode parser (based on Parslet) for parsing arbitrary timecode formats into a standardized format

## Usage

```ruby
  parser = Tc::Duration.new

  parser.parse('00:12:43;23') 
  # => { :hours => '00', :minutes => '12', :seconds => '43', :frames => '23', :ndf => ';'}

  parser.parse('123m') 
  # => { :minutes => '123' }

  parser.parse('approx. 54s')
  # => { :seconds => '54', :approximate => 'approx.' }

```

See ```spec/lib/tc_duration.rb``` for additional examples.

Given an ambiguously formatted input (e.g. ```01:34```), Tc will prefer ```hh:mm``` for small values of ```hh``` (<= 2 hours), but ```mm:ss``` in all other cases.
