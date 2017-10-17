# -*- mode: ruby -*-
# # vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
PROJECT_PATH = File.dirname(__FILE__)

require "#{PROJECT_PATH}/instances.config.rb"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    # plugin conflict
    if Vagrant.has_plugin?("vagrant-vbguest") then
        config.vbguest.auto_update = false
    end

    (INSTANCES).each do |(nameInstance, settings)| 
        _nameInstance = nameInstance
        _hostname = (DOMAIN.empty? ? _nameInstance : "#{_nameInstance}.#{DOMAIN}") 

        _box = ((settings.key?(:box) && !settings[:box].empty?) ? settings[:box] : nil)      
        _boxVersion = ((settings.key?(:boxVersion) && !settings[:boxVersion].empty?) ? settings[:boxVersion] : nil)    
        _boxURL = ((settings.key?(:boxURL) && !settings[:boxURL].empty?) ? settings[:boxURL] : nil)    

        _cpus = (settings.key?(:cpus) ? settings[:cpus] : 1)
        _memory = (settings.key?(:memory) ? settings[:memory] : 512)
        _enableLogging = (settings.key?(:enableLogging) ? settings[:enableLogging] : false)
        _enableSharedFolders = (settings.key?(:enableSharedFolders) ? settings[:enableSharedFolders] : false)

        _overrideSharedFolders = (settings.key?(:overrideSharedFolders) ? settings[:overrideSharedFolders] : nil)
        _network = (settings.key?(:network) ? settings[:network] : nil)
        _provision = (settings.key?(:provision) ? settings[:provision] : nil)

        config.vm.define _hostname do |config|
            # define access --------------------------------------------------------------
            config.vm.hostname = _hostname
            config.ssh.insert_key = false
            config.ssh.forward_agent = true        
            # define box -----------------------------------------------------------------
            if _box.nil? == false then 
                config.vm.box = _box
            end
            if _boxURL.nil? == false then
                config.vm.box_url = _boxURL
            end
            if _boxVersion.nil? == false then
                config.vm.box_version = _boxVersion
            end
            # provider virtualbox --------------------------------------------------------
            config.vm.provider "virtualbox" do |vb|
                vb.gui = false
                vb.cpus = _cpus
                vb.memory = _memory
                vb.functional_vboxsf = false
                vb.check_guest_additions = false
                vb.customize ["modifyvm", :id, "--cpuexecutioncap", "100"]
            end
            # provider network -----------------------------------------------------------
            if _network.nil? == false then
                (_network).each do |(item)|
                    config.vm.network "#{item[:type]}", item[:settings]
                end
            end 
            # provider provision VM ------------------------------------------------------
            if _provision.nil? == false then
                (_provision).each do |(item)|
                    config.vm.provision "#{item[:type]}", item[:settings]
                end
            end 
            # provider shared folders ----------------------------------------------------
            if _enableSharedFolders == true then
                if _overrideSharedFolders.nil? == false then
                    (_overrideSharedFolders).each do |(item)|
                        config.vm.synced_folder item[:host], item[:guest], (item.key?(:settings) ? item[:settings] : {})
                    end
                else 
                    (GLOBAL_SHARED_FOLDERS).each do |(item)|
                        config.vm.synced_folder item[:host], item[:guest], (item.key?(:settings) ? item[:settings] : {})
                    end 
                end 
            end  
            # generates logs -------------------------------------------------------------
            if _enableLogging == true then
                logdir = File.join(File.dirname(__FILE__), "log")
                FileUtils.mkdir_p(logdir)

                serialFile = File.join(logdir, "%s-serial.txt" % _nameInstance)
                FileUtils.touch(serialFile)

                config.vm.provider :virtualbox do |vb, override|
                    vb.customize ["modifyvm", :id, "--uart1", "0x3F8", "4"]
                    vb.customize ["modifyvm", :id, "--uartmode1", serialFile]
                end
            end
        end
    end
end