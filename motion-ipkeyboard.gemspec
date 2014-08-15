Gem::Specification.new do |gem|
  gem.authors     = ["Diogo André"]
  gem.email       = 'diogo@regattapix.com'
  gem.name        = 'motion-ipkeyboard'
  gem.summary     = "iPhone keyboards customized for typing IPv4 and IPv6 values"
  gem.description = "Custom iPhone keyboard. Made for iOS7"
  gem.version     = '0.0.3'
  gem.date        = '2014-08-12'
  gem.homepage    = 'https://github.com/diogoandre/motion-ipkeyboard'
  gem.licenses    = "MIT"
  files = []
  files << 'README.md'
  files << 'LICENSE'
  files.concat(Dir.glob('lib/**/*.rb'))
  files.concat(Dir.glob('lib/resources/*.png'))
  gem.files       = files
  gem.require_paths = ["lib"]
end
