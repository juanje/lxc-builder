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
