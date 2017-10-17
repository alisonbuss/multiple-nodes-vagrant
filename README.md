
# Multiple Nodes Vagrant
Este é um modelo Vagrantfile que é fácil adicionar **VMs** sobre uma **configuração simples**
que gera nós ou pontos de montagens e cada nó pode ser personalizado. 
Cada servidor "Maquina" pode ser facilmente provisionado com Puppet, Chef, **Ansible** ou um script.

> **Nota:**
> *Esse projeto se basease no post: 
  "[A Vagrantfile template](http://jerematic.com/articles/2015-07/a-vagrantfile-template)" 
  de Jeremy Steinert* 
>   

## Começando

1) Instalar dependências

* [VirtualBox](https://www.virtualbox.org/) 4.3.10 ou superior..
* [Vagrant](https://www.vagrantup.com/downloads.html) 1.6.3 ou superior.

2) Clone este projeto para começá-lo a funcionar!

```bash
$ git clone https://github.com/alisonbuss/multiple-nodes-vagrant/
$ ls multiple-nodes-vagrant
...
 multiple-nodes-vagrant
  |---log/                   'Pasta de arquivos de log'
  |---shared-folder/         'Pasta de compartilhamento da máquina para VM'
  |---shared-folder/text.txt 'Arquivo a ser compartilhado'
  |---instances.config.rb    'ARQUIVO PRINCIPAL!! onde configura as VM'
  |---LICENSE                'Licença Pública Geral GNU v3.0'
  |---README.md              'Instruções de uso'
  |---Vagrantfile            'Arquivo vagrant'
...
$ cd multiple-nodes-vagrant
```

3) Inicialização e SSH

    O provedor usando é o **VirtualBox** e é o provedor padrão do Vagrant.

```bash
$ vagrant up
...

$ vagrant ssh centos.example.com
...

$ vagrant ssh ubuntu.example.com
...

```

### **Arquivo Principal** *de configuração para subir instancias de VMs*:

```bash
$ cat instances.config.rb

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
```