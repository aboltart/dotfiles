
require 'rake'

desc "install files"
task :install do
  Rake::Task["dotfiles"].invoke
  Rake::Task["application_support"].invoke
end

desc "install the dot files into user's home directory"
task :dotfiles do
  replace_all = false
  Dir['*'].each do |file|
    next if ['Rakefile', 'README.md', 'LICENSE', 'Application Support'].include? file
    target_name = %[bin login.sql].include?(file) ? file : ".#{file}"
    replace_all = configure_install(
      File.join(ENV['PWD'], file),
      File.join(ENV['HOME'], target_name),
      replace_all
    )
  end
end

desc "install the Application Support files"
task :application_support do
  replace_all = false
  Dir.glob("Application Support/**/*").select{|f| !File.directory?(f)}.each do |file|
    replace_all = configure_install(
      File.join(ENV['PWD'], file),
      File.join(ENV['HOME'], 'Library', file),
      replace_all,
      {backup: true}
    )
  end
end

def configure_install(file_path, target_path, replace_all, options={})
  if File.exist?(target_path)
    if replace_all
      make_install_file(file_path, target_path, options)
    else
      print "overwrite #{target_path}? [ynaq] "
      case $stdin.gets.chomp
      when 'a'
        replace_all = true
        make_install_file(file_path, target_path, options)
      when 'y'
        make_install_file(file_path, target_path, options)
      when 'q'
        exit
      else
        puts "skipping #{target_path}"
      end
    end
  else
    make_install_file(file_path, target_path, options)
  end
  replace_all
end

def make_install_file(file_path, target_path, options={})
  if options[:backup] && File.exist?(target_path)
    # Check if file is real file, then mack backup
    system %Q{if [[ ! -L #{target_path.gsub(/ /, '\ ')} ]]; then mv #{target_path.gsub(/ /, '\ ')} #{target_path.gsub(/ /, '\ ')}-back-#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}; fi}
  end
  system %Q{rm -rf "#{target_path}"}
  puts "linking #{file_path} to #{target_path}"
  system %Q{ln -s "#{file_path}" "#{target_path}"}
end

task :default => :install
