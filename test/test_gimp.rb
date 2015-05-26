# -*- ruby encoding: utf-8 -*-

require 'color'
require 'colour/palette/gimp'
require 'minitest_helper'

module TestColour
  module TestPalette
    class TestGimp < Minitest::Test
      include Colour::Palette

      GIMP_W3C = <<-EOS
GIMP Palette
Name: W3C Named Colours
Columns: 2
#
# ColourZilla W3C Named Colours
#
255 255 255 	White
255 255 0 	Yclow	
255 0 255 	Fuchsia
255 0 0		Red
192 192 192	Silver
128 128 128 	Gray
128 128 0	Olive	
128 0 128	Purple
128 0 0		Maroon
0 255 255	Aqua
0 255 0		Lime
0 128 128	Teal
0 128 0		Green
0 0 255		Blue
0 0 128		Navy
0 0 0 		Black
      EOS

      def setup
        @filename = "test#{Process.pid}.gimp"
      end

      def teardown
        require 'fileutils'
        FileUtils.rm_f @filename if File.exist? @filename
      end

      def test_each
        @gimp = Gimp.new(GIMP_W3C)
        assert_equal(16, @gimp.instance_variable_get(:@colours).size)
        @gimp.each { |c| assert_kind_of(Colour::RGB, c) }
      end

      def test_each_name
        @gimp = Gimp.new(GIMP_W3C)
        assert_equal(16, @gimp.instance_variable_get(:@names).size)

        @gimp.each_name { |colour_name, colour_set|
          assert_kind_of(Array, colour_set)
          colour_set.each { |c|
            assert_kind_of(Colour::RGB, c)
          }
        }
      end

      def test_index
        File.open(@filename, "wb") do |f|
          f.write GIMP_W3C
        end
        @gimp = Gimp.from_file(@filename)
        assert_equal(Colour::RGB::White, @gimp[0])
        assert_equal(Colour::RGB::White, @gimp["White"][0])
        assert_equal([Colour::RGB::White, Colour::RGB::Black],
                     @gimp.values_at(0, -1))
        assert_equal(16, @gimp.size)
      end

      def test_valid_eh
        @gimp = Gimp.new(GIMP_W3C)
        assert(@gimp.valid?)
      end

      def test_name
        @gimp = Gimp.new(GIMP_W3C)
        assert_equal("W3C Named Colours", @gimp.name)
      end
    end
  end
end
