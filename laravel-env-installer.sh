#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

exit_abnormal() {
    echo -e "Usage: ${0##*/} [-f] [-n NAME] [-p PATH]"
}

show_help() {
	echo -e "Laravel Environment Installer - Set up the environment for your Laravel projects."
	echo -e "Usage: ${0##*/} [-f] [-n NAME] [-p PATH]\n"
	echo -e "\t-h\tshow brief help"
	echo -e "\t-f\tfresh Linux installation environment (${bold}OPTIONAL${normal})"
    echo -e "\t-n\tspecify the name of the project"
	echo -e "\t-p\tspecify the directory that the project will be stored (${bold}OPTIONAL${normal})\n"
	echo -e "${bold}NOTE:${normal} If -p is not used, the project will be stored in /var/www/."
}

fflag= nflag= pflag=

while getopts 'hfn:name:p:path' opt; do
    case $opt in
        h)
			show_help
        	exit 0
			;;
        f)
            fflag=1
            ;;
		n)
			nflag=1
            name="${OPTARG}"
			;;
		p)
			pflag=1
			path="${OPTARG}"
			;;
		*)
			exit_abnormal >&2 && exit 1
			;;
  esac
done

shift $(($OPTIND - 1))

if [ -z "$nflag" ] && [ -z "$name" ] ; then
    echo "${0##*/}: option 'n' is required"
    exit_abnormal >&2 ; exit 1
fi

if [ ! -z "$pflag" ] && [ ! -d "$path" ] ; then
    echo "${0##*/}: path given does not exist"
    exit_abnormal >&2 ; exit 1
fi

# Laravel environment for a fresh Linux installation
if [ ! -z "$fflag" ]; then
    # Nginx Web Server
    sudo apt update && sudo apt --yes --force-yes install nginx

    # MySQL
    sudo apt --yes --force-yes install mysql-server
    sudo mysql_secure_installation

    # PHP
    sudo apt --yes --force-yes install php-fpm php-mysql php-mbstring php-xml php-bcmath php-cli unzip

    # Composer
    curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
    HASH=`curl -sS https://composer.github.io/installer.sig` ; echo $HASH
    php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer
fi

# Laravel project creation with composer
if [ ! -z "$pflag" ]; then
    sudo composer create-project --prefer-dist laravel/laravel $path/$name
else
    sudo composer create-project --prefer-dist laravel/laravel /var/www/$name
fi

# Nginx Config
nginxdpath="/etc/nginx/sites-available/$name"
sudo cp -v nginx-config $nginxdpath
sudo sed -i "s/DOMAIN_NAME/$name.test/g" $nginxdpath
sudo sed -i "s/PROJECT_NAME/$name/g" $nginxdpath
sudo chown root:root $nginxdpath && sudo chmod 644 $nginxdpath
sudo ln -s $nginxdpath /etc/nginx/sites-enabled/$name

if [ ! -z "$pflag" ]; then
    (cd $path/$name; sudo composer install; sudo php artisan key:generate)
else
    (cd /var/www/$name; sudo composer install; sudo php artisan key:generate)
fi

curl -L https://github.com/joseareia/laravel-permissions/archive/refs/tags/v1.0.0.tar.gz -o /tmp/laravel-permissions.tar.gz
sudo mkdir -p /tmp/laravel-permissions && sudo tar -xvf /tmp/laravel-permissions.tar.gz -C /tmp/laravel-permissions --strip-components=1
(cd /tmp/laravel-permissions; sudo chmod +x install.sh; ./install.sh)
[ ! -z "$pflag" ] && (cd $path/$name; laravel-permissions) || (cd /var/www/$name; laravel-permissions)

sudo sed -i.bak "3i\
127.0.0.1 $name.test" /etc/hosts

sudo service php7.4-fpm restart
sudo service nginx restart

echo -e "[CONFIG] The server block configuration for Nginx is stored /etc/nginx/sites-available/$name"
echo -e "[SUCCESS] The installation is complete!"
echo -e "Access your Laravel project via: http://$name.test"
