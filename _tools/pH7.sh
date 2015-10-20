#!/bin/bash

##
# Title:           Useful Unix functions
# Description:     For this script to work correctly, you should use it when you're at the root of the project with the terminal (e.g., you@you:/path/to/root-project$ bash _tools/pH7.sh).
# Author:          Pierre-Henry Soria <ph7software@gmail.com>
# Copyright:       (c) 2012-2015, Pierre-Henry Soria. All Rights Reserved.
# License:         GNU General Public License; See PH7.LICENSE.txt and PH7.COPYRIGHT.txt in the root directory.
##

function init() {
    echo "Please enter a command, OPTION:"
    echo "1) clear cache"
    echo "2) remove tmp file"
    echo "3) remove log file"
    echo "4) clean code"
    echo "5) count line code"
    echo "6) count php line code"
    echo "7) count file"
    echo "8) count php file"
    echo "9) count dir"
    echo "10) show empty file"
    echo "11) file permissions"
    echo "12) file strict permissions"
    echo "13) backup"


    read option
    case $option in
      "clear cache") clear-cache;;
      "remove tmp file") remove-tmp-file;;
      "remove log file") remove-log-file;;
      "clean code") clean-code;;
      "count line code") count-line-code;;
      "count php line code") count-php-line-code;;
      "count file") count-file;;
      "count php file") count-php-file;;
      "count dir") count-dir;;
      "show empty file") show-empty-file;;
      "file permissions") file-permissions;;
      "file strict permissions") file-strict-permissions;;
      "backup") backup;;
      *) _error
    esac
}

# Delete all caches
function clear-cache() {
    _confirm "Are you sure you want to delete caches?"
    if [ $? -eq 1 ]; then
        _cache-permissions

        # public
        rm -rf ./_install/data/caches/smarty_compile/*
        rm -rf ./_install/data/caches/smarty_cache/*

        # _protected
        rm -rf ./_protected/data/cache/pH7tpl_compile/*
        rm -rf ./_protected/data/cache/pH7tpl_cache/*
        rm -rf ./_protected/data/cache/pH7_static/*
        rm -rf ./_protected/data/cache/pH7_cache/*
        echo "The Caches have been removed!"
    fi
}

# Deleting temporary files
function remove-tmp-file() {
    _confirm "Are you sure you want to remove the temporary files (e.g., file.pl~, ._file.php)?"
    if [ $? -eq 1 ]; then
        find . -type f \( -name '*~' -or -name '*.tmp' -or -name '*.swp' -or -name '.directory' -or -name '._*' -or -name '.DS_Store*' -or -name 'Thumbs.db' \) -exec rm {} \;
        echo "Temporary files have been removed!"
    fi
}

# Deleting log files
function remove-log-file() {
    _confirm "Are you sure you want to remove all log files (*.log)?"
    if [ $? -eq 1 ]; then
        find . -type f -name '*.log' -exec rm {} \;
        echo "Log files have been removed!"
    fi
}

# Clean up the code
function clean-code() {
    _confirm "Are you sure you want to clean up the code?"
    if [ $? -eq 1 ]; then
        params="-name '*.php' -or -name '*.css' -or -name '*.js' -or -name '*.html' -or -name '*.xml' -or -name '*.xsl' -or -name '*.xslt' -or -name '*.json' -or -name '*.yml' -or -name '*.tpl' -or -name '*.phs' -or -name '*.ph7' -or -name '*.sh' -or -name '*.sql' -or -name '*.ini' -or -name '*.md' -or -name '*.markdown' -or -name '.htaccess'"
        exec="find . -type f \( $params \) -print0 | xargs -0 perl -wi -pe"
        eval "$exec 's/\s+$/\n/'"
        eval "$exec 's/\t/    /g'"

        # _clean-indent
        echo "The code has been cleaned!"
    fi
}

# Count all line of code in all files
function count-line-code() {
    find . -type f | xargs wc -l
}

# Count all line of code in PHP files
function count-php-line-code() {
    find . -type f -name '*.php' | xargs wc -l
}

# Count all files
function count-file() {
    find . -type f | wc -l
}

# Count all PHP files
function count-php-file() {
    find . -type f -name '*.php' | wc -l
}

# Count all directories
function count-dir() {
    find . -type d | wc -l
}

# Display all empty files (0 bytes)
function show-empty-file() {
    find . -type f -size 0
}

# Check and correct file permissions (CHMOD)
# These permissions allow editing and creating files in the File Management admin module.
function file-permissions() {
    _permissions 666 777
    _cache-permissions
    echo "Permissions have been changed!"
}

# Check and correct file permissions (CHMOD)
# These permissions don't allow editing and creating files in the File Management admin module.
function file-strict-permissions() {
    _permissions 644 755
    _cache-permissions
    echo "Permissions Strict have been changed!"
}

# Backup. Create a compressed archive of the project
function backup() {
    echo "Specify the path ending with a SLASH where the archive will be stored"
    read path
    if [ ! -d $path ]; then
        echo "The path is not a valid directory."
        exit 1
    fi
    file="PH7SocialDatingCms.tar.bz2"
    full_path=$path$file
    if [ -e  $full_path ]; then
        _confirm "A backup already exists in this directory, do you want to delete it?"
        if [ $? -eq 1 ]; then
            rm $full_path
        else
            echo "Backup canceled. Please choose a different backup directory or delete the old one."
            exit 2
        fi
    fi
    tar -jcvf $full_path  ../
    echo "Backup project successfully created into: $full_path"
}


#### Private functions ####

# Clean indentation code
function _clean-indent() {
    sed -i 's/\(.*\)\(function\|class\|try\|catch\)\([^{]*\){\([^}].*\)/\1\2\3\n\1{\4/'  $(find -name '*.php')
}

# CHange permissions of the folders/files (CHMOD)
function _permissions() {
    find . -type f -print0 | sudo xargs -0 chmod $1 # First parameter for Files
    find . -type d -print0 | sudo xargs -0 chmod $2 # Second parameter for Folders

    sudo chmod 777 ./
    sudo chmod 777 -R ./_install/*
    sudo chmod 777 -R ./_repository/module/*
    sudo chmod 777 -R ./_repository/upgrade/*
    sudo chmod 777 -R ./_protected/app/configs/*
    sudo chmod 777 -R ./_protected/data/backup/*
    sudo chmod 777 -R ./_protected/data/tmp/*
    sudo chmod 777 -R ./_protected/data/log/*
}

# Cache permissions (CHMOD)
function _cache-permissions() {
    sudo chmod 777 -R ./_install/data/caches/*
    sudo chmod 777 -R ./_protected/data/cache/*
}

# Confirmation of orders entered
function _confirm() {
    echo $1 "(Y/N)"
    read input
    input=$(_to-lower $input) # Case-insensitive
    if [ "$input" == "y" ]; then
        return 1
    else
        return 0
    fi
}

# To lower
function _to-lower() {
    echo $1 | tr '[:upper:]' '[:lower:]'
}

function _error() {
    echo "ERROR!"
}

init
