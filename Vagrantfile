# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'socket'

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # specify memory size in MiB
  vm_ram = ENV['VAGRANT_VM_RAM'] || 2048
  vm_cpu = ENV['VAGRANT_VM_CPU'] || 2
  vm_ram_bytes = vm_ram * 1024 * 1024

  config.vm.hostname = "gdal-vagrant"
  config.vm.host_name = "gdal-vagrant"

  # proxy configurations.
  # these options are also specified by environment variables;
  #   VAGRANT_HTTP_PROXY, VAGRANT_HTTPS_PROXY, VAGRANT_FTP_PROXY
  #   VAGRANT_NO_PROXY, VAGRANT_SVN_PROXY, VAGRANT_GIT_PROXY
  # if you want to set these on Vagrantfile, edit followings.
  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.enabled   = false  # true|false
    #config.proxy.http      = "http://192.168.0.2:3128"
    #config.proxy.ftp       = "http://192.168.0.2:3128"
    #config.proxy.https     = "DIRECT"
    #config.proxy.no_proxy  = "localhost,127.0.0.1,.example.com"
    #config.svn_proxy.http  = ""
    #config.git_proxy.http  = ""
  end

  config.vm.provider :virtualbox do |vb,ovrd|
     ovrd.vm.network :forwarded_port, guest: 80, host: 8080
     ovrd.vm.box = "trusty64"
     ovrd.vm.box_url = "http://files.vagrantup.com/precise64.box"
     vb.customize ["modifyvm", :id, "--memory", vm_ram]
     vb.customize ["modifyvm", :id, "--cpus", vm_cpu]
     vb.customize ["modifyvm", :id, "--ioapic", "on"]
     vb.name = "gdal-vagrant"
  end

  config.vm.provider :lxc do |lxc,ovrd|
    ovrd.vm.box = "cultuurnet/ubuntu-14.04-64-puppet"
    lxc.backingstore = 'dir'
    lxc.customize 'cgroup.memory.limit_in_bytes', vm_ram_bytes
    lxc.customize 'aa_allow_incomplete', 1
    lxc.container_name = "gdal-vagrant"
  end
 
  config.vm.provider :hyperv do |hyperv,ovrd|
    ovrd.vm.box = "withinboredom/Trusty64"
    ovrd.ssh.username = "vagrant"
    hyperv.cpus = vm_cpu
    hyperv.memory = vm_ram
    # If you want to avoid copying an entire image with
    # differencing disk feature, uncomment a following line.
    # hyperv.differencing_disk = true
    hyperv.vmname = "gdal-vagrant"
  end

  ppaRepos = [
    "ppa:openjdk-r/ppa",
    "ppa:ubuntugis/ubuntugis-unstable", "ppa:miurahr/gta",
    "ppa:miurahr/fyba"
  ]

  packageList = [
    "autoconf",
    "automake",
    "subversion",
    "python-numpy",
    "python-dev",
    "postgis",
    "postgresql-server-dev-9.3",
    "postgresql-9.3-postgis-2.2",
    "postgresql-9.3-postgis-scripts",
    "libmysqlclient-dev",
    "libpq-dev",
    "libpng12-dev",
    "libjpeg-dev",
    "libgif-dev",
    "liblzma-dev",
    "libgeos-dev",
    "libcurl4-gnutls-dev",
    "libproj-dev",
    "libxml2-dev",
    "libexpat-dev",
    "libxerces-c-dev",
    "libnetcdf-dev",
    "netcdf-bin",
    "libpoppler-dev",
    "libpoppler-private-dev",
    "libspatialite-dev",
    "gpsbabel",
    "libboost-all-dev",
    "libgmp-dev",
    "libmpfr-dev",
    "libkml-dev",
    "swig",
    "libhdf4-dev",
    "libhdf5-dev",
    "poppler-utils",
    "libfreexl-dev",
    "unixodbc-dev",
    "libwebp-dev",
    "openjdk-8-jdk",
    "libepsilon-dev",
    "libgta-dev",
    "liblcms2-2",
    "libpcre3-dev",
    "libjasper-dev",
    "libarmadillo-dev",
    "libcrypto++-dev",
    "libdap-dev",
    "libogdi3.2-dev",
    "libcfitsio3-dev",
    "libfyba-dev",
    "libsfcgal-dev",
    "librasterlite-dev",
    "couchdb",
    "libmongo-client-dev",
    "make",
    "g++",
    "bison",
    "flex",
    "doxygen",
    "texlive-latex-base",
    "vim",
    "ant",
    "mono-mcs",
    "libjson-c-dev",
    "libtiff5-dev",
    "libopenjp2-7-dev"
  ];

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  if Dir.glob("#{File.dirname(__FILE__)}/.vagrant/machines/default/*/id").empty?
	  pkg_cmd = "sed -i 's#deb http[s]?://.*archive.ubuntu.com/ubuntu/#deb mirror://mirrors.ubuntu.com/mirrors.txt#' /etc/apt/sources.list; "
    pkg_cmd << 'echo "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty universe" > /etc/apt/sources.list.d/official-ubuntu-trusty-universe.list; '
    pkg_cmd << 'echo "deb [ arch=amd64 ] http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.4 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.4.list; '
	  pkg_cmd << "apt-get update -qq; apt-get install -q -y python-software-properties; "

	  if ppaRepos.length > 0
		  ppaRepos.each { |repo| pkg_cmd << "add-apt-repository -y " << repo << " ; " }
		  pkg_cmd << "apt-get update -qq; "
	  end

	  # install packages we need we need
	  pkg_cmd << "apt-get install -q -y " + packageList.join(" ") << " ; "
	  config.vm.provision :shell, :inline => pkg_cmd
    scripts = [
      "cmake.sh",
      "libkml.sh",
      "gdal.sh",
      "postgis.sh"
    ];
    scripts.each { |script| config.vm.provision :shell, :privileged => false, :path => "scripts/vagrant/" << script }
  end
end
