# -*- encoding: utf-8 -*-
require File.expand_path('../lib/csv_line_parser/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Chandresh Pant"]
  gem.email         = ["cp@cpant.in"]
  gem.description   = %q{Write a gem description}
  gem.summary       = %q{Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "csv_line_parser"
  gem.require_paths = ["lib"]
  gem.version       = CsvLineParser::VERSION
end
