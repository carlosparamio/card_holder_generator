lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "card_holder_generator/version"

Gem::Specification.new do |spec|
  spec.name          = "card_holder_generator"
  spec.version       = CardHolderGenerator::VERSION
  spec.authors       = ["Carlos Paramio"]
  spec.email         = ["hola@carlosparamio.com"]

  spec.summary       = %q{Script to generate OpenSCAD files that contains the design for custom card holders.}
  spec.description   = %q{Script to generate OpenSCAD files that contains the design for custom card holders.}
  spec.homepage      = "https://github.com/carlosparamio/card_holder_generator"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
