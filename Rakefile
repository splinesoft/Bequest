# encoding: UTF-8
# Bequest

class String
  def self.colorize(text, color_code)
    "\e[#{color_code}m#{text}\e[0m"
  end

  def cyan
    self.class.colorize(self, 36)
  end

  def green
    self.class.colorize(self, 32)
  end
end

desc 'Installs dependencies and pods'
task :setup do
  
  puts "Installing bundle...".cyan
  sh "bundle check --path=vendor/bundle || bundle install --jobs=4 --retry=2 --path=vendor/bundle"

  puts "Installing Pods...".cyan
  sh "bundle exec pod install --project-directory=src"

end

desc 'Runs all Bequest Tests'
task :test do

  puts "Running Bequest Tests...".cyan
  
  swiftcov = `which swiftcov`.chomp
  build_command = cov_command = "set -o pipefail && "
  
  test_command = "xcodebuild "+
  "-scheme 'Bequest Dev' "+
  "-workspace 'src/Bequest.xcworkspace' "+
  "-configuration Debug "+
  "-sdk iphonesimulator "+
  "-destination \"platform=iOS Simulator,name=iPhone 6\" "+
  "test"
  
  build_command += test_command + " | bundle exec xcpretty -c"
  
  if ENV['CIRCLECI'] == 'true'
    build_command += " --report junit --output ${CIRCLE_TEST_REPORTS}/junit.xml"
  end
    
  sh build_command
      
  if swiftcov.length > 0
    if ENV['CIRCLE_CI'] == 'true'
      output = "$CIRCLE_ARTIFACTS" 
    else 
      output = "output/coverage" 
    end
    
    cov_command += "#{swiftcov} generate --output #{output} #{test_command}"
    
    sh cov_command
  end
end

desc 'Runs various static analyzers and linters'
task :lint do
  
  sh "bundle exec pod outdated --project-directory=src"
  
  puts `bundle exec obcd --path src/Bequest find HeaderStyle`
  
  swiftlint = "/usr/local/bin/swiftlint lint --path "
  
  puts `#{swiftlint} src/Bequest`
  puts `#{swiftlint} src/BequestTests`
  
end