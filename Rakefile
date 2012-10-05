require 'yaml'

def run_quiet(cmd)
  cmd_end = RakeFileUtils.verbose_flag == true ? "" : "> /dev/null 2>&1"
  `#{cmd} #{cmd_end}`
end

def clone_cookbook(repo, cookbook_name, revision)
  run_quiet "git clone #{repo} cookbooks/#{cookbook_name}"
  run_quiet "cd cookbooks/#{cookbook_name} ; git checkout -b #{revision} #{revision}"
  puts "  Cookbook #{cookbook_name} cloned"
end

def clone_cookbooks(cookbooks)
  run_quiet "mkdir cookbooks"
  cookbooks.each do |cookbook|
    clone_cookbook cookbook[:repo], cookbook[:name], cookbook[:revision]
  end
end

namespace :update do
  desc "Clean old files"
  task :clean do
    puts "Cleaning old files and directories..."
    sh "  rm -f chef-solo.tar.gz" if File.exist? 'chef-solo.tar.gz'
    sh "  rm -fr cookbooks" if Dir.exist? 'cookbooks'
    puts "Done."
  end

  desc "Clone cookbooks"
  task :clone => :clean do
    cookbooks = YAML.load_file("cookbooks.yml")
    puts "Cloning cookbooks..."
    clone_cookbooks cookbooks
    puts "Done."
  end

  desc "Update chef-solo.tar.gz"
  task :tarball => :clone do
    puts "Updating chef-solo.tar.gz file..."
    run_quiet "tar --exclude-vcs -zvcf chef-solo.tar.gz cookbooks"
    puts "Done."
  end
end

desc "Obtain cookbooks and update the chef-solo.tar.gz file"
task :update => 'update:tarball'

namespace :install do
  desc "Do I have enough permissions?"
  task :root do
    if Process.uid != 0
      fail "You must to be root in order to run this task. Try with sudo"
    end
  end

  desc "Copy the cookbooks into the LXC cache"
  task :tarball => :root do
    Rake::Task[:update].invoke
    puts "Copying the tarball to the LXC cache..."
    cp "chef-solo.tar.gz", "/var/cache/lxc/chef-solo.tar.gz"
    puts "Done."
    Rake::Task['update:clean'].execute
  end

  directory "/usr/local/bin/"

  desc "Copy the lxc-build-project script to your PATH"
  task :builder => [:root, "/usr/local/bin/"] do
    puts "Copying the lxc-build-project script to your PATH..."
    cp "lxc-build-project", "/usr/local/bin/lxc-build-project"
    chmod 0755, "/usr/local/bin/lxc-build-project"
    puts "Done."
  end

  desc "Copy the lxc-provision command to your PATH"
  task :provision => [:root, "/usr/local/bin/"] do
    puts "Copying the lxc-provision command to your PATH..."
    cp "lxc-provision", "/usr/local/bin/lxc-provision"
    chmod 0755, "/usr/local/bin/lxc-provision"
    puts "Done."
  end

  desc "Copy the lxc-ssh command to your PATH"
  task :ssh => [:root, "/usr/local/bin/"] do
    puts "Copying the lxc-ssh command to your PATH..."
    cp "lxc-ssh", "/usr/local/bin/lxc-ssh"
    chmod 0755, "/usr/local/bin/lxc-ssh"
    puts "Done."
  end

  desc "Run all install tasks"
  task :all => [:tarball, :template, :provision, :ssh]
end

desc "Install LXC files"
task :install => 'install:all'

task :default => :install
