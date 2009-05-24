require 'test/unit'

Test::Unit::AutoRunner.class_eval do
  alias_method :options_original, :options
  def options
    o = options_original
    o.on('-n', '--name=NAME', String,
      "Runs tests matching NAME.",
      "(patterns may be used).") do |n|
        n = (%r{\A/(.*)/\Z} =~ n ? Regexp.new($1) : n)
        case n
          when Regexp
            @filters << proc{|t| n =~ t.method_name ? true : nil}
          when n.start_with?("test_")
            @filters << proc{|t| n == t.method_name ? true : nil}
          else
            n = Regexp.new(n.gsub(/[\s]/,"(_|\s)"))
            @filters << proc{|t| n =~ t.method_name ? true : nil}
        end
    end
  end
end
