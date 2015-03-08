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
  
  test_command = "set -o pipefail && bundle exec xcodebuild "+
  "-scheme 'Bequest Dev' "+
  "-workspace 'src/Bequest.xcworkspace' "+
  "-sdk iphonesimulator "+
  "-destination \"platform=iOS Simulator,name=iPhone 6\" "+
  "clean test | xcpretty -c"
  
  if ENV['CIRCLECI'] == 'true'
    test_command += " --report junit --output ${CIRCLE_TEST_REPORTS}/junit.xml"
  end

  sh "#{test_command}"
end

desc 'Runs various static analyzers and linters'
task :lint do
  
  sh "bundle exec pod outdated --project-directory=src"
  
end