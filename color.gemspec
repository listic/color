# -*- encoding: utf-8 -*-
# stub: color 1.7.1 ruby lib

Gem::Specification.new do |s|
  s.name = "color"
  s.version = "1.7.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Austin Ziegler", "Matt Lyon"]
  s.date = "2014-07-17"
  s.description = "Colour is a Ruby library to provide basic RGB, CMYK, HSL, and other colourspace\nmanipulation support to applications that require it. It also provides 152\nnamed RGB colours (184 with spelling variations) that are commonly supported in\nHTML, SVG, and X11 applications. A technique for generating monochromatic\ncontrasting palettes is also included.\n\nThe Colour library performs purely mathematical manipulation of the colours\nbased on color theory without reference to color profiles (such as sRGB or\nAdobe RGB). For most purposes, when working with RGB and HSL color spaces,\nthis won't matter. Absolute color spaces (like CIE L*a*b* and XYZ) and cannot\nbe reliably converted to relative color spaces (like RGB) without color\nprofiles.\n\nColour version 1.7.1 adds Colour::RGB::RebeccaPurple for the color #663399 in\nhonour of Rebecca Meyer, the daughter of Eric Meyer, who passed away on the 7th\nof June, 2014. Her favourite color was purple.\n{rebeccapurple}[http://meyerweb.com/eric/thoughts/2014/06/19/rebeccapurple/]\n\nBarring bugs introduced in this release, this is the last version of color that\nsupports Ruby 1.8, so make sure that your gem specification is set properly (to\n<tt>~> 1.6</tt>) if that matters for your application."
  s.email = ["halostatue@gmail.com", "matt@postsomnia.com"]
  s.extra_rdoc_files = ["Contributing.rdoc", "History.rdoc", "Licence.rdoc", "Manifest.txt", "README.rdoc", "Contributing.rdoc", "History.rdoc", "Licence.rdoc", "README.rdoc"]
  s.files = [".autotest", ".gemtest", ".hoerc", ".minitest.rb", ".travis.yml", "Contributing.rdoc", "Gemfile", "History.rdoc", "Licence.rdoc", "Manifest.txt", "README.rdoc", "Rakefile", "lib/color.rb", "lib/color/cmyk.rb", "lib/color/css.rb", "lib/color/grayscale.rb", "lib/color/hsl.rb", "lib/color/palette.rb", "lib/color/palette/adobecolour.rb", "lib/color/palette/gimp.rb", "lib/color/palette/monocontrast.rb", "lib/color/rgb.rb", "lib/color/rgb/colors.rb", "lib/color/rgb/contrast.rb", "lib/color/rgb/metallic.rb", "lib/color/yiq.rb", "test/minitest_helper.rb", "test/test_adobecolour.rb", "test/test_cmyk.rb", "test/test_colour.rb", "test/test_css.rb", "test/test_gimp.rb", "test/test_grayscale.rb", "test/test_hsl.rb", "test/test_monocontrast.rb", "test/test_rgb.rb", "test/test_yiq.rb"]
  s.homepage = "https://github.com/halostatue/color"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--main", "README.rdoc"]
  s.rubygems_version = "2.2.1"
  s.summary = "Colour is a Ruby library to provide basic RGB, CMYK, HSL, and other colourspace manipulation support to applications that require it"
  s.test_files = ["test/test_adobecolour.rb", "test/test_cmyk.rb", "test/test_colour.rb", "test/test_css.rb", "test/test_gimp.rb", "test/test_grayscale.rb", "test/test_hsl.rb", "test/test_monocontrast.rb", "test/test_rgb.rb", "test/test_yiq.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<minitest>, ["~> 5.3"])
      s.add_development_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_development_dependency(%q<hoe-doofus>, ["~> 1.0"])
      s.add_development_dependency(%q<hoe-gemspec2>, ["~> 1.1"])
      s.add_development_dependency(%q<hoe-git>, ["~> 1.5"])
      s.add_development_dependency(%q<hoe-rubygems>, ["~> 1.0"])
      s.add_development_dependency(%q<hoe-travis>, ["~> 1.2"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_development_dependency(%q<hoe>, ["~> 3.12"])
    else
      s.add_dependency(%q<minitest>, ["~> 5.3"])
      s.add_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_dependency(%q<hoe-doofus>, ["~> 1.0"])
      s.add_dependency(%q<hoe-gemspec2>, ["~> 1.1"])
      s.add_dependency(%q<hoe-git>, ["~> 1.5"])
      s.add_dependency(%q<hoe-rubygems>, ["~> 1.0"])
      s.add_dependency(%q<hoe-travis>, ["~> 1.2"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<hoe>, ["~> 3.12"])
    end
  else
    s.add_dependency(%q<minitest>, ["~> 5.3"])
    s.add_dependency(%q<rdoc>, ["~> 4.0"])
    s.add_dependency(%q<hoe-doofus>, ["~> 1.0"])
    s.add_dependency(%q<hoe-gemspec2>, ["~> 1.1"])
    s.add_dependency(%q<hoe-git>, ["~> 1.5"])
    s.add_dependency(%q<hoe-rubygems>, ["~> 1.0"])
    s.add_dependency(%q<hoe-travis>, ["~> 1.2"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<hoe>, ["~> 3.12"])
  end
end
