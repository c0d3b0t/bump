require 'json'
require 'optparse'

class Version

   def initialize( file )
      @file = file
      @parts = JSON.parse( File.read( file ) )

      @major = @parts[ 'major' ].to_i
      @minor = @parts[ 'minor' ].to_i
      @patch = @parts[ 'patch' ].to_i
   end

   def bump_major
      @major += 1
   end

   def bump_minor
      @minor += 1
   end

   def bump_patch
      @patch += 1
   end

   def string
      'v' + @major.to_s + '.' + @minor.to_s + '.' + @patch.to_s
   end

   def write
      ver = {
        "major" => @major,
        "minor" => @minor,
        "patch" => @patch
     }

     File.open( @file, "w" ) do |f|
       f.write(ver.to_json)
     end
   end
end

opts = { :major => false, :minor => false, :patch => false, :file => 'version.json' }

optparse = OptionParser.new do |options|
  options.on('-h', '-?', '--help', 'Show help.' ) do
    puts options
    exit
  end

  options.on( '-a', '--major', 'Bump major number.' ) do |name|
     opts[:major] = true
  end

  options.on( '-m', '--minor', 'Bump minor number.' ) do |name|
     opts[:minor] = true
  end

  options.on( '-p', '--patch', 'Bump patch number.' ) do |name|
     opts[:patch] = true
  end

  options.on( '-f', '--file', String, 'Specify file. (defaults to ./version.json )' ) do |name|
     opts[:name] = name
  end

end

optparse.parse( $* )

ver = Version.new( opts[:file] )

if opts[:major] then
   ver.bump_major
end

if opts[:minor] then
   ver.bump_minor
end

if opts[:patch] then
   ver.bump_patch
end

ver.write

puts ver.string
