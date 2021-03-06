vimrc
=====
Author: Kai-Hung (Randy) Huang <randy.hunang@gmail.com>

Fork mine on GitHub https://github.com/Randy-Huang/vimrc.

MANUALLY INSTALL
----------------

**1. Check out from github**

        git clone git://github.com/Randy-Huang/vimrc.git ~/.vim

**2. Install ~/.vimrc**  
    
        cd ~/.vim
        ./auto-install.sh
        
**3. Install Cscope library**

        sudo apt install cscope
        
**4. Compile YCM libiray**        
* YCM offical homepage: www.github.com/ycm-core/YouCompleteMe
        
* Now we start to use VIM before, we need to compile YCM library; for Ubuntu 16.04 and later for installing development tools:

        sudo apt install build-essential cmake python3-dev
         
* And install G++-8 
       
        sudo apt-get install g++-8
        sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 700 --slave /usr/bin/g++ g++ /usr/bin/g++-7
        sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 --slave /usr/bin/g++ g++ /usr/bin/g++-8        
                
* To simply compile with everything enabled, there's a `--all` flag to ensure `xbuild`, `go`, `node`, `npm` and tools are installed and in your `PATH`. then you can run:

        cd ~/.vim/bundle/YouCompleteMe
        python3 install.py --all

* That's it. You're done for installing YCM. Now you can start to use VIM!
