Gem::Specification.new do |s|
  s.name        = 'frequency_enumerator'
  s.version     = '1.1.1'
  s.summary     = 'Frequency Enumerator'
  s.description = 'Yields hashes that correlate with the given frequency distribution.'
  s.author      = 'Chris Patuzzo'
  s.email       = 'chris@patuzzo.co.uk'
  s.files       = ['README.md'] + Dir['lib/**/*.*']
  s.homepage    = 'https://github.com/tuzz/frequency_enumerator'

  s.add_development_dependency 'rspec'
end
