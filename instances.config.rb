=begin ############################################################################

Instance default values:

    INSTANCES = {                  
        :"name-instance" => {    
            box: null,           
            boxURL: null,        
            boxVersion: null,       
            cpus: 1,              
            memory: 512,         
            enableLogging: false,
            enableSharedFolders: false,
            overrideSharedFolders: [],
            network: null,
            provision: null  
        }, ...
    } 

=end ##############################################################################

DOMAIN = "example.com"

INSTANCES = {
    :"centos" => {
        box: "centos/7",
        enableSharedFolders: true,
        overrideSharedFolders: [
            {host: "shared-folder/", guest: "/home/shared", settings:{ 
                id: "shared-override-01", nfs: true, mount_options: ['nolock,vers=3,udp'] 
            }}
        ],
        network: [
            { type: "private_network", settings: { ip: "172.17.8.101" }},
            { type: "forwarded_port", settings: { guest: 80, host: 8080, auto_correct: true }}
        ],
        provision: [
            { type: "shell", settings: { inline: "echo Hello, World", privileged: true }}
        ]
    },
    :"ubuntu" => {
        box: "ubuntu/trusty64",
        enableSharedFolders: true,
        network: [
            { type: "private_network", settings: { ip: "172.17.8.102" }}
        ],
        provision: [
            # Example: { type: "ansible", settings: { playbook: "provision/install.yml", host_key_checking: false, sudo: true, tags: ["common", "jenkins"] }},
            { type: "shell", settings: { inline: "echo Hello, World", privileged: true }}
        ]
    }
}

GLOBAL_SHARED_FOLDERS = [
    {host: "shared-folder/", guest: "/home/shared-folder"}
]