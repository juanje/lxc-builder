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
    cookbooks = [
      {
        name: 'apt',
        repo: 'git://github.com/opscode-cookbooks/apt.git',
        revision: '1.4.4'
      },
      {
        name: 'java',
        repo: 'git://github.com/opscode-cookbooks/java.git',
        revision: '1.5.2'
      },
      {
        name: 'openssl',
        repo: 'git://github.com/opscode-cookbooks/openssl.git',
        revision: '26fd53d'
      },
      {
        name: 'postgresql',
        repo: 'git://github.com/opscode-cookbooks/postgresql.git',
        revision: 'dbf5e44'
      },
      {
        name: 'sudo',
        repo: 'git://github.com/opscode-cookbooks/sudo.git',
        revision: '1.2.0'
      },
      {
        name: 'mongodb',
        repo: 'git://github.com/edelight/chef-mongodb.git',
        revision: '0.11.0'
      },
      {
        name: 'rvm',
        repo: 'git://github.com/fnichol/chef-rvm.git',
        revision: 'v0.9.0'
      },
      {
        name: 'conf',
        repo: 'git://github.com/juanje/cookbook-conf.git',
        revision: 'ba2e875'
      },
      {
        name: 'aentos-bootstrap',
        repo: 'git://github.com/aentos/cookbook-aentos-bootstrap.git',
        revision: '0.1.0'
      }
    ]
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
    user = `whoami`.chomp
    if user != 'root'
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

  desc "Copy the Aentos's template to the LXC templates"
  task :template => :root do
    puts "Copying the Aentos's template to the LXC templates..."
    cp "lxc-aentos", "/usr/lib/lxc/templates/lxc-aentos"
    puts "Done."
  end

  directory "/usr/local/bin/"

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
