#!/bin/bash

if [ ! -d "/opt/" ]; then
    sudo mkdir /opt
fi

if [ -d "/opt/laravel-env-installer" ]; then
    sudo rm -r /opt/laravel-env-installer
    sudo rm -r /opt/nginx-config
    sudo rm -r /usr/local/bin/laravel-env-installer
fi

sudo mkdir /opt/laravel-env-installer

echo -e "Copying the files to /opt/laravel-env-installer..."
sudo cp --preserve laravel-env-installer.sh /opt/laravel-env-installer
sudo cp --preserve nginx-config /opt/nginx-config

echo -e "Creating a symlink of 'laravel-env-installer.sh' to /usr/local/bin/laravel-env-installer..."
sudo ln -s /opt/laravel-env-installer/laravel-env-installer.sh /usr/local/bin/laravel-env-installer

echo -e "[SUCCESS] Installation complete!"
