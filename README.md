## Laravel Environment Installer

Bash script to set up an environment for Laravel applications.

### Installation

Follow this steps to make the script run globally in your machine.

```shell
$ curl -L https://github.com/joseareia/laravel-env-installer/archive/refs/tags/v1.0.0.tar.gz -o laravel-env-installer.tar.gz
$ mkdir laravel-env-installer
$ tar -xvf laravel-env-installer.tar.gz -C laravel-env-installer --strip-components=1
$ cd laravel-env-installer
$ chmod +x install.sh laravel-env-installer.sh
$ ./install.sh
```

### Usage

To properly use this script you can pass three arguments:
- `-n NAME` which is **required** and assigns a name to your project
- `-f` in case you're in a fresh Linux installation without any dependencies (e.g Nginx, PHP, etc...)
- `-p PATH` to specify the directory where the project will be stored

**Note:** If the `-p PATH` isn't used, the project will be stored in `/var/www/`

```shell
// Simple usage (only with -n flag)
$ laravel-env-installer -n my-app

// With -p flag followed by the path
$ laravel-env-installer -n my-app -p /my/random/directory

// In a fresh Linux installation
$ laravel-env-installer -f -n my-app
```

If any doubts, just run `$ laravel-env-installer -h` for some brief help.

**IMPORTANT NOTE:** If you choose to use the `-f` flag, during the installation of the service `MySQL` it will ask you to setup a *VALIDATE PASSWORD*. Enter `yes` and type your password and enter `yes` once again in order to save you password, then for the rest of the setup enter `no`.

### Dependencies

This script doesn't depend on anything to run properly, although in the script itself, if the flag `-f` is assigned it will download and install the following services: `NGINX`, `MySQL`, `PHP` and `Composer`.

In a normal usage of the script (without the `-f` flag), it will only set up a new Laravel project via `Composer`, create a new `Nginx Server Block` and it will download the most recent release of the project [Laravel Permissions](https://github.com/joseareia/laravel-permissions) and run it in order to assign the correct permissions to your Laravel project.

### TODO

- Apache2 compatibility
- MySQL assign default password during installation
- env file auto modification

### License

This project is under the [GPL-3.0 license](https://www.gnu.org/licenses/gpl-3.0.en.html).
