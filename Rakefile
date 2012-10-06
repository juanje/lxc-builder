require 'yaml'

DESTDIR = ENV["DESTDIR"] || ""
BINDIR = ENV["BINDIR"] || "/usr/local/bin"
TARGETDIR = ENV["TARGETDIR"] || ".target"
CONTAINER = ENV["CONTAINER"] || ""

def run_quiet(cmd)
  cmd_end = RakeFileUtils.verbose_flag == true ? "" : "> /dev/null 2>&1"
  `#{cmd} #{cmd_end}`
  fail("#{cmd} failed") unless $?.success?
end

namespace :update do
  desc "Clean old files"
  task :clean do
    rm_rf TARGETDIR
  end

  desc "Clone cookbooks"
  task :clone do
    puts "Cloning cookbooks..."
    YAML.load_file("cookbooks.yml").each do |cookbook|
      repo_dir = "#{TARGETDIR}/cookbooks/#{cookbook[:name]}"
      run_quiet "git clone #{cookbook[:repo]} #{repo_dir}" unless File.directory?(repo_dir)
      run_quiet "cd #{repo_dir} ; git reset -q --hard #{cookbook[:revision]}"
      puts "  Cookbook #{cookbook[:name]} cloned"
    end
  end

  desc "Update chef-solo.tar.gz"
  task :tarball => :clone do
    puts "Updating chef-solo.tar.gz file..."
    Dir.chdir TARGETDIR do
      run_quiet "tar --exclude-vcs -zvcf chef-solo.tar.gz cookbooks"
    end
  end
end

desc "Obtain cookbooks and update the chef-solo.tar.gz file"
task :update => 'update:tarball'

namespace :install do

  desc "Copy the cookbooks into the LXC cache"
  task :tarball => :update do
    mkdir_p "#{DESTDIR}/var/cache/lxc/"
    install "#{TARGETDIR}/chef-solo.tar.gz", "#{DESTDIR}/var/cache/lxc", mode: 0644
  end

  desc "Copy the cookbooks into a specific container"
  task :tarball_to_container do
    tarball_path = "#{DESTDIR}/var/lib/lxc/#{CONTAINER}/rootfs/var/chef-solo/chef-solo.tar.gz"
    if ! File.exists? tarball_path
      fail "It seems like the container '#{CONTAINER}' doesn't exist."
    end
    Rake::Task[:update].invoke
    puts "Copying the tarball to the LXC cache..."
    install "#{TARGETDIR}/chef-solo.tar.gz", tarball_path, mode: 0644
    puts "Done."
    Rake::Task['update:clean'].execute
  end

  desc "Copy the lxc-ssh command to your PATH"
  task :commands do
    mkdir_p "#{DESTDIR}#{BINDIR}"
    install Dir["bin/*"], "#{DESTDIR}#{BINDIR}", mode: 0755
  end

  desc "Run all install tasks"
  task :all => [:tarball, :commands]
end

desc "Install LXC files"
task :install => 'install:all'

task :default => :install
